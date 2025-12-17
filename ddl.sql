/*
 * TRABALHO PRÁTICO - Grupo 05
 * Ficheiro: ddl.sql
 */


-- ============================================================================
-- 1. LIMPEZA DE ESTRUTURAS ANTIGAS
-- ============================================================================

DROP TRIGGER IF EXISTS trg_calculo_dano ON RegistoDano;
DROP TRIGGER IF EXISTS trg_verificar_regras_reserva ON Reserva;
DROP FUNCTION IF EXISTS fn_calculo_dano;
DROP FUNCTION IF EXISTS fn_verificar_regras_reserva;

DROP TABLE IF EXISTS Aloca_Torneio CASCADE;
DROP TABLE IF EXISTS Torneio CASCADE;
DROP TABLE IF EXISTS RegistoDano CASCADE;
DROP TABLE IF EXISTS Reserva CASCADE;
DROP TABLE IF EXISTS Tarifario CASCADE;
DROP TABLE IF EXISTS Court CASCADE;
DROP TABLE IF EXISTS NaoSocio CASCADE;
DROP TABLE IF EXISTS Socio CASCADE;
DROP TABLE IF EXISTS Utilizador_Telefone CASCADE;
DROP TABLE IF EXISTS Utilizador CASCADE;

-- ============================================================================
-- 2. CRIAÇÃO DE TABELAS
-- ============================================================================

CREATE TABLE Utilizador (
    ID_Utilizador INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    NIF INT NOT NULL UNIQUE
);

CREATE TABLE Utilizador_Telefone (
    ID_Utilizador INT,
    Telefone VARCHAR(20),
    PRIMARY KEY (ID_Utilizador, Telefone),
    FOREIGN KEY (ID_Utilizador) REFERENCES Utilizador(ID_Utilizador) ON DELETE CASCADE
);

CREATE TABLE Socio (
    ID_Utilizador INT PRIMARY KEY,
    Data_Admissao DATE NOT NULL,
    Estatuto_Socio VARCHAR(50),
    FOREIGN KEY (ID_Utilizador) REFERENCES Utilizador(ID_Utilizador) ON DELETE CASCADE
);

CREATE TABLE NaoSocio (
    ID_Utilizador INT PRIMARY KEY,
    Data_Criacao_Perfil DATE NOT NULL,
    FOREIGN KEY (ID_Utilizador) REFERENCES Utilizador(ID_Utilizador) ON DELETE CASCADE
);

CREATE TABLE Court (
    ID_Court INT PRIMARY KEY,
    Nome_Court VARCHAR(50) NOT NULL,
    Tipo_Piso VARCHAR(50) NOT NULL
);

CREATE TABLE Tarifario (
    ID_Tarifario INT PRIMARY KEY,
    Descricao VARCHAR(100) NOT NULL,
    Tipo_Piso_Aplicavel VARCHAR(50),
    Preco_Base_Hora DECIMAL(5,2) NOT NULL,
    Acrescimo_Pico_Pct DECIMAL(5,2),
    Acrescimo_Iluminacao DECIMAL(5,2)
);

CREATE TABLE Reserva (
    ID_Reserva INT PRIMARY KEY,
    DataHora_Inicio TIMESTAMP NOT NULL, 
    Duracao_Minutos INT NOT NULL,
    Requer_Iluminacao BOOLEAN NOT NULL DEFAULT FALSE,
    ID_Court INT NOT NULL,
    ID_Tarifario INT NOT NULL,
    ID_Utilizador INT NOT NULL,
    FOREIGN KEY (ID_Court) REFERENCES Court(ID_Court),
    FOREIGN KEY (ID_Tarifario) REFERENCES Tarifario(ID_Tarifario),
    FOREIGN KEY (ID_Utilizador) REFERENCES Utilizador(ID_Utilizador),
    CONSTRAINT CHK_Duracao_Valida CHECK (Duracao_Minutos IN (60, 90, 120, 150))
);

CREATE TABLE RegistoDano (
    ID_Dano INT PRIMARY KEY,
    Descricao VARCHAR(255) NOT NULL,
    Valor_Prejuizo_Total DECIMAL(10,2) NOT NULL,
    -- O Valor Cobrado será calculado automaticamente pelo Trigger (50%)
    Valor_Cobrado_Utilizador DECIMAL(10,2),
    ID_Reserva INT NOT NULL,
    FOREIGN KEY (ID_Reserva) REFERENCES Reserva(ID_Reserva)
);

CREATE TABLE Torneio (
    ID_Torneio INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    DataHora_Inicio TIMESTAMP NOT NULL,
    DataHora_Fim TIMESTAMP NOT NULL,
    DataHora_Fecho_Inscricoes TIMESTAMP NOT NULL,
    Valor_Inscricao DECIMAL(10,2) NOT NULL,
    Num_Max_Inscritos INT NOT NULL
);

CREATE TABLE Aloca_Torneio (
    ID_Torneio INT,
    ID_Court INT,
    PRIMARY KEY (ID_Torneio, ID_Court),
    FOREIGN KEY (ID_Torneio) REFERENCES Torneio(ID_Torneio),
    FOREIGN KEY (ID_Court) REFERENCES Court(ID_Court)
);

-- ============================================================================
-- 3. TRIGGERS E FUNÇÕES
-- ============================================================================

/*
 * TRIGGER 1: Validação de Reservas
 * Implementa:
 * - Regra de Antecedência: Sócios (7 dias) vs Não Sócios (1 dia).
 * - Regra de Perfil Temporário: Não Sócios com perfil > 3 meses não podem reservar.
 */
CREATE OR REPLACE FUNCTION fn_verificar_regras_reserva()
RETURNS TRIGGER AS $$
DECLARE
    v_data_criacao DATE;
    v_e_socio BOOLEAN;
    v_diferenca_dias INT;
    v_meses_perfil INT;
    v_existe_conflito BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 
        FROM Reserva
        WHERE ID_Court = NEW.ID_Court
          AND ID_Reserva != NEW.ID_Reserva
          AND (
            NEW.DataHora_Inicio < (DataHora_Inicio + make_interval(mins => Duracao_Minutos))
            AND
            (NEW.DataHora_Inicio + make_interval(mins => NEW.Duracao_Minutos)) > DataHora_Inicio
          )
    ) INTO v_existe_conflito;

    IF v_existe_conflito THEN
        RAISE EXCEPTION 'Erro: O Court % já se encontra ocupado neste horário.', NEW.ID_Court;
    END IF;

    SELECT EXISTS(SELECT 1 FROM Socio WHERE ID_Utilizador = NEW.ID_Utilizador) INTO v_e_socio;

    v_diferenca_dias := DATE_PART('day', NEW.DataHora_Inicio - CURRENT_TIMESTAMP);

    IF v_e_socio THEN
        IF v_diferenca_dias > 7 THEN 
            RAISE EXCEPTION 'Erro: Sócios só podem reservar com 7 dias de antecedência.';
        END IF;
    ELSE
        SELECT Data_Criacao_Perfil INTO v_data_criacao FROM NaoSocio WHERE ID_Utilizador = NEW.ID_Utilizador;
        
        v_meses_perfil := (DATE_PART('year', CURRENT_DATE) - DATE_PART('year', v_data_criacao)) * 12 +
                          (DATE_PART('month', CURRENT_DATE) - DATE_PART('month', v_data_criacao));

        IF v_meses_perfil >= 3 THEN
             RAISE EXCEPTION 'Erro: Perfil de Não Sócio expirado (mais de 3 meses).';
        END IF;

        IF v_diferenca_dias > 1 THEN 
            RAISE EXCEPTION 'Erro: Não Sócios só podem reservar com 1 dia de antecedência.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_regras_reserva
BEFORE INSERT ON Reserva
FOR EACH ROW EXECUTE FUNCTION fn_verificar_regras_reserva();


/*
 * TRIGGER 2: Cálculo Automático de Danos
 * Implementa:
 * - Regra de Cobrança: O valor cobrado ao utilizador é sempre 50% do prejuízo total.
 */
CREATE OR REPLACE FUNCTION fn_calculo_dano()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Valor_Cobrado_Utilizador := NEW.Valor_Prejuizo_Total * 0.50;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculo_dano
BEFORE INSERT ON RegistoDano
FOR EACH ROW EXECUTE FUNCTION fn_calculo_dano();

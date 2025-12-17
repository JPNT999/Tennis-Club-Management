/*
 * TRABALHO PRÁTICO - Grupo 05
 * Ficheiro: proc_func.sql
 */


CREATE OR REPLACE FUNCTION fn_calcular_preco_reserva(p_id_reserva INT)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_preco_base DECIMAL(10,2);
    v_custo_luz DECIMAL(10,2);
    v_duracao_min INT;
    v_requer_luz BOOLEAN;
    v_id_utilizador INT;
    v_e_socio BOOLEAN;
    v_preco_final DECIMAL(10,2);
    v_horas DECIMAL(10,2);
BEGIN
    -- 1. Obter dados da reserva e tarifário associado
    SELECT 
        r.Duracao_Minutos, r.Requer_Iluminacao, r.ID_Utilizador,
        t.Preco_Base_Hora, t.Acrescimo_Iluminacao
    INTO 
        v_duracao_min, v_requer_luz, v_id_utilizador,
        v_preco_base, v_custo_luz
    FROM Reserva r
    JOIN Tarifario t ON r.ID_Tarifario = t.ID_Tarifario
    WHERE r.ID_Reserva = p_id_reserva;

    -- 2. Converter duração (minutos) para horas decimais
    v_horas := v_duracao_min::DECIMAL / 60.0;

    -- 3. Cálculo do valor base: (Preço por Hora * Duração)
    v_preco_final := v_preco_base * v_horas;

    -- 4. Adicionar custo fixo de iluminação se requisitado
    IF v_requer_luz THEN
        v_preco_final := v_preco_final + v_custo_luz;
    END IF;

    -- 5. Aplicação da Regra de Desconto de Sócio (Regra 5)
    -- Se o utilizador for Sócio, aplica-se um desconto de 30% sobre o total
    SELECT EXISTS(SELECT 1 FROM Socio WHERE ID_Utilizador = v_id_utilizador) INTO v_e_socio;
    
    IF v_e_socio THEN
        v_preco_final := v_preco_final * 0.70; 
    END IF;

    RETURN ROUND(v_preco_final, 2);
END;
$$ LANGUAGE plpgsql;

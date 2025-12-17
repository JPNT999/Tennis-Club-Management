/*
 * TRABALHO PRÁTICO - Grupo 05
 * Ficheiro: dml_insert.sql
 */


-- ============================================================================
-- 1. UTILIZADORES
-- ============================================================================

INSERT INTO Utilizador (ID_Utilizador, Nome, Email, NIF) VALUES 
    (1,  'Carlos Admin',      'admin@clubedeluxo.pt',       100000001),
    (2,  'Maria Receção',     'maria.rececao@clubedeluxo.pt', 100000002),
    -- Sócios Gold
    (10, 'João Teixeira',     'joao.teixeira@mail.com',     200300400),
    (11, 'Guilherme Silva',   'guilherme.silva@mail.com',   210310410),
    (12, 'Mohammed Rohaim',   'mohammed.rohaim@mail.com',   220320420),
    (13, 'Cristiano Ronaldo', 'cr7@luxo.pt',                999888777),
    (14, 'Madonna Ciccone',   'madonna@music.com',          888777666),
    (15, 'José Mourinho',     'special.one@coach.com',      777666555),
    -- Sócios Silver
    (20, 'António Costa',     'antonio.costa@mail.pt',      123123123),
    (21, 'Ana Gomes',         'ana.gomes@mail.pt',          321321321),
    (22, 'Ricardo Araújo',    'ricardo.araujo@mail.pt',     456456456),
    -- Sócios Normal
    (23, 'Beatriz Lebre',     'beatriz.lebre@mail.pt',      654654654),
    (24, 'Tiago Bettencourt', 'tiago.musica@mail.pt',       987987987),
    (25, 'Marisa Liz',        'marisa.liz@mail.pt',         147147147),
    (26, 'Herman José',       'herman@humor.pt',            258258258),
    (27, 'Catarina Furtado',  'catarina@tv.pt',             369369369),
    -- Não Sócios
    (30, 'John Smith',        'john.smith@uk.mail.com',     500000001),
    (31, 'Pierre Dupont',     'pierre.dupont@fr.mail.com',  500000002),
    (32, 'Hans Müller',       'hans.muller@de.mail.com',    500000003),
    (33, 'Ana Visitante',     'ana.visitante@mail.com',     230330430),
    (34, 'Pedro Turista',     'pedro.turista@mail.com',     240340440),
    (35, 'Sofia Passageira',  'sofia.pass@mail.com',        500000010),
    (36, 'Lucas Espanhol',    'lucas.es@mail.com',          500000011),
    (37, 'Emma British',      'emma.uk@mail.com',           500000012),
    (38, 'Sven Svensson',     'sven.sw@mail.com',           500000013),
    (39, 'Giulia Rossi',      'giulia.it@mail.com',         500000014);

-- ============================================================================
-- 2. ESPECIALIZAÇÃO (Sócios, Não Sócios e Contactos)
-- ============================================================================

-- 2.1 Sócios
INSERT INTO Socio (ID_Utilizador, Data_Admissao, Estatuto_Socio) VALUES 
    (1,  '2010-01-01', 'Staff'),
    (2,  '2015-05-01', 'Staff'),
    (10, '2020-01-15', 'Gold'),
    (11, '2021-05-20', 'Gold'),
    (12, '2019-03-10', 'Gold'),
    (13, '2018-08-01', 'Gold'),
    (14, '2022-06-01', 'Gold'),
    (15, '2020-12-25', 'Gold'),
    (20, '2023-01-10', 'Silver'),
    (21, '2023-02-15', 'Silver'),
    (22, '2023-03-20', 'Silver'),
    (23, '2024-01-05', 'Normal'),
    (24, '2024-02-10', 'Normal'),
    (25, '2024-03-15', 'Normal'),
    (26, '2024-04-20', 'Normal'),
    (27, '2024-05-25', 'Normal');

-- 2.2 Não Sócios (Datas dinâmicas para evitar expiração automática)
INSERT INTO NaoSocio (ID_Utilizador, Data_Criacao_Perfil) VALUES 
    (30, CURRENT_DATE - INTERVAL '1 month'),
    (31, CURRENT_DATE - INTERVAL '1 month'),
    (32, CURRENT_DATE - INTERVAL '2 days'),
    (33, CURRENT_DATE - INTERVAL '5 days'),
    (34, CURRENT_DATE - INTERVAL '10 days'),
    (35, CURRENT_DATE - INTERVAL '1 month'),
    (36, CURRENT_DATE - INTERVAL '2 months'), -- Ainda válido (<3 meses)
    (37, CURRENT_DATE - INTERVAL '1 day'),
    (38, CURRENT_DATE - INTERVAL '1 day'),
    (39, CURRENT_DATE - INTERVAL '1 day');

-- 2.3 Telefones
INSERT INTO Utilizador_Telefone (ID_Utilizador, Telefone) VALUES 
    (10, '910000001'), (10, '910000002'),
    (11, '960000001'),
    (12, '930000001'), (12, '210000001'),
    (13, '999999999'),
    (30, '+44 7700 9000'),
    (31, '+33 6 12 34 56'),
    (32, '+49 170 123456');

-- ============================================================================
-- 3. COURTS E TARIFÁRIOS
-- ============================================================================

INSERT INTO Court (ID_Court, Nome_Court, Tipo_Piso) VALUES 
    (1,  'Central Rápido',     'Piso Rápido'),
    (2,  'Court Rápido 2',     'Piso Rápido'),
    (3,  'Court Rápido 3',     'Piso Rápido'),
    (4,  'Court Rápido 4',     'Piso Rápido'),
    (5,  'Court Rápido 5',     'Piso Rápido'),
    (6,  'Court Rápido 6',     'Piso Rápido'),
    (7,  'Court Rápido 7',     'Piso Rápido'),
    (8,  'Court Rápido 8',     'Piso Rápido'),
    (9,  'Court Rápido 9',     'Piso Rápido'),
    (10, 'Court Rápido 10',    'Piso Rápido'),
    (11, 'Terra Batida A',     'Terra Batida'),
    (12, 'Terra Batida B',     'Terra Batida'),
    (13, 'Terra Batida C',     'Terra Batida'),
    (14, 'Terra Batida D',     'Terra Batida'),
    (15, 'Padel Panorâmico 1', 'Padel'),
    (16, 'Padel Panorâmico 2', 'Padel'),
    (17, 'Padel Vidro 3',      'Padel'),
    (18, 'Padel Vidro 4',      'Padel'),
    (19, 'Padel Vidro 5',      'Padel'),
    (20, 'Padel Vidro 6',      'Padel'),
    (21, 'Padel Vidro 7',      'Padel'),
    (22, 'Padel Vidro 8',      'Padel');

INSERT INTO Tarifario 
(ID_Tarifario, Descricao, Tipo_Piso_Aplicavel, Preco_Base_Hora, Acrescimo_Pico_Pct, Acrescimo_Iluminacao) 
VALUES 
    (1, 'Ténis Rápido Standard',      'Piso Rápido',  10.00, 0.25, 5.00),
    (2, 'Ténis Terra Batida Premium', 'Terra Batida', 15.00, 0.25, 5.00),
    (3, 'Padel Standard',             'Padel',        12.50, 0.25, 5.00);

-- ============================================================================
-- 4. RESERVAS 
-- Nota: Usamos NOW() para garantir que o script funciona em qualquer data
-- sem violar regras de antecedência ou histórico.
-- ============================================================================

-- 4.1 Reservas Passadas (Histórico)
INSERT INTO Reserva (ID_Reserva, DataHora_Inicio, Duracao_Minutos, Requer_Iluminacao, ID_Court, ID_Tarifario, ID_Utilizador) VALUES 
    (100, NOW() - INTERVAL '30 days', 60,  FALSE, 1,  1, 10),
    (101, NOW() - INTERVAL '30 days', 90,  FALSE, 11, 2, 11),
    (102, NOW() - INTERVAL '29 days', 60,  TRUE,  15, 3, 30),
    (103, NOW() - INTERVAL '29 days', 90,  TRUE,  15, 3, 31),
    (104, NOW() - INTERVAL '28 days', 120, FALSE, 2,  1, 13),
    (105, NOW() - INTERVAL '28 days', 60,  FALSE, 3,  1, 14),
    (106, NOW() - INTERVAL '27 days', 150, FALSE, 11, 2, 20),
    (107, NOW() - INTERVAL '27 days', 60,  FALSE, 12, 2, 21),
    (108, NOW() - INTERVAL '26 days', 90,  TRUE,  1,  1, 15),
    (109, NOW() - INTERVAL '25 days', 60,  FALSE, 16, 3, 32);

-- 4.2 Reservas Futuras (Atenção às regras de antecedência!)
INSERT INTO Reserva (ID_Reserva, DataHora_Inicio, Duracao_Minutos, Requer_Iluminacao, ID_Court, ID_Tarifario, ID_Utilizador) VALUES 
    -- Não Sócio: Marca para daqui a 2h (Válido: < 24h antecedência)
    (300, NOW() + INTERVAL '2 hours', 60,  FALSE, 1,  1, 35),
    (301, NOW() + INTERVAL '3 hours', 90,  FALSE, 2,  1, 36),
    
    -- Sócio: Marca para amanhã (Válido: < 7 dias antecedência)
    (302, NOW() + INTERVAL '1 day',   60,  FALSE, 11, 2, 10),
    (303, NOW() + INTERVAL '1 day',   120, FALSE, 15, 3, 11),
    
    -- Sócio VIP/Gold: Marca para daqui a 3-6 dias
    (400, NOW() + INTERVAL '3 days',  90,  FALSE, 1,  1, 13),
    (401, NOW() + INTERVAL '4 days',  60,  TRUE,  15, 3, 14),
    (402, NOW() + INTERVAL '5 days',  120, FALSE, 11, 2, 15),
    (403, NOW() + INTERVAL '6 days',  60,  FALSE, 5,  1, 10);

-- ============================================================================
-- 5. DANOS
-- Nota: Valor_Cobrado é NULL para testar o Trigger que calcula 50% automaticamente.
-- ============================================================================
    
INSERT INTO RegistoDano (ID_Dano, Descricao, Valor_Prejuizo_Total, Valor_Cobrado_Utilizador, ID_Reserva) VALUES 
    (1, 'Raquete partiu o vidro lateral do campo de Padel', 400.00, NULL, 102), -- Trigger deve definir 200€
    (2, 'Rede rasgada por mau uso',                        150.00, NULL, 100), -- Trigger deve definir 75€
    (3, 'Projetor de luz partido com bola',                300.00, NULL, 108), -- Trigger deve definir 150€
    (4, 'Banco de descanso partido',                        80.00, NULL, 300); -- Trigger deve definir 40€

-- ============================================================================
-- 6. TORNEIOS
-- Nota: Datas futuras calculadas relativamente a "hoje".
-- ============================================================================
    
INSERT INTO Torneio 
(ID_Torneio, Nome, DataHora_Inicio, DataHora_Fim, DataHora_Fecho_Inscricoes, Valor_Inscricao, Num_Max_Inscritos) 
VALUES 
    (1, 'Open de Verão Quinta do Lago', 
     NOW() + INTERVAL '2 months', 
     NOW() + INTERVAL '2 months 2 days', 
     NOW() + INTERVAL '1 month 25 days', 
     50.00, 32),
    
    (2, 'Torneio Solidário Padel VIP', 
     NOW() + INTERVAL '3 months', 
     NOW() + INTERVAL '3 months 1 day', 
     NOW() + INTERVAL '2 months 25 days', 
     75.00, 16);

-- Alocação de Courts aos Torneios
INSERT INTO Aloca_Torneio (ID_Torneio, ID_Court) VALUES 
    (1, 1), (1, 2), (1, 11), (1, 12),
    (2, 15), (2, 16);

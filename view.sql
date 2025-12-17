/*
 * TRABALHO PRÁTICO - Grupo 05
 * Ficheiro: views.sql
 */

CREATE OR REPLACE VIEW V_Agenda_Courts AS
SELECT 
    r.DataHora_Inicio,
    r.Duracao_Minutos,
    c.Nome_Court,
    c.Tipo_Piso
FROM Reserva r
JOIN Court c ON r.ID_Court = c.ID_Court
ORDER BY r.DataHora_Inicio DESC;

CREATE OR REPLACE VIEW V_Contactos_VIP AS
SELECT 
    u.Nome,
    u.Email,
    s.Data_Admissao
FROM Utilizador u
JOIN Socio s ON u.ID_Utilizador = s.ID_Utilizador
WHERE s.Estatuto_Socio = 'Gold';

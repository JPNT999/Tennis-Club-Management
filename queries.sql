/*
 * TRABALHO PRÁTICO - Grupo 05
 * Ficheiro: queries.sql
 */


-- Q.1:
SELECT 
    u.Nome, u.Email, u.NIF, s.Estatuto_Socio
FROM 
    Utilizador u, Socio s
WHERE 
    u.ID_Utilizador = s.ID_Utilizador 
    AND s.Estatuto_Socio = 'Gold';


-- Q.2:
SELECT 
    c.Tipo_Piso, COUNT(r.ID_Reserva) AS Total_Reservas
FROM 
    Reserva r
JOIN 
    Court c ON r.ID_Court = c.ID_Court
GROUP BY 
    c.Tipo_Piso;


-- Q.3:
SELECT 
    c.Nome_Court, COUNT(r.ID_Reserva) AS Qtd_Reservas
FROM 
    Court c
JOIN 
    Reserva r ON c.ID_Court = r.ID_Court
GROUP BY 
    c.Nome_Court
HAVING 
    COUNT(r.ID_Reserva) > 1;


-- Q.4:
SELECT 
    u.Nome, u.Email, s.Data_Admissao, s.Estatuto_Socio
FROM 
    Utilizador u
LEFT OUTER JOIN 
    Socio s ON u.ID_Utilizador = s.ID_Utilizador;


-- Q.5:
SELECT 
    Nome 
FROM 
    Utilizador 
WHERE 
    ID_Utilizador IN (
        SELECT r.ID_Utilizador 
        FROM Reserva r 
        JOIN Court c ON r.ID_Court = c.ID_Court 
        WHERE c.Tipo_Piso = 'Padel'
    );


-- Q.6:
WITH MinutosJogados AS (
    SELECT 
        ID_Utilizador, SUM(Duracao_Minutos) AS Total_Tempo
    FROM 
        Reserva
    GROUP BY 
        ID_Utilizador
)
SELECT 
    u.Nome, m.Total_Tempo
FROM 
    Utilizador u
JOIN 
    MinutosJogados m ON u.ID_Utilizador = m.ID_Utilizador;


-- Q.7:
SELECT 
    u.Nome 
FROM 
    Utilizador u
WHERE NOT EXISTS (
    SELECT 1 
    FROM Reserva r 
    WHERE r.ID_Utilizador = u.ID_Utilizador
);


-- Q.8:
SELECT 
    c1.Nome_Court AS Court_A, 
    c2.Nome_Court AS Court_B, 
    c1.Tipo_Piso
FROM 
    Court c1, Court c2
WHERE 
    c1.Tipo_Piso = c2.Tipo_Piso 
    AND c1.ID_Court < c2.ID_Court
ORDER BY 
    c1.Tipo_Piso;


-- Q.9:
SELECT u.Nome
FROM Utilizador u
WHERE NOT EXISTS (
    (SELECT DISTINCT Tipo_Piso FROM Court)
    EXCEPT
    (SELECT DISTINCT c.Tipo_Piso 
     FROM Reserva r
     JOIN Court c ON r.ID_Court = c.ID_Court
     WHERE r.ID_Utilizador = u.ID_Utilizador)
);


-- Q.10:
SELECT 
    Nome, Email
FROM 
    Utilizador
WHERE 
    Email LIKE '%@mail.com';


-- Q.11:
SELECT 
    * FROM 
    Reserva
WHERE 
    Duracao_Minutos >= ALL (SELECT Duracao_Minutos FROM Reserva);


-- Q.12:
-- Query Livre/Complexa:
SELECT 
    u.Nome, 
    s.Estatuto_Socio, 
    SUM((t.Preco_Base_Hora * (r.Duracao_Minutos / 60.0))) AS Total_Gasto_Estimado
FROM 
    Reserva r
JOIN 
    Utilizador u ON r.ID_Utilizador = u.ID_Utilizador
JOIN 
    Socio s ON u.ID_Utilizador = s.ID_Utilizador
JOIN 
    Tarifario t ON r.ID_Tarifario = t.ID_Tarifario
GROUP BY 
    u.Nome, s.Estatuto_Socio
ORDER BY 
    Total_Gasto_Estimado DESC;

--Gruppo 3:
--Lorenzo Foschi
--Polizzi Lucrezia
--Filippo Roncallo

set search_path to "unicorsi";  
 
--  INTERROGAZIONI SU SINGOLA RELAZIONE

 --1
SELECT Matricola, Cognome, Nome
FROM Studenti
WHERE Iscrizione < 2007  and Relatore IS NULL;

--2 
SELECT facolta, Denominazione
FROM CorsiDiLaurea
WHERE Attivazione NOT BETWEEN '2006/2007' and '2009/2010'
ORDER BY facolta, Denominazione;

--3
SELECT Matricola, Cognome, Nome
FROM Studenti
WHERE Residenza IN ('Genova', 'La Spezia', 'Savona') OR Cognome NOT IN ('Serra', 'Melogno', 'Giunchi')
ORDER BY  Matricola DESC;

-- INTERROGAZIONI CHE COINVOLGONO PIU' RELAZIONI

--1
SELECT Matricola, CorsoDiLaurea, Laurea
FROM Studenti JOIN CorsiDiLaurea
				ON Studenti.CorsoDiLaurea = CorsiDiLaurea.id 
WHERE Denominazione = 'Informatica' and Laurea < '01/11/2009';

--2
SELECT Studenti.Cognome, Studenti.Nome, Professori.Cognome
FROM Studenti, Professori
WHERE Studenti.Relatore = Professori.id 
ORDER BY Studenti.Cognome, Studenti.Nome ;

--3
 SELECT DISTINCT Studenti.Cognome, Studenti.Nome
FROM Studenti JOIN PianiDiStudio
			  ON Studenti.Matricola = PianiDiStudio.Studente
				JOIN CorsiDiLaurea
				ON Studenti.CorsoDiLaurea = CorsiDiLaurea.id
WHERE Relatore IS NOT NULL
AND AnnoAccademico = '2011' 
AND Anno = 5
AND Denominazione = 'Informatica'
ORDER BY Studenti.Cognome DESC, Studenti.Nome;

-- OPERAZIONI INSIEMISTICHE

--1
SELECT Studenti.Cognome, Studenti.Nome , 'Studente'
FROM Studenti
UNION
SELECT  Professori.Cognome, Professori.Nome,'Professore'
FROM Professori;

--2
SELECT Matricola
FROM Studenti 
JOIN CorsiDiLaurea ON Studenti.CorsoDiLaurea = CorsiDiLaurea.id
JOIN Esami ON Studenti.Matricola = Esami.Studente
JOIN Corsi ON Esami.Corso = Corsi.id
WHERE CorsiDiLaurea.Denominazione = 'Informatica' AND Corsi.Denominazione = 'Basi Di Dati 1'
AND Esami.Data BETWEEN '06/01/2010' AND '06/30/2010'
AND Voto >= 18
EXCEPT
SELECT Matricola
FROM Studenti 
JOIN CorsiDiLaurea ON Studenti.CorsoDiLaurea = CorsiDiLaurea.id
JOIN Esami ON Studenti.Matricola = Esami.Studente
JOIN Corsi ON Esami.Corso = Corsi.id
WHERE CorsiDiLaurea.Denominazione = 'Informatica' AND Corsi.Denominazione = 'Interfacce Grafiche'
AND Esami.Data BETWEEN '06/01/2010' AND '06/30/2010'
AND Voto >= 18

--3
SELECT Matricola
FROM Studenti 
JOIN CorsiDiLaurea ON Studenti.CorsoDiLaurea = CorsiDiLaurea.id
JOIN Esami ON Studenti.Matricola = Esami.Studente
JOIN Corsi ON Esami.Corso = Corsi.id
WHERE CorsiDiLaurea.Denominazione = 'Informatica' AND Corsi.Denominazione = 'Basi Di Dati 1'
AND Esami.Data BETWEEN '06/01/2010' AND '06/30/2010'
AND Voto >= 18
INTERSECT
SELECT Matricola
FROM Studenti 
JOIN CorsiDiLaurea ON Studenti.CorsoDiLaurea = CorsiDiLaurea.id
JOIN Esami ON Studenti.Matricola = Esami.Studente
JOIN Corsi ON Esami.Corso = Corsi.id
WHERE CorsiDiLaurea.Denominazione = 'Informatica' AND Corsi.Denominazione = 'Interfacce Grafiche'
AND Esami.Data BETWEEN '06/01/2010' AND '06/30/2010'
AND Voto >= 18
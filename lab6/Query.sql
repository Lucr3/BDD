			set search_path to "unicorsi";  

		-- VINCOLI --

		--Specificare attraverso un vincolo CHECK che un esame non può essere sostenuto in data successiva alla data odierna. 
		--Si riesce ad aggiungere tale vincolo? Perchè? 
		--Si, il vincolo si riesce a raggiungere perché non ci sono esami con data successiva aquella odierna

			ALTER TABLE Esami ADD CONSTRAINT dataOggi CHECK (Data < CURRENT_DATE)

		--  Specificare attraverso un vincolo CHECK che un esame non può essere sostenuto in data precedente il 1 gennaio 2014. 
		--  Si riesce ad aggiungere tale vincolo? Perchè?
			ALTER TABLE Esami ADD CONSTRAINT dataEsame CHECK (Data > '01-01-2014');

		-- Non si riesce ad aggiungere il vincol in quanto ci sono degli esami che sono stati sostenuti in data precedente al 1 gennaio 2014

		-- Specificare attraverso un vincolo CHECK che non è mai possibile che il relatore non sia specificato (relatore nullo) 
		-- per uno studente che ha già iniziato la tesi ( laurea non nulla)

		 ALTER TABLE Studenti ADD CONSTRAINT RelS CHECK (Relatore IS NOT NULL AND Laurea IS NOT NULL);

		-- Non si riesce araggiungere il vincolo perchè il vincolo è violato da alcune righe

		-- MODIFICHE --

		-- Inserire nella relazione Professori:

		-- (a)  i dati relativi al Professore Prini Gian Franco con identificativo 38 e stipendio 50000 euro;

		-- (b)  i dati relativi alla Professoressa Stefania Bandini, con identificativo 39, senza specificare un valore per stipendio;

		-- (c)  i dati relativi alla Professorressa Rosti, con identificativo 40, senza specificare nome proprio né stipendio.

		-- I comandi vanno a buon fine? Perchè?


		INSERT INTO Professori VALUES(38, 'Prini', 'Gian Franco', 50000);
		INSERT INTO Professori VALUES(39, 'Bandini', 'Stefania');
		INSERT INTO Professori VALUES(40, 'Rosti');

		-- I primi due comandi vanno a buon fine, mentre l'ultimo inserimento non funziona perché vengono violati dei vincoli.

		--Aumentare di 5000 euro lo stipendio dei Professori che hanno uno stipendio inferiore a 15000 euro.

		UPDATE Professori
		SET Stipendio = Stipendio + 5000
		WHERE Stipendio < 15000;




		-- Rimuovere il vincolo not null su Esami.voto mediante il comando alter table esami alter column voto drop not null;
		   alter table esami alter column voto drop not null;
		-- Inserire ora il corso di ’Laboratorio di Informatica’ (id ’labinfo’) per il corso di laurea di Informatica (id corso di laurea 9).
			INSERT INTO Corsi(id,CorsoDiLaurea,Denominazione) VALUES('labinfo', 9,'Laboratorio di Informatica');
		-- Inserire il fatto che gli studenti di Informatica non ancora in tesi hanno sostenuto tale esame in data odierna 
		-- (senza inserire votazione).
			ALTER TABLE Esami DROP CONSTRAINT dataOggi;
			INSERT INTO Esami(Studente, Corso, Data) 
			SELECT DISTINCT Studente, 'labinfo', CURRENT_DATE
			FROM Esami
						JOIN Studenti ON Matricola= Studente
			WHERE Laurea IS NULL;
		-- Modificare i voti degli studenti che hanno sostenuto tale corso e non hanno assegnata una votazione 
		-- assegnando come votazione la votazione media dello studente.
			UPDATE Esami
			SET Voto = (SELECT AVG(Voto)
					   FROM Esami)
			WHERE Voto IS NULL AND Corso = 'labinfo';
		-- Ripristinare, se possibile, il vincolo not null su Esami.voto, ad es. mediante il comando alter table esami add constraint vnn check 
		-- (voto is not null); 
		   alter table esami add constraint vnn check(voto IS NOT NULL);


		-- DATI DERIVATI, VISTE --

		--  Creare una vista StudentiNonInTesi che permetta di visualizzare i dati 
		--  (matricola, cognome, nome, residenza, data di nascita, luogo di nascita, corso di laurea, anno accademico di iscrizione) 
		--  degli studenti non ancora in tesi (che non hanno assegnato alcun relatore).


		CREATE VIEW StudentiNonInTesi AS 
		SELECT Matricola, Cognome, Nome, Residenza, DataNascita, LuogoNascita, CorsoDiLaurea,Iscrizione
		FROM Studenti
		WHERE Relatore IS NULL;

		--Interrogare la vista StudentiNonInTesi per determinare gli studenti non in tesi nati e residenti a Genova.

		SELECT Matricola, Cognome, Nome, Residenza, DataNascita, LuogoNascita, CorsoDiLaurea,Iscrizione
		FROM StudentiNonInTesi
		WHERE Residenza = 'Genova' AND LuogoNascita = 'Genova';

		-- Creare la vista StudentiMate degli studenti di matematica non ancora laureati in cui ad ogni studente sono associate le 
		-- informazioni sul numero di esami che ha sostenuto e la votazione media conseguita. Nella vista devono comparire anche gli 
		-- studenti che non hanno sostenuto alcun esame.

		CREATE VIEW StudentiMate AS 
		SELECT Matricola, Cognome, Nome, COUNT(voto) AS NEsami, AVG(Voto) as Media
		FROM Studenti
						LEFT OUTER JOIN Esami ON studente= matricola
						JOIN CorsiDiLaurea CL ON corsoDiLaurea = CL.id
		WHERE Denominazione = 'Matematica' AND Laurea IS NULL
		GROUP BY Matricola, Cognome,Nome ;

		-- Utilizzando la vista StudentiMate determinare quanti esami hanno sostenuto complessivamente gli studenti di matematica 
		-- non ancora laureati.
		 SELECT SUM(NEsami)
		 FROM StudentiMate;

		--Inserire una tupla a vostra scelta nella vista StudentiNonInTesi. 
		--L'inserimento va a buon fine? Perché? Esaminare l'effetto dell'inserimento, se andato a buon fine, sulla tabella Studenti

		INSERT INTO StudentiNonInTesi VALUES('S4935449', 'Polizzi', 'Lucrezia', 'Boissano', '2001-11-15', 'Pietra Ligure',9, '2020' );

		SELECT *
		FROM Studenti
		ORDER BY Cognome;
		-- L'inserimento va a buon fine perché sono stati inseriti correttamente tutti i campi ed è stato inserito anche nella tabella Studenti

		--Inserire una tupla a piacere nella vista StudentiMate. 
		--L'inserimento va a buon fine? Perché? Esaminare l'effetto dell'inserimento, se andato a buon fine, sulla tabella Studenti.



		INSERT INTO StudentiMate VALUES('S4935449', 'Polizzi', 'Lucrezia', 8, 20 );

		SELECT *
		FROM Studenti
		ORDER BY Cognome;

		-- L'inserimento non va a buon fine per colpa di un group by. 
		-- L'errore che mi da è questo :
	-- 	ERROR:  cannot insert into view "studentimate"
	-- DETAIL:  Views containing GROUP BY are not automatically updatable.
	-- HINT:  To enable inserting into the view, provide an INSTEAD OF INSERT trigger or an unconditional ON INSERT DO INSTEAD rule.












/*CREATE schema corsi;*/
set search_path to corsi;



CREATE TABLE Professori
(id NUMERIC(5,0) PRIMARY KEY,
cognome VARCHAR(20) NOT NULL,
nome VARCHAR(20) NOT NULL,
stipendio NUMERIC(8,2) DEFAULT 15000,
InCongedo BOOL DEFAULT FALSE,
UNIQUE(cognome, nome));

INSERT INTO Professori VALUES(6642,'verdi','marco',1500,false);
INSERT INTO Professori VALUES(64,'ancona','davide',4000.50,false);



/*-- un valore chiave duplicato viola il vincolo univoco "professori_pkey"*/
INSERT INTO Professori VALUES(64,'guerrini','giovanna',3000.50,true);
/*-- un valore chiave duplicato viola il vincolo univoco "professori_cognome_nome_key" */
INSERT INTO Professori VALUES(581,'ancona','davide',2000.50,true);
/*-- valori null nella colonna "cognome" violano il vincolo non-null */
INSERT INTO Professori (id, nome, stipendio, InCongedo) VALUES(65,'giovanna',99999.99,true);



CREATE TABLE Corsi
(id CHAR(10) PRIMARY KEY,
CorsoDiLaurea VARCHAR(20) NOT NULL,
Nome VARCHAR(20) NOT NULL,
Professore NUMERIC(5, 0) REFERENCES Professori ON UPDATE CASCADE ON DELETE RESTRICT,
Attivato BOOL DEFAULT FALSE
);



/* Inserimento dei prof rispettivi (non richiesto) */
INSERT INTO Professori VALUES(92,'Odone','Francesca',5459,false);
INSERT INTO Professori VALUES(74,'Caminata','Alessio',3000.50,false);
INSERT INTO Professori VALUES(61,'Alberti','Giovanni',7000,true);
INSERT INTO Professori VALUES(500,'Chiola','Giovanni',10000,false);



INSERT INTO Corsi VALUES(664,'Informatica','Programmazione',92 ,false);
INSERT INTO Corsi VALUES(665,'Informatica','Calculus',61,false);
INSERT INTO Corsi VALUES(666,'Informatica','Algebra',74,false);



INSERT INTO Corsi (id, CorsoDiLaurea, Nome, Attivato) VALUES(45,'Informatica','Adc',false);



/*--un valore chiave duplicato viola il vincolo univoco "corsi_pkey"*/
INSERT INTO Corsi VALUES(664,'Informatica','Programmazione',111,false);



/* Cambio id della Odone e verifico che sia stato cambiato in Corsi (CASCADE) */
UPDATE Professori SET Id = 1 WHERE Id = 92;
SELECT * FROM Corsi WHERE Professore = 1;



/*-- l'istruzione UPDATE o DELETE sulla tabella "professori" viola il vincolo di chiave esterna "corsi_professore_fkey" sulla tabella "corsi"
DETAIL: La chiave (id)=(74) è ancora referenziata dalla tabella "corsi". */
DELETE FROM Professori WHERE Id = 74;

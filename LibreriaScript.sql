drop database if exists Libreria;
create database if not exists Libreria;
use Libreria;

drop table if exists Fornitori;
drop table if exists Provenienze;
drop table if exists Posizioni;
drop table if exists Titoli;
drop table if exists LibriISBN;
drop table if exists Clienti;
drop table if exists Acquisti;
drop table if exists Vendite;

/*Table fornitori prima della forma 3NF (Fornitori U Provenienza)

Create table if not exists Fornitori(
CodF char(2) primary key,
Cognome varchar(10),
Nome varchar(8),
Denominazione_Aziendale varchar(20),
Citta varchar(15),
Provincia char(2)
 )ENGINE=INNODB;

*/

create table if not exists Provenienze(
Citta varchar(15) primary key,
Provincia char(2)
)ENGINE=INNODB;

create table if not exists Fornitori(
CodF char(2) primary key,
Cognome varchar(10),
Nome varchar(8),
Denominazione_Aziendale varchar(20),
Citta varchar(15) not null,
Foreign key (Citta) references Provenienze(Citta)
) ENGINE=INNODB;

create table if not exists Posizioni(
Lettera char(1),
Scaffale char(1),
primary key (Lettera, Scaffale)
) ENGINE=INNODB;


/*Tabella LIBRI PRIMA DELLA 3NF (LibriISBN U Titoli)

create table if not exists Libri(
ISBN char(14) primary key,
Titolo varchar(60),
Lingua varchar(20),
N_Pagine smallint,
Prezzo decimal(4,2),
Genere varchar(20),
Eta_Consigliata tinyint,
Editore varchar(30),
Data_Pubblicazione Date,
Tipo_Copertina varchar(15),
Lettera char(1) not null,
Scaffale char(1) not null,
foreign key (Lettera, Scaffale) references Posizioni(Lettera, Scaffale)
) ENGINE=INNODB;

*/

Create table if not exists Titoli(
Titolo varchar(60) primary key,
Lingua varchar(20),
Eta_Consigliata tinyint,
Genere varchar(20),
Lettera char(1) not null,
Scaffale char(1) not null,
Foreign key (Lettera, Scaffale) references Posizioni(Lettera, Scaffale)
) ENGINE=INNODB;

Create table if not exists LibriISBN(
ISBN char(14) primary key,
Titolo varchar(60) not null,
N_Pagine smallint,
Prezzo decimal(4,2),
Editore varchar(30),
Data_Pubblicazione Date,
Tipo_Copertina varchar(15),
Foreign key (Titolo) references Titoli(Titolo)
)ENGINE=INNODB;

Create view InfoLibri as
Select 	ISBN, Titoli.Titolo, Titoli.Lingua, N_Pagine, Prezzo, Titoli.Genere, Titoli.Eta_Consigliata, Editore, Data_Pubblicazione, Tipo_Copertina, Titoli.Lettera, Titoli.Scaffale
FROM	LibriISBN Inner Join Titoli On LibriISBN.Titolo = Titoli.Titolo;

create table if not exists Clienti(
Email varchar(40) primary key,
Cognome varchar(20),
Nome varchar(20),
DataN date,
Telefono char(10)
) ENGINE=INNODB;

create table if not exists Acquisti(
CodF char(2),
ISBN char(14),
DataF date,
Sconto_Percentuale tinyint,
Prezzo_Unitario decimal(4,2),
Quantita tinyint,
primary key(CodF, ISBN, DataF),
foreign key(CodF) references Fornitori(CodF),
foreign key(ISBN) references LibriISBN(ISBN)
) ENGINE=INNODB;

create table if not exists Vendite(
ISBN char(14),
Email varchar(40),
DataV date,
Sconto_Percentuale tinyint,
N_Copie tinyint,
primary key (ISBN, Email, DataV),
foreign key (ISBN) references LibriISBN(ISBN),
foreign key (Email) references Clienti(Email)
) ENGINE=INNODB;

/* Insert prima della 3NF di FORNITORI

Insert into Fornitori values
('AA','Bianchi', 'Marco','BMsrl' ,'Roma', 'RO'),
('AB','Rossi', 'Sofia','RSsrl','Milano', 'MI'),
('AC','Verdi', 'Luca','VLsrl','Roma', 'RO'),
('AD','Gialli', 'Matilda','GMsrl','Milano', 'MI'),
('AE','Neri', 'Giuseppe','NGsrl','Milano', 'MI');

*/

insert into Provenienze values
('Roma', 'RO'), ('Milano', 'MI');

insert into Fornitori values
('AA','Bianchi', 'Marco','BMsrl', 'Roma'),
('AB','Rossi', 'Sofia','RSsrl', 'Milano'),
('AC','Verdi', 'Luca','VLsrl', 'Roma'),
('AD','Gialli', 'Matilda','GMsrl', 'Milano'),
('AE','Neri', 'Giuseppe','NGsrl', 'Milano');

insert into Posizioni values
('A','1'), ('B','1'), ('C','1'), ('D','1'), ('E','2'), ('F','2'), ('G','2'), ('H','2'), ('I','3'), ('L','3'), ('M','3'),('N','3'), 
('O','4'), ('P','4'), ('Q','4'), ('R','4'), ('S','5'), ('T','5'), ('U','5'), ('V','5'), ('W','6'), ('X','6'), ('Y','6'), ('Z','6'),
('0','1');

/* Insert prima della 3NF di Libri (LibriISBN U Titoli)  

insert into Libri values
('978-1408855652',"Harry Potter and the Philosopher's Stone",'Inglese', 352, 7.71,'Fantasy', 9,'Bloomsbury','2014/09/01', 'Flessibile', 'H','2'),
('978-1408855669',"Harry Potter and the Chamber of Secrets",'Inglese',384, 9.13,'Fantasy', 9,'Bloomsbury','2014/01/01', 'Flessibile', 'H','2'),
('978-1408855676',"Harry Potter and the Prisoner of Azkaban",'Inglese', 480, 10.75,'Fantasy', 9,'Bloomsbury','2014/01/01', 'Flessibile', 'H','2'),
('978-1408855683',"Harry Potter and the Goblet of Fire",'Inglese', 640, 12.24,'Fantasy', 9,'Bloomsbury','2014/01/01', 'Flessibile','H','2'),
('978-1408855690',"Harry Potter and the Order of Phoenix",'Inglese', 816, 13.68,'Fantasy', 9,'Bloomsbury','2014/01/01', 'Flessibile','H','2'),
('978-1408855706',"Harry Potter and the Half-blood Prince",'Inglese', 560, 13.20,'Fantasy', 9,'Bloomsbury','2014/01/01', 'Flessibile','H','2'),
('978-1408855713',"Harry Potter and the Deathly Hallows",'Inglese', 640, 9.70,'Fantasy', 9,'Bloomsbury','2014/09/01', 'Flessibile','H','2'),
('978-8807900587', "Il Ritratto di Dorian Gray", 'Italiano', 272, 8.07, 'Romanzo Gotico',12,'Feltrinelli','2013/06/13','Flessibile', 'R','4'),
('978-8807900129', "Cime Tempestose", 'Italiano', 428, 9.02, 'Romanzo Gotico',13,'Feltrinelli','2014/04/12', 'Flessibile','C',1),
('978-8804719137', "1984", 'Italiano',321, 12.35,'Romanzo Distopico', 12, 'Mondadori', '2019/11/12', 'Flessibile','0', '1'),
('978-8863114355', "La Fattoria degli Animali", "Italiano", 128, 4.80, 'Romanzo Distopico', 12, 'Liberamente', '2020/01/01', 'Flessibile', 'L','3'),
('978-8804736677', "Una corte di spine e rose. Trilogia. La saga di Feyre", 'Italiano', 1440, 30.40, 'Fantasy', 14,'Mondadori', '2021/11/30', 'Rigida', 'C', '1')
;

*/

Insert into Titoli Values
("Harry Potter and the Philosopher's Stone", 'Inglese', 9, 'Fantasy', 'H', '2'),
("Harry Potter and the Chamber of Secrets",'Inglese', 9, 'Fantasy', 'H', '2'),
("Harry Potter and the Prisoner of Azkaban",'Inglese', 9, 'Fantasy', 'H', '2'),
("Harry Potter and the Goblet of Fire",'Inglese', 9, 'Fantasy', 'H', '2'),
("Harry Potter and the Order of Phoenix",'Inglese', 9, 'Fantasy', 'H', '2'),
("Harry Potter and the Half-blood Prince",'Inglese', 9, 'Fantasy', 'H', '2'),
("Harry Potter and the Deathly Hallows",'Inglese', 9, 'Fantasy', 'H', '2'),
("Il Ritratto di Dorian Gray", 'Italiano', 12 , 'Romanzo Gotico', 'R', '4'),
("Cime Tempestose", 'Italiano', 13 , 'Romanzo Gotico', 'C', '1'),
("1984", 'Italiano', 12, 'Romanzo Distopico', '0', '1'),
("La Fattoria degli Animali", 'Italiano', 12, 'Romanzo Distopico', 'L', '3'),
("Una corte di spine e rose. Trilogia. La saga di Feyre", 'Italiano', 14,  'Fantasy', 'C', '1')
;

Insert into LibriISBN Values
('978-1408855652',"Harry Potter and the Philosopher's Stone", 352, 7.71, 'Bloomsbury', '2014/09/01', 'Flessibile'),
('978-1408855669',"Harry Potter and the Chamber of Secrets", 384, 9.13,  'Bloomsbury', '2014/01/01', 'Flessibile'),
('978-1408855676',"Harry Potter and the Prisoner of Azkaban", 480, 10.75, 'Bloomsbury', '2014/01/01', 'Flessibile'),
('978-1408855683',"Harry Potter and the Goblet of Fire", 640, 12.24, 'Bloomsbury', '2014/01/01', 'Flessibile'),
('978-1408855690',"Harry Potter and the Order of Phoenix", 816, 13.68, 'Bloomsbury', '2014/01/01', 'Flessibile'),
('978-1408855706',"Harry Potter and the Half-blood Prince", 560, 13.20, 'Bloomsbury', '2014/01/01', 'Flessibile'),
('978-1408855713',"Harry Potter and the Deathly Hallows", 640, 9.70, 'Bloomsbury', '2014/09/01', 'Flessibile'),
('978-8807900587', "Il Ritratto di Dorian Gray", 272, 8.07, 'Feltrinelli','2013/06/13','Flessibile'),
('978-8807900129', "Cime Tempestose", 428, 9.02, 'Feltrinelli','2014/04/12', 'Flessibile'),
('978-8804719137', "1984", 321, 12.35,'Mondadori', '2019/11/12', 'Flessibile'),
('978-8863114355', "La Fattoria degli Animali", 128, 4.80, 'Liberamente', '2020/01/01', 'Flessibile'),
('978-8804736677', "Una corte di spine e rose. Trilogia. La saga di Feyre", 1440, 30.40, 'Mondadori', '2021/11/30', 'Rigida')
;



insert into Clienti values
("mihauca135@gmail.com", "Sauca", "Mihai", "2000/05/13","1234567891"),
("rossaolo128@gmail.com","Rossi","Paolo","1999/08/21","1987654321"),
("lucianchi023@mail.com", "Bianchi", "Luca", "2002/03/20","3202134897"),
("eleneri02@mail.com", "Neri", "Elena", "2001/12/15","3230192857"), /*12/15*/
("Soferdi139@mail.com", "Verdi", "Sofia", "2003/09/12","3212133847")
;

insert into Acquisti values
('AA','978-1408855652','2014/08/09', 0, 5.25, 20),
('AB','978-1408855669','2014/09/19', 10, 7.10, 10),
('AD','978-1408855676','2014/10/22', 10, 7.20, 20),
('AA','978-1408855683','2014/11/17', 10, 9.40, 10),
('AE','978-1408855690','2014/12/01', 10, 11.10, 15),
('AE','978-1408855706','2014/12/09', 10, 11.00, 15),
('AC','978-1408855713','2014/12/15', 10, 7.50, 10),
('AC','978-8807900587','2012/12/15', 10, 6.20, 10),
('AB','978-8807900129','2014/01/15', 10, 6.50, 10),
('AB','978-8804719137','2019/12/15', 10, 10.20, 10),
('AC','978-8863114355','2020/01/15', 0, 2.50, 10),
('AA','978-8804736677', '2021/12/02', 10, 22, 10)
;

/*
Trigger che si attiva se si inserisce una data di vendita antecedente alla data di acquisto del libro mettendo quest'ultima come data di vendita
*/
DELIMITER $$
CREATE TRIGGER CheckDataVendita
BEFORE INSERT ON Vendite
FOR EACH ROW
	IF (NEW.DataV) < (SELECT Max(DataF) FROM Acquisti WHERE NEW.ISBN = Acquisti.ISBN)
    THEN SET NEW.DataV = (SELECT Max(DataF) FROM Acquisti WHERE NEW.ISBN = Acquisti.ISBN);
    END IF $$
DELIMITER ;

insert into Vendite values 
('978-1408855669',"mihauca135@gmail.com",'2014/10/20', 10, 2),
('978-1408855669',"rossaolo128@gmail.com",'2014/11/20', 10, 1),
('978-1408855690',"lucianchi023@mail.com",'2015/02/12', 15,3),
('978-1408855713',"eleneri02@mail.com",'2013/01/09', 0, 1), -- Inserimento data sbagliato per vedere il trigger --
('978-1408855713',"Soferdi139@mail.com",'2015/01/10', 0, 1)
;

/*
Funzione per calcolare l'eta di una persona data la data di nascita.
*/
DELIMITER $$
CREATE FUNCTION ETA(DNascita DATE)
RETURNS INT
Deterministic
BEGIN
	declare oggi date;
    declare nascita date;
    declare n int;
    set oggi = curdate();
    set nascita = DNascita;
    
    SELECT (Year(oggi) - Year(nascita))
    - ( CASE 
           WHEN (MONTH(oggi) > MONTH(nascita))
               OR (
                   MONTH(oggi) = MONTH(nascita)
                   AND DAY(oggi) >= DAY(nascita)
               )
           THEN 0
           ELSE 1
        END) 
		INTO n;
        RETURN n;
END $$
DELIMITER ;

/*
Funzione per calcolare il ricavo di un libro dato il suo ISBN togliendo eventuali sconti applicati
*/
DELIMITER $$
CREATE FUNCTION RicavoLibro(ISBN char(14))
RETURNS DECIMAL(7,2)
DETERMINISTIC
BEGIN
	DECLARE Ricavo decimal(4,2);
    DECLARE Prezzo decimal(4,2);
    DECLARE Qta decimal(4,2);
    DECLARE Sconto decimal(4,2);
    SELECT  LibriISBN.Prezzo FROM LibriISBN WHERE LibriISBN.ISBN = ISBN INTO Prezzo;
    SELECT	Sum(N_Copie), Sum(Sconto_Percentuale) FROM Vendite WHERE Vendite.ISBN = ISBN INTO Qta, Sconto;
    RETURN	(Prezzo*Qta)-(Prezzo*Sconto/100);
END$$
DELIMITER ;

CREATE VIEW PrezziEconomici AS
SELECT ISBN, Titolo, Prezzo
FROM LibriISBN
WHERE Prezzo <= 10;

CREATE VIEW PrezziCostosi AS
SELECT ISBN, Titolo, Prezzo
FROM LibriISBN
WHERE Prezzo > 30;

CREATE VIEW RicavoTotalePerOgniLibro AS
SELECT LibriISBN.ISBN, LibriISBN.Titolo, RicavoLibro(LibriISBN.ISBN) AS Ricavo
FROM Vendite INNER Join LibriISBN ON Vendite.ISBN = LibriISBN.ISBN
GROUP BY LibriISBN.ISBN;

DELIMITER $$
CREATE PROCEDURE GeneriPresenti()
COMMENT 'Restituisce una lista di tutti i generi presenti e quanti libri diversi appartengono a quel genere'
SELECT Genere, Count(Titolo) as Numero_Di_Libri
FROM Titoli 
GROUP BY Genere$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE LibriGenereConPagineMaggioreUgualeDi(g varchar(20), p smallint)
COMMENT 'Restituisce il titolo, il costo e le pagine dei libri in base al genere specificato e con numero di pagine maggiore o uguale di uno specificato'
SELECT Titolo, Prezzo, N_Pagine
FROM InfoLibri
WHERE Genere = g  AND N_Pagine >= p$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ClientiEtaMaggioreUgualeDi(a tinyint)
COMMENT 'Restituisce le Email e le età dei clienti con età maggiore o uguale di una specificata'
SELECT Email, ETA(DataN) as Eta
FROM Clienti
WHERE ETA(DataN) >= a$$
DELIMITER ;

/*ALCUNE INTERROGAZIONI SULLA BASE DI DATI E CHIAMATE A FUNZIONI E PROCEDURE*/

Select * FROM Fornitori;

-- Informazioni sui libri non in inglese, con numero di pagine superiori a 300 e data di pubblicazione maggiore del 2002 con prezzo maggiore di 10 --
Select * 
From INFOLibri 
Where N_Pagine > 300 and Prezzo > 10 and year(Data_Pubblicazione) > 2002 and Lingua not in ('Inglese'); 

Select * From Vendite;

-- Info su chi ha acquistato più copie di un libro della saga di Harry Potter in una volta sola e di quale libro si tratta oltre al numero di copie--
Select Clienti.Email, N_copie, Titolo as Libro_Comprato 
From LibriISBN, Vendite, Clienti 
Where LibriISBN.ISBN = Vendite.ISBN and Vendite.Email = Clienti.Email and Titolo Like "Harry Potter and %" and N_Copie > 1 ;

SELECT Nome, Cognome, ETA(DataN) as Eta
FROM Clienti;

SELECT * FROM PrezziEconomici;
SELECT * FROM PrezziCostosi;

SELECT RicavoLibro("978-1408855669");
SELECT * FROM RicavoTotalePerOgniLibro;

CALL GeneriPresenti;
Call LibriGenereConPagineMaggioreUgualeDi('Fantasy', 500);
Call ClientiEtaMaggioreUgualeDI(20);
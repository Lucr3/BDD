set search_path to 'unicorsilarge';



-- Query per ottenere relpages (numero blocchi per memorizzare la tabella) e reltuples (numero tuple per tabella)
SELECT C.oid, relname, relfilenode, relam, relpages, reltuples, relhasindex, relkind
FROM pg_namespace N JOIN pg_class C ON N.oid = C.relnamespace
WHERE N.nspname = 'unicorsilarge';



SELECT relname, relpages, reltuples
FROM pg_namespace N JOIN pg_class C ON N.oid = C.relnamespace
WHERE N.nspname = 'unicorsilarge';



/* Individuare il piano di esecuzione scelto dal sistema nel caso per determinare tutti gli esami con voto superiore a 18
Descrivere il piano scelto dal sistema, descrivendo ciascun operatore fisico, e riportare il tempo di esecuzione totale.*/
/* ANALYZE singolo per sync */
ANALYZE;



EXPLAIN ANALYZE
SELECT *
FROM Esami
WHERE Voto > 18;
/* Il piano scelto dal sistema è un singolo Seq Scan () (singolo nodo; con rows removed by filter 67514)
(cost=0.00..2383.00 rows=52380 width=28) (actual time=0.030..45.381 rows=52486 loops=1)
Planning time: 0.171 ms
Execution time: 47.964 ms*/



/* Creare un indice ad albero non clusterizzato sull'attributo voto della tabella esami.
Individuare nuovamente il piano di esecuzione scelto dal sistema per determinare tutti gli esami con voto superiore a 18.
Descrivere il piano scelto dal sistema, descrivendo ciascun operatore fisico, e riportare il tempo di esecuzione totale.
Cosa cambia rispetto al punto precedente? */



CREATE INDEX idx_voto
ON Esami(voto);



EXPLAIN ANALYZE
SELECT *
FROM Esami
WHERE voto > 18;
/*
Nonostante l'indice viene comunque scelto il piano sequenziale.
La selezione con Filter: (voto > '18'::numeric) non è evidentemente stata giudicata come significativa
Seq Scan on esami (cost=0.00..2383.00 rows=52380 width=28) (actual time=0.021..39.425 rows=52486 loops=1)
Planning time: 0.129 ms
Execution time: 41.852 ms (circa stesso tempo di esecuzione di prima)
*/



/* Individuare adesso il piano di esecuzione scelto dal sistema per determinare tutti gli esami con voto superiore a 29.
Descrivere il piano scelto dal sistema, descrivendo ciascun operatore fisico, e riportare il tempo di esecuzione totale.
Cosa cambia rispetto al punto precedente? */


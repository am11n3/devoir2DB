//Amine EJJORFI

------------------
//C7
------------------

DECLARE
CURSOR C_pilote
IS SELECT nom, sal, comm
FROM pilote 
WHERE nopilot BETWEEN 1280 AND 1999 FOR UPDATE;
v_nom pilote.nom%type;
v_sal pilote.sal%type;
v_comm pilote.comm%type;
BEGIN
open C_pilote;
loop
fetch C_pilote into v_nom, v_sal,v_comm;
exit WHEN C_pilote%notfound;
if v_comm is NULL THEN
DELETE pilote WHERE current of C_pilote ;
elsif
v_comm > v_sal THEN 
UPDATE pilote 
SET sal = sal + comm ,comm = NULL
WHERE current of C_pilote ;
END if ;
END loop ;
close C_pilote ;
END ;

----------------
//C8
----------------
CREATE OR REPLACE PROCEDURE l_plt( v_nopil in pilote.nopilot%type)
 is cursor C_pilote is SELECT nopilot,sal,comm FROM pilote;
    plt_notexist  EXCEPTION; 
    plt_exist    EXCEPTION;
    comm_sal    EXCEPTION;
     b number := 0;
   BEGIN
     for v_rest IN C_pilote
     loop
       if v_rest.nopilot = v_nopil
          THEN b:=1;
              if v_rest.comm > v_rest.sal
                  THEN raise comm_sal;
              END if;
       END if;
     END loop;
         if b=1 THEN 
             raise plt_exist;
         ELSE  
             raise plt_notexist;
         END if;
   EXCEPTION
        WHEN  plt_exist THEN
            dbms_output.put_line (' ERREUR :  NOM PILOTE-OK') ;
        WHEN  plt_notexist THEN
            DBMS_OUTPUT.PUT_LINE (' ERREUR :PILOTE INCONNU ');
        WHEN  comm_sal THEN
            DBMS_OUTPUT.PUT_LINE (' ERREUR :NOM PILOTE , COMM >SAL');
END;
----------------

//D1

CREATE VIEW v_plt
AS
SELECT * FROM pilote
WHERE ville = 'paris';

----------------
//D2

UPDATE v_plt
SET sal=sal*0.1
WHERE ville='paris';
----------------

//D3

CREATE VIEW D_vol
AS
SELECT  avion ,max(date_vol) AS max FROM affectation 
GROUP BY avion;
--------------------

//D4

CREATE VIEW  C_plt AS
SELECT *  FROM pilote 
WHERE(ville='paris' AND comm IS NOT NULL)
OR(ville <>'paris' AND comm IS NULL)
WITH CHECK option;

-----------------------

//D5

CREATE VIEW mycm AS 
SELECT * FROM pilote
WHERE(comm IS null AND nopilot NOT IN ( SELECT pilote FROM affectation))
OR ( comm IS NOT NULL AND nopilot IN( SELECT pilote FROM affectation))
WITH CHECK option;


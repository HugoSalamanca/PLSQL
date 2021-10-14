-----------REF CURSORS----------------
--------------------------------------
/*1. Crear un REF CURSOR para que visualice el primer nombre de la región
de la tabla REGIONS. */

DECLARE
    TYPE RC1 IS REF CURSOR;
    V1 RC1;
    REGIONES REGIONS%ROWTYPE;
BEGIN
    OPEN V1 FOR SELECT * FROM REGIONS;
    FETCH V1 INTO REGIONES;
    DBMS_OUTPUT.PUT_LINE(REGIONES.REGION_NAME);
    CLOSE V1;
END;

/

/*2. Con el mismo cursor visualizamos también la primera ciudad 
de la tabla LOCATIONS*/

DECLARE
    TYPE RC1 IS REF CURSOR;
    V1 RC1;
    REGIONES REGIONS%ROWTYPE;
    CIUDAD LOCATIONS%ROWTYPE;
BEGIN
    OPEN V1 FOR SELECT * FROM REGIONS;
    FETCH V1 INTO REGIONES;
    DBMS_OUTPUT.PUT_LINE(REGIONES.REGION_NAME);
    CLOSE V1;
    OPEN V1 FOR SELECT * FROM LOCATIONS;
    FETCH V1 INTO CIUDAD;
    DBMS_OUTPUT.PUT_LINE(CIUDAD.CITY);
    CLOSE V1;
END;

/

/*3 Crear un procedimiento que tenga un parámetro de tipo numérico.

    - Si es un 1 debe visualizar todos los nombres de regiones.
    - Si es un 2 debe visualizar todas las ciudades.
    *DEBE USARSE UN SOLO BUCLE PARA HACER EL TRABAJO.
*/

CREATE OR REPLACE PROCEDURE ejercicio3 (numero NUMBER) IS

    TYPE RC1 IS REF CURSOR;
    V1 RC1;
    CADENA VARCHAR(30);
    
BEGIN
    
    IF numero = 1 THEN
    OPEN V1 FOR SELECT REGION_NAME FROM REGIONS;
    END IF;
    IF numero = 2 THEN
    OPEN V1 FOR SELECT CITY FROM LOCATIONS;
    END IF;
    
    FETCH V1 INTO CADENA;
    WHILE V1%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(CADENA);
        FETCH V1 INTO CADENA;
    END LOOP;
END ejercicio3;

/

/*4. Crear una función que reciba como argumento un salario 
y que devuelva un REF CURSOR de tipo EMPLOYEES con los
empleados que ganen más de ese salario.
Crear luego un bloque PL/SQL que llame a la función para probarla.
*/

CREATE OR REPLACE FUNCTION ejercicio4 (salario NUMBER) RETURN SYS_REFCURSOR IS

    TYPE RC1 IS REF CURSOR RETURN EMPLOYEES%ROWTYPE;
    V1 RC1;
    
BEGIN
    
    OPEN V1 FOR SELECT * FROM EMPLOYEES WHERE SALARIO > salario;
    RETURN V1;
END ejercicio4;

/

DECLARE
    RC1 SYS_REFCURSOR;
    salario NUMBER;
    EMPLEADOS EMPLOYEES%ROWTYPE;
BEGIN
    salario:=2000;
    RC1 := ejercicio4(salario);
    LOOP
    FETCH RC1 INTO EMPLEADOS;
    DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST_NAME || ' ' || EMPLEADOS.SALARY);
    EXIT WHEN RC1%NOTFOUND;
    END LOOP;
END;

/


/*5. Vamos a crear un paquete que tenga las siguientes características.
    
    - Declarar una variable de tipo REF_CURSOR de tipo EMPLOYEES.
    - Crear una función dentro del paquete que tenga como argumento
        el REF_CURSOR creado anteriormente y devuelve la media de los salarios.
    -Desde un bloque anónimo creamos una variable REF_CURSOR, la rellenamos
        con alguna condición (libre). Y pasamos este cursor a la función
        para que nos devuelva la suma de la media de los salarios.
*/

CREATE OR REPLACE PACKAGE PACKAGE1 IS

    TYPE RC1 IS REF CURSOR RETURN EMPLOYEES%ROWTYPE;
    FUNCTION media_salarios (V1 RC1) RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY PACKAGE1 IS
    
    FUNCTION media_salarios (V1 RC1) RETURN NUMBER IS
        SALARIOS NUMBER;
        MEDIA NUMBER;
        CONTADOR NUMBER;
        EMPLEADO EMPLOYEES%ROWTYPE;
    BEGIN
        SALARIOS := 0;
        MEDIA := 0;
        CONTADOR := 0;
        LOOP
            FETCH V1 INTO EMPLEADO;
            EXIT WHEN V1%NOTFOUND;
            SALARIOS:= SALARIOS + EMPLEADO.SALARY;
            CONTADOR:= CONTADOR + 1;
        END LOOP;
        MEDIA := SALARIOS / CONTADOR;
        RETURN MEDIA;
    END media_salarios;
END;

/

DECLARE
    REF1 PACKAGE1.RC1;
    MEDIA NUMBER(10,2);
BEGIN
    OPEN REF1 FOR SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 100;
    MEDIA := PACKAGE1.media_salarios(REF1);
    DBMS_OUTPUT.PUT_LINE(' La media de los empleados es: ' || media);
END;
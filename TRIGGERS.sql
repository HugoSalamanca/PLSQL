---------------------------TRIGGERS---------------------------------------------

--Trigger1: Trigger que guarda cambios en tabla FACTURAS

CREATE OR REPLACE TRIGGER trigger1 
AFTER INSERT OR UPDATE OR DELETE ON FACTURAS
BEGIN
    IF INSERTING THEN
    INSERT INTO CONTROL_LOG VALUES (USER, SYSDATE,'FACTURAS','I');
    END IF;
    IF UPDATING THEN
    INSERT INTO CONTROL_LOG VALUES (USER, SYSDATE, 'FACTURAS', 'U');
    END IF;
    IF DELETING THEN
    INSERT INTO CONTROL_LOG VALUES (USER, SYSDATE, 'FACTURAS', 'D');
    END IF;
END trigger1;

/

--Trigger2: Trigger que guarda cambios en la tabla LINEAS_FACTURA

CREATE OR REPLACE TRIGGER trigger2 
AFTER INSERT OR UPDATE OR DELETE ON LINEAS_FACTURA
BEGIN
    IF INSERTING THEN
    INSERT INTO CONTROL_LOG VALUES (USER, SYSDATE,'FACTURAS','I');
    END IF;
    IF UPDATING THEN
    INSERT INTO CONTROL_LOG VALUES (USER, SYSDATE, 'FACTURAS', 'U');
    END IF;
    IF DELETING THEN
    INSERT INTO CONTROL_LOG VALUES (USER, SYSDATE, 'FACTURAS', 'D');
    END IF;
END trigger2;

/

--Trigger 3:
/* La columna TOTAL_VENDIDO de la tabla PRODUCTOS mantiene el total de ventas
de un determinado producto.

Para controlarlo, creamos un trigger sobre la tabla LINEAS_FACTURA, de forma 
que cada vez que se añada, cambie o borre una línea se actualice en la tabla
PRODUCTOS la columna TOTAL_VENDIDO, ya sea añadiendo o restando.*/

CREATE OR REPLACE TRIGGER trigger3
AFTER INSERT OR UPDATE OR DELETE ON LINEAS_FACTURA
FOR EACH ROW
DECLARE
    diferencia NUMBER := 0;
BEGIN
    IF INSERTING THEN
        UPDATE PRODUCTOS SET TOTAL_VENDIDOS = :NEW.UNIDADES WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;
    END IF;
    IF UPDATING THEN
        diferencia := :OLD.UNIDADES - :NEW.UNIDADES;
        UPDATE PRODUCTOS SET TOTAL_VENDIDOS = TOTAL_VENDIDOS + diferencia WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;
    END IF;
    IF DELETING THEN
        UPDATE PRODUCTOS SET TOTAL_VENDIDOS = TOTAL_VENDIDOS - :NEW.UNIDADES WHERE COD_PRODUCTO = :NEW.COD_PRODUCTO;
    END IF;
END trigger3;

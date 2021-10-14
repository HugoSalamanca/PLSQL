CREATE OR REPLACE PACKAGE FACTURASP IS
    --Procedimientos
    PROCEDURE ALTA_FACTURA(COD_FACTURA NUMBER, FECHA DATE, DESCRIPCION VARCHAR2);
    PROCEDURE BAJA_FACTURA(COD_FACTURA NUMBER);
    PROCEDURE MOD_DESCRIP(COD_FACTURA NUMBER, DESCRIPCION VARCHAR2);
    PROCEDURE MOD_FECHA(COD_FACTURA NUMBER, FECHA DATE);
    --Funciones
    FUNCTION NUM_FACTURAS(FECHA_INICIO DATE, FECHA_FIN DATE) RETURN NUMBER;
    FUNCTION TOTAL_FACTURA(COD_FACTURA NUMBER) RETURN NUMBER;
END FACTURASP;
/

CREATE OR REPLACE PACKAGE BODY FACTURASP IS

--Función privada para comprobar si existe una factura

    FUNCTION EXISTECODIGO (COD_FACTURA NUMBER)
    RETURN BOOLEAN IS
        codigo FACTURAS.COD_FACTURA%TYPE;
    --Comprobamos si existe la factura
    BEGIN
        SELECT COD_FACTURA INTO codigo FROM FACTURAS WHERE COD_FACTURA = COD_FACTURA;
        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ha occurido un error: ' || sqlcode);
    END EXISTECODIGO;

-- Procedimiento Alta factura

    PROCEDURE ALTA_FACTURA (COD_FACTURA IN NUMBER, FECHA DATE, DESCRIPCION VARCHAR2) IS
        existe_factura BOOLEAN;
        error_duplicado EXCEPTION;
    BEGIN 
    existe_factura := EXISTECODIGO(COD_FACTURA);
        IF NOT existe_factura THEN
            INSERT INTO FACTURAS VALUES (COD_FACTURA, FECHA, DESCRIPCION);
            COMMIT;
        ELSE
            RAISE error_duplicado;
        END IF;
    EXCEPTION
        WHEN error_duplicado THEN
            RAISE_APPLICATION_ERROR(-20001,'Ese número de factura ya existe, no se puede duplicar');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Ha ocurrido un error: ' || sqlcode);
    END ALTA_FACTURA;
    
--Procedimiento Baja factura

    PROCEDURE BAJA_FACTURA(COD_FACTURA NUMBER) IS
    existe_factura BOOLEAN;
    error_no_existe EXCEPTION;
    BEGIN
    existe_factura := EXISTECODIGO(COD_FACTURA);
        IF existe_factura THEN
            DELETE FROM FACTURAS WHERE COD_FACTURA = COD_FACTURA;
            DELETE FROM LINEAS_FACTURA WHERE COD_FACTURA = COD_FACTURA;
            COMMIT;
        ELSE
            RAISE error_no_existe;
        END IF;
    EXCEPTION
        WHEN error_no_existe THEN
            RAISE_APPLICATION_ERROR(-20001,'No existe el número de factura proporcionado');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Ha ocurrido un error: ' || sqlcode);
    END BAJA_FACTURA;

--Procedimiento Modificar descripción

    PROCEDURE MOD_DESCRIP (COD_FACTURA IN NUMBER, DESCRIPCION VARCHAR2) IS
    existe_factura BOOLEAN;
    error_no_existe EXCEPTION;
    BEGIN 
    existe_factura := EXISTECODIGO(COD_FACTURA);
        IF existe_factura THEN
            UPDATE FACTURAS SET DESCRIPTION = DESCRIPCION WHERE COD_FACTURA = COD_FACTURA;
            COMMIT;
        ELSE
            RAISE error_no_existe;
        END IF;
    EXCEPTION
        WHEN error_no_existe THEN
            RAISE_APPLICATION_ERROR(-20001,'No existe el número de factura proporcionado');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Ha ocurrido un error: ' || sqlcode);
    END MOD_DESCRIP;

--Procedimiento Modificar fecha.

    PROCEDURE MOD_FECHA (COD_FACTURA IN NUMBER, FECHA DATE) IS
    existe_factura BOOLEAN;
    error_no_existe EXCEPTION;
    BEGIN 
    existe_factura := EXISTECODIGO(COD_FACTURA);
        IF existe_factura THEN
            UPDATE FACTURAS SET FECHA = FECHA WHERE COD_FACTURA = COD_FACTURA;
            COMMIT;
        ELSE
            RAISE error_no_existe;
        END IF;
    EXCEPTION
        WHEN error_no_existe THEN
            RAISE_APPLICATION_ERROR(-20001,'No existe el número de factura proporcionado');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Ha ocurrido un error: ' || sqlcode);
    END MOD_FECHA;
    
--Función Número de facturas entre dos fechas.

    FUNCTION NUM_FACTURAS (FECHA_INICIO DATE, FECHA_FIN DATE) 
    RETURN NUMBER IS
    contador NUMBER;
    BEGIN
        SELECT COUNT(*) INTO contador FROM FACTURAS WHERE FECHA BETWEEN FECHA_INICIO AND FECHA_FIN;
    RETURN contador;
    END NUM_FACTURAS;
    
-- Función total de una factura.

    FUNCTION TOTAL_FACTURA (COD_FACTURA NUMBER)
    RETURN NUMBER IS
    total NUMBER;
    BEGIN
        SELECT SUM(PVP*UNIDADES) INTO total FROM LINEAS_FACTURA WHERE COD_FACTURA = COD_FACTURA;
    RETURN total;
    END TOTAL_FACTURA;

END FACTURASP;
    
/

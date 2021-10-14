CREATE OR REPLACE PACKAGE LINEAS_FACTURAP IS
    -- Procedimientos
    PROCEDURE ALTA_LINEA(COD_FACTURA NUMBER, COD_PRODUCTO NUMBER, UNIDADES NUMBER, FECHA DATE);
    PROCEDURE BAJA_LINEA(COD_FACTURA NUMBER, COD_PRODUCTO NUMBER);
    PROCEDURE MOD_PRODUCTO(COD_FACTURA NUMBER, COD_PRODUCTO NUMBER, UNIDADES NUMBER);
    PROCEDURE MOD_PRODUCTO(COD_FACTURA NUMBER, COD_PRODUCTO NUMBER, FECHA DATE);
    -- Funciones
    FUNCTION NUM_LINEAS(COD_FACTURA NUMBER) RETURN NUMBER;
END LINEAS_FACTURAP;

/

CREATE OR REPLACE PACKAGE BODY LINEAS_FACTURAP IS

-- Función privada para comprobar si existe la factura

    FUNCTION EXISTE_FACTURA (COD_FACTURA NUMBER) RETURN BOOLEAN IS
    codigo FACTURAS.COD_FACTURA%TYPE;
    BEGIN
        SELECT COD_FACTURA INTO codigo FROM FACTURAS WHERE COD_FACTURA = COD_FACTURA;
        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ha occurido un error: ' || sqlcode);
    END EXISTE_FACTURA; 

-- Función privada para comprobar si existe el producto
    FUNCTION EXISTE_PRODUCTO (COD_PRODUCTO NUMBER) RETURN BOOLEAN IS
    codigo PRODUCTOS.COD_PRODUCTO%TYPE;
    BEGIN
        SELECT COD_PRODUCTO INTO codigo FROM PRODUCTOS WHERE COD_PRODUCTO = COD_PRODUCTO;
     RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ha occurido un error: ' || sqlcode);
    END EXISTE_PRODUCTO;  
    
-- Procedimiento Alta Línea.

    PROCEDURE ALTA_LINEA (COD_FACTURA NUMBER, COD_PRODUCTO NUMBER, UNIDADES NUMBER, FECHA DATE) IS
    precio PRODUCTOS.PVP%TYPE;
    existefactura BOOLEAN;
    existeproducto BOOLEAN;
    error_no_existe EXCEPTION;
    BEGIN
        existefactura := EXISTE_FACTURA(COD_FACTURA);
        existeproducto := EXISTE_PRODUCTO(COD_PRODUCTO);
    IF existefactura AND existeproducto THEN
        SELECT PVP INTO precio FROM PRODUCTOS WHERE COD_PRODUCTO = COD_PRODUCTO;
        INSERT INTO LINEAS_FACTURA VALUES (COD_FACTURA, COD_PRODUCTO, precio, UNIDADES, FECHA);
    ELSE
        RAISE error_no_existe;
    END IF;
    EXCEPTION
        WHEN error_no_existe THEN
            IF NOT existefactura THEN
                RAISE_APPLICATION_ERROR(-20001,'Error, no existe la factura proporcionada');
            ELSIF NOT existeproducto THEN
                RAISE_APPLICATION_ERROR(-20002,'Error, no existe el producto proporcionado');
            ELSE
                RAISE_APPLICATION_ERROR(-20003,'Error, no existen la factura ni el producto proporcionados');
            END IF;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20004, 'Ha ocurrido un error: '|| sqlcode);
    END ALTA_LINEA;
    
-- Procedimiento Baja Línea.

    PROCEDURE BAJA_LINEA (COD_FACTURA NUMBER, COD_PRODUCTO NUMBER) IS
    existefactura BOOLEAN;
    existeproducto BOOLEAN;
    error_no_existe EXCEPTION;
    BEGIN
        existefactura := EXISTE_FACTURA(COD_FACTURA);
        existeproducto := EXISTE_PRODUCTO(COD_PRODUCTO);
    
    IF existefactura AND existeproducto THEN
        DELETE FROM LINEAS_FACTURA WHERE COD_FACTURA = COD_FACTURA AND COD_PRODUCTO = COD_PRODUCTO;
    ELSE
        RAISE error_no_existe;
    END IF;
    EXCEPTION
        WHEN error_no_existe THEN
            IF NOT existefactura THEN
                RAISE_APPLICATION_ERROR(-20001,'Error, no existe la factura proporcionada');
            ELSIF NOT existeproducto THEN
                RAISE_APPLICATION_ERROR(-20002,'Error, no existe el producto proporcionado');
            ELSE
                RAISE_APPLICATION_ERROR(-20003,'Error, no existen la factura ni el producto proporcionados');
            END IF;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20004, 'Ha ocurrido un error: '|| sqlcode);
    END BAJA_LINEA;
    
-- Procedimiento Modificar Unidades    
    
    PROCEDURE MOD_PRODUCTO (COD_FACTURA NUMBER, COD_PRODUCTO NUMBER, UNIDADES NUMBER) IS
    existefactura BOOLEAN;
    existeproducto BOOLEAN;
    error_no_existe EXCEPTION;
    BEGIN
        existefactura := EXISTE_FACTURA(COD_FACTURA);
        existeproducto := EXISTE_PRODUCTO(COD_PRODUCTO);
    
    IF existefactura AND existeproducto THEN
        UPDATE LINEAS_FACTURA SET UNIDADES = UNIDADES WHERE COD_FACTURA = COD_FACTURA AND COD_PRODUCTO = COD_PRODUCTO;
    ELSE
        RAISE error_no_existe;
    END IF;
    EXCEPTION
        WHEN error_no_existe THEN
            IF NOT existefactura THEN
                RAISE_APPLICATION_ERROR(-20001,'Error, no existe la factura proporcionada');
            ELSIF NOT existeproducto THEN
                RAISE_APPLICATION_ERROR(-20002,'Error, no existe el producto proporcionado');
            ELSE
                RAISE_APPLICATION_ERROR(-20003,'Error, no existen la factura ni el producto proporcionados');
            END IF;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20004, 'Ha ocurrido un error: '|| sqlcode);
    END MOD_PRODUCTO;
    
-- Procedimiento Modificar la fecha.

    PROCEDURE MOD_PRODUCTO (COD_FACTURA NUMBER, COD_PRODUCTO NUMBER, FECHA DATE) IS
    existefactura BOOLEAN;
    existeproducto BOOLEAN;
    error_no_existe EXCEPTION;
    BEGIN
        existefactura := EXISTE_FACTURA(COD_FACTURA);
        existeproducto := EXISTE_PRODUCTO(COD_PRODUCTO);
    
    IF existefactura AND existeproducto THEN
        UPDATE LINEAS_FACTURA SET FECHA = FECHA WHERE COD_FACTURA = COD_FACTURA AND COD_PRODUCTO = COD_PRODUCTO;
    ELSE
        RAISE error_no_existe;
    END IF;
    EXCEPTION
        WHEN error_no_existe THEN
            IF NOT existefactura THEN
                RAISE_APPLICATION_ERROR(-20001,'Error, no existe la factura proporcionada');
            ELSIF NOT existeproducto THEN
                RAISE_APPLICATION_ERROR(-20002,'Error, no existe el producto proporcionado');
            ELSE
                RAISE_APPLICATION_ERROR(-20003,'Error, no existen la factura ni el producto proporcionados');
        END IF;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20004, 'Ha ocurrido un error: '|| sqlcode);
    END MOD_PRODUCTO;

-- Función Número de Líneas.

    FUNCTION NUM_LINEAS (COD_FACTURA NUMBER) RETURN NUMBER IS
    numero NUMBER;
    BEGIN
        SELECT COUNT(*) INTO numero FROM LINEAS_FACTURA WHERE COD_FACTURA = COD_FACTURA;
    END NUM_LINEAS; 
    
    
    
    
END LINEAS_FACTURAP;

/

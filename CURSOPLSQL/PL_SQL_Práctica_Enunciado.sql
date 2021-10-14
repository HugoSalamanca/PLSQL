--TABLAS Y ELEMENTOS NECESARIOS PARA LA PRÁCTICA--

CREATE TABLE LINEAS_FACTURA(
    COD_FACTURA NUMBER,
    COD_PRODUCTO NUMBER,
    PVP NUMBER,
    UNIDADES NUMBER,
    FECHA DATE
    );

CREATE TABLE FACTURAS (
    COD_FACTURA NUMBER,
    FECHA DATE,
    DESCRIPTION VARCHAR2(100)
    );

CREATE TABLE PRODUCTOS(
    COD_PRODUCTO NUMBER,
    NOMBRE_PRODUCTO VARCHAR2(50),
    PVP NUMBER,
    TOTAL_VENDIDOS NUMBER
    );

CREATE TABLE CONTROL_LOG(
    COD_EMPLEADO NUMBER,
    FECHA DATE,
    TABLA VARCHAR2(20),
    COD_OPERACION CHAR
    );

ALTER TABLE LINEAS_FACTURA ADD CONSTRAINT LINEAS_FACTURA_PK PRIMARY KEY (COD_FACTURA, COD_PRODUCTO);
ALTER TABLE LINEAS_FACTURA MODIFY COD_PRODUCTO NOT NULL ENABLE;
ALTER TABLE LINEAS_FACTURA MODIFY COD_FACTURA NOT NULL ENABLE;


Insert into PRODUCTOS 
(COD_PRODUCTO,NOMBRE_PRODUCTO,PVP,TOTAL_VENDIDOS) values 
('1','TORNILLO','1',null);
Insert into PRODUCTOS 
(COD_PRODUCTO,NOMBRE_PRODUCTO,PVP,TOTAL_VENDIDOS) values 
('2','TUERCA','5',null);
Insert into PRODUCTOS 
(COD_PRODUCTO,NOMBRE_PRODUCTO,PVP,TOTAL_VENDIDOS) values 
('3','ARANDELA','4',null);
Insert into PRODUCTOS 
(COD_PRODUCTO,NOMBRE_PRODUCTO,PVP,TOTAL_VENDIDOS) values 
('4','MARTILLO','40',null);
Insert into PRODUCTOS 
(COD_PRODUCTO,NOMBRE_PRODUCTO,PVP,TOTAL_VENDIDOS) values 
('5','CLAVO','1',null);


------------------COMPONENTES DE LA PRÁCTICA----------------------
/*La práctica pretende realizar los componentes necesarios para gestionar 
esas tablas. En cocreto:
    - Paquete para gestionar las facturas.
    - Paquete para gestionar las lineas de factura.
    - Triggers para controlar el acceso a las tablas.
    
--------------------------------------------------------------------------------
------------------------PAQUETE FACTURAS----------------------------------------
--------------------------------------------------------------------------------

------------------------PROCEDIMIENTOS------------------------------------------
/*ALTA_FACTURA(COD_FACTURA,FECHA,DESCRIPCION)
    -Debe dar de alta una factura con los valores indicados en los parámetros.
    -Debe comrpobar que no se duplica.


  BAJA_FACTURA(COD_FACTURA)
    - Debe borrar la factura indicada en el parámetro.
    - Debe borrar también las líneas de factura asociadas en la tabla LINEAS_FACTURA.


  MOD_DESCRIP(COD_FACTURA,DESCRIPCION)
    - Debe modificar la descripción de la factura que tenga el código
        del parámetro con la nueva descripción.


  MOD_FECHA(COD_FACTURA, FECHA)
    - Debe modificar la fecha de la factura que tenga el código del parámetro
        con la nueva fecha./*


----------------------------FUNCIONES-------------------------------------------
/*NUM_FACTURAS(FECHA_INIDIO,FECHA_FIN)
    - Devuelve el número de facturas que hay entre esas dos fechas.

  TOTAL_FACTURA(COD_FACTURA)
    - Devuelve el total de la factura con ese código. Debe hacer el sumatorio
    de pvp*unidades de las líneas de esa factura en la tabla LINEAS_FACTURA.
*/


--------------------------------------------------------------------------------
------------------------PAQUETE LINEA_FACTURAS----------------------------------
--------------------------------------------------------------------------------

------------------------PROCEDIMIENTOS------------------------------------------
/* ALTA_LINEA(COD_FACTURA, COD_PRODUCTO, UNIDADES, FECHA)
	- Procedimiento para insertas una línea de Factura.
	- Debe comprobar que existe ya la factura antes de insertar el registro.
	- También debemos comprobar que existe el producto en la tabla de PRODUCTOS.
	- El PVP debemos seleccionarlo de la tabla PRODUCTOS.

   BAJA_LINEA(COD_FACTURA, COD_PRODUCTO)
	- Damos de baja la línea con esa clave primaria.

   MOD_PRODUCTO(COD_FACTURA, COD_PRODUCTO, PARÁMETRO)
	-Se trata de 2 métodos sobrecargados, es decir, el parámetro debe de admitir 
	 los siguientes valores:
		UNIDADES
		FECHA
	- Por tanto debe modificar o bien las unidades o bien la fecha.*/

----------------------------FUNCIONES-------------------------------------------
/* NUM_LINEAS(COD_FACTURA)
	- Devuelve el número de líneas de la factura.*/


--------------------------------------------------------------------------------
-----------------------------TRIGGERS-------------------------------------------
--------------------------------------------------------------------------------

-------------------------TRIGGERS DE TIPO STATEMENT-----------------------------

/* Creamos dos triggers, uno para la tabla FACTURAS y otro para LINEAS_FACTURA
	
	Cada cambio en alguna de las tablas (INSERT, UPDATE O DELETE) debe generar
	una entrada en la tabla CONTROL_LOG con los datos siguientes:
		- Tabla(FACTURAS o lINEAS_FACTURA)
		- Fecha -> SYSDATE
		- Usuario que lo ha realizado
		- Operación realizada (INSERTING, UPDATING, DELETING)
*/


-------------------------TRIGGERS DE TIPO FILA---------------------------------

/* La columna TOTAL_VENDIDO de la tabla PRODUCTOS mantiene el total de ventas
de un determinado producto.

Para controlarlo, creamos un trigger sobre la tabla LINEAS_FACTURA, de forma 
que cada vez que se añada, cambie o borre una línea se actualice en la tabla
PRODUCTOS la columna TOTAL_VENDIDO, ya sea añadiendo o restando.*/






















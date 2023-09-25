-- SCRIPT 1 DDL

DROP SCHEMA IF EXISTS remerasrapha2;
CREATE SCHEMA remerasRapha2;

USE remerasRapha2;


CREATE TABLE IF NOT EXISTS Cuello (
    id_cuello INT NOT NULL AUTO_INCREMENT,
    cuelloObj VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_cuello)
);
	
CREATE TABLE IF NOT EXISTS Estampado (
    id_estampado INT NOT NULL AUTO_INCREMENT,
    estampadoObj VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_estampado)
);

CREATE TABLE IF NOT EXISTS Talle (
    id_talle INT NOT NULL AUTO_INCREMENT,
    talleObj VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_talle)
);

CREATE TABLE IF NOT EXISTS Color (
    id_color INT NOT NULL AUTO_INCREMENT,
    colorObj VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_color)
);

CREATE TABLE IF NOT EXISTS Colores_Elegidos (
    id_colores_e INT NOT NULL AUTO_INCREMENT,
    id_color1 INT NOT NULL,
    id_color2 INT ,
    id_color3 INT ,
    PRIMARY KEY (id_colores_e),
    FOREIGN KEY (id_color1)
        REFERENCES Color (id_color),
    FOREIGN KEY (id_color2)
        REFERENCES Color (id_color),
    FOREIGN KEY (id_color3)
        REFERENCES Color (id_color)
);

CREATE TABLE IF NOT EXISTS Remera (
    id_remera INT NOT NULL AUTO_INCREMENT,
    id_cuello INT NOT NULL,
    id_estampado INT NOT NULL,
    id_talle INT NOT NULL,
    id_colores_e INT NOT NULL,
    PRIMARY KEY (id_remera),
    FOREIGN KEY (id_cuello)
        REFERENCES Cuello (id_cuello),
    FOREIGN KEY (id_estampado)
        REFERENCES Estampado (id_estampado),
    FOREIGN KEY (id_talle)
        REFERENCES Talle (id_talle),
    FOREIGN KEY (id_colores_e)
        REFERENCES Colores_Elegidos (id_colores_e)
);

CREATE TABLE IF NOT EXISTS Ubicacion (
    id_ubicacion INT NOT NULL AUTO_INCREMENT,
    codigo_postal VARCHAR(30) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255),
    PRIMARY KEY (id_ubicacion)
);

CREATE TABLE IF NOT EXISTS Contacto (
    id_contacto INT NOT NULL AUTO_INCREMENT,
    telefono VARCHAR(100),
    email VARCHAR(255),
    PRIMARY KEY (id_contacto)
);

CREATE TABLE IF NOT EXISTS Usuarios (
    id_usuario INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    id_ubicacion INT NOT NULL,
    id_contacto INT NOT NULL,
    PRIMARY KEY (id_usuario),
    CONSTRAINT FK_ContactodeUsuario FOREIGN KEY (id_contacto)
        REFERENCES Contacto (id_contacto),
    CONSTRAINT FK_UbicacionUsuario FOREIGN KEY (id_ubicacion)
        REFERENCES Ubicacion (id_ubicacion)
);

CREATE TABLE IF NOT EXISTS Ordenes (
    id_orden INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    fecha_de_orden DATETIME NOT NULL,
    comentario_de_pedido VARCHAR(255),
    entregado BOOLEAN NOT NULL,
    PRIMARY KEY (id_orden),
    FOREIGN KEY (id_usuario)
        REFERENCES Usuarios (id_usuario)
    
);

CREATE TABLE IF NOT EXISTS Pedidos (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    id_remera INT NOT NULL,
    id_orden INT NOT NULL,
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_remera)
        REFERENCES Remera (id_remera),
	FOREIGN KEY (id_orden)
		REFERENCES ordenes (id_orden)
	
);

CREATE TABLE IF NOT EXISTS Review (
    id_review INT NOT NULL AUTO_INCREMENT,
    id_remera INT NOT NULL,
    comentario VARCHAR(255),
    calificacion TINYINT CHECK (calificacion >= 1 AND calificacion <= 5),
    fecha_publicacion DATETIME NOT NULL,
    PRIMARY KEY (id_review),
    FOREIGN KEY (id_remera)
        REFERENCES Remera (id_remera)

);

-- (Aqui estan las tablas de los TRIGGERS)

CREATE TABLE IF NOT EXISTS Pedidos_log
(
    id_pedido INT NOT NULL AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    usuario VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_pedido)
);

CREATE TABLE IF NOT EXISTS colores_elegidos_log (
    timestamp DATETIME,
    usuario VARCHAR(255),
    action VARCHAR(50),
    old_id_colores_e INT,
    old_id_color1 INT,
    old_id_color2 INT,
    old_id_color3 INT,
    new_id_color1 INT,
    new_id_color2 INT,
    new_id_color3 INT
);

CREATE TABLE IF NOT EXISTS usuarios_log (
    id_usuario INT NOT NULL,
    creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
       
CREATE TABLE IF NOT EXISTS log_entrega_orden (
        id_orden INT ,
        creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        estado varchar(10) DEFAULT 'Entregado'
);

-- SCRIPT 2 VIEWS

-- VISTA 1
-- ESTA VISTA DEVUELVE TODO EL DISEÑO ADEMAS DE LOS COLORES DE LA REMERA
CREATE OR REPLACE VIEW Diseños_remeras AS
(SELECT R.id_remera,c.cuelloObj, Es.estampadoObj,T.talleObj
,(c1.colorObj) AS color1,
(c2.colorObj) AS color2,
(c3.colorObj) AS color3 
FROM remera R 
JOIN cuello C ON C.id_cuello = R.id_cuello
JOIN estampado Es ON Es.id_estampado = R.id_estampado
JOIN talle T ON T.id_talle = R.id_talle
JOIN colores_elegidos CE ON CE.id_colores_e = R.id_colores_e
LEFT JOIN color c1 ON CE.id_color1 = c1.id_color
LEFT JOIN color c2 ON CE.id_color2 = c2.id_color
LEFT JOIN color c3 ON CE.id_color3 = c3.id_color
ORDER BY id_remera);

-- VISTA 2
-- ESTA VIEW DEVUELVE LOS COLORES DE CADA ID_REMERA
CREATE OR REPLACE VIEW Colores_remeras AS (
SELECT R.id_remera,R.id_colores_e,
(c1.colorObj) AS color1,
(c2.colorObj) AS color2,
(c3.colorObj) AS color3
FROM remera R
JOIN colores_elegidos CE ON CE.id_colores_e = R.id_colores_e
LEFT JOIN color c1 ON CE.id_color1 = c1.id_color
LEFT JOIN color c2 ON CE.id_color2 = c2.id_color
LEFT JOIN color c3 ON CE.id_color3 = c3.id_color
ORDER BY id_remera);

-- VISTA 3
-- ESTA VIEW DEVUELVE UNA VISTA CON TODAS LAS REMERAS Y SUS CLASIFICACIONES
CREATE OR REPLACE VIEW Calificacion_remeras as
(SELECT REV.*,co.email,co.telefono FROM review REV join remera REM ON REV.id_remera = REM.id_remera 
join pedidos p on p.id_remera = REM.id_remera 
join ordenes o on o.id_orden = p.id_orden
join usuarios us on o.id_usuario = us.id_usuario 
join contacto co on us.id_contacto = co.id_contacto);

-- VISTA 4
-- ESTA VISTA DEVUELVE INFORMACION UTIL PARA EL REPARTIDOR
CREATE OR REPLACE VIEW infoparaRepartidor as (
SELECT ord.id_orden,Concat(US.nombre,' ',US.apellido) 
AS Nombre_Apellido ,UB.direccion, UB.descripcion, CO.telefono 
FROM ubicacion UB
JOIN usuarios US ON US.id_ubicacion = UB.id_ubicacion
JOIN contacto CO ON CO.id_contacto = US.id_contacto
join ordenes ord ON ord.id_usuario = US.id_usuario
where entregado = false Order By id_orden );

-- VISTA 5
-- ESTA VISTA DEVUELVE INFORMACION GENERAL DEL PEDIDO
CREATE OR REPLACE VIEW InformacionOrdenes AS
(SELECT p.id_remera,o.id_orden,c.email,o.fecha_de_orden, o.comentario_de_pedido 
FROM pedidos p JOIN ordenes o
ON p.id_orden = o.id_orden 
JOIN usuarios u ON o.id_usuario = u.id_usuario
JOIN contacto c ON u.id_contacto = c.id_contacto
ORDER BY fecha_de_orden ASC);


-- VISTA 6
-- CANTIDAD DE PEDIDOS POR CADA USUARIO ORDENADO DE MENOR A MAYOR
CREATE OR REPLACE VIEW Cant_pedidos_por_usuario AS (
SELECT concat(u.nombre,' ',u.apellido) as Nombre, count(id_pedido) as cantidadPedida FROM usuarios u 
JOIN ordenes o ON o.id_usuario = u.id_usuario
JOIN pedidos p ON p.id_orden = o.id_orden
group by u.id_usuario
order by cantidadPedida desc);

-- VISTA  7
-- CANTIDAD DE ORDENES POR USUARIO (UNA ORDEN PUEDE TENER MUCHOS PEDIDOS)
CREATE OR REPLACE VIEW Cant_ordenes_por_usuario AS (
SELECT concat(u.nombre,' ',u.apellido) as Nombre, count(id_orden) as cantidadOrdenes FROM usuarios u 
JOIN ordenes o ON o.id_usuario = u.id_usuario
group by u.id_usuario
order by cantidadOrdenes desc);


-- VISTA 8
CREATE OR REPLACE VIEW infoUsuarios as (
	select us.id_usuario,nombre,apellido,telefono,email,codigo_postal,direccion from contacto c 
    join usuarios us on us.id_contacto = c.id_contacto
    join ubicacion u on us.id_ubicacion = u.id_ubicacion);
    
-- VISTA 9
    
CREATE OR REPLACE VIEW top_estampados AS (
SELECT estampadoObj as estampado,count(r.id_estampado) as Cantidad 
FROM remera r join estampado e on r.id_estampado = e.id_estampado
group by (estampadoObj) order by count(r.id_estampado) desc);


-- SCRIPT 3 FUNCTIONS

-- Funcion que devuelve la cantidad de ventas por estampado
DROP FUNCTION IF EXISTS cantVentas_x_estampado;
-- FUNC 1
DELIMITER //
CREATE FUNCTION cantVentas_x_estampado(estampado_id INT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE cantidad INT;
    
    SELECT COUNT(*) INTO cantidad
    FROM Remera R
    JOIN Pedidos P ON R.id_remera = P.id_remera
    WHERE R.id_estampado = estampado_id;
     
    RETURN cantidad;
END
//
/* -- OTRA MANERA ES ASI!
DELIMITER //
CREATE FUNCTION cantVentas_x_estampado(estampado_id INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT COUNT(*) 
    FROM Remera R
    JOIN Pedidos P ON R.id_remera = P.id_remera
    WHERE R.id_estampado = estampado_id);
END
// */

DROP FUNCTION IF EXISTS email_usuario;
-- FUNC 2
DELIMITER $$
-- DEVUELVE EL EMAIL DEL ID_USUARIO INGRESADO
CREATE FUNCTION email_usuario(usuario_id INT)
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    return(select c.email as email from usuarios u 
    join contacto c on c.id_contacto = u.id_contacto
    where id_usuario = usuario_id);
END $$

-- devuelve cantidad de remeras con el id_color ingresado

DROP FUNCTION IF EXISTS cantRemerascon_xcolor;

-- FUNC 3
DELIMITER $$
CREATE FUNCTION cantRemerascon_xcolor(color_id INT ) 
RETURNS int READS SQL DATA
BEGIN
	return(SELECT count(*) as Cantidad_del_ID_COLOR FROM colores_elegidos ce 
    where ce.id_color1 = color_id or ce.id_color2 = color_id or ce.id_color3 = color_id);
END$$

DROP FUNCTION if exists telefono_usuario;
-- FUNC 4
DELIMITER $$
CREATE FUNCTION telefono_usuario(usuario_id INT)
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    return(select c.telefono as Telefono from usuarios u 
    join contacto c on c.id_contacto = u.id_contacto
    where id_usuario = usuario_id);
END $$

-- FUNC 5
DELIMITER $$
CREATE FUNCTION cant_remeras_registradas()
RETURNS INT 
READS SQL DATA
BEGIN
	DECLARE remeras_registradas INT;
	SELECT COUNT(*) INTO remeras_registradas FROM remera;
    RETURN remeras_registradas;
END $$


-- FUNC 6
DELIMITER $$
CREATE FUNCTION cant_remeras_entregadas()
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE remeras_entregadas INT;
    SELECT count(*) INTO remeras_entregadas from 
    pedidos p join ordenes o on p.id_orden = o.id_orden
    where entregado = TRUE;
    RETURN remeras_entregadas;
END $$


-- FUNC 7
DELIMITER $$
CREATE FUNCTION cant_remeras_para_entregar()
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE remeras_para_entregada INT;
    SELECT count(*) INTO remeras_para_entregada from 
    pedidos p join ordenes o on p.id_orden = o.id_orden
    where entregado = FALSE;
    RETURN remeras_para_entregada;
END $$

-- SCRIPT 4 STORED PROCEDURES 

-- SP 1
-- Colocas una id de orden y confirma su entrega, si esta ya fue entregada, devolvera que ya fue entregada valga la redundancia.
DELIMITER //
CREATE PROCEDURE confirmarEntregaOrden(IN orderID INT)
BEGIN
	
    DECLARE entregado_value INT;

	SELECT entregado INTO entregado_value
	FROM ordenes
	WHERE id_orden = orderID;
    
    IF entregado_value = 0 THEN
		UPDATE ordenes
		SET entregado = 1 where id_orden = orderID;
        SELECT 'Entrega Realizada Correctamente!' as comentario;
	ELSE 
		SELECT 'El pedido YA fue entregado' as comentario;
	END IF;
END //

-- SP 2
-- Selecciona y ordena a los usuarios segun la columna indicada, y se puede elegir asc o desc
DELIMITER //
create procedure Usuarios_Ordenamiento(IN columna varchar(50),IN asc_desc char(4))
BEGIN
	
    DECLARE clausula VARCHAR(200);
    DECLARE orderbycolumna VARCHAR(100);
    DECLARE tipodeordenamiento varchar(200);
    
    IF columna <> '' THEN
		set @orderbycolumna = concat('Order by ', columna);
	ELSE
		set @orderbycolumna = '';
	END IF;
    
    IF asc_desc IN ('ASC','asc','DESC','desc') THEN
		SET @tipodeordenamiento = asc_desc;
	ELSE
		set @tipodeordenamiento = '';
	END IF;
    
    SET @clausula = concat('Select * from Usuarios ', @orderbycolumna,' ', @tipodeordenamiento);
    PREPARE runSQL FROM @clausula;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END //

-- SP 3
-- SELECCIONA UNA COLUMNA 'cuelloObj','estampadoObj','talleObj' Y HACE UN TOP CON LAS MAS VENDIDAS DE LA SELECCIONADA
DELIMITER // 
CREATE PROCEDURE top_de_cada_accesorio(
IN tipoAccesorio ENUM('cuelloObj','estampadoObj','talleObj'))
	
BEGIN 
DECLARE clausula1 varchar(255);    
DECLARE accesorioelegido varchar(50);

	SET @accesorioelegido = tipoAccesorio;
	SET @clausula1 = concat('SELECT ',@accesorioelegido,',count(*) as 
    CantUsada FROM remera R jOIN cuello C ON C.id_cuello = R.id_cuello
	JOIN estampado Es ON Es.id_estampado = R.id_estampado
	JOIN talle T ON T.id_talle = R.id_talle 
	group by ',@accesorioelegido ,' order by CantUsada desc;');
    
    PREPARE runSQL FROM @clausula1;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END //

-- SP 4
-- AGREGA UN USUARIO CON SUS DATOS TAMBIEN EL LA TABLA CONTACTO Y UBICACION
DELIMITER $$
CREATE PROCEDURE add_usuario(
    IN nombreNuevo VARCHAR(100),
    IN apellidoNuevo VARCHAR(100),
    IN telefonoNuevo VARCHAR(100),
    IN emailNuevo VARCHAR(255),
    IN codigo_postalNuevo VARCHAR(30),
    IN direccion VARCHAR(255))
    
BEGIN
		DECLARE contacto_id INT;
		DECLARE ubicacion_id INT;
	IF nombreNuevo = '' OR apellidoNuevo = '' OR telefonoNuevo = '' OR emailNuevo = '' OR codigo_postalNuevo = '' OR direccion = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Todos los campos son obligatorios. Por favor, complete todos los campos.';
    ELSE
		
		INSERT INTO ubicacion (codigo_postal, direccion, descripcion) 
		VALUES (codigo_postalNuevo, direccion,'');
		SET ubicacion_id = LAST_INSERT_ID(); -- le agregamos a la variable ubicacion_id ,la utima id de la tabla

		INSERT INTO contacto (telefono, email) 
		VALUES (telefonoNuevo, emailNuevo);
		SET contacto_id = LAST_INSERT_ID(); -- le agregamos a la variable contacto_id ,la utima id de la tabla
	   
		INSERT INTO usuarios (nombre, apellido, id_contacto, id_ubicacion) 
		VALUES (nombreNuevo, apellidoNuevo, contacto_id, ubicacion_id);
		
		SELECT 'Nuevo usuario agregado: ' AS Mensaje, nombreNuevo AS Nombre, apellidoNuevo AS Apellido;
    END IF;
END $$

-- SP 5
-- AGREGA UNA REMERA CON LOS DATOS NECESARIOS (en caso de no querer agregar id_color1 y 2 setear null)
DELIMITER //
CREATE PROCEDURE add_remera(
    IN cuello_id INT, IN estampado_id INT, IN talle_id INT,
    IN color1_id INT, IN color2_id char(2), IN color3_id char(2))
BEGIN
    DECLARE remera_id INT;
    DECLARE colores_elegidos_id INT;
    DECLARE color2 INT;
    DECLARE color3 INT;
    
    IF color2_id like '' THEN
		SET color2 = NULL;
	ELSE SET color2 = color2_id;
    END IF;
    
     IF color3_id like '' THEN
		SET color3 = NULL;
	ELSE SET color3 = color3_id;
    END IF;
    
    INSERT INTO Colores_Elegidos (id_color1, id_color2, id_color3) 
    VALUES (color1_id, color2, color3);
    SET colores_elegidos_id = LAST_INSERT_ID();
    
    INSERT INTO Remera (id_cuello, id_estampado, id_talle, id_colores_e) 
    VALUES (cuello_id, estampado_id, talle_id, colores_elegidos_id);
    SET remera_id = LAST_INSERT_ID();
    
    SELECT 	concat('id_remera: ',remera_id,' agregada correctamente') as Mensaje;
    
END //

-- SP 6
-- TOMA COMO VALORES EL ID_USUARIO Y LA REMERA YA CREADA, Y ALMACENA CADA UNA EN UN PEDIDO CORRESPONDIENTE,
-- SI PEDIS UNA REMERA, Y EN UN LAPSO MENOR A 24 HORAS PEDIS OTRA, SE ALMACENAN CON LA MISMA ID_ORDEN 
DELIMITER //
CREATE PROCEDURE add_pedido(
    IN usuario_id INT,
    IN id_remera INT
)
BEGIN
    DECLARE orden_id INT;
    DECLARE ultima_orden24hs_id INT;
    DECLARE mensaje VARCHAR(255);
   
    SELECT id_orden INTO ultima_orden24hs_id
    FROM Ordenes
    WHERE id_usuario = usuario_id
    AND fecha_de_orden >= DATE_SUB(NOW(), INTERVAL 1 DAY)
    ORDER BY fecha_de_orden DESC
    LIMIT 1;
    
	IF ultima_orden24hs_id IS NULL THEN
		INSERT INTO Ordenes (id_usuario, fecha_de_orden, entregado) 
        VALUES (usuario_id, NOW(), false);
		SET orden_id = LAST_INSERT_ID();
	ELSE
		SET orden_id = ultima_orden24hs_id;
	END IF;

	INSERT INTO Pedidos (id_remera, id_orden) VALUES (id_remera, orden_id);
END //

--  SP 7 STORED PROCEDURE QUE LLAMA A add_pedido y add_remera a la vez

DELIMITER //
CREATE PROCEDURE add_remera_a_pedido (
IN usuario_id_ INT,IN estampado_id_ INT,IN talle_id_ INT,
IN cuello_id_ INT, IN color1_id_ INT,IN color2_id_ char(2),IN color3_id_ char(2)) 
BEGIN
	DECLARE nueva_id_remera INT;
	CALL add_remera(cuello_id_,estampado_id_,talle_id_,color1_id_,color2_id_,color3_id_);
    SET nueva_id_remera = LAST_INSERT_ID();
    
    CALL add_pedido (usuario_id_,nueva_id_remera);
    
    SELECT concat('La id_remera: ',nueva_id_remera,
    ' a sido creada y pedida por el usuario: ',usuario_id_) as Message;
END //

-- SP 8
-- PROCEDURE QUE TOMA COMO PARAMETRO A UNA ID DE REMERA Y LE ACTUALIZA LOS COLORES (EN CASO DE NO QUERER PONER OTRO COLOR SETEAR NULL)
delimiter //
CREATE PROCEDURE edit_Colores_Elegidos 
(IN remera_id INT,IN color1_id INT,IN color2_id char(2),IN color3_id char(2))
BEGIN

	DECLARE color2 INT;
    DECLARE color3 INT;
    
    IF color2_id like '' THEN
		SET color2 = NULL;
	ELSE SET color2 = color2_id;
    END IF;
    
     IF color3_id like '' THEN
		SET color3 = NULL;
	ELSE SET color3 = color3_id;
    END IF;

	UPDATE colores_elegidos co join remera r on r.id_colores_e = co.id_colores_e 
    set id_color1 = color1_id,id_color2 = color2,id_color3 = color3 
    where co.id_colores_e = remera_id;
    select concat('La id_remera: ',remera_id,' a sido modificada a los colores: ') as Comentario,
    color1_id as id_color1,
    color2_id as id_color2,
    color3_id as id_color3 from colores_elegidos
    limit 1;
END //


-- SP 9
-- Obtiene el total de ordenes por id_usuario
DELIMITER //
CREATE PROCEDURE get_totalOrdenesxUsuario(
    IN usuario_id INT,
    OUT totalOrdenes INT
)
BEGIN
    SELECT COUNT(*) INTO totalOrdenes
    FROM Ordenes
    WHERE id_usuario = usuario_id ;
END // 	


-- SP 10
-- AGREGA O ACTUALIZA LA DESCRIPCION DE LA UBICACION DE UN USUARIO SEGUN SU ID_USUARIO
DELIMITER // 
CREATE PROCEDURE agregarDescripcion_Ubicacion(IN usuario_id INT,IN nueva_descripcion_ubicacion varchar(255))
BEGIN
	UPDATE ubicacion ub join usuarios us 
    ON  ub.id_ubicacion = us.id_ubicacion
    SET descripcion = nueva_descripcion_ubicacion where id_usuario = usuario_id;
END // 


-- SP 11
-- FILTRA LAS REMERAS POR id_ESTAMPADO Y MOSTRAR INFORMACION DE REMERA
DELIMITER // 
CREATE PROCEDURE remerasxestampado(IN estampado_id INT)
BEGIN
	SELECT R.id_remera,c.cuelloObj, Es.estampadoObj,T.talleObj, R.id_colores_e
	,(c1.colorObj) AS color1,
	(c2.colorObj) AS color2,
	(c3.colorObj) AS color3 
	FROM remera R 
	JOIN cuello C ON C.id_cuello = R.id_cuello
	JOIN estampado Es ON Es.id_estampado = R.id_estampado
	JOIN talle T ON T.id_talle = R.id_talle
	JOIN colores_elegidos CE ON CE.id_colores_e = R.id_colores_e
	LEFT JOIN color c1 ON CE.id_color1 = c1.id_color
	LEFT JOIN color c2 ON CE.id_color2 = c2.id_color
	LEFT JOIN color c3 ON CE.id_color3 = c3.id_color
    where Es.id_estampado = estampado_id
	ORDER BY id_remera;
END // 

-- SP 12
-- FACILITA EL SELECT A TODOS LOS USUARIOS
DELIMITER //
CREATE PROCEDURE get_usuarios()
BEGIN
	SELECT id_usuario,nombre,apellido FROM USUARIOS;
END //

-- SP 13
-- OBTIENE LOS COLORES DE TODAS LAS REMERAS
DELIMITER //
CREATE PROCEDURE get_colores_remera ()
BEGIN
	SELECT R.id_remera,R.id_colores_e,
	(c1.colorObj) AS color1,
	(c2.colorObj) AS color2,	
	(c3.colorObj) AS color3
	FROM remera R
	JOIN colores_elegidos CE ON CE.id_colores_e = R.id_colores_e
	LEFT JOIN color c1 ON CE.id_color1 = c1.id_color
	LEFT JOIN color c2 ON CE.id_color2 = c2.id_color
	LEFT JOIN color c3 ON CE.id_color3 = c3.id_color
    ORDER BY id_remera asc;
END //

-- SP 14
-- AGREGA UN ESTAMPADO
DELIMITER // 
CREATE PROCEDURE add_Estampado(in nuevoEstampado varchar(50))
BEGIN
	IF nuevoEstampado not in (select estampadoObj from estampado) then
		INSERT INTO estampado (estampadoObj) values (nuevoEstampado);
		SELECT concat('Nuevo estampado: ',nuevoEstampado,' fue agregado correctamente!') as Comentario; 
	ELSE
		SELECT 'Este estampado ya existe' as comentario;
	END IF;
END //

-- SP 15
-- LE AGREGA UN COMENTARIO A LA ORDEN INDICADA SEGUN EL ID DE ESTE MISMO!
DELIMITER //
CREATE PROCEDURE add_comentario_orden(IN orden_ID INT,IN Comentario_Orden varchar(255))
BEGIN
	update ordenes 
    set comentario_de_pedido = Comentario_Orden 
    WHERE id_orden = orden_id;
END //

-- SP 16
-- PROCEDURE ENCARGADO DE AGREGAR UN COMENTARIO Y UNA CALIFICACION A UNA CIERTA ID_REMERA
DELIMITER //
CREATE PROCEDURE add_review(IN remera_id INT, IN comentarioNew VARCHAR(255), IN calificacionNew TINYINT)
BEGIN
	if calificacionNew >= 1 AND calificacionNew <= 5 THEN
		INSERT INTO review (id_remera,comentario,calificacion,fecha_publicacion) 
        values (remera_id,comentarioNew,calificacionNew,NOW());
		SELECT * from review where id_remera = remera_id;
	ELSE
		select concat('La calificacion solo esta permitida desde 1 a 5');
END IF;
END //
        
-- SP 17
DELIMITER //
CREATE PROCEDURE obtenerReseñaPorRemera(IN remeraID INT)
BEGIN
    if remeraID in (select id_remera from review) then
		SELECT r.id_remera, r.comentario, r.calificacion, r.fecha_publicacion
		FROM Review r
		WHERE r.id_remera = remeraID;
	else
		select 'Esta remera no tiene review' as Mensaje;
	END IF;
END //

-- SP 18 USO DE LA VISTA infousuarios para devolver la informacion de un solo usuario

DELIMITER // 
CREATE PROCEDURE infodeusuario (IN usuario_id INT)
BEGIN
	SELECT * FROM remerasrapha2.infousuarios 
    where id_usuario = usuario_id;
END //

-- SCRIPT 5 TRIGGERS 

-- TRIGGER 1

-- CADA VEZ QUE SE INSERTE UN PEDIDO, EL TRIGGER DISPARA UN INSERT EN LOG PEDIDO CON LA INFORMACION, 
-- Y QUE ADMINISTRADOR, O USUARIO LO EJECUTO 
delimiter //
CREATE TRIGGER  log_pedido
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO Pedidos_log
    (id_pedido, fecha_hora, usuario)
    VALUES
    (NEW.id_pedido, NOW(), USER());
END //


-- TRIGGER 2 encargado de auditar los update de color en los colores_elegidos con su respectiva tabla

DELIMITER //
CREATE TRIGGER log_colores_elegidos_act
BEFORE UPDATE ON colores_elegidos
FOR EACH ROW
BEGIN
    INSERT INTO colores_elegidos_log
    VALUES (NOW(), USER(), 'UPDATE',  OLD.id_colores_e, OLD.id_color1, OLD.id_color2, OLD.id_color3,
    NEW.id_color1,NEW.id_color2,NEW.id_color3);
END //


-- TRIGGER 3 QUE INSERTA EN LA TABLA USUARIOS LOG, EL ID_USUARIO, Y EL TIMESTAMP EN EL QUE SE CREO

DELIMITER //
CREATE TRIGGER log_usuarios
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
	INSERT INTO usuarios_log
    (id_usuario) values (NEW.id_usuario);
END //


-- TRIGGER 4

DELIMITER //
CREATE TRIGGER log_entrega_ordenes
AFTER UPDATE ON ordenes
FOR EACH ROW
BEGIN
	IF OLD.entregado <> NEW.entregado THEN
	INSERT INTO log_entrega_orden (id_orden) VALUES (new.id_orden);
    END IF;
END //
DELIMITER ;

-- SCRIPT 6 PrivilegesUsers

drop user if exists administracion@localhost;
drop user if exists fabrica_remeras@localhost;

-- Crea al usuario administracion en el localhost, y le asigna su contraseña
CREATE USER administracion@localhost IDENTIFIED BY '123456789';
-- Le da a USUARIO administracion la posibilidad de hacer selects, inserts, y update a todas las tablas
GRANT SELECT,INSERT,UPDATE ON remerasrapha2.* TO administracion@localhost;


-- Crea al usuario fabrica_remeras en el localhost, y le asigna su contraseña
CREATE USER fabrica_remeras@localhost IDENTIFIED BY 'qwertyuiop';

-- Le da al usuario fabricas_remeras la posibilidad de hacer Selects vistas que le sirven para fabricar las remeras

GRANT SELECT ON colores_remeras TO fabrica_remeras@localhost;
GRANT SELECT ON diseños_remeras TO fabrica_remeras@localhost; 

-- Muestran los privilegios concedidos
/* SHOW GRANTS FOR administracion@localhost;
SHOW GRANTS FOR fabrica_remeras@localhost; */

/* revoke select on *.* from USUARIO1@localhost;
revoke select,insert,update on *.* from USUARIO2@localhost; */

-- SCRIPT 7 INSERTS

SET SQL_safe_updates = 0;
SET foreign_key_checks = 0;

INSERT INTO Cuello (cuelloObj) VALUES
  ('Cuello Redondo'),
  ('Cuello en V'),
  ('Cuello Polo'),
  ('Cuello Alto'),
  ('Cuello Mao');

INSERT INTO Estampado (estampadoObj) VALUES
  ('Artic Monkeys'),
  ('Queen'),
  ('Darth Vader'),
  ('Logo Argentina'),
  ('Lu la mejor Profe'),
  ('NewYork'),
  ('The Backyardingans'),
  ('Mickey Mouse'),
  ('IloveParis'),
  ('Lionel Messi');

INSERT INTO Talle (id_talle,talleObj) 
VALUES (1,'S'),
  (2,'M'),
  (3,'L'),
  (4,'XL'),
  (5,'XXL');
  

INSERT INTO Color (colorObj) VALUES
  ('Rojo'),
  ('Azul'),
  ('Verde'),
  ('Amarillo'),
  ('Blanco'),
  ('Negro'),
  ('Gris');

 
INSERT INTO colores_elegidos (id_colores_e,id_color1,id_color2,id_color3)
VALUES (1,1,2,3),
	   (2,2,4,NULL),
       (3,3,NULL,NULL),
       (4,5,6,NULL),
       (5,4,7,NULL),
       (6,4,5,7),
       (7,3,1,2),
       (8,4,NULL,NULL),
       (9,3,3,NULL),
       (10,2,1,1),
       (11,1,4,1),
       (12,3,NULL,NULL),
       (13,4,1,7),
       (14,3,2,6),
       (15,4,3,7),
       (16,2,1,6),
       (17,1,1,5);
       
	
INSERT INTO remera (id_remera,id_cuello,id_estampado,id_talle,id_colores_e) 
VALUES (1,1,7,1,1),
	   (2,3,8,2,2),
       (3,3,3,4,3), 
       (4,4,5,4,4), 
       (5,1,1,2,5), 
       (6,2,4,2,6), 
       (7,1,7,1,7), 
       (8,2,4,3,8), 
       (9,4,2,2,9), 
       (10,3,5,2,10), 
       (11,2,1,1,11), 
       (12,4,3,3,12), 
       (13,3,9,3,13),
       (14,2,5,1,14),
       (15,4,2,1,15),
       (16,3,9,4,16),
       (17,4,2,2,17);
       
INSERT INTO ubicacion (id_ubicacion,codigo_postal,direccion,descripcion) 
VALUES (1,2342,'111 Southridge Circle',''),
	   (2,342423,'069 Becker Center',''),
       (3,67543,'29 Sunnyside Terrace',''),
       (4,662133,'917 Moose Alley',''),
       (5,53455,'424 Kim Court',''),
       (6,3455,'4 Marquette Junction',''),
       (7,6464,'7 Vidon Terrace','Tocar la puerta fuerte'),
       (8,45646,'22 Pleasure Street','llamar (no funciona timbre)'),
       (9,155048,'61 Melby Junction','Al lado de la puerta roja)'),
       (10,55631,'0136 1st Way','');

INSERT INTO contacto (id_contacto,telefono,email)
VALUES (1,'45 790 7322','acaush0@shutterfly.com'),
       (2,'57 818 2814','atrenholm1@epa.gov'),
       (3,'33 211 5197','gvenus2@ehow.com'),
       (4,'32 321 6187','rchingedehals3@domainmarket.com'),
       (5,'36 654 4278','mberetta4@unc.edu'),
       (6,'54 597 8524','brolstone5@nps.gov'),
       (7,'54 152 7355','pleyshon6@hhs.gov'),
       (8,'54 678 7616','tlenard7@wikispaces.com'),
       (9,'53 523 9950','agrishakin8@redcross.org'),
       (10,'55 241 8560','dvosse9@dailymotion.com');
       
INSERT INTO usuarios (id_usuario,nombre,apellido,id_ubicacion,id_contacto)
VALUES (1,'Jobyna','Trowill',1,1),
	   (2,'Taber','Malinowski',2,2),
       (3,'Kate','Pikhno',3,3),
       (4,'Aubree','Scriver',4,4),
       (5,'Bobbi','Maddicks',5,5),
       (6,'Arielle','Timny',6,6),
       (7,'Ashil','Scard',7,7),
       (8,'Winne','Oggers',8,8),
       (9,'Herman','Brantl',9,9),
       (10,'Cherice','Pettican',10,10);

INSERT INTO ordenes (id_orden,id_usuario,fecha_de_orden,comentario_de_pedido,entregado)
VALUES (1,1,"2023-07-24 12:34:56","Pedido para ocasion especial",1),
	   (2,2,"2023-07-25 10:00:00","Pedido para regalo",1),
	   (3,3,"2023-07-28 15:45:00","Pedido para un evento",1),
	   (4,4,"2023-07-29 14:20:00","Pedido para uso diario",1),
	   (5,5,"2023-07-28 15:45:00","Pedido para un evento",0),
	   (6,6,"2023-07-29 13:20:00","Pedido para uso personal",1),
	   (7,7,"2023-08-11 13:20:00",NULL,0),
	   (8,8,"2023-08-11 14:01:23","Pedido para regalo",0),
	   (9,9,"2023-08-15 13:01:12","Pedido para mi",0),
	   (10,10,"2023-08-18 12:41:32","Un pedido para mi y mi novia",0),
	   (11,5,"2023-08-18 12:48:12","Un pedido ",0),
       (12,4,"2023-09-15 12:48:12",NULL,0),
       (13,9,"2023-09-17 18:48:12","Pedido para navidad",0),
       (14,5,"2023-10-17 22:41:12","Pedido",0);
       
INSERT INTO pedidos (id_pedido,id_remera,id_orden)
VALUES (1,1,1),
	   (2,2,2),
       (3,3,3),
       (4,4,4),
       (5,5,5),
       (6,6,6),
       (7,7,7),
       (8,8,8),
       (9,9,9),
       (10,10,10),
       (11,11,10),
       (12,12,11),
       (13,13,11),
       (14,14,12),
       (15,15,12),
       (16,16,13),
       (17,17,14);
       
INSERT INTO review (id_review,id_remera,comentario,calificacion,fecha_publicacion)
VALUES (1,1,"Excelente remera muy comoda",5,"2023-07-26 08:15:00"),
	   (2,2,"El estampado es genial",4,"2023-07-27 14:30:00"),
       (3,3,"Dudosa calidad de la remera",3,"2023-07-30 09:30:00"),
       (4,4,"Muy comoda y elegante",5,"2023-07-31 12:00:00"),
       (5,6,"Tremenda remera muy feliz estoy",5,"2023-08-01 13:00:00");




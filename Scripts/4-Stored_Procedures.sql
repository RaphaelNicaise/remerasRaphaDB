-- STORED PROCEDURES 

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
    IN color1_id INT, IN color2_id INT, IN color3_id INT )
BEGIN
    DECLARE remera_id INT;
    DECLARE colores_elegidos_id INT;
    
    INSERT INTO Colores_Elegidos (id_color1, id_color2, id_color3) 
    VALUES (color1_id, IFNULL(color2_id, NULL), IFNULL(color3_id, NULL));
    SET colores_elegidos_id = LAST_INSERT_ID();
    
    INSERT INTO Remera (id_cuello, id_estampado, id_talle, id_colores_e) 
    VALUES (cuello_id, estampado_id, talle_id, colores_elegidos_id);
    
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
IN cuello_id_ INT, IN color1_id_ INT,IN color2_id_ INT,IN color3_id_ INT
) 
BEGIN
	DECLARE nueva_id_remera INT;
	CALL add_remera(cuello_id_,estampado_id_,talle_id_,color1_id_,color2_id_,color3_id_);
    SET nueva_id_remera = LAST_INSERT_ID();
    
    CALL add_pedido (usuario_id_,nueva_id_remera);
    
    SELECT concat('La id_remera: ',nueva_id_remera,' a sido pedida por el usuario: ',usuario_id_) as Message;
END //

-- SP 8
-- PROCEDURE QUE TOMA COMO PARAMETRO A UNA ID DE REMERA Y LE ACTUALIZA LOS COLORES (EN CASO DE NO QUERER PONER OTRO COLOR SETEAR NULL)
delimiter //
CREATE PROCEDURE edit_Colores_Elegidos 
(IN remera_id INT,IN color1_id INT,IN color2_id INT,IN color3_id INT)
BEGIN

	UPDATE colores_elegidos co join remera r on r.id_colores_e = co.id_colores_e 
    set id_color1 = color1_id,id_color2 = color2_id,id_color3 = color3_id 
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




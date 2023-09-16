-- FUNCIONES

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


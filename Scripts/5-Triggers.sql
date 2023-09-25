-- TRIGGERS


-- TRIGGER 1

-- CADA VEZ QUE SE INSERTE UN PEDIDO, EL TRIGGER DISPARA UN INSERT EN LOG PEDIDO CON LA INFORMACION, 
-- Y QUE ADMINISTRADOR, O USUARIO LO EJECUTO 

CREATE TABLE IF NOT EXISTS Pedidos_log
(
    id_pedido INT NOT NULL AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    usuario VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_pedido)
);


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

delimiter;
-- TRIGGER 2 encargado de auditar los update de color en los colores_elegidos con su respectiva tabla

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

DELIMITER //
CREATE TRIGGER log_colores_elegidos_act
BEFORE UPDATE ON colores_elegidos
FOR EACH ROW
BEGIN
    INSERT INTO colores_elegidos_log
    VALUES (NOW(), USER(), 'UPDATE',  OLD.id_colores_e, OLD.id_color1, OLD.id_color2, OLD.id_color3,
    NEW.id_color1,NEW.id_color2,NEW.id_color3);
END //
delimiter ;


-- TRIGGER 3 QUE INSERTA EN LA TABLA USUARIOS LOG, EL ID_USUARIO, Y EL TIMESTAMP EN EL QUE SE CREO
CREATE TABLE IF NOT EXISTS usuarios_log (
    id_usuario INT NOT NULL,
    creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER log_usuarios
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
	INSERT INTO usuarios_log
    (id_usuario) values (NEW.id_usuario);
END //
delimiter;

-- TRIGGER 4

CREATE TABLE IF NOT EXISTS log_entrega_orden (
        id_orden INT ,
        creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        estado varchar(10) DEFAULT 'Entregado'
);

DELIMITER //
CREATE TRIGGER log_entrega_ordenes
AFTER UPDATE ON ordenes
FOR EACH ROW
BEGIN
	IF OLD.entregado <> NEW.entregado THEN
	INSERT INTO log_entrega_orden (id_orden) VALUES (new.id_orden);
    END IF;
END //

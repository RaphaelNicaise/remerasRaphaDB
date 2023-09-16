-- TRIGGERS

-- CADA VEZ QUE SE INSERTE UN PEDIDO, EL TRIGGER DISPARA UN INSERT EN LOG PEDIDO CON LA INFORMACION, 
-- Y QUE ADMINISTRADOR, O USUARIO LO EJECUTO 

CREATE TABLE Pedidos_log
(
    id_pedido INT NOT NULL AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    usuario VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_pedido)
);


delimiter //
CREATE TRIGGER log_pedido
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO Pedidos_log
    (id_pedido, fecha_hora, usuario)
    VALUES
    (NEW.id_pedido, NOW(), USER());
END //

-- TRIGGER encargado de auditar los update de color en los colores_elegidos con su respectiva tabla

CREATE TABLE colores_elegidos_log (
    timestamp DATETIME,
    usuario VARCHAR(255),
    action VARCHAR(50),
    old_id_colores_e INT,
    old_id_color1 INT,
    old_id_color2 INT,
    old_id_color3 INT
);

DELIMITER //
CREATE TRIGGER log_colores_elegidos_act
BEFORE UPDATE ON Colores_Elegidos
FOR EACH ROW
BEGIN
    INSERT INTO colores_elegidos_log
    VALUES (NOW(), USER(), 'UPDATE',  NEW.id_colores_e, NEW.id_color1, NEW.id_color2, NEW.id_color3);
END //
DROP SCHEMA IF EXISTS remerasrapha2;
CREATE SCHEMA remerasRapha2;

USE remerasRapha2;


CREATE TABLE Cuello (
    id_cuello INT NOT NULL AUTO_INCREMENT,
    cuelloObj VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_cuello)
);
	
CREATE TABLE Estampado (
    id_estampado INT NOT NULL AUTO_INCREMENT,
    estampadoObj VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_estampado)
);

CREATE TABLE Talle (
    id_talle INT NOT NULL AUTO_INCREMENT,
    talleObj VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_talle)
);

CREATE TABLE Color (
    id_color INT NOT NULL AUTO_INCREMENT,
    colorObj VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_color)
);

CREATE TABLE Colores_Elegidos (
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

CREATE TABLE Remera (
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

CREATE TABLE Ubicacion (
    id_ubicacion INT NOT NULL AUTO_INCREMENT,
    codigo_postal VARCHAR(30) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255),
    PRIMARY KEY (id_ubicacion)
);

CREATE TABLE Contacto (
    id_contacto INT NOT NULL AUTO_INCREMENT,
    telefono VARCHAR(100),
    email VARCHAR(255),
    PRIMARY KEY (id_contacto)
);

CREATE TABLE Usuarios (
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

CREATE TABLE Ordenes (
    id_orden INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    fecha_de_orden DATETIME NOT NULL,
    comentario_de_pedido VARCHAR(255),
    entregado BOOLEAN NOT NULL,
    PRIMARY KEY (id_orden),
    FOREIGN KEY (id_usuario)
        REFERENCES Usuarios (id_usuario)
    
);

CREATE TABLE Pedidos (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    id_remera INT NOT NULL,
    id_orden INT NOT NULL,
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_remera)
        REFERENCES Remera (id_remera),
	FOREIGN KEY (id_orden)
		REFERENCES ordenes (id_orden)
	
);

CREATE TABLE Review (
    id_review INT NOT NULL AUTO_INCREMENT,
    id_remera INT NOT NULL,
    comentario VARCHAR(255),
    calificacion TINYINT CHECK (calificacion >= 1 AND calificacion <= 5),
    fecha_publicacion DATETIME NOT NULL,
    PRIMARY KEY (id_review),
    FOREIGN KEY (id_remera)
        REFERENCES Remera (id_remera)

);




       

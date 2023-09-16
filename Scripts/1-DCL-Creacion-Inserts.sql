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

-- SECCION DE INSERTS 

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
  ('Lionel Messi'),
  ('NewYork'),
  ('The Backyardingans'),
  ('Mickey Mouse'),
  ('IloveParis');

INSERT INTO Talle (id_talle,talleObj) VALUES
  (1,'S'),
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
       (13,4,1,7);
	
INSERT INTO remera (id_remera,id_cuello,id_estampado,id_talle,id_colores_e) 
VALUES (1,1,7,1,1),
	   (2,3,8,2,2),
       (3,3,3,4,3), 
       (4,4,5,4,4), 
       (5,1,1,2,5), 
       (6,2,4,2,6), 
       (7,1,7,1,7), 
       (8,2,4,3,8), 
       (9,2,2,2,9), 
       (10,3,5,2,10), 
       (11,2,1,1,11), 
       (12,4,3,1,12), 
       (13,1,9,2,13);
       
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
	   (11,5,"2023-08-18 12:48:12","Un pedido ",0);
       
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
       (13,13,11);
       
INSERT INTO review (id_review,id_remera,comentario,calificacion,fecha_publicacion)
VALUES (1,1,"Excelente remera muy comoda",5,"2023-07-26 08:15:00"),
	   (2,2,"El estampado es genial",4,"2023-07-27 14:30:00"),
       (3,3,"Dudosa calidad de la remera",3,"2023-07-30 09:30:00"),
       (4,4,"Muy comoda y elegante",5,"2023-07-31 12:00:00"),
       (5,6,"Tremenda remera muy feliz estoy",5,"2023-08-01 13:00:00");
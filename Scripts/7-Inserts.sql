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




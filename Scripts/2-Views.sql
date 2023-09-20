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
group by (estampadoObj) order by count(r.id_estampado) desc)

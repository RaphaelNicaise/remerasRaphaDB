# Documentación

- Documentación Principal
    
    Objetivo / Problemática / Modelo de Negocio
    
    El objetivo principal de esta base de datos es la buena gestión,  control y análisis profundo de todas las operaciones que conllevan a un E-Commerce especializado en la venta de remeras, personalizadas por los propios usuarios. Mi meta fue crear una Base de datos, que permita a al cliente diseñar y pedir remeras personalizadas, (según un catalogo establecido), y que mediante varios procesos, se pueda llegar a tener un análisis, y una buena gestión, para que el negocio funcione de manera excelente.
    
    La problemática principal que conlleva a realizar la base de datos, se relaciona con la complejidad que tiene  un modelo de negocio de E-Commerce centrado en la personalización de productos como las remeras. Si no hay una gestión inteligente y una base de datos efectiva, se pueden dar casos de fallos, como la mezcla de remeras a cada usuario, o remeras mal registradas, etc.
    
    Uno de los problemas clave que resuelve la DB, es la de permitir al usuario poder tener una remera completamente personalizada, resguardando todos los datos de esta, para que no se pierda, y pueda llegar al cliente de forma segura.
    
    Además, la producción y la logística de entrega también pueden volverse un problema sin una base de datos buena. Por lo que se brindan vistas, que serian utilizados por proveedores, por los fabricantes de la remera, a los que le enviamos todos los datos, para que la producción y la entrega se ejecute, también de forma segura.
    
    Por último, y no menos importante, esta DB nos permite analizar de distintas maneras, cuales son los accesorios mas usados,  como también nos brinda información de fechas en distintas tablas, para que posteriormente podamos usarlas y filtrarlas para distintos procesos estadísticos, como por ejemplo, cantidad de ordenes por mes.
    
- TABLES
    1. **Cuello**: Esta tabla almacena diferentes tipos de cuellos para las remeras, con un ID único para cada tipo de cuello.
    2. **Estampado**: Acá se registran los distintos estampados que pueden aplicarse a las remeras, también con un ID único para cada tipo de estampado.
    3. **Talle**: Guarda los tamaños disponibles para las remeras, con un ID único para cada talla.
    4. **Color**: Almacena la variedad de colores que se pueden utilizar en las remeras.
    5. **Colores Elegidos**: Esta tabla registra la combinación de colores seleccionada para una remera específica. Puede incluir hasta tres colores diferentes y se asocia a través foreign keys provenientes de la tabla color.
    6. **Remera**: Contiene Foreign keys de las tablas, cuello, estampado, talle y colores_elegidos, para que estas se combinen creando una id_remera, haciendo que esta se pueda colocar en un pedido.
    7. **Ubicación**: Guarda la información de un usuario, como el código postal y la dirección.
    8. **Contacto**: Registra información de contacto de cada usuario, como el email y el teléfono
    9. **Usuarios**: Esta tabla contiene el nombre y apellido del usuario, como también claves foráneas de su id_ubicacion y id_contacto.
    10. **Ordenes**: Contiene registros de las órdenes realizadas por los usuarios, con detalles como la fecha de la orden, un comentario opcional y un boolean que indica si la orden fue sido entregada.
    11. **Pedidos**: Esta tabla relaciona mediante una id_pedido, a una remera con una orden. Ya que el usuario puede hacer muchos pedidos en una misma orden.
    12. **Review**: Registra opiniones y calificaciones (del 1 al 5) de remeras. Incluye campos para el comentario, la fecha de publicación y se relaciona con las remeras mediante su ID. Las reseñas ayudan a los fabricantes y al negocio en general a mejorar.
- VIEWS
    
    **VISTA 1: Diseños_remeras**
    
    - Propósito: Esta vista devuelve información sobre las remeras, incluyendo su diseño, cuello, estampado, talle y hasta tres colores de la remera.
    - Tablas utilizadas: **`remera`**, **`cuello`**, **`estampado`**, **`talle`**, **`colores_elegidos`**, **`color`**.
    
    **VISTA 2: Colores_remeras**
    
    - Propósito: Esta vista devuelve información sobre los colores de cada remera, ya que en cada remera se usa un id_colores_e, esta contiene id_color numéricos, que se relacionan con colores en si, y esa es la función que cumple la vista, mostrarnos los colores tal cual.
    - Tablas utilizadas: **`remera`**, **`colores_elegidos`**, **`color`**.
    
    **VISTA 3: Calificacion_remeras**
    
    - Propósito: Esta vista devuelve información sobre las remeras y sus calificaciones, incluyendo el correo electrónico y el teléfono del usuario que realizó la Review.
    - Tablas utilizadas: **`review`**, **`remera`**, **`pedidos`**, **`ordenes`**, **`usuarios`**, **`contacto`**.
    
    **VISTA 4: infoparaRepartidor**
    
    - Propósito: Esta vista proporciona información útil para el repartidor, incluyendo la dirección de entrega y el teléfono de los usuarios, a los cuales su orden, todavía no fue entregada.
    - Tablas utilizadas: **`ubicacion`**, **`usuarios`**, **`contacto`**, **`ordenes`**.
    
    **VISTA 5: InformacionOrdenes**
    
    - Propósito: Esta vista devuelve información general sobre los pedidos, incluyendo el email, la fecha de la orden y un comentario (si es que el usuario hizo uno).
    - Tablas utilizadas: **`pedidos`**, **`ordenes`**, **`usuarios`**, **`contacto`**.
    
    **VISTA 6: Cant_pedidos_por_usuario**
    
    - Propósito: Esta vista muestra la cantidad de pedidos realizados por cada usuario, ordenando la cantidad de mayor a menor, para saber quien hizo mas pedidos (hay que recordar que cada pedido es una remera).
    - Tablas utilizadas: **`usuarios`**, **`ordenes`**, **`pedidos`**.
    
    **VISTA 7: Cant_ordenes_por_usuario**
    
    - Propósito: en cambio, esta vista muestra la cantidad de órdenes que se realizaron por cada usuario (hay que recordar que en una orden, puede haber muchos pedidos, osea muchas remeras).
    - Tablas utilizadas: **`usuarios`**, **`ordenes`**.
    
    **VISTA 8: infoUsuarios**
    
    - Propósito: Esta vista muestra información detallada sobre los usuarios, incluyendo su nombre, apellido, teléfono, correo electrónico, código postal y dirección.
    - Tablas utilizadas: **`contacto`**, **`usuarios`**, **`ubicacion`**.
    
    **VISTA 9: top_estampados**
    
    - Propósito: Esta vista devuelve una lista de los estampados, y al lado la cantidad de remeras, que usan este estampado, ordenado de mayor a menor, de manera que podemos saber cuales son los mas usados.
    - Tablas utilizadas: **`remera`**, **`estampado`**.
- STORED PROCEDURES
    
    **SP 1: confirmarEntregaOrden**
    
    - Este SP permite registrar como entregada una cierta id_orden, la lógica es: Si el valor booleano de entregado es 0 (FALSE), se coloca como 1 (TRUE), pero si este ya estaba entregado, te lo advierte, y deja el valor como estaba.
    - Parámetros:
        - **`orderID`**
    
    **SP 2: Usuarios_Ordenamiento**
    
    - Propósito: Seleccionar y ordenar a los usuarios según nombre o apellido, y el orden (ascendente o descendente) especificado (este campo puede ser no especificado)
    - Parámetros:
        - **`columna:`** nombre o apellido.
        - **`asc_desc:`** asc o desc.
    
    **SP 3: top_de_cada_accesorio**
    
    - Propósito: Seleccionar y mostrar el top de un cierto accesorio seleccionado, estos pueden ser el estampado, el talle o el cuello.
    - Parámetros:
        - **`tipoAccesorio`:** (cuelloObj,estampadoObj,talleObj).
    
    **SP 4: add_usuario**
    
    - Propósito: Agregar un nuevo usuario con sus datos en las tablas de contacto, ubicación, y su nombre y apellido. Si uno de estos campos esta vacío, el SP devuelve un mensaje de error.
    - Parámetros:
        - **`nombreNuevo`**, **`apellidoNuevo`**, **`telefonoNuevo`**, **`emailNuevo`**, **`codigo_postalNuevo`**, **`direccion`** .
    
    **SP 5: add_remera**
    
    - Propósito: Agregar una nueva remera con los id de cada accesorio, incluyendo los colores, en la tabla remera. La lógica de el negocio me permite colocar solo un color, como también dos y 3. Pero si o si una, las otras pueden ser NULL.
    - Parámetros:
        - **`cuello_id`**, **`estampado_id`**, **`talle_id`**, **`color1_id`**, **`color2_id`**, **`color3_id`** .
    
    **SP 6: add_pedido**
    
    - Propósito:   Asignar una remera a un usuario, permitiendo que los usuarios puedan realizar múltiples pedidos dentro de una orden. La lógica del procedimiento consiste en verificar si el usuario hace un pedido en las últimas 24 horas; si no lo hizo, se crea una nueva orden y se agrega el pedido a esta orden recién creada. Si el usuario ya ha hizo un pedido en ese período, el nuevo pedido se asigna a la misma orden existente. Esto facilita la agrupación de pedidos similares en una sola orden cuando son realizados en un corto período de tiempo, mejorando la eficiencia en la gestión de pedidos.
    - Parámetros:
        - **`usuario_id`**, **`id_remera` .**
    
    **SP 7: add_remera_a_pedido**
    
    - Propósito: Este SP es conveniente a usar ya que utiliza add_remera y add_pedido en una sola llamada, esto facilita el pedido, ya que agregas la remera, tu id_usuario y automáticamente se hace la gestión. Cabe recalcar que este SP, llama a los 2 SP anteriormente mencionados, así que la lógica seguirá funcionando igual.
    - Parámetros:
        - **`usuario_id_`**, **`estampado_id_`**, **`talle_id_`**, **`cuello_id_`**, **`color1_id_`**, **`color2_id_`**, **`color3_id_`**
    
    **SP 8: edit_Colores_Elegidos**
    
    - Propósito: Modificar los colores de una remera en la tabla colores_elegidos.
    - Parámetros:
        - **`remera_id`**, **`color1_id`**, **`color2_id`**, **`color3_id`** .
    
    **SP 9: get_totalOrdenesxUsuario**
    
    - Propósito: Devuelve la cantidad de ordenes realizadas por el id_usuario indicado.
    - Parámetros:
        - **`usuario_id`** , (**`totalOrdenes`** como valor de salida).
    
    **SP 10: agregarDescripcion_Ubicacion**
    
    - Propósito: Este SP agrega una descripción de la ubicación, a un cierto id_usuario.
    - Parámetros:
        - **`usuario_id`**, **`nueva_descripcion_ubicacion` .**
        
    
    **SP 11: remerasxestampado**
    
    - Propósito: Ingresas un id_estampado, y este devuelve toda la info de todas las remeras que contengan el id_estampado especificado.
    - Parámetros:
        - **`estampado_id`**.
    
    **SP 12: get_usuarios**
    
    - Propósito: Un SP muy sencillo, que al llamarlo devuelve el id_usuario, nombre y apellido de todos los usuarios.
    
    **SP 13: get_colores_remera**
    
    - Propósito: Otro SP muy sencillo en el que al llamarlo devuelve los colores de todas las remeras.
    
    **SP 14: add_Estampado**
    
    - Propósito: Agregar un nuevo estampado a la tabla estampado (si no existe).
    - Parámetros:
        - **`nuevoEstampado.`**
    
    **SP 15: add_comentario_orden**
    
    - Propósito: Agregar un comentario a una orden específica mediante  su id_orden.
    - Parámetros:
        - **`orden_ID`**, **`Comentario_Orden` .**
    
    **SP 16: add_review**
    
    - Propósito: Agregar una review (comentario y calificación) a una id_remera especifica.
    - Parámetros:
        - **`remera_id`**, **`comentarioNew`**, **`calificacionNew .`**
    
    **SP 17: obtenerReseñaPorRemera**
    
    - Propósito: Obtener la reseña de una remera específica mediante su ID de remera, pero antes verifica si esta id_remera esta en la tabla reviews.
    - Parámetros:
        - **`remeraID`** .
    
    **SP 18: infodeusuario**
    
    - Propósito: Obtiene información detallada de los usuarios, proveniente de la vista ‘infousuarios’
    - Parámetros:
        - **`usuario_id.`**
- TRIGGERS
    
    **TRIGGER 1 - log_pedido:**
    
    Este trigger se dispara después de que se inserte un nuevo pedido en la tabla pedidos. Su propósito es registrar la fecha, la hora, y el usuario que inserto el pedido, en la tabla pedidos_log como forma de auditoria.
    
    **TRIGGER 2 - log_colores_elegidos_act:**
    
    Este trigger se dispara antes de que se realice una actualización en la tabla colores_elegidos. Su objetivo es auditar los cambios en los colores elegidos y registrarlos en la tabla colores_elegidos_log, en la que se guarda la fecha y hora en la que se hizo, los tres id_color antiguos, y al lado, los 3 nuevos. 
    
    **TRIGGER 3 - log_usuarios:**
    
    Este trigger se dispara después de que se inserte un nuevo usuario en la tabla usuarios. Su función es registrar el id del usuario y el momento en el que se creo (fecha y hora), en la tabla usuarios_log
    
    **TRIGGER 4 - log_entrega_ordenes:**
    
    Este Trigger se dispara cuando se actualiza la tabla ordenes, mas específicamente cuando se actualiza la condición de entregado, por cada vez que suceda esto, chequea que cada campo de entregado nuevo, sea distinto al entregado viejo. (OLD.entregado <> NEW.entregado)
    
     Si es así, este inserta en la tabla log_entrega_ordenes la id_orden que se entrego, y el momento en el que se entrego. Si OLD y NEW son iguales entonces no se procede a nada.
    
    El condicional fue puesto ya que, hay un Stored Procedure, que actualiza la tabla ordenes, pero al campo de comentario, dando a que si agregábamos  un comentario, este se registraría también en log_entrega_ordenes, lo cual era un problema grave.
    
- FUNCTIONS
    
    **FUNCIÓN 1 - cantVentas_x_estampado:**
    
    Esta función toma como entrada el id_estampado de un estampado (valga la redundancia) y devuelve la cantidad de remeras asociadas a ese estampado. En la variable cantidad se almacena el count(*) de las remeras con ese id_estampado, y se retorna esa cantidad.
    
    **FUNCIÓN 2 - email_usuario:**
    
    Esta función toma como entrada el id_usuario y devuelve su dirección de correo electrónico. retornando la selección del mail de un usuario, usando un join para unir la tabla usuarios y contacto
    
    **FUNCIÓN 3 - cantRemerascon_xcolor:**
    
    Esta función toma como entrada un id_color y devuelve la cantidad de remeras que tienen ese color en alguna de sus tres opciones. Retorna el recuento de la selección de remeras que contengan ese color en alguno de los tres campos.
    
    **FUNCIÓN 4 - telefono_usuario:**
    
    Esta función toma como entrada un id_usuario devuelve su número de teléfono. Lo mismo que la del mail, hace un join de la tabla usuarios y tabla contacto.
    
    **FUNCIÓN 5 - cant_remeras_registradas:**
    
    Esta función no tiene valor de entrada, solo devuelve la cantidad total de remeras registradas en la base de datos. Hace un count(*) de todas las remeras en la base de datos.
    
    **FUNCIÓN 6 - cant_remeras_entregadas:**
    
    Esta función tampoco tiene valor de entrada, y devuelve la cantidad de remeras que han sido entregadas. Selecciona todas las remeras, y para saber si están entregadas, joinea  la tabla ordenes, condiciona a que entregado = TRUE, retornando así las remeras que han sido entregadas.
    
    **FUNCIÓN 7 - cant_remeras_para_entregar:**
    
    Lo mismo que la anterior, pero cambia en el condicionamiento, esta retorna las remeras que tengan su campo de orden entregado = FALSE.
    
- PRIVILEGE USERS
    

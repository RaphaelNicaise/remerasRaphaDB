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




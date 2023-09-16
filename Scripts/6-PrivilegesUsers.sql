-- Crea al USUARIO1 en el localhost, y le asigna su contraseña
CREATE USER USUARIO1@localhost IDENTIFIED BY '123456789';
-- Le da a USUARIO1 solo la posibilidad de Leer (Hacer Selects a todas tablas y vistas)
GRANT SELECT ON remerasrapha2.* TO USUARIO1@localhost;
-- Crea al USUARIO2 en el localhost, y le asigna su contraseña
CREATE USER USUARIO2@localhost IDENTIFIED BY 'qwertyuiop';
-- Le da al USUARIO2 la posibilidad de hacer Selects a todas las tablas y vistas
-- Tambien tiene la posibilidad de hacer Inserts y Updates a cualquier tabla
GRANT SELECT,INSERT,UPDATE ON remerasrapha2.* TO USUARIO2@localhost;

-- Muestran los privilegios concedidos
SHOW GRANTS FOR USUARIO1@localhost;
SHOW GRANTS FOR USUARIO2@localhost;


/* revoke select on *.* from USUARIO1@localhost;
revoke select,insert,update on *.* from USUARIO2@localhost; */

-- Supuestamente esto actualiza los privilegios (?
				FLUSH PRIVILEGES;



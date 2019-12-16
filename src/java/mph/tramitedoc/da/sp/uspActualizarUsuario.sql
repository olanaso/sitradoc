CREATE OR REPLACE FUNCTION uspActualizarUsuario(
	_idusuario integer,
	_nombres character varying,
	_apellidos character varying,
	_dni character varying,
	_direccion character varying,
	_telefono character varying,
	_usuario character varying,
	_password character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuario WHERE idusuario <> _idusuario) THEN

	UPDATE usuario
  SET 
	idusuario=_idusuario,
	nombres=_nombres,
	apellidos=_apellidos,
	dni=_dni,
	direccion=_direccion,
	telefono=_telefono,
	usuario=_usuario,
	password=_password,
	estado=_estado

 WHERE idusuario=_idusuario;


            RETURN (select max(idusuario) from usuario)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






CREATE OR REPLACE FUNCTION uspInsertarUsuario(
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
DECLARE _idusuario integer;
DECLARE _retorno integer;
BEGIN	
	_idusuario =(select max(idusuario) from usuario)::integer;
	_idusuario=_idusuario+1;
	if(_idusuario is null) then
	_idusuario=1;
	end if;	
	INSERT INTO usuario(

	idusuario,
	nombres,
	apellidos,
	dni,
	direccion,
	telefono,
	usuario,
	password,
	estado )

 VALUES (	_idusuario,
	_nombres,
	_apellidos,
	_dni,
	_direccion,
	_telefono,
	_usuario,
	_password,
	_estado );


            _retorno =(select max(idusuario) from usuario)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






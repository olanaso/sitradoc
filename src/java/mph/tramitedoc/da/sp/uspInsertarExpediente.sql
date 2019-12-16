CREATE OR REPLACE FUNCTION uspInsertarExpediente(
	_idusuariocargo integer,
	_idprocedimiento integer,
	_idarea integer,
	_codigo character varying,
	_dni_ruc character varying,
	_nombre_razonsocial character varying,
	_apellidos character varying,
	_direccion character varying,
	_telefono character varying,
	_correo character varying,
	_asunto character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idexpediente integer;
DECLARE _retorno integer;
BEGIN	
	_idexpediente =(select max(idexpediente) from expediente)::integer;
	_idexpediente=_idexpediente+1;
	if(_idexpediente is null) then
	_idexpediente=1;
	end if;	
	INSERT INTO expediente(

	idexpediente,
	idusuariocargo,
	idprocedimiento,
	idarea,
	codigo,
	dni_ruc,
	nombre_razonsocial,
	apellidos,
	direccion,
	telefono,
	correo,
	asunto,
	estado )

 VALUES (	_idexpediente,
	_idusuariocargo,
	_idprocedimiento,
	_idarea,
	_codigo,
	_dni_ruc,
	_nombre_razonsocial,
	_apellidos,
	_direccion,
	_telefono,
	_correo,
	_asunto,
	_estado );


            _retorno =(select max(idexpediente) from expediente)::integer;
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






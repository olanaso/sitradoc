CREATE OR REPLACE FUNCTION uspActualizarExpediente(
	_idexpediente bigint,
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
BEGIN	
--IF  EXISTS (SELECT 1 FROM expediente WHERE idexpediente <> _idexpediente) THEN

	UPDATE expediente
  SET 
	idexpediente=_idexpediente,
	idusuariocargo=_idusuariocargo,
	idprocedimiento=_idprocedimiento,
	idarea=_idarea,
	codigo=_codigo,
	dni_ruc=_dni_ruc,
	nombre_razonsocial=_nombre_razonsocial,
	apellidos=_apellidos,
	direccion=_direccion,
	telefono=_telefono,
	correo=_correo,
	asunto=_asunto,
	estado=_estado

 WHERE idexpediente=_idexpediente;


            RETURN (select max(idexpediente) from expediente)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






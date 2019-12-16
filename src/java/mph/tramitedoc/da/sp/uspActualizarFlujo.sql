CREATE OR REPLACE FUNCTION uspActualizarFlujo(
	_idflujo bigint,
	_idexpediente bigint,
	_idestadoflujo integer,
	_idusuario integer,
	_idusuarioenvia integer,
	_idusuariorecepciona integer,
	_fechaenvio timestamp without time zone,
	_fechalectura timestamp without time zone,
	_asunto character varying,
	_descripcion text,
	_observacion text,
	_binderror boolean,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM flujo WHERE idflujo <> _idflujo) THEN

	UPDATE flujo
  SET 
	idflujo=_idflujo,
	idexpediente=_idexpediente,
	idestadoflujo=_idestadoflujo,
	idusuario=_idusuario,
	idusuarioenvia=_idusuarioenvia,
	idusuariorecepciona=_idusuariorecepciona,
	fechaenvio=_fechaenvio,
	fechalectura=_fechalectura,
	asunto=_asunto,
	descripcion=_descripcion,
	observacion=_observacion,
	binderror=_binderror,
	estado=_estado

 WHERE idflujo=_idflujo;


            RETURN (select max(idflujo) from flujo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






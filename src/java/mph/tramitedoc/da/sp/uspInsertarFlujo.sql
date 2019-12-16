CREATE OR REPLACE FUNCTION uspInsertarFlujo(
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
DECLARE _idflujo integer;
DECLARE _retorno integer;
BEGIN	
	_idflujo =(select max(idflujo) from flujo)::integer;
	_idflujo=_idflujo+1;
	if(_idflujo is null) then
	_idflujo=1;
	end if;	
	INSERT INTO flujo(

	idflujo,
	idexpediente,
	idestadoflujo,
	idusuario,
	idusuarioenvia,
	idusuariorecepciona,
	fechaenvio,
	fechalectura,
	asunto,
	descripcion,
	observacion,
	binderror,
	estado )

 VALUES (	_idflujo,
	_idexpediente,
	_idestadoflujo,
	_idusuario,
	_idusuarioenvia,
	_idusuariorecepciona,
	_fechaenvio,
	_fechalectura,
	_asunto,
	_descripcion,
	_observacion,
	_binderror,
	_estado );


            _retorno =(select max(idflujo) from flujo)::integer;
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






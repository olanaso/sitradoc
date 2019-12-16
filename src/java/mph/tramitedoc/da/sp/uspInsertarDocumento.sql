CREATE OR REPLACE FUNCTION uspInsertarDocumento(
	_tipodocumento integer,
	_asunto character varying,
	_mensaje text,
	_prioridad integer,
	_bindrespuesta boolean,
	_diasrespuesta integer,
	_bindllegadausuario boolean,
	_idareacioncreacion integer,
	_idusuariocreacion integer,
	_fechacreacion timestamp without time zone,
	_idexpediente bigint,
	_codigoexpediente bigint,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _iddocumento integer;
DECLARE _retorno integer;
BEGIN	
	_iddocumento =(select max(iddocumento) from documento)::integer;
	_iddocumento=_iddocumento+1;
	if(_iddocumento is null) then
	_iddocumento=1;
	end if;	
	INSERT INTO documento(

	iddocumento,
	tipodocumento,
	asunto,
	mensaje,
	prioridad,
	bindrespuesta,
	diasrespuesta,
	bindllegadausuario,
	idareacioncreacion,
	idusuariocreacion,
	fechacreacion,
	idexpediente,
	codigoexpediente,
	estado )

 VALUES (	_iddocumento,
	_tipodocumento,
	_asunto,
	_mensaje,
	_prioridad,
	_bindrespuesta,
	_diasrespuesta,
	_bindllegadausuario,
	_idareacioncreacion,
	_idusuariocreacion,
	_fechacreacion,
	_idexpediente,
	_codigoexpediente,
	_estado );


            _retorno =(select max(iddocumento) from documento)::integer;
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






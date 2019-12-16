CREATE OR REPLACE FUNCTION uspActualizarDocumento(
	_iddocumento bigint,
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
BEGIN	
--IF  EXISTS (SELECT 1 FROM documento WHERE iddocumento <> _iddocumento) THEN

	UPDATE documento
  SET 
	iddocumento=_iddocumento,
	tipodocumento=_tipodocumento,
	asunto=_asunto,
	mensaje=_mensaje,
	prioridad=_prioridad,
	bindrespuesta=_bindrespuesta,
	diasrespuesta=_diasrespuesta,
	bindllegadausuario=_bindllegadausuario,
	idareacioncreacion=_idareacioncreacion,
	idusuariocreacion=_idusuariocreacion,
	fechacreacion=_fechacreacion,
	idexpediente=_idexpediente,
	codigoexpediente=_codigoexpediente,
	estado=_estado

 WHERE iddocumento=_iddocumento;


            RETURN (select max(iddocumento) from documento)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






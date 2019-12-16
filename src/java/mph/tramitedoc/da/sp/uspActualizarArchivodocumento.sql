CREATE OR REPLACE FUNCTION uspActualizarArchivodocumento(
	_idarchivodocumento bigint,
	_documento bigint,
	_codigo character varying,
	_nombre character varying,
	_url character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM archivodocumento WHERE idarchivodocumento <> _idarchivodocumento) THEN

	UPDATE archivodocumento
  SET 
	idarchivodocumento=_idarchivodocumento,
	documento=_documento,
	codigo=_codigo,
	nombre=_nombre,
	url=_url,
	estado=_estado

 WHERE idarchivodocumento=_idarchivodocumento;


            RETURN _idarchivodocumento;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






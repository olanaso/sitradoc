CREATE OR REPLACE FUNCTION uspEliminarDocumento(
	_iddocumento bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM documento WHERE iddocumento <> _iddocumento) THEN

	UPDATE documento
  SET 
estado=false

 WHERE iddocumento=_iddocumento;


            RETURN _iddocumento;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






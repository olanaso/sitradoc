CREATE OR REPLACE FUNCTION uspEliminarArchivodocumento(
	_idarchivodocumento bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM archivodocumento WHERE idarchivodocumento <> _idarchivodocumento) THEN

	UPDATE archivodocumento
  SET 
estado=false

 WHERE idarchivodocumento=_idarchivodocumento;


            RETURN _idarchivodocumento;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






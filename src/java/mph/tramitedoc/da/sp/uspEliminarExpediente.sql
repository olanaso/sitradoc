CREATE OR REPLACE FUNCTION uspEliminarExpediente(
	_idexpediente bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expediente WHERE idexpediente <> _idexpediente) THEN

	UPDATE expediente
  SET 
estado=false

 WHERE idexpediente=_idexpediente;


            RETURN _idexpediente;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






CREATE OR REPLACE FUNCTION uspEliminarEstadoflujo(
	_idestadoflujo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM estadoflujo WHERE idestadoflujo <> _idestadoflujo) THEN

	UPDATE estadoflujo
  SET 
estado=false

 WHERE idestadoflujo=_idestadoflujo;


            RETURN _idestadoflujo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






CREATE OR REPLACE FUNCTION uspEliminarExpedienterequisito(
	_inexpedienterequisito bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expedienterequisito WHERE inexpedienterequisito <> _inexpedienterequisito) THEN

	UPDATE expedienterequisito
  SET 
estado=false

 WHERE inexpedienterequisito=_inexpedienterequisito;


            RETURN _inexpedienterequisito;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






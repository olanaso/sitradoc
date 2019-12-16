CREATE OR REPLACE FUNCTION uspEliminarFlujo(
	_idflujo bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM flujo WHERE idflujo <> _idflujo) THEN

	UPDATE flujo
  SET 
estado=false

 WHERE idflujo=_idflujo;


            RETURN _idflujo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






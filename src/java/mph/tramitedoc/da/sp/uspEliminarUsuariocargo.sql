CREATE OR REPLACE FUNCTION uspEliminarUsuariocargo(
	_idusuariocargo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuariocargo WHERE idusuariocargo <> _idusuariocargo) THEN

	UPDATE usuariocargo
  SET 
estado=false

 WHERE idusuariocargo=_idusuariocargo;


            RETURN _idusuariocargo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






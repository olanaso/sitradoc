CREATE OR REPLACE FUNCTION uspEliminarCargo(
	_idcargo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM cargo WHERE idcargo <> _idcargo) THEN

	UPDATE cargo
  SET 
estado=false

 WHERE idcargo=_idcargo;


            RETURN _idcargo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






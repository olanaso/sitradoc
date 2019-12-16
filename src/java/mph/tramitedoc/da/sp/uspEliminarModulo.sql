CREATE OR REPLACE FUNCTION uspEliminarModulo(
	_idmodulo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM modulo WHERE idmodulo <> _idmodulo) THEN

	UPDATE modulo
  SET 
estado=false

 WHERE idmodulo=_idmodulo;


            RETURN _idmodulo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






CREATE OR REPLACE FUNCTION uspEliminarRolmodulo(
	_idrolmodulo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM rolmodulo WHERE idrolmodulo <> _idrolmodulo) THEN

	UPDATE rolmodulo
  SET 
estado=false

 WHERE idrolmodulo=_idrolmodulo;


            RETURN _idrolmodulo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






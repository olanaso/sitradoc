CREATE OR REPLACE FUNCTION uspEliminarRol(
	_idrol integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM rol WHERE idrol <> _idrol) THEN

	UPDATE rol
  SET 
estado=false

 WHERE idrol=_idrol;


            RETURN _idrol;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






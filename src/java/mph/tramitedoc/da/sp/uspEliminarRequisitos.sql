CREATE OR REPLACE FUNCTION uspEliminarRequisitos(
	_idrequisitos integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM requisitos WHERE idrequisitos <> _idrequisitos) THEN

	UPDATE requisitos
  SET 
estado=false

 WHERE idrequisitos=_idrequisitos;


            RETURN _idrequisitos;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






CREATE OR REPLACE FUNCTION uspEliminarRegla(
	_idregla integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM regla WHERE idregla <> _idregla) THEN

	UPDATE regla
  SET 
estado=false

 WHERE idregla=_idregla;


            RETURN _idregla;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






CREATE OR REPLACE FUNCTION uspEliminarArea(
	_idarea integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM area WHERE idarea <> _idarea) THEN

	UPDATE area
  SET 
estado=false

 WHERE idarea=_idarea;


            RETURN _idarea;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






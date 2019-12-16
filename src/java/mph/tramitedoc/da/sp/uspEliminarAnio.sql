CREATE OR REPLACE FUNCTION uspEliminarAnio(
	_idanio integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM anio WHERE idanio <> _idanio) THEN

	UPDATE anio
  SET 
estado=false

 WHERE idanio=_idanio;


            RETURN _idanio;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






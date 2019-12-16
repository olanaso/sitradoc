CREATE OR REPLACE FUNCTION uspEliminarFeriado(
	_idferiado integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM feriado WHERE idferiado <> _idferiado) THEN

	UPDATE feriado
  SET 
estado=false

 WHERE idferiado=_idferiado;


            RETURN _idferiado;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






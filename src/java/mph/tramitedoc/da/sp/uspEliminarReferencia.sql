CREATE OR REPLACE FUNCTION uspEliminarReferencia(
	_idreferencia bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM referencia WHERE idreferencia <> _idreferencia) THEN

	UPDATE referencia
  SET 
estado=false

 WHERE idreferencia=_idreferencia;


            RETURN _idreferencia;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






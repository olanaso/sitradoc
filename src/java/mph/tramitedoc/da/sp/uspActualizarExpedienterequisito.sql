CREATE OR REPLACE FUNCTION uspActualizarExpedienterequisito(
	_inexpedienterequisito bigint,
	_idrequisitos integer,
	_idexpediente bigint,
	_fecha timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expedienterequisito WHERE inexpedienterequisito <> _inexpedienterequisito) THEN

	UPDATE expedienterequisito
  SET 
	inexpedienterequisito=_inexpedienterequisito,
	idrequisitos=_idrequisitos,
	idexpediente=_idexpediente,
	fecha=_fecha,
	estado=_estado

 WHERE inexpedienterequisito=_inexpedienterequisito;


            RETURN (select max(inexpedienterequisito) from expedienterequisito)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






CREATE OR REPLACE FUNCTION uspInsertarExpedienterequisito(
	_idrequisitos integer,
	_idexpediente bigint,
	_fecha timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idexpedienterequisito integer;
DECLARE _retorno integer;
BEGIN	
	_inexpedienterequisito =(select max(inexpedienterequisito) from expedienterequisito)::integer;
	_inexpedienterequisito=_inexpedienterequisito+1;
	if(_inexpedienterequisito is null) then
	_inexpedienterequisito=1;
	end if;	
	INSERT INTO expedienterequisito(

	inexpedienterequisito,
	idrequisitos,
	idexpediente,
	fecha,
	estado )

 VALUES (	_inexpedienterequisito,
	_idrequisitos,
	_idexpediente,
	_fecha,
	_estado );


            _retorno =(select max(inexpedienterequisito) from expedienterequisito)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






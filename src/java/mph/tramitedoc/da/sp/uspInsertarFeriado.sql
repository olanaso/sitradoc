CREATE OR REPLACE FUNCTION uspInsertarFeriado(
	_idanio integer,
	_fecha date,
	_motivo character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idferiado integer;
DECLARE _retorno integer;
BEGIN	
	_idferiado =(select max(idferiado) from feriado)::integer;
	_idferiado=_idferiado+1;
	if(_idferiado is null) then
	_idferiado=1;
	end if;	
	INSERT INTO feriado(

	idferiado,
	idanio,
	fecha,
	motivo,
	estado )

 VALUES (	_idferiado,
	_idanio,
	_fecha,
	_motivo,
	_estado );


            _retorno =(select max(idferiado) from feriado)::integer;
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






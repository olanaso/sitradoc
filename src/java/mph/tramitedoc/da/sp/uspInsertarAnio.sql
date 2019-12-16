CREATE OR REPLACE FUNCTION uspInsertarAnio(
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idanio integer;
DECLARE _retorno integer;
BEGIN	
	_idanio =(select max(idanio) from anio)::integer;
	_idanio=_idanio+1;
	if(_idanio is null) then
	_idanio=1;
	end if;	
	INSERT INTO anio(

	idanio,
	denominacion,
	estado )

 VALUES (	_idanio,
	_denominacion,
	_estado );


            _retorno =(select max(idanio) from anio)::integer;
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






CREATE OR REPLACE FUNCTION uspInsertarCargo(
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idcargo integer;
DECLARE _retorno integer;
BEGIN	
	_idcargo =(select max(idcargo) from cargo)::integer;
	_idcargo=_idcargo+1;
	if(_idcargo is null) then
	_idcargo=1;
	end if;	
	INSERT INTO cargo(

	idcargo,
	denominacion,
	estado )

 VALUES (	_idcargo,
	_denominacion,
	_estado );


            _retorno =(select max(idcargo) from cargo)::integer;
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






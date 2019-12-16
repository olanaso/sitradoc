CREATE OR REPLACE FUNCTION uspInsertarModulo(
	_denominacion character varying,
	_paginainicio character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idmodulo integer;
DECLARE _retorno integer;
BEGIN	
	_idmodulo =(select max(idmodulo) from modulo)::integer;
	_idmodulo=_idmodulo+1;
	if(_idmodulo is null) then
	_idmodulo=1;
	end if;	
	INSERT INTO modulo(

	idmodulo,
	denominacion,
	paginainicio,
	estado )

 VALUES (	_idmodulo,
	_denominacion,
	_paginainicio,
	_estado );


            _retorno =(select max(idmodulo) from modulo)::integer;
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






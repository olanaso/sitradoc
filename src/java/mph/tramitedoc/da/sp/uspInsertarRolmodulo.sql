CREATE OR REPLACE FUNCTION uspInsertarRolmodulo(
	_idrol integer,
	_idmodulo integer,
	_fechaasignacion timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idrolmodulo integer;
DECLARE _retorno integer;
BEGIN	
	_idrolmodulo =(select max(idrolmodulo) from rolmodulo)::integer;
	_idrolmodulo=_idrolmodulo+1;
	if(_idrolmodulo is null) then
	_idrolmodulo=1;
	end if;	
	INSERT INTO rolmodulo(

	idrolmodulo,
	idrol,
	idmodulo,
	fechaasignacion,
	estado )

 VALUES (	_idrolmodulo,
	_idrol,
	_idmodulo,
	_fechaasignacion,
	_estado );


            _retorno =(select max(idrolmodulo) from rolmodulo)::integer;
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






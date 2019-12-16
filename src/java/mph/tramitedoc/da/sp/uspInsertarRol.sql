CREATE OR REPLACE FUNCTION uspInsertarRol(
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idrol integer;
DECLARE _retorno integer;
BEGIN	
	_idrol =(select max(idrol) from rol)::integer;
	_idrol=_idrol+1;
	if(_idrol is null) then
	_idrol=1;
	end if;	
	INSERT INTO rol(

	idrol,
	denominacion,
	estado )

 VALUES (	_idrol,
	_denominacion,
	_estado );


            _retorno =(select max(idrol) from rol)::integer;
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






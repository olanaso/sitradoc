CREATE OR REPLACE FUNCTION uspInsertarRequisitos(
	_idprocedimiento integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idrequisitos integer;
DECLARE _retorno integer;
BEGIN	
	_idrequisitos =(select max(idrequisitos) from requisitos)::integer;
	_idrequisitos=_idrequisitos+1;
	if(_idrequisitos is null) then
	_idrequisitos=1;
	end if;	
	INSERT INTO requisitos(

	idrequisitos,
	idprocedimiento,
	denominacion,
	estado )

 VALUES (	_idrequisitos,
	_idprocedimiento,
	_denominacion,
	_estado );


            _retorno =(select max(idrequisitos) from requisitos)::integer;
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






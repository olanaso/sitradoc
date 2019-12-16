CREATE OR REPLACE FUNCTION uspInsertarProcedimiento(
	_idarea integer,
	_codigo character varying,
	_denominacion character varying,
	_plazodias integer,
	_idcargoresolutor integer,
	_descripcion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idprocedimiento integer;
DECLARE _retorno integer;
BEGIN	
	_idprocedimiento =(select max(idprocedimiento) from procedimiento)::integer;
	_idprocedimiento=_idprocedimiento+1;
	if(_idprocedimiento is null) then
	_idprocedimiento=1;
	end if;	
	INSERT INTO procedimiento(

	idprocedimiento,
	idarea,
	codigo,
	denominacion,
	plazodias,
	idcargoresolutor,
	descripcion,
	estado )

 VALUES (	_idprocedimiento,
	_idarea,
	_codigo,
	_denominacion,
	_plazodias,
	_idcargoresolutor,
	_descripcion,
	_estado );


            _retorno =(select max(idprocedimiento) from procedimiento)::integer;
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






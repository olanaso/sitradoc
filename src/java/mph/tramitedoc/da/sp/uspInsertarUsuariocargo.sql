CREATE OR REPLACE FUNCTION uspInsertarUsuariocargo(
	_idusuario integer,
	_idcargo integer,
	_fechaasignado timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idusuariocargo integer;
DECLARE _retorno integer;
BEGIN	
	_idusuariocargo =(select max(idusuariocargo) from usuariocargo)::integer;
	_idusuariocargo=_idusuariocargo+1;
	if(_idusuariocargo is null) then
	_idusuariocargo=1;
	end if;	
	INSERT INTO usuariocargo(

	idusuariocargo,
	idusuario,
	idcargo,
	fechaasignado,
	estado )

 VALUES (	_idusuariocargo,
	_idusuario,
	_idcargo,
	_fechaasignado,
	_estado );


            _retorno =(select max(idusuariocargo) from usuariocargo)::integer;
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






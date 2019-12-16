CREATE OR REPLACE FUNCTION uspInsertarUsuariorol(
	_idusuario integer,
	_idrol integer,
	_fechaasignacion timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idusuariorol integer;
DECLARE _retorno integer;
BEGIN	
	_idusuariorol =(select max(idusuariorol) from usuariorol)::integer;
	_idusuariorol=_idusuariorol+1;
	if(_idusuariorol is null) then
	_idusuariorol=1;
	end if;	
	INSERT INTO usuariorol(

	idusuariorol,
	idusuario,
	idrol,
	fechaasignacion,
	estado )

 VALUES (	_idusuariorol,
	_idusuario,
	_idrol,
	_fechaasignacion,
	_estado );


            _retorno =(select max(idusuariorol) from usuariorol)::integer;
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






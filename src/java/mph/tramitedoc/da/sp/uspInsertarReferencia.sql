CREATE OR REPLACE FUNCTION uspInsertarReferencia(
	_iddocumento bigint,
	_iddocumentoreferencia bigint,
	_fecharegistro timestamp without time zone,
	_idusuarioregistra integer,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idreferencia integer;
DECLARE _retorno integer;
BEGIN	
	_idreferencia =(select max(idreferencia) from referencia)::integer;
	_idreferencia=_idreferencia+1;
	if(_idreferencia is null) then
	_idreferencia=1;
	end if;	
	INSERT INTO referencia(

	idreferencia,
	iddocumento,
	iddocumentoreferencia,
	fecharegistro,
	idusuarioregistra,
	estado )

 VALUES (	_idreferencia,
	_iddocumento,
	_iddocumentoreferencia,
	_fecharegistro,
	_idusuarioregistra,
	_estado );


            _retorno =(select max(idreferencia) from referencia)::integer;
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






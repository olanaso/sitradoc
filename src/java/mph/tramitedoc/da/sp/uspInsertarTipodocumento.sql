CREATE OR REPLACE FUNCTION uspInsertarTipodocumento(
	_idregla integer,
	_denominacion character varying,
	_descripcion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idtipodocumento integer;
DECLARE _retorno integer;
BEGIN	
	_idtipodocumento =(select max(idtipodocumento) from tipodocumento)::integer;
	_idtipodocumento=_idtipodocumento+1;
	if(_idtipodocumento is null) then
	_idtipodocumento=1;
	end if;	
	INSERT INTO tipodocumento(

	idtipodocumento,
	idregla,
	denominacion,
	descripcion,
	estado )

 VALUES (	_idtipodocumento,
	_idregla,
	_denominacion,
	_descripcion,
	_estado );


            _retorno =(select max(idtipodocumento) from tipodocumento)::integer;
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






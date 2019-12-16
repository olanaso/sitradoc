CREATE OR REPLACE FUNCTION uspInsertarBandeja(
	_iddocumento bigint,
	_idareaproviene integer,
	_idareadestino integer,
	_idusuarioenvia integer,
	_idusuariodestino integer,
	_bindrecepcion boolean,
	_idusuariorecepciona integer,
	_fecharecepciona timestamp without time zone,
	_fechalectura timestamp without time zone,
	_fechaderivacion timestamp without time zone,
	_fecharegistro timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idbandeja integer;
DECLARE _retorno integer;
BEGIN	
	_idbandeja =(select max(idbandeja) from bandeja)::integer;
	_idbandeja=_idbandeja+1;
	if(_idbandeja is null) then
	_idbandeja=1;
	end if;	
	INSERT INTO bandeja(

	idbandeja,
	iddocumento,
	idareaproviene,
	idareadestino,
	idusuarioenvia,
	idusuariodestino,
	bindrecepcion,
	idusuariorecepciona,
	fecharecepciona,
	fechalectura,
	fechaderivacion,
	fecharegistro,
	estado )

 VALUES (	_idbandeja,
	_iddocumento,
	_idareaproviene,
	_idareadestino,
	_idusuarioenvia,
	_idusuariodestino,
	_bindrecepcion,
	_idusuariorecepciona,
	_fecharecepciona,
	_fechalectura,
	_fechaderivacion,
	_fecharegistro,
	_estado );


            _retorno =(select max(idbandeja) from bandeja)::integer;
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






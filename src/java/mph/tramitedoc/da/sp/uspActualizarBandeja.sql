CREATE OR REPLACE FUNCTION uspActualizarBandeja(
	_idbandeja bigint,
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
BEGIN	
--IF  EXISTS (SELECT 1 FROM bandeja WHERE idbandeja <> _idbandeja) THEN

	UPDATE bandeja
  SET 
	idbandeja=_idbandeja,
	iddocumento=_iddocumento,
	idareaproviene=_idareaproviene,
	idareadestino=_idareadestino,
	idusuarioenvia=_idusuarioenvia,
	idusuariodestino=_idusuariodestino,
	bindrecepcion=_bindrecepcion,
	idusuariorecepciona=_idusuariorecepciona,
	fecharecepciona=_fecharecepciona,
	fechalectura=_fechalectura,
	fechaderivacion=_fechaderivacion,
	fecharegistro=_fecharegistro,
	estado=_estado

 WHERE idbandeja=_idbandeja;


            RETURN (select max(idbandeja) from bandeja)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






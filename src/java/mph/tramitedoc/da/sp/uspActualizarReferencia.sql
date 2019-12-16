CREATE OR REPLACE FUNCTION uspActualizarReferencia(
	_idreferencia bigint,
	_iddocumento bigint,
	_iddocumentoreferencia bigint,
	_fecharegistro timestamp without time zone,
	_idusuarioregistra integer,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM referencia WHERE idreferencia <> _idreferencia) THEN

	UPDATE referencia
  SET 
	idreferencia=_idreferencia,
	iddocumento=_iddocumento,
	iddocumentoreferencia=_iddocumentoreferencia,
	fecharegistro=_fecharegistro,
	idusuarioregistra=_idusuarioregistra,
	estado=_estado

 WHERE idreferencia=_idreferencia;


            RETURN (select max(idreferencia) from referencia)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






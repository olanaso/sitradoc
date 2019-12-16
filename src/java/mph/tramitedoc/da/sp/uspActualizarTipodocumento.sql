CREATE OR REPLACE FUNCTION uspActualizarTipodocumento(
	_idtipodocumento integer,
	_idregla integer,
	_denominacion character varying,
	_descripcion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM tipodocumento WHERE idtipodocumento <> _idtipodocumento) THEN

	UPDATE tipodocumento
  SET 
	idtipodocumento=_idtipodocumento,
	idregla=_idregla,
	denominacion=_denominacion,
	descripcion=_descripcion,
	estado=_estado

 WHERE idtipodocumento=_idtipodocumento;


            RETURN (select max(idtipodocumento) from tipodocumento)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






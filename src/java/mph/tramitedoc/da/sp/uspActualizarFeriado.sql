CREATE OR REPLACE FUNCTION uspActualizarFeriado(
	_idferiado integer,
	_idanio integer,
	_fecha date,
	_motivo character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM feriado WHERE idferiado <> _idferiado) THEN

	UPDATE feriado
  SET 
	idferiado=_idferiado,
	idanio=_idanio,
	fecha=_fecha,
	motivo=_motivo,
	estado=_estado

 WHERE idferiado=_idferiado;


            RETURN (select max(idferiado) from feriado)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






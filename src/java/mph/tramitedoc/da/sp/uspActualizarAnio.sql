CREATE OR REPLACE FUNCTION uspActualizarAnio(
	_idanio integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM anio WHERE idanio <> _idanio) THEN

	UPDATE anio
  SET 
	idanio=_idanio,
	denominacion=_denominacion,
	estado=_estado

 WHERE idanio=_idanio;


            RETURN (select max(idanio) from anio)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






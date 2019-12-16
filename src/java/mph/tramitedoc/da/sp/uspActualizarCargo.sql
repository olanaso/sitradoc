CREATE OR REPLACE FUNCTION uspActualizarCargo(
	_idcargo integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM cargo WHERE idcargo <> _idcargo) THEN

	UPDATE cargo
  SET 
	idcargo=_idcargo,
	denominacion=_denominacion,
	estado=_estado

 WHERE idcargo=_idcargo;


            RETURN (select max(idcargo) from cargo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






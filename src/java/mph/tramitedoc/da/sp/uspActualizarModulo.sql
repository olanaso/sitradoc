CREATE OR REPLACE FUNCTION uspActualizarModulo(
	_idmodulo integer,
	_denominacion character varying,
	_paginainicio character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM modulo WHERE idmodulo <> _idmodulo) THEN

	UPDATE modulo
  SET 
	idmodulo=_idmodulo,
	denominacion=_denominacion,
	paginainicio=_paginainicio,
	estado=_estado

 WHERE idmodulo=_idmodulo;


            RETURN (select max(idmodulo) from modulo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






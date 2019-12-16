CREATE OR REPLACE FUNCTION uspActualizarRolmodulo(
	_idrolmodulo integer,
	_idrol integer,
	_idmodulo integer,
	_fechaasignacion timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM rolmodulo WHERE idrolmodulo <> _idrolmodulo) THEN

	UPDATE rolmodulo
  SET 
	idrolmodulo=_idrolmodulo,
	idrol=_idrol,
	idmodulo=_idmodulo,
	fechaasignacion=_fechaasignacion,
	estado=_estado

 WHERE idrolmodulo=_idrolmodulo;


            RETURN (select max(idrolmodulo) from rolmodulo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






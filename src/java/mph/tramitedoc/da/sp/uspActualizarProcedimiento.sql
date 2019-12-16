CREATE OR REPLACE FUNCTION uspActualizarProcedimiento(
	_idprocedimiento integer,
	_idarea integer,
	_codigo character varying,
	_denominacion character varying,
	_plazodias integer,
	_idcargoresolutor integer,
	_descripcion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM procedimiento WHERE idprocedimiento <> _idprocedimiento) THEN

	UPDATE procedimiento
  SET 
	idprocedimiento=_idprocedimiento,
	idarea=_idarea,
	codigo=_codigo,
	denominacion=_denominacion,
	plazodias=_plazodias,
	idcargoresolutor=_idcargoresolutor,
	descripcion=_descripcion,
	estado=_estado

 WHERE idprocedimiento=_idprocedimiento;


            RETURN (select max(idprocedimiento) from procedimiento)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






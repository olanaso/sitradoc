CREATE OR REPLACE FUNCTION uspEliminarProcedimiento(
	_idprocedimiento integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM procedimiento WHERE idprocedimiento <> _idprocedimiento) THEN

	UPDATE procedimiento
  SET 
estado=false

 WHERE idprocedimiento=_idprocedimiento;


            RETURN _idprocedimiento;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






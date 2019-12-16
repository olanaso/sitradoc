CREATE OR REPLACE FUNCTION uspActualizarRequisitos(
	_idrequisitos integer,
	_idprocedimiento integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM requisitos WHERE idrequisitos <> _idrequisitos) THEN

	UPDATE requisitos
  SET 
	idrequisitos=_idrequisitos,
	idprocedimiento=_idprocedimiento,
	denominacion=_denominacion,
	estado=_estado

 WHERE idrequisitos=_idrequisitos;


            RETURN (select max(idrequisitos) from requisitos)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






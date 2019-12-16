CREATE OR REPLACE FUNCTION uspActualizarRol(
	_idrol integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM rol WHERE idrol <> _idrol) THEN

	UPDATE rol
  SET 
	idrol=_idrol,
	denominacion=_denominacion,
	estado=_estado

 WHERE idrol=_idrol;


            RETURN (select max(idrol) from rol)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






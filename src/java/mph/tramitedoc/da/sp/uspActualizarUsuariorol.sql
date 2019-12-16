CREATE OR REPLACE FUNCTION uspActualizarUsuariorol(
	_idusuariorol integer,
	_idusuario integer,
	_idrol integer,
	_fechaasignacion timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuariorol WHERE idusuariorol <> _idusuariorol) THEN

	UPDATE usuariorol
  SET 
	idusuariorol=_idusuariorol,
	idusuario=_idusuario,
	idrol=_idrol,
	fechaasignacion=_fechaasignacion,
	estado=_estado

 WHERE idusuariorol=_idusuariorol;


            RETURN (select max(idusuariorol) from usuariorol)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






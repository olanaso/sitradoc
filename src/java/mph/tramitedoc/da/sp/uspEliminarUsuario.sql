CREATE OR REPLACE FUNCTION uspEliminarUsuario(
	_idusuario integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuario WHERE idusuario <> _idusuario) THEN

	UPDATE usuario
  SET 
estado=false

 WHERE idusuario=_idusuario;


            RETURN _idusuario;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






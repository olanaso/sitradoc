CREATE OR REPLACE FUNCTION uspEliminarUsuariorol(
	_idusuariorol integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuariorol WHERE idusuariorol <> _idusuariorol) THEN

	UPDATE usuariorol
  SET 
estado=false

 WHERE idusuariorol=_idusuariorol;


            RETURN _idusuariorol;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






CREATE OR REPLACE FUNCTION uspActualizarUsuariocargo(
	_idusuariocargo integer,
	_idusuario integer,
	_idcargo integer,
	_fechaasignado timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuariocargo WHERE idusuariocargo <> _idusuariocargo) THEN

	UPDATE usuariocargo
  SET 
	idusuariocargo=_idusuariocargo,
	idusuario=_idusuario,
	idcargo=_idcargo,
	fechaasignado=_fechaasignado,
	estado=_estado

 WHERE idusuariocargo=_idusuariocargo;


            RETURN (select max(idusuariocargo) from usuariocargo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






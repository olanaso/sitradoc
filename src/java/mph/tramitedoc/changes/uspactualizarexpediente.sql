
-- Function: uspactualizarexpediente(bigint, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean)

-- DROP FUNCTION uspactualizarexpediente(bigint, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _bindobservado boolean)
  RETURNS integer AS
$BODY$
BEGIN	
	UPDATE expediente
  SET 
	--idexpediente=_idexpediente,
	idusuariocargo=_idusuariocargo,
	idprocedimiento=_idprocedimiento,
	idarea=_idarea,
	dni_ruc=_dni_ruc,
	nombre_razonsocial=_nombre_razonsocial,
	apellidos=_apellidos,
	direccion=_direccion,
	telefono=_telefono,
	correo=_correo,
	asunto=_asunto,
	bindobservado=_bindobservado


 WHERE idexpediente=_idexpediente;

	/*actualizando la recepcion*/
	UPDATE recepcion
	SET  
        idarea=_idarea,
        idprocedimiento=_idprocedimiento,
        idusuariorecepciona=_idusuariocargo
	WHERE 
        bindprimero=true 
        and idexpediente=_idexpediente;
	/*actualizar*/


            RETURN (select codigo from expediente where idexpediente=_idexpediente);
--END IF;
		--;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION uspactualizarexpediente(bigint, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean) OWNER TO postgres;

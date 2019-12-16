
-- Function: uspinsertarexpediente(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean)

-- DROP FUNCTION uspinsertarexpediente(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean);

CREATE OR REPLACE FUNCTION uspinsertarexpediente(_idusuariocargo integer, _idprocedimiento integer, _idarea integer, _codigo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _estado boolean, _bindentregado boolean, _bindobservado boolean)
  RETURNS integer AS
$BODY$
DECLARE _idexpediente bigint;
DECLARE _idrecepcion bigint;
DECLARE _codigogen bigint;
DECLARE _retorno integer;
DECLARE _anio integer;
BEGIN	
	_idexpediente =(select max(idexpediente) from expediente)::integer;
	_idexpediente=_idexpediente+1;
	if(_idexpediente is null) then
	_idexpediente=1;
	end if;	

	_anio=(SELECT extract(year from now())::integer);

_codigogen =(select max(codigo) from expediente WHERE estado=true and extract(year from fecharegistro)::integer=_anio )::integer;
	_codigogen=_codigogen+1;
	if(_codigogen is null) then
	_codigogen=1;
	end if;	

	INSERT INTO expediente(

	idexpediente,
	idusuariocargo,
	idprocedimiento,
	idarea,
	codigo,
	dni_ruc,
	nombre_razonsocial,
	apellidos,
	direccion,
	telefono,
	correo,
	asunto,
	estado,
	bindentregado,
	bindobservado )

 VALUES (	_idexpediente,
	_idusuariocargo,
	_idprocedimiento,
	_idarea,
	_codigogen,
	_dni_ruc,
	_nombre_razonsocial,
	_apellidos,
	_direccion,
	_telefono,
	_correo,
	_asunto,
	_estado,
	_bindentregado,
	_bindobservado);


/*registro de recepcion*/



_idrecepcion =(select max(idrecepcion) from recepcion)::integer;
	_idrecepcion=_idrecepcion+1;
	if(_idrecepcion is null) then
	_idrecepcion=1;
	end if;	

INSERT INTO recepcion(
            idrecepcion, idexpediente, idarea, idusuariorecepciona, bindentregado, 
            fecharecepcion, bindderivado, bindprimero,fechaderivacion, estado ,idprocedimiento)
    VALUES (_idrecepcion,_idexpediente, _idarea, _idusuariocargo, false, 
            now(), false,true, null, true, _idprocedimiento);

/*fin de registro de recepcion*/



           
		RETURN _codigogen;
	--ELSE

			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION uspinsertarexpediente(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean) OWNER TO postgres;

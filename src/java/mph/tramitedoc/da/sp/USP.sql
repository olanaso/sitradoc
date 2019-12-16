CREATE OR REPLACE FUNCTION uspInsertarAnio(
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idanio integer;
DECLARE _retorno integer;
BEGIN	
	_idanio =(select max(idanio) from anio)::integer;
	_idanio=_idanio+1;
	if(_idanio is null) then
	_idanio=1;
	end if;	
	INSERT INTO anio(

	idanio,
	denominacion,
	estado )

 VALUES (	_idanio,
	_denominacion,
	_estado );


            _retorno =(select max(idanio) from anio)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarAnio(
	_idanio integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM anio WHERE idanio <> _idanio) THEN

	UPDATE anio
  SET 
	idanio=_idanio,
	denominacion=_denominacion,
	estado=_estado

 WHERE idanio=_idanio;


            RETURN (select max(idanio) from anio)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarAnio(
	_idanio integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM anio WHERE idanio <> _idanio) THEN

	UPDATE anio
  SET 
estado=false

 WHERE idanio=_idanio;


            RETURN _idanio;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarArea(
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idarea integer;
DECLARE _retorno integer;
BEGIN	
	_idarea =(select max(idarea) from area)::integer;
	_idarea=_idarea+1;
	if(_idarea is null) then
	_idarea=1;
	end if;	
	INSERT INTO area(

	idarea,
	denominacion,
	estado )

 VALUES (	_idarea,
	_denominacion,
	_estado );


            _retorno =(select max(idarea) from area)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarArea(
	_idarea integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM area WHERE idarea <> _idarea) THEN

	UPDATE area
  SET 
	idarea=_idarea,
	denominacion=_denominacion,
	estado=_estado

 WHERE idarea=_idarea;


            RETURN (select max(idarea) from area)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarArea(
	_idarea integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM area WHERE idarea <> _idarea) THEN

	UPDATE area
  SET 
estado=false

 WHERE idarea=_idarea;


            RETURN _idarea;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarCargo(
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idcargo integer;
DECLARE _retorno integer;
BEGIN	
	_idcargo =(select max(idcargo) from cargo)::integer;
	_idcargo=_idcargo+1;
	if(_idcargo is null) then
	_idcargo=1;
	end if;	
	INSERT INTO cargo(

	idcargo,
	denominacion,
	estado )

 VALUES (	_idcargo,
	_denominacion,
	_estado );


            _retorno =(select max(idcargo) from cargo)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarCargo(
	_idcargo integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM cargo WHERE idcargo <> _idcargo) THEN

	UPDATE cargo
  SET 
	idcargo=_idcargo,
	denominacion=_denominacion,
	estado=_estado

 WHERE idcargo=_idcargo;


            RETURN (select max(idcargo) from cargo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarCargo(
	_idcargo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM cargo WHERE idcargo <> _idcargo) THEN

	UPDATE cargo
  SET 
estado=false

 WHERE idcargo=_idcargo;


            RETURN _idcargo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarEstadoflujo(
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idestadoflujo integer;
DECLARE _retorno integer;
BEGIN	
	_idestadoflujo =(select max(idestadoflujo) from estadoflujo)::integer;
	_idestadoflujo=_idestadoflujo+1;
	if(_idestadoflujo is null) then
	_idestadoflujo=1;
	end if;	
	INSERT INTO estadoflujo(

	idestadoflujo,
	denominacion,
	estado )

 VALUES (	_idestadoflujo,
	_denominacion,
	_estado );


            _retorno =(select max(idestadoflujo) from estadoflujo)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarEstadoflujo(
	_idestadoflujo integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM estadoflujo WHERE idestadoflujo <> _idestadoflujo) THEN

	UPDATE estadoflujo
  SET 
	idestadoflujo=_idestadoflujo,
	denominacion=_denominacion,
	estado=_estado

 WHERE idestadoflujo=_idestadoflujo;


            RETURN (select max(idestadoflujo) from estadoflujo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarEstadoflujo(
	_idestadoflujo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM estadoflujo WHERE idestadoflujo <> _idestadoflujo) THEN

	UPDATE estadoflujo
  SET 
estado=false

 WHERE idestadoflujo=_idestadoflujo;


            RETURN _idestadoflujo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarExpediente(
	_idusuariocargo integer,
	_idprocedimiento integer,
	_idarea integer,
	_codigo character varying,
	_dni_ruc character varying,
	_nombre_razonsocial character varying,
	_apellidos character varying,
	_direccion character varying,
	_telefono character varying,
	_correo character varying,
	_asunto character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idexpediente integer;
DECLARE _retorno integer;
BEGIN	
	_idexpediente =(select max(idexpediente) from expediente)::integer;
	_idexpediente=_idexpediente+1;
	if(_idexpediente is null) then
	_idexpediente=1;
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
	estado )

 VALUES (	_idexpediente,
	_idusuariocargo,
	_idprocedimiento,
	_idarea,
	_codigo,
	_dni_ruc,
	_nombre_razonsocial,
	_apellidos,
	_direccion,
	_telefono,
	_correo,
	_asunto,
	_estado );


            _retorno =(select max(idexpediente) from expediente)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarExpediente(
	_idexpediente bigint,
	_idusuariocargo integer,
	_idprocedimiento integer,
	_idarea integer,
	_codigo character varying,
	_dni_ruc character varying,
	_nombre_razonsocial character varying,
	_apellidos character varying,
	_direccion character varying,
	_telefono character varying,
	_correo character varying,
	_asunto character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expediente WHERE idexpediente <> _idexpediente) THEN

	UPDATE expediente
  SET 
	idexpediente=_idexpediente,
	idusuariocargo=_idusuariocargo,
	idprocedimiento=_idprocedimiento,
	idarea=_idarea,
	codigo=_codigo,
	dni_ruc=_dni_ruc,
	nombre_razonsocial=_nombre_razonsocial,
	apellidos=_apellidos,
	direccion=_direccion,
	telefono=_telefono,
	correo=_correo,
	asunto=_asunto,
	estado=_estado

 WHERE idexpediente=_idexpediente;


            RETURN (select max(idexpediente) from expediente)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarExpediente(
	_idexpediente bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expediente WHERE idexpediente <> _idexpediente) THEN

	UPDATE expediente
  SET 
estado=false

 WHERE idexpediente=_idexpediente;


            RETURN _idexpediente;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarExpedienterequisito(
	_idrequisitos integer,
	_idexpediente bigint,
	_fecha timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idexpedienterequisito integer;
DECLARE _retorno integer;
BEGIN	
	_idexpedienterequisito =(select max(idexpedienterequisito) from expedienterequisito)::integer;
	_idexpedienterequisito=_idexpedienterequisito+1;
	if(_idexpedienterequisito is null) then
	_idexpedienterequisito=1;
	end if;	
	INSERT INTO expedienterequisito(

	idexpedienterequisito,
	idrequisitos,
	idexpediente,
	fecha,
	estado )

 VALUES (	_idexpedienterequisito,
	_idrequisitos,
	_idexpediente,
	_fecha,
	_estado );


            _retorno =(select max(idexpedienterequisito) from expedienterequisito)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarExpedienterequisito(
	_idexpedienterequisito bigint,
	_idrequisitos integer,
	_idexpediente bigint,
	_fecha timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expedienterequisito WHERE idexpedienterequisito <> _idexpedienterequisito) THEN

	UPDATE expedienterequisito
  SET 
	idexpedienterequisito=_idexpedienterequisito,
	idrequisitos=_idrequisitos,
	idexpediente=_idexpediente,
	fecha=_fecha,
	estado=_estado

 WHERE idexpedienterequisito=_idexpedienterequisito;


            RETURN (select max(idexpedienterequisito) from expedienterequisito)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarExpedienterequisito(
	_idexpedienterequisito bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expedienterequisito WHERE idexpedienterequisito <> _idexpedienterequisito) THEN

	UPDATE expedienterequisito
  SET 
estado=false

 WHERE idexpedienterequisito=_idexpedienterequisito;


            RETURN _idexpedienterequisito;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarFeriado(
	_idanio integer,
	_fecha date,
	_motivo character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idferiado integer;
DECLARE _retorno integer;
BEGIN	
	_idferiado =(select max(idferiado) from feriado)::integer;
	_idferiado=_idferiado+1;
	if(_idferiado is null) then
	_idferiado=1;
	end if;	
	INSERT INTO feriado(

	idferiado,
	idanio,
	fecha,
	motivo,
	estado )

 VALUES (	_idferiado,
	_idanio,
	_fecha,
	_motivo,
	_estado );


            _retorno =(select max(idferiado) from feriado)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarFeriado(
	_idferiado integer,
	_idanio integer,
	_fecha date,
	_motivo character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM feriado WHERE idferiado <> _idferiado) THEN

	UPDATE feriado
  SET 
	idferiado=_idferiado,
	idanio=_idanio,
	fecha=_fecha,
	motivo=_motivo,
	estado=_estado

 WHERE idferiado=_idferiado;


            RETURN (select max(idferiado) from feriado)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarFeriado(
	_idferiado integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM feriado WHERE idferiado <> _idferiado) THEN

	UPDATE feriado
  SET 
estado=false

 WHERE idferiado=_idferiado;


            RETURN _idferiado;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarFlujo(
	_idexpediente bigint,
	_idestadoflujo integer,
	_idusuario integer,
	_idusuarioenvia integer,
	_idusuariorecepciona integer,
	_fechaenvio timestamp without time zone,
	_fechalectura timestamp without time zone,
	_asunto character varying,
	_descripcion text,
	_observacion text,
	_binderror boolean,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idflujo integer;
DECLARE _retorno integer;
BEGIN	
	_idflujo =(select max(idflujo) from flujo)::integer;
	_idflujo=_idflujo+1;
	if(_idflujo is null) then
	_idflujo=1;
	end if;	
	INSERT INTO flujo(

	idflujo,
	idexpediente,
	idestadoflujo,
	idusuario,
	idusuarioenvia,
	idusuariorecepciona,
	fechaenvio,
	fechalectura,
	asunto,
	descripcion,
	observacion,
	binderror,
	estado )

 VALUES (	_idflujo,
	_idexpediente,
	_idestadoflujo,
	_idusuario,
	_idusuarioenvia,
	_idusuariorecepciona,
	_fechaenvio,
	_fechalectura,
	_asunto,
	_descripcion,
	_observacion,
	_binderror,
	_estado );


            _retorno =(select max(idflujo) from flujo)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarFlujo(
	_idflujo bigint,
	_idexpediente bigint,
	_idestadoflujo integer,
	_idusuario integer,
	_idusuarioenvia integer,
	_idusuariorecepciona integer,
	_fechaenvio timestamp without time zone,
	_fechalectura timestamp without time zone,
	_asunto character varying,
	_descripcion text,
	_observacion text,
	_binderror boolean,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM flujo WHERE idflujo <> _idflujo) THEN

	UPDATE flujo
  SET 
	idflujo=_idflujo,
	idexpediente=_idexpediente,
	idestadoflujo=_idestadoflujo,
	idusuario=_idusuario,
	idusuarioenvia=_idusuarioenvia,
	idusuariorecepciona=_idusuariorecepciona,
	fechaenvio=_fechaenvio,
	fechalectura=_fechalectura,
	asunto=_asunto,
	descripcion=_descripcion,
	observacion=_observacion,
	binderror=_binderror,
	estado=_estado

 WHERE idflujo=_idflujo;


            RETURN (select max(idflujo) from flujo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarFlujo(
	_idflujo bigint
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM flujo WHERE idflujo <> _idflujo) THEN

	UPDATE flujo
  SET 
estado=false

 WHERE idflujo=_idflujo;


            RETURN _idflujo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarModulo(
	_denominacion character varying,
	_paginainicio character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idmodulo integer;
DECLARE _retorno integer;
BEGIN	
	_idmodulo =(select max(idmodulo) from modulo)::integer;
	_idmodulo=_idmodulo+1;
	if(_idmodulo is null) then
	_idmodulo=1;
	end if;	
	INSERT INTO modulo(

	idmodulo,
	denominacion,
	paginainicio,
	estado )

 VALUES (	_idmodulo,
	_denominacion,
	_paginainicio,
	_estado );


            _retorno =(select max(idmodulo) from modulo)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarModulo(
	_idmodulo integer,
	_denominacion character varying,
	_paginainicio character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM modulo WHERE idmodulo <> _idmodulo) THEN

	UPDATE modulo
  SET 
	idmodulo=_idmodulo,
	denominacion=_denominacion,
	paginainicio=_paginainicio,
	estado=_estado

 WHERE idmodulo=_idmodulo;


            RETURN (select max(idmodulo) from modulo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarModulo(
	_idmodulo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM modulo WHERE idmodulo <> _idmodulo) THEN

	UPDATE modulo
  SET 
estado=false

 WHERE idmodulo=_idmodulo;


            RETURN _idmodulo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarProcedimiento(
	_idarea integer,
	_codigo character varying,
	_denominacion character varying,
	_plazodias integer,
	_idcargoresolutor integer,
	_descripcion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idprocedimiento integer;
DECLARE _retorno integer;
BEGIN	
	_idprocedimiento =(select max(idprocedimiento) from procedimiento)::integer;
	_idprocedimiento=_idprocedimiento+1;
	if(_idprocedimiento is null) then
	_idprocedimiento=1;
	end if;	
	INSERT INTO procedimiento(

	idprocedimiento,
	idarea,
	codigo,
	denominacion,
	plazodias,
	idcargoresolutor,
	descripcion,
	estado )

 VALUES (	_idprocedimiento,
	_idarea,
	_codigo,
	_denominacion,
	_plazodias,
	_idcargoresolutor,
	_descripcion,
	_estado );


            _retorno =(select max(idprocedimiento) from procedimiento)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





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





CREATE OR REPLACE FUNCTION uspInsertarRequisitos(
	_idprocedimiento integer,
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idrequisitos integer;
DECLARE _retorno integer;
BEGIN	
	_idrequisitos =(select max(idrequisitos) from requisitos)::integer;
	_idrequisitos=_idrequisitos+1;
	if(_idrequisitos is null) then
	_idrequisitos=1;
	end if;	
	INSERT INTO requisitos(

	idrequisitos,
	idprocedimiento,
	denominacion,
	estado )

 VALUES (	_idrequisitos,
	_idprocedimiento,
	_denominacion,
	_estado );


            _retorno =(select max(idrequisitos) from requisitos)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





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





CREATE OR REPLACE FUNCTION uspEliminarRequisitos(
	_idrequisitos integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM requisitos WHERE idrequisitos <> _idrequisitos) THEN

	UPDATE requisitos
  SET 
estado=false

 WHERE idrequisitos=_idrequisitos;


            RETURN _idrequisitos;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarRol(
	_denominacion character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idrol integer;
DECLARE _retorno integer;
BEGIN	
	_idrol =(select max(idrol) from rol)::integer;
	_idrol=_idrol+1;
	if(_idrol is null) then
	_idrol=1;
	end if;	
	INSERT INTO rol(

	idrol,
	denominacion,
	estado )

 VALUES (	_idrol,
	_denominacion,
	_estado );


            _retorno =(select max(idrol) from rol)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





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





CREATE OR REPLACE FUNCTION uspEliminarRol(
	_idrol integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM rol WHERE idrol <> _idrol) THEN

	UPDATE rol
  SET 
estado=false

 WHERE idrol=_idrol;


            RETURN _idrol;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarRolmodulo(
	_idrol integer,
	_idmodulo integer,
	_fechaasignacion timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idrolmodulo integer;
DECLARE _retorno integer;
BEGIN	
	_idrolmodulo =(select max(idrolmodulo) from rolmodulo)::integer;
	_idrolmodulo=_idrolmodulo+1;
	if(_idrolmodulo is null) then
	_idrolmodulo=1;
	end if;	
	INSERT INTO rolmodulo(

	idrolmodulo,
	idrol,
	idmodulo,
	fechaasignacion,
	estado )

 VALUES (	_idrolmodulo,
	_idrol,
	_idmodulo,
	_fechaasignacion,
	_estado );


            _retorno =(select max(idrolmodulo) from rolmodulo)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarRolmodulo(
	_idrolmodulo integer,
	_idrol integer,
	_idmodulo integer,
	_fechaasignacion timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM rolmodulo WHERE idrolmodulo <> _idrolmodulo) THEN

	UPDATE rolmodulo
  SET 
	idrolmodulo=_idrolmodulo,
	idrol=_idrol,
	idmodulo=_idmodulo,
	fechaasignacion=_fechaasignacion,
	estado=_estado

 WHERE idrolmodulo=_idrolmodulo;


            RETURN (select max(idrolmodulo) from rolmodulo)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspEliminarRolmodulo(
	_idrolmodulo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM rolmodulo WHERE idrolmodulo <> _idrolmodulo) THEN

	UPDATE rolmodulo
  SET 
estado=false

 WHERE idrolmodulo=_idrolmodulo;


            RETURN _idrolmodulo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarUsuario(
	_nombres character varying,
	_apellidos character varying,
	_dni character varying,
	_direccion character varying,
	_telefono character varying,
	_usuario character varying,
	_password character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idusuario integer;
DECLARE _retorno integer;
BEGIN	
	_idusuario =(select max(idusuario) from usuario)::integer;
	_idusuario=_idusuario+1;
	if(_idusuario is null) then
	_idusuario=1;
	end if;	
	INSERT INTO usuario(

	idusuario,
	nombres,
	apellidos,
	dni,
	direccion,
	telefono,
	usuario,
	password,
	estado )

 VALUES (	_idusuario,
	_nombres,
	_apellidos,
	_dni,
	_direccion,
	_telefono,
	_usuario,
	_password,
	_estado );


            _retorno =(select max(idusuario) from usuario)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspActualizarUsuario(
	_idusuario integer,
	_nombres character varying,
	_apellidos character varying,
	_dni character varying,
	_direccion character varying,
	_telefono character varying,
	_usuario character varying,
	_password character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuario WHERE idusuario <> _idusuario) THEN

	UPDATE usuario
  SET 
	idusuario=_idusuario,
	nombres=_nombres,
	apellidos=_apellidos,
	dni=_dni,
	direccion=_direccion,
	telefono=_telefono,
	usuario=_usuario,
	password=_password,
	estado=_estado

 WHERE idusuario=_idusuario;


            RETURN (select max(idusuario) from usuario)::integer;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





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





CREATE OR REPLACE FUNCTION uspInsertarUsuariocargo(
	_idusuario integer,
	_idcargo integer,
	_fechaasignado timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idusuariocargo integer;
DECLARE _retorno integer;
BEGIN	
	_idusuariocargo =(select max(idusuariocargo) from usuariocargo)::integer;
	_idusuariocargo=_idusuariocargo+1;
	if(_idusuariocargo is null) then
	_idusuariocargo=1;
	end if;	
	INSERT INTO usuariocargo(

	idusuariocargo,
	idusuario,
	idcargo,
	fechaasignado,
	estado )

 VALUES (	_idusuariocargo,
	_idusuario,
	_idcargo,
	_fechaasignado,
	_estado );


            _retorno =(select max(idusuariocargo) from usuariocargo)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





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





CREATE OR REPLACE FUNCTION uspEliminarUsuariocargo(
	_idusuariocargo integer
)

  RETURNS integer AS
$BODY$
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuariocargo WHERE idusuariocargo <> _idusuariocargo) THEN

	UPDATE usuariocargo
  SET 
estado=false

 WHERE idusuariocargo=_idusuariocargo;


            RETURN _idusuariocargo;
--END IF;
		--;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





CREATE OR REPLACE FUNCTION uspInsertarUsuariorol(
	_idusuario integer,
	_idrol integer,
	_fechaasignacion timestamp without time zone,
	_estado boolean)

  RETURNS integer AS
$BODY$
DECLARE _idusuariorol integer;
DECLARE _retorno integer;
BEGIN	
	_idusuariorol =(select max(idusuariorol) from usuariorol)::integer;
	_idusuariorol=_idusuariorol+1;
	if(_idusuariorol is null) then
	_idusuariorol=1;
	end if;	
	INSERT INTO usuariorol(

	idusuariorol,
	idusuario,
	idrol,
	fechaasignacion,
	estado )

 VALUES (	_idusuariorol,
	_idusuario,
	_idrol,
	_fechaasignacion,
	_estado );


            _retorno =(select max(idusuariorol) from usuariorol)::integer;
		RETURN _retorno;
	--ELSE
	EXCEPTION
     WHEN unique_violation THEN
          RETURN 0;
     WHEN others THEN
	   RETURN 0;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;





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






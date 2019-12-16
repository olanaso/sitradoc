-- Function: uspentregaexpediente(bigint, integer)

-- DROP FUNCTION uspentregaexpediente(bigint, integer);

CREATE OR REPLACE FUNCTION uspentregaexpediente(_idexpediente bigint, _idusuariorecepciona integer)
  RETURNS integer AS
$BODY$
DECLARE _retorno integer;
DECLARE _idflujo bigint;
DECLARE _idusuariocargo integer;
BEGIN	

	_idusuariocargo=(select case when c.idusuario is null then 0 else c.idusuario end   from recepcion a 
	inner join procedimiento b on a.idprocedimiento=b.idprocedimiento
	left join usuariocargo c on b.idcargoresolutor=c.idcargo
	where idrecepcion=_idexpediente
	and a.estado=true
	and b.estado=true
	and c.estado=true);

	if(_idusuariocargo=0) then 
		_retorno=-1;
	else
	--ACTUALIZANDO AL EXPEDIENTE Y AFIRMADO QUE EL EXPEDIENTE FUE RECEPCIONADO
		UPDATE recepcion
		SET 
		bindentregado=true,
		idusuariorecepciona=_idusuariorecepciona,
		fecharecepcion= NOW()
		WHERE idrecepcion=_idexpediente;


		_idflujo =(select max(idflujo) from flujo)::integer;
		_idflujo=_idflujo+1;
		if(_idflujo is null) then
		_idflujo=1;
		end if;	


		INSERT INTO flujo(
		idflujo, idexpediente, idestadoflujo, idusuario, idusuarioenvia, 
		idusuariorecepciona,bindparent, fechaenvio, fechalectura, asunto, descripcion, 
		observacion, binderror, bindicaleido, estado)

		VALUES (_idflujo, _idexpediente,1 ,_idusuariorecepciona, _idusuariorecepciona
		,_idusuariocargo,true, now(), null,  'RECEPCION', 'ENVIO AL JEFE DEL AREA PARA LA ATENCION PERTINENTE'
		, 'ENVIO AL JEFE' , FALSE, FALSE, true);
		_retorno=1;

	end if;

	RETURN _retorno;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION uspentregaexpediente(bigint, integer) OWNER TO postgres;

--funcion para realizar la recepcion interna interna 

CREATE OR REPLACE FUNCTION uspinsertarreferencia(_ididrecepcioninterna bigint, _idexpediente bigint,_iddocumento bigint, _idarea_destino int,
						_idarea_proviene int,_idusuariorecepciona int,_idusuarioenvia int,_idrecepcion_proviene int, 
						_bindentregado boolean, _fecharecepcion timestamp without time zone,_bindderivado boolean,_bindprimero boolean,_fechaderivacion timestamp without time zone,
						_observacion text,_estado boolean)
  RETURNS integer AS
$BODY$
DECLARE _idrecepcioninterna integer;
DECLARE _retorno integer;
BEGIN	
	_idrecepcioninterna =(select max(idrecepcioninterna) from recepcioninterna)::integer;
	_idrecepcioninterna=_idrecepcioninterna+1;
	if(_idrecepcioninterna is null) then
	_idrecepcioninterna=1;
	end if;	

	INSERT INTO recepcioninterna(
            idrecepcioninterna, idexpediente, iddocumento, idarea_destino, 
            idarea_proviene, idusuariorecepciona, idusuarioenvia, idrecepcion_proviene, 
            bindentregado, fecharecepcion, bindderivado, bindprimero, fechaderivacion, 
            observacion, estado)
	VALUES (_idrecepcioninterna, _idexpediente, _iddocumento, _idarea_destino, 
            _idarea_proviene, _idusuariorecepciona, _idusuarioenvia, _idrecepcion_proviene, 
            _bindentregado, _fecharecepcion, _bindderivado, _bindprimero, _fechaderivacion, 
            _observacion, _estado);

	RETURN _idrecepcioninterna;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

/*migrar los stores de */
--insertar documento
--insertar bandeja 


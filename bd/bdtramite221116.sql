--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.20
-- Dumped by pg_dump version 9.0.20
-- Started on 2016-11-23 13:00:01

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 816 (class 2612 OID 11574)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 376 (class 1255 OID 431532)
-- Dependencies: 9 816
-- Name: listar_bandeja_cant_entrada_tramite_interno(text, text, text, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION listar_bandeja_cant_entrada_tramite_interno(_idusuario text, _idsarea text, _idsusuarioenvia text, _asunto text, _mensaje text, _indsrecepcion text, _indsrespuesta text, _indsprioridad text, _vencidosactivos text, fechainicio text, fechafin text, limite text, offsete text) RETURNS SETOF bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
_query text;
BEGIN


_query='
select 
count(a.idbandeja) total

                       
from bandeja a
inner join mensaje b on a.idmensaje = b.idmensaje
inner join usuario c on c.idusuario = a.idusuarioenvia
where
a.idusuariodestino ='||_idusuario;

IF(length(_idsarea)>0) then
_query=_query||' and a.idareaproviene in ('||_idsarea||')';
END IF;

IF(length(_idsusuarioenvia)>0) then
_query=_query||' and a.idusuarioenvia in ('||_idsusuarioenvia||')';
END IF;

IF(length(_asunto)>0) then
_query=_query||'
and
    (b.asunto ilike ''%'' || replace(rtrim(ltrim(
            case when '''' = '''||_asunto||'''
            then '' ''
            else '''||_asunto||'''
            end, '' ''), '' ''), '' '', ''%'') || ''%''
        or to_tsvector(b.asunto) @@plainto_tsquery('''||_asunto||''')
    )';
END IF;

IF(length(_mensaje)>0) then
_query=_query||'
and
    (b.mensaje ilike ''%'' || replace(rtrim(ltrim(
            case when '''' = '''||_mensaje||'''
            then ''''
            else '''||_mensaje||'''
            end, '' ''), '' ''), '' '', ''%'') || ''%''
        or to_tsvector(b.mensaje) @@ plainto_tsquery('''||_mensaje||''')
    )';
END IF;



IF(length(_indsrecepcion)>0) then
_query=_query||' and a.bindrecepcion in ('||_indsrecepcion||')';
END IF;

IF(length(_indsrespuesta)>0) then
_query=_query||' and b.bindrespuesta in ('||_indsrespuesta||')';
END IF;

IF(length(_indsprioridad)>0) then
_query=_query||' and b.prioridad in ('||_indsprioridad||')';
END IF;

IF _vencidosactivos='true' THEN
	_query=_query ||' and (date_part(''day'', now() - b.fechacreacion ) + (select count(idferiado)  from feriado 
	where fecha between b.fechacreacion and now() and estado=true)>b.diasrespuesta) = true';
END IF;

IF _vencidosactivos='false' THEN
	_query=_query ||' and (date_part(''day'', now() - b.fechacreacion ) + (select count(idferiado)  from feriado 
	where fecha between b.fechacreacion and now() and estado=true)>b.diasrespuesta) = true';
END IF;

IF _vencidosactivos='null' THEN
	_query=_query ||' ';
END IF;

_query=_query ||'and (b.fechacreacion between '''||fechainicio||''' and '''||fechafin||''' )
and a.estado = true
and b.estado = true
and c.estado = true
group by b.fechacreacion
order by b.fechacreacion desc

limit '||limite||' offset '||offsete||' ';

RAISE NOTICE 'Nonexistent ID --> %',_query;


RETURN QUERY EXECUTE _query;
END
$$;


ALTER FUNCTION public.listar_bandeja_cant_entrada_tramite_interno(_idusuario text, _idsarea text, _idsusuarioenvia text, _asunto text, _mensaje text, _indsrecepcion text, _indsrespuesta text, _indsprioridad text, _vencidosactivos text, fechainicio text, fechafin text, limite text, offsete text) OWNER TO postgres;

--
-- TOC entry 377 (class 1255 OID 431533)
-- Dependencies: 9 816
-- Name: listar_bandeja_entrada_tramite_interno(text, text, text, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION listar_bandeja_entrada_tramite_interno(_idusuario text, _idsarea text, _idsusuarioenvia text, _asunto text, _mensaje text, _indsrecepcion text, _indsrespuesta text, _indsprioridad text, _vencidosactivos text, fechainicio text, fechafin text, limite text, offsete text) RETURNS TABLE(idbandeja bigint, idmensaje bigint, usuarioenvia text, asunto character varying, mensaje text, fechaenvio text, adjunto text, recepcion text)
    LANGUAGE plpgsql
    AS $$
DECLARE
_query text;
BEGIN


_query='
select 
a.idbandeja,b.idmensaje,
case when a.bindleido=false then ''<b>''||c.nombres||'' ''||c.apellidos||''</b>''  else c.nombres||'' ''||c.apellidos  end usuarioenvia ,
case when a.bindleido=false then ''<b>''||b.asunto||''</b>''  else b.asunto  end asunto ,
case when a.bindleido=false then ''<b>''||b.mensaje||''</b>''  else b.mensaje  end  mensaje,
case when to_char( b.fechacreacion,''dd/mm/yyyy'')=to_char(now(),''dd/mm/yyyy'') 
then to_char(b.fechacreacion,''HH24:MI:SS'') else to_char(b.fechacreacion,''DD Mon YYYY HH24:MI'')  end  fechaenvio,
case when (select  count(idmensaje) from archivomensaje where idmensaje=b.idmensaje)>0 then ''<i class="fa fa-paperclip" aria-hidden="true"></i>''
else '''' end adjunto,
case when a.bindrecepcion=false then ''PENDIENTE''  else ''RECEPCIONADO - ''||to_char(a.fecharecepciona,''HH24:MI:SS'')   end  recepcion
                       
from bandeja a
inner join mensaje b on a.idmensaje = b.idmensaje
inner join usuario c on c.idusuario = a.idusuarioenvia
where
a.idusuariodestino ='||_idusuario;


IF(length(_idsarea)>0) then
_query=_query||' and a.idareaproviene in ('||_idsarea||')';
END IF;

IF(length(_idsusuarioenvia)>0) then
_query=_query||' and a.idusuarioenvia in ('||_idsusuarioenvia||')';
END IF;

IF(length(_asunto)>0) then
_query=_query||'
and
    (b.asunto ilike ''%'' || replace(rtrim(ltrim(
            case when '''' = '''||_asunto||'''
            then '' ''
            else '''||_asunto||'''
            end, '' ''), '' ''), '' '', ''%'') || ''%''
        or to_tsvector(b.asunto) @@plainto_tsquery('''||_asunto||''')
    )';
END IF;

IF(length(_mensaje)>0) then
_query=_query||'
and
    (b.mensaje ilike ''%'' || replace(rtrim(ltrim(
            case when '''' = '''||_mensaje||'''
            then ''''
            else '''||_mensaje||'''
            end, '' ''), '' ''), '' '', ''%'') || ''%''
        or to_tsvector(b.mensaje) @@ plainto_tsquery('''||_mensaje||''')
    )';
END IF;



IF(length(_indsrecepcion)>0) then
_query=_query||' and a.bindrecepcion in ('||_indsrecepcion||')';
END IF;

IF(length(_indsrespuesta)>0) then
_query=_query||' and b.bindrespuesta in ('||_indsrespuesta||')';
END IF;

IF(length(_indsprioridad)>0) then
_query=_query||' and b.prioridad in ('||_indsprioridad||')';
END IF;

IF _vencidosactivos='true' THEN
	_query=_query ||' and (date_part(''day'', now() - b.fechacreacion ) + (select count(idferiado)  from feriado 
	where fecha between b.fechacreacion and now() and estado=true)>b.diasrespuesta) = true';
END IF;

IF _vencidosactivos='false' THEN
	_query=_query ||' and (date_part(''day'', now() - b.fechacreacion ) + (select count(idferiado)  from feriado 
	where fecha between b.fechacreacion and now() and estado=true)>b.diasrespuesta) = true';
END IF;

IF _vencidosactivos='null' THEN
	_query=_query ||' ';
END IF;

_query=_query ||'and (b.fechacreacion between '''||fechainicio||''' and '''||fechafin||''' )
and a.estado = true
and b.estado = true
and c.estado = true
group by b.fechacreacion
order by b.fechacreacion desc
limit '||limite||' offset '||offsete||' ';

RAISE NOTICE 'Nonexistent ID --> %',_query;


RETURN QUERY EXECUTE _query;
END
$$;


ALTER FUNCTION public.listar_bandeja_entrada_tramite_interno(_idusuario text, _idsarea text, _idsusuarioenvia text, _asunto text, _mensaje text, _indsrecepcion text, _indsrespuesta text, _indsprioridad text, _vencidosactivos text, fechainicio text, fechafin text, limite text, offsete text) OWNER TO postgres;

--
-- TOC entry 374 (class 1255 OID 431511)
-- Dependencies: 9 816
-- Name: listar_bandeja_salida_tramite_interno(text, text, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION listar_bandeja_salida_tramite_interno(_idsarea text, _idsusuarioenvia text, _asunto text, _mensaje text, _indsrecepcion text, _indsrespuesta text, _indsprioridad text, _vencidosactivos text, fechainicio text, fechafin text, limite text, offsete text) RETURNS TABLE(count bigint)
    LANGUAGE plpgsql
    AS $$
DECLARE
_query text;
BEGIN
_query='
select 
count (b.idmensaje) total
from bandeja a
inner join mensaje b on a.idmensaje = b.idmensaje
inner join usuario c on c.idusuario = a.idusuarioenvia
where
a.idusuariodestino = 9
and a.idareaproviene in ('||_idsarea||')
and a.idusuarioenvia in ('||_idsusuarioenvia||')
and
    (b.asunto ilike ''%'' || replace(rtrim(ltrim(
            case when '''' = '||_asunto||'
            then '' ''
            else '||_asunto||'
            end, '' ''), '' ''), '' '', ''%'') || ''%''
        or to_tsvector(b.asunto) @ @ plainto_tsquery('||_asunto||')
    )
and
    (b.mensaje ilike ''%'' || replace(rtrim(ltrim(
            case when '''' = '||_mensaje||'
            then ''''
            else '||_mensaje||'
            end, '' ''), '' ''), '' '', ''%'') || ''%''
        or to_tsvector(b.mensaje) @ @ plainto_tsquery('||_mensaje||')
    )

and a.bindrecepcion in ('||_indsrecepcion||')
and b.bindrespuesta in ('||_indsrespuesta||')
and b.prioridad in ('||_indsprioridad||')';

IF _vencidosactivos='true' THEN
	_query=_query ||' and (date_part(''day'', now() - b.fechacreacion ) + (select count(idferiado)  from feriado 
	where fecha between b.fechacreacion and now() and estado=true)>b.diasrespuesta) = true';
END IF;

IF _vencidosactivos='false' THEN
	_query=_query ||' and (date_part(''day'', now() - b.fechacreacion ) + (select count(idferiado)  from feriado 
	where fecha between b.fechacreacion and now() and estado=true)>b.diasrespuesta) = true';
END IF;

IF _vencidosactivos='null' THEN
	_query=_query ||' ';
END IF;

_query=_query ||'and (b.fechacreacion between '||fechainicio||' and '||fechafin||' )
and a.estado = true
and b.estado = true
and c.estado = true
';




RETURN QUERY EXECUTE _query;
END
$$;


ALTER FUNCTION public.listar_bandeja_salida_tramite_interno(_idsarea text, _idsusuarioenvia text, _asunto text, _mensaje text, _indsrecepcion text, _indsrespuesta text, _indsprioridad text, _vencidosactivos text, fechainicio text, fechafin text, limite text, offsete text) OWNER TO postgres;

--
-- TOC entry 318 (class 1255 OID 164013)
-- Dependencies: 9 816
-- Name: tg_insertuser(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tg_insertuser() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	INSERT INTO ofuser(
            username, plainpassword, encryptedpassword, "name", email, creationdate, 
            modificationdate)
    VALUES (new.usuario, '', new.password, new.nombres||' '||new.apellidos, new.telefono, new.creationdate, 
            '');

            return new;

end;
$$;


ALTER FUNCTION public.tg_insertuser() OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 172204)
-- Dependencies: 816 9
-- Name: tg_opinsertuser(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tg_opinsertuser() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare res integer;
begin
	res=(select uspinsertarusuario(new.name, new.name , new.email, '', '', new.username, new.encryptedpassword, true, new.creationdate ));

            return new;

end;
$$;


ALTER FUNCTION public.tg_opinsertuser() OWNER TO postgres;

--
-- TOC entry 332 (class 1255 OID 197140)
-- Dependencies: 9 816
-- Name: upssetexpleido(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION upssetexpleido(_idflujo bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _bindleido boolean;
BEGIN	

_bindleido=(select bindicaleido from flujo where idflujo=_idflujo);
if(_bindleido=true)
then 
_idflujo=1;
else
UPDATE flujo
SET 
fechalectura=now(),
bindicaleido=true
WHERE idflujo=_idflujo;
end if;


RETURN _idflujo;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.upssetexpleido(_idflujo bigint) OWNER TO postgres;

--
-- TOC entry 345 (class 1255 OID 380231)
-- Dependencies: 9 816
-- Name: usp_listar_estadobandeja(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usp_listar_estadobandeja(_idusuariorecepciona integer) RETURNS TABLE(idestadobandeja integer, icono character varying, denominacionestado character varying, cantidad integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
registro RECORD;
_cantidad int;
BEGIN



CREATE TEMPORARY TABLE tmp_estado_bandeja (
   tmp_idestadobandeja int,
tmp_icono varchar(200),
  tmp_denominacionestado varchar(200),
  tmp_cantidad int
);

FOR registro IN SELECT  a.idestadobandeja  ,a.icono, a.denominacion FROM estadobandeja a order by a.orden LOOP
 _cantidad=(select count(idbandeja) from bandeja b
  where b.estado=true
  and b.idusuariodestino=_idusuariorecepciona
  and b.idestadobandeja=registro.idestadobandeja);

INSERT INTO tmp_estado_bandeja(
            tmp_idestadobandeja,tmp_icono,tmp_denominacionestado,tmp_cantidad)
VALUES ( registro.idestadobandeja,registro.icono,registro.denominacion,_cantidad);

 END LOOP;

 RETURN QUERY SELECT tmp_idestadobandeja,tmp_icono,tmp_denominacionestado,tmp_cantidad FROM tmp_estado_bandeja;
DROP TABLE tmp_estado_bandeja;

END
$$;


ALTER FUNCTION public.usp_listar_estadobandeja(_idusuariorecepciona integer) OWNER TO postgres;

--
-- TOC entry 326 (class 1255 OID 188768)
-- Dependencies: 816 9
-- Name: usp_listar_estadoexpediente(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usp_listar_estadoexpediente(_idusuariorecepciona integer) RETURNS TABLE(denominacion character varying, cantidad integer, isatendido boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
registro RECORD;
_cantidad int;
BEGIN



CREATE TEMPORARY TABLE tmp_estado_flujo (
   idestadoflujo int,
  denominacionestado varchar(100),
  cantidad int
);

FOR registro IN SELECT  idestadoflujo  , denominacion FROM estadoflujo  LOOP
 _cantidad=(select count(idflujo) from flujo
  where bindparent=true
  and idusuariorecepciona=_idusuario
  and idestadoflujo=registro.idestadoflujo);

INSERT INTO tmp_estado_flujo(
            idestadoflujo,denominacionestado,cantidad)
    VALUES ( registro.idestadoflujo,resgitro.denominacion,_cantidad);

 END LOOP;

  RETURN QUERY SELECT * FROM tmp_estado_flujo;
DROP TABLE tmp_estado_flujo;

END
$$;


ALTER FUNCTION public.usp_listar_estadoexpediente(_idusuariorecepciona integer) OWNER TO postgres;

--
-- TOC entry 327 (class 1255 OID 188779)
-- Dependencies: 816 9
-- Name: usp_listar_estadoexpediente2(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usp_listar_estadoexpediente2(_idusuariorecepciona integer) RETURNS TABLE(idestadoflujo integer, denominacionestado character varying, cantidad integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
registro RECORD;
_cantidad int;
BEGIN



CREATE TEMPORARY TABLE tmp_estado_flujo (
   tmp_idestadoflujo int,
  tmp_denominacionestado varchar(100),
  tmp_cantidad int
);

FOR registro IN SELECT  a.idestadoflujo  , a.denominacion FROM estadoflujo a order by a.orden LOOP
 _cantidad=(select count(idflujo) from flujo b
  where b.bindparent=true
  and b.idusuariorecepciona=_idusuariorecepciona
  and b.idestadoflujo=registro.idestadoflujo);

INSERT INTO tmp_estado_flujo(
            tmp_idestadoflujo,tmp_denominacionestado,tmp_cantidad)
    VALUES ( registro.idestadoflujo,registro.denominacion,_cantidad);

 END LOOP;

 RETURN QUERY SELECT tmp_idestadoflujo,tmp_denominacionestado,tmp_cantidad FROM tmp_estado_flujo;
DROP TABLE tmp_estado_flujo;

END
$$;


ALTER FUNCTION public.usp_listar_estadoexpediente2(_idusuariorecepciona integer) OWNER TO postgres;

--
-- TOC entry 321 (class 1255 OID 188708)
-- Dependencies: 816 9
-- Name: usp_listarexpedientes_estado_atencion(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usp_listarexpedientes_estado_atencion(_idusuario integer) RETURNS TABLE(denominacion character varying, cantidad integer, isatendido boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
 _cantidad_sinresolver int;
 _cantidad_resuelto int;
BEGIN


 _cantidad_sinresolver=( select count(idflujo) from flujo
  where bindparent=false
  and idusuariorecepciona=_idusuario
  and bindatendido=false);

 _cantidad_resuelto=(select count(idflujo) from flujo
  where bindparent=false
  and idusuariorecepciona=_idusuario
  and bindatendido=true);

CREATE TEMPORARY TABLE tmp_estado_atencion (
   denominacion character varying(100),
  cantidad integer,
  isatendido BOOLEAN
);

INSERT INTO tmp_estado_atencion(
            denominacion,cantidad,isatendido)
    VALUES ( 'POR ATENDER',_cantidad_sinresolver,FALSE);
INSERT INTO tmp_estado_atencion(
            denominacion,cantidad,isatendido)
    VALUES ( 'ATENDIDO',_cantidad_resuelto,TRUE);

---
  RETURN QUERY SELECT * FROM tmp_estado_atencion;
DROP TABLE tmp_estado_atencion;

END
$$;


ALTER FUNCTION public.usp_listarexpedientes_estado_atencion(_idusuario integer) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 139437)
-- Dependencies: 816 9
-- Name: uspactualizaranio(integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizaranio(_idanio integer, _denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _anioduplicado INTEGER;
DECLARE _retorno INTEGER;

BEGIN	
--IF  EXISTS (SELECT 1 FROM anio WHERE idanio <> _idanio) THEN
	_anioduplicado=(select max(idanio) from anio where denominacion=_denominacion and estado=true);

IF _anioduplicado is null then
	
	UPDATE anio
  SET 
	idanio=_idanio,
	denominacion=_denominacion,
	estado=_estado

 WHERE idanio=_idanio;

	_retorno=(select max(idanio) from anio)::integer;
ELSE
 _retorno=-1;
 END IF;

	RETURN _retorno;
            
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizaranio(_idanio integer, _denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 314 (class 1255 OID 188588)
-- Dependencies: 9 816
-- Name: uspactualizararchivo(bigint, bigint, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizararchivo(_idarchivo bigint, _idflujo bigint, _denominacion character varying, _ruta character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM archivo WHERE idarchivo <> _idarchivo) THEN

	UPDATE archivo
  SET 
	idarchivo=_idarchivo,
	idflujo=_idflujo,
	denominacion=_denominacion,
	ruta=_ruta,
	estado=_estado

 WHERE idarchivo=_idarchivo;


            RETURN (select max(idarchivo) from archivo)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizararchivo(_idarchivo bigint, _idflujo bigint, _denominacion character varying, _ruta character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 335 (class 1255 OID 303869)
-- Dependencies: 816 9
-- Name: uspactualizararchivodocumento(bigint, bigint, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizararchivodocumento(_idarchivodocumento bigint, _documento bigint, _codigo character varying, _nombre character varying, _url character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM archivodocumento WHERE idarchivodocumento <> _idarchivodocumento) THEN

	UPDATE archivodocumento
  SET 
	idarchivodocumento=_idarchivodocumento,
	documento=_documento,
	codigo=_codigo,
	nombre=_nombre,
	url=_url,
	estado=_estado

 WHERE idarchivodocumento=_idarchivodocumento;


            RETURN _idarchivodocumento;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizararchivodocumento(_idarchivodocumento bigint, _documento bigint, _codigo character varying, _nombre character varying, _url character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 347 (class 1255 OID 388757)
-- Dependencies: 9 816
-- Name: uspactualizararchivomensaje(bigint, bigint, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizararchivomensaje(_idarchivomensaje bigint, _idmensaje bigint, _nombre character varying, _url character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM archivodocumento WHERE idarchivodocumento <> _idarchivodocumento) THEN

UPDATE archivomensaje
   SET idarchivomensaje=_idarchivomensaje
	, idmensaje=_idmensaje
	, nombre=_nombre
	, url=_url
	, estado=_estado
 WHERE 
 idarchivomensaje=_idarchivomensaje;


            RETURN _idarchivomensaje;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizararchivomensaje(_idarchivomensaje bigint, _idmensaje bigint, _nombre character varying, _url character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 139438)
-- Dependencies: 9 816
-- Name: uspactualizararea(integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizararea(_idarea integer, _denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _areaduplicado INTEGER;
DECLARE _retorno INTEGER;

BEGIN	
--IF  EXISTS (SELECT 1 FROM area WHERE idarea <> _idarea) THEN


	_areaduplicado=(select max(idarea) from area where denominacion=_denominacion and estado=true);
IF _areaduplicado is null then 

	UPDATE area
  SET 
	idarea=_idarea,
	denominacion=_denominacion,
	estado=_estado

 WHERE idarea=_idarea;

		  _retorno =(select max(idarea) from area)::integer;
		  
ELSE
 _retorno=-1;
 END IF;

	RETURN _retorno;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizararea(_idarea integer, _denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 359 (class 1255 OID 412798)
-- Dependencies: 9 816
-- Name: uspactualizararea(integer, character varying, character varying, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizararea(_idarea integer, _denominacion character varying, _abreviatura character varying, _codigo character varying, _idareasuperior integer, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _areaduplicado INTEGER;
DECLARE _retorno INTEGER;

BEGIN	
--IF  EXISTS (SELECT 1 FROM area WHERE idarea <> _idarea) THEN


--	_areaduplicado=(select max(idarea) from area where denominacion=_denominacion and estado=true);
--IF _areaduplicado is null then 

	UPDATE area
  SET 
	idarea=_idarea,
	denominacion=_denominacion,
	abreviatura=_abreviatura,
	codigo=_codigo,
	idareasuperior=_idareasuperior,
	estado=_estado

 WHERE idarea=_idarea;

		  _retorno =(select max(idarea) from area)::integer;
		  
--ELSE
-- _retorno=-1;
-- END IF;

	RETURN _retorno;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizararea(_idarea integer, _denominacion character varying, _abreviatura character varying, _codigo character varying, _idareasuperior integer, _estado boolean) OWNER TO postgres;

--
-- TOC entry 336 (class 1255 OID 303870)
-- Dependencies: 816 9
-- Name: uspactualizarbandeja(bigint, bigint, integer, integer, integer, integer, boolean, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarbandeja(_idbandeja bigint, _iddocumento bigint, _idareaproviene integer, _idareadestino integer, _idusuarioenvia integer, _idusuariodestino integer, _bindrecepcion boolean, _idusuariorecepciona integer, _fecharecepciona timestamp without time zone, _fechalectura timestamp without time zone, _fechaderivacion timestamp without time zone, _fecharegistro timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM bandeja WHERE idbandeja <> _idbandeja) THEN

	UPDATE bandeja
  SET 
	idbandeja=_idbandeja,
	iddocumento=_iddocumento,
	idareaproviene=_idareaproviene,
	idareadestino=_idareadestino,
	idusuarioenvia=_idusuarioenvia,
	idusuariodestino=_idusuariodestino,
	bindrecepcion=_bindrecepcion,
	idusuariorecepciona=_idusuariorecepciona,
	fecharecepciona=_fecharecepciona,
	fechalectura=_fechalectura,
	fechaderivacion=_fechaderivacion,
	fecharegistro=_fecharegistro,
	estado=_estado

 WHERE idbandeja=_idbandeja;


            RETURN (select max(idbandeja) from bandeja)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarbandeja(_idbandeja bigint, _iddocumento bigint, _idareaproviene integer, _idareadestino integer, _idusuarioenvia integer, _idusuariodestino integer, _bindrecepcion boolean, _idusuariorecepciona integer, _fecharecepciona timestamp without time zone, _fechalectura timestamp without time zone, _fechaderivacion timestamp without time zone, _fecharegistro timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 368 (class 1255 OID 415003)
-- Dependencies: 816 9
-- Name: uspactualizarcargo(integer, integer, character varying, boolean, integer, integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarcargo(_idcargo integer, _idarea integer, _denominacion character varying, _bindjefe boolean, _idcargoparent integer, _nivel integer, _abreviatura character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM cargo WHERE idcargo <> _idcargo) THEN

	UPDATE cargo
  SET 
	idcargo=_idcargo,
	idarea=_idarea,
	denominacion=_denominacion,
	bindjefe=_bindjefe,
	idcargoparent=_idcargoparent,
	nivel=_nivel,
	abreviatura=_abreviatura,
	estado=_estado

 WHERE idcargo=_idcargo;


            RETURN (select max(idcargo) from cargo)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarcargo(_idcargo integer, _idarea integer, _denominacion character varying, _bindjefe boolean, _idcargoparent integer, _nivel integer, _abreviatura character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 337 (class 1255 OID 303871)
-- Dependencies: 9 816
-- Name: uspactualizardocumento(bigint, integer, character varying, text, integer, boolean, integer, boolean, integer, integer, timestamp without time zone, bigint, bigint, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizardocumento(_iddocumento bigint, _tipodocumento integer, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _diasrespuesta integer, _bindllegadausuario boolean, _idareacioncreacion integer, _idusuariocreacion integer, _fechacreacion timestamp without time zone, _idexpediente bigint, _codigoexpediente bigint, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM documento WHERE iddocumento <> _iddocumento) THEN

	UPDATE documento
  SET 
	iddocumento=_iddocumento,
	tipodocumento=_tipodocumento,
	asunto=_asunto,
	mensaje=_mensaje,
	prioridad=_prioridad,
	bindrespuesta=_bindrespuesta,
	diasrespuesta=_diasrespuesta,
	bindllegadausuario=_bindllegadausuario,
	idareacioncreacion=_idareacioncreacion,
	idusuariocreacion=_idusuariocreacion,
	fechacreacion=_fechacreacion,
	idexpediente=_idexpediente,
	codigoexpediente=_codigoexpediente,
	estado=_estado

 WHERE iddocumento=_iddocumento;


            RETURN (select max(iddocumento) from documento)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizardocumento(_iddocumento bigint, _tipodocumento integer, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _diasrespuesta integer, _bindllegadausuario boolean, _idareacioncreacion integer, _idusuariocreacion integer, _fechacreacion timestamp without time zone, _idexpediente bigint, _codigoexpediente bigint, _estado boolean) OWNER TO postgres;

--
-- TOC entry 316 (class 1255 OID 188596)
-- Dependencies: 816 9
-- Name: uspactualizarenvio(bigint, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarenvio(_idenvio bigint, _idusuario integer, _fechaenvio timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM envio WHERE idenvio <> _idenvio) THEN

	UPDATE envio
  SET 
	idenvio=_idenvio,
	idusuario=_idusuario,
	fechaenvio=_fechaenvio,
	estado=_estado

 WHERE idenvio=_idenvio;


            RETURN (select max(idenvio) from envio)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarenvio(_idenvio bigint, _idusuario integer, _fechaenvio timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 139440)
-- Dependencies: 9 816
-- Name: uspactualizarestadoflujo(integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarestadoflujo(_idestadoflujo integer, _denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspactualizarestadoflujo(_idestadoflujo integer, _denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 139441)
-- Dependencies: 816 9
-- Name: uspactualizarexpediente(bigint, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarexpediente(_idexpediente bigint, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expediente WHERE idexpediente <> _idexpediente) THEN

	UPDATE expediente
  SET 
	idexpediente=_idexpediente,
	idusuariocargo=_idusuariocargo,

	dni_ruc=_dni_ruc,
	nombre_razonsocial=_nombre_razonsocial,
	apellidos=_apellidos,
	direccion=_direccion,
	telefono=_telefono,
	correo=_correo,
	asunto=_asunto


 WHERE idexpediente=_idexpediente;


            RETURN _idexpediente;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarexpediente(_idexpediente bigint, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 139442)
-- Dependencies: 9 816
-- Name: uspactualizarexpediente(bigint, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expediente WHERE idexpediente <> _idexpediente) THEN

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
	asunto=_asunto


 WHERE idexpediente=_idexpediente;


            RETURN _idexpediente;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying) OWNER TO postgres;

--
-- TOC entry 362 (class 1255 OID 254677)
-- Dependencies: 9 816
-- Name: uspactualizarexpediente(bigint, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _bindobservado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
	WHERE 
		idexpediente=_idexpediente;


	INSERT INTO hexpediente(
	idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado, 
	accion)
	SELECT idexpediente, _idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado,'ACTUALIZACION'
	FROM expediente
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

$$;


ALTER FUNCTION public.uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _bindobservado boolean) OWNER TO postgres;

--
-- TOC entry 366 (class 1255 OID 414950)
-- Dependencies: 816 9
-- Name: uspactualizarexpediente(bigint, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _bindobservado boolean, _folios integer, _nombredocumento character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
		folios=_folios,
		nombredocumento=_nombredocumento,
		bindobservado=_bindobservado
	WHERE 
		idexpediente=_idexpediente;


	INSERT INTO hexpediente(
	idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado, 
	accion)
	SELECT idexpediente, _idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, now(), bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado,'ACTUALIZACION'
	FROM expediente
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

$$;


ALTER FUNCTION public.uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _bindobservado boolean, _folios integer, _nombredocumento character varying) OWNER TO postgres;

--
-- TOC entry 378 (class 1255 OID 431601)
-- Dependencies: 9 816
-- Name: uspactualizarexpediente(bigint, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _bindobservado boolean, _folios integer, _nombredocumento character varying, _observacion character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
		folios=_folios,
		nombredocumento=_nombredocumento,
		bindobservado=_bindobservado
	WHERE 
		idexpediente=_idexpediente;


	INSERT INTO hexpediente(
	idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado, 
	accion)
	SELECT idexpediente, _idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, now(), bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado,'ACTUALIZACION:'||_observacion
	FROM expediente
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

$$;


ALTER FUNCTION public.uspactualizarexpediente(_idexpediente bigint, _idprocedimiento integer, _idarea integer, _idusuariocargo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _bindobservado boolean, _folios integer, _nombredocumento character varying, _observacion character varying) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 139444)
-- Dependencies: 816 9
-- Name: uspactualizarexpedienterequisito(integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarexpedienterequisito(_idrequisitos integer, _idexpediente bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE _idexpedienterequisito integer;
DECLARE _retorno integer;
BEGIN	
	
	--delete from expedienterequisito where  idexpediente=_idexpediente;

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
	now(),
	true );


            _retorno =(select max(idexpedienterequisito) from expedienterequisito)::integer;
		RETURN _retorno;
	--ELSE




END;

$$;


ALTER FUNCTION public.uspactualizarexpedienterequisito(_idrequisitos integer, _idexpediente bigint) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 139445)
-- Dependencies: 9 816
-- Name: uspactualizarexpedienterequisito(bigint, integer, bigint, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarexpedienterequisito(_idexpedienterequisito bigint, _idrequisitos integer, _idexpediente bigint, _fecha timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE _idexpedienterequisito integer;
DECLARE _retorno integer;
BEGIN	
	
	--delete from expedienterequisito where  idexpediente=_idexpediente;

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
	new(),
	true );


            _retorno =(select max(idexpedienterequisito) from expedienterequisito)::integer;
		RETURN _retorno;
	--ELSE




END;

$$;


ALTER FUNCTION public.uspactualizarexpedienterequisito(_idexpedienterequisito bigint, _idrequisitos integer, _idexpediente bigint, _fecha timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 139446)
-- Dependencies: 9 816
-- Name: uspactualizarferiado(integer, integer, date, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarferiado(_idferiado integer, _idanio integer, _fecha date, _motivo character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _retorno integer;
DECLARE _feriadoduplicado integer;
BEGIN	
--IF  EXISTS (SELECT 1 FROM feriado WHERE idferiado <> _idferiado) THEN

 _feriadoduplicado=(select max(idferiado) from feriado where fecha=_fecha and motivo=_motivo);

 IF _feriadoduplicado is null then
 
	UPDATE feriado
  SET 
	idferiado=_idferiado,
	idanio=_idanio,
	fecha=_fecha,
	motivo=_motivo,
	estado=_estado

 WHERE idferiado=_idferiado;

_retorno =(select max(idferiado) from feriado)::integer;

ELSE

 _retorno=-1;

 
END IF;

 RETURN _retorno;
END;

$$;


ALTER FUNCTION public.uspactualizarferiado(_idferiado integer, _idanio integer, _fecha date, _motivo character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 139447)
-- Dependencies: 816 9
-- Name: uspactualizarflujo(bigint, bigint, integer, integer, integer, integer, timestamp without time zone, timestamp without time zone, character varying, text, text, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarflujo(_idflujo bigint, _idexpediente bigint, _idestadoflujo integer, _idusuario integer, _idusuarioenvia integer, _idusuariorecepciona integer, _fechaenvio timestamp without time zone, _fechalectura timestamp without time zone, _asunto character varying, _descripcion text, _observacion text, _binderror boolean, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspactualizarflujo(_idflujo bigint, _idexpediente bigint, _idestadoflujo integer, _idusuario integer, _idusuarioenvia integer, _idusuariorecepciona integer, _fechaenvio timestamp without time zone, _fechalectura timestamp without time zone, _asunto character varying, _descripcion text, _observacion text, _binderror boolean, _estado boolean) OWNER TO postgres;

--
-- TOC entry 349 (class 1255 OID 388793)
-- Dependencies: 816 9
-- Name: uspactualizarmensaje(bigint, character varying, text, integer, boolean, integer, integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarmensaje(_idmensaje bigint, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _diasrespuesta integer, _idareacioncreacion integer, _idusuariocreacion integer, _fechacreacion timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM mensaje WHERE idmensaje <> _idmensaje) THEN

	UPDATE mensaje
  SET 
	idmensaje=_idmensaje,
	asunto=_asunto,
	mensaje=_mensaje,
	prioridad=_prioridad,
	bindrespuesta=_bindrespuesta,
	diasrespuesta=_diasrespuesta,
	idareacioncreacion=_idareacioncreacion,
	idusuariocreacion=_idusuariocreacion,
	fechacreacion=_fechacreacion,
	estado=_estado

 WHERE idmensaje=_idmensaje;


            RETURN _idmensaje;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarmensaje(_idmensaje bigint, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _diasrespuesta integer, _idareacioncreacion integer, _idusuariocreacion integer, _fechacreacion timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 139448)
-- Dependencies: 816 9
-- Name: uspactualizarmodulo(integer, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarmodulo(_idmodulo integer, _denominacion character varying, _paginainicio character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _modduplicado INTEGER;
DECLARE _retorno INTEGER;
BEGIN	
--IF  EXISTS (SELECT 1 FROM modulo WHERE idmodulo <> _idmodulo) THEN

	_modduplicado=(select max(idmodulo) from modulo where denominacion=_denominacion and paginainicio=_paginainicio and estado=true);
IF _modduplicado is null then 

	UPDATE modulo
  SET 
	idmodulo=_idmodulo,
	denominacion=_denominacion,
	paginainicio=_paginainicio,
	estado=_estado

 WHERE idmodulo=_idmodulo;


            _retorno =(select max(idmodulo) from modulo)::integer;

 ELSE
 _retorno=-1;
 END IF;

	RETURN _retorno;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarmodulo(_idmodulo integer, _denominacion character varying, _paginainicio character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 355 (class 1255 OID 389168)
-- Dependencies: 816 9
-- Name: uspactualizarprocedimiento(integer, integer, character varying, character varying, integer, integer, integer, character varying, double precision, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarprocedimiento(_idprocedimiento integer, _idarea integer, _codigo character varying, _denominacion character varying, _plazodias integer, _idcargoresolutor integer, _idtipoprocedimiento integer, _descripcion character varying, _montototal double precision, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
	idtipoprocedimiento=_idtipoprocedimiento,
	descripcion=_descripcion,
	montototal=_montototal,
	estado=_estado

 WHERE idprocedimiento=_idprocedimiento;


            RETURN (select max(idprocedimiento) from procedimiento)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarprocedimiento(_idprocedimiento integer, _idarea integer, _codigo character varying, _denominacion character varying, _plazodias integer, _idcargoresolutor integer, _idtipoprocedimiento integer, _descripcion character varying, _montototal double precision, _estado boolean) OWNER TO postgres;

--
-- TOC entry 338 (class 1255 OID 303872)
-- Dependencies: 9 816
-- Name: uspactualizarreferencia(bigint, bigint, bigint, timestamp without time zone, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarreferencia(_idreferencia bigint, _iddocumento bigint, _iddocumentoreferencia bigint, _fecharegistro timestamp without time zone, _idusuarioregistra integer, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM referencia WHERE idreferencia <> _idreferencia) THEN

	UPDATE referencia
  SET 
	idreferencia=_idreferencia,
	iddocumento=_iddocumento,
	iddocumentoreferencia=_iddocumentoreferencia,
	fecharegistro=_fecharegistro,
	idusuarioregistra=_idusuarioregistra,
	estado=_estado

 WHERE idreferencia=_idreferencia;


            RETURN (select max(idreferencia) from referencia)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarreferencia(_idreferencia bigint, _iddocumento bigint, _iddocumentoreferencia bigint, _fecharegistro timestamp without time zone, _idusuarioregistra integer, _estado boolean) OWNER TO postgres;

--
-- TOC entry 339 (class 1255 OID 303873)
-- Dependencies: 9 816
-- Name: uspactualizarregla(integer, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarregla(_idregla integer, _subida boolean, _igual boolean, _bajada boolean, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM regla WHERE idregla <> _idregla) THEN

	UPDATE regla
  SET 
	idregla=_idregla,
	subida=_subida,
	igual=_igual,
	bajada=_bajada,
	estado=_estado

 WHERE idregla=_idregla;


            RETURN (select max(idregla) from regla)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarregla(_idregla integer, _subida boolean, _igual boolean, _bajada boolean, _estado boolean) OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 139450)
-- Dependencies: 9 816
-- Name: uspactualizarrequisitos(integer, integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarrequisitos(_idrequisitos integer, _idprocedimiento integer, _denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspactualizarrequisitos(_idrequisitos integer, _idprocedimiento integer, _denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 139451)
-- Dependencies: 816 9
-- Name: uspactualizarrol(integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarrol(_idrol integer, _denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _rolduplicado integer;----
DECLARE _retorno integer;
BEGIN	
--IF  EXISTS (SELECT 1 FROM rol WHERE idrol <> _idrol) THEN
			_rolduplicado=(select max(idrol) from rol where denominacion=_denominacion and estado=true);----

if _rolduplicado is null then 
	UPDATE rol
  SET 
	idrol=_idrol,
	denominacion=_denominacion,
	estado=_estado

 WHERE idrol=_idrol;

		_retorno = (select max(idrol) from rol)::integer;
            --RETURN (select max(idrol) from rol)::integer;
--END IF;
		--;

		else----
		_retorno=-1;----
		end if;----
		RETURN _retorno;----
END;

$$;


ALTER FUNCTION public.uspactualizarrol(_idrol integer, _denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 139452)
-- Dependencies: 816 9
-- Name: uspactualizarrolmodulo(integer, integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarrolmodulo(_idrolmodulo integer, _idrol integer, _idmodulo integer, _fechaasignacion timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _retorno INTEGER;
DECLARE _rolmoduloduplicado INTEGER;
BEGIN	
--IF  EXISTS (SELECT 1 FROM rolmodulo WHERE idrolmodulo <> _idrolmodulo) THEN

	_rolmoduloduplicado =(select max(idrolmodulo) from rolmodulo where idrol=_idrol and idmodulo=_idmodulo and estado=_estado);

IF _rolmoduloduplicado IS NULL THEN
	
	UPDATE rolmodulo
  SET 
	idrolmodulo=_idrolmodulo,
	idrol=_idrol,
	idmodulo=_idmodulo,
	fechaasignacion=_fechaasignacion,
	estado=_estado

 WHERE idrolmodulo=_idrolmodulo;


            _retorno = (select max(idrolmodulo) from rolmodulo)::integer;
--END IF;
		--;
ELSE
	_retorno=-1;
END IF;
	    RETURN _retorno;

END;

$$;


ALTER FUNCTION public.uspactualizarrolmodulo(_idrolmodulo integer, _idrol integer, _idmodulo integer, _fechaasignacion timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 350 (class 1255 OID 388801)
-- Dependencies: 9 816
-- Name: uspactualizartipodocumento(integer, integer, character varying, character varying, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizartipodocumento(_idtipodocumento integer, _idregla integer, _denominacion character varying, _descripcion character varying, _subida boolean, _igual boolean, _bajada boolean, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM tipodocumento WHERE idtipodocumento <> _idtipodocumento) THEN

	UPDATE tipodocumento
  SET 
	idtipodocumento=_idtipodocumento,
	idregla=_idregla,
	denominacion=_denominacion,
	descripcion=_descripcion,
	subida=_subida,
	igual=_igual,
	bajada=_bajada,
	estado=_estado

 WHERE idtipodocumento=_idtipodocumento;


            RETURN (select max(idtipodocumento) from tipodocumento)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizartipodocumento(_idtipodocumento integer, _idregla integer, _denominacion character varying, _descripcion character varying, _subida boolean, _igual boolean, _bajada boolean, _estado boolean) OWNER TO postgres;

--
-- TOC entry 370 (class 1255 OID 423510)
-- Dependencies: 816 9
-- Name: uspactualizartipoprocedimiento(integer, character varying, character varying, integer, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizartipoprocedimiento(_idtipoprocedimiento integer, _denominacion character varying, _descripcion character varying, _orden integer, _bindactual boolean, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM tipoprocedimiento WHERE idtipoprocedimiento <> _idtipoprocedimiento) THEN

	UPDATE tipoprocedimiento
  SET 
	idtipoprocedimiento=_idtipoprocedimiento,
	denominacion=_denominacion,
	descripcion=_descripcion,
	orden=_orden,
	bindactual=_bindactual,
	estado=_estado

 WHERE idtipoprocedimiento=_idtipoprocedimiento;


            RETURN (select max(idtipoprocedimiento) from tipoprocedimiento)::integer;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizartipoprocedimiento(_idtipoprocedimiento integer, _denominacion character varying, _descripcion character varying, _orden integer, _bindactual boolean, _estado boolean) OWNER TO postgres;

--
-- TOC entry 333 (class 1255 OID 139453)
-- Dependencies: 9 816
-- Name: uspactualizarusuario(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarusuario(_idusuario integer, _nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _usuarioduplicado INTEGER;
DECLARE _retorno INTEGER;
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuario WHERE idusuario <> _idusuario) THEN
_usuarioduplicado =(select max(idusuario) from usuario where (dni=_dni or usuario=_usuario or password=_password) and estado=true and idusuario <> _idusuario);

IF _usuarioduplicado IS NULL THEN

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

          _retorno =(select max(idusuario) from usuario)::integer;

 ELSE 
	_retorno=-1;
 END IF;

	RETURN _retorno;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarusuario(_idusuario integer, _nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 382 (class 1255 OID 459016)
-- Dependencies: 9 816
-- Name: uspactualizarusuario(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarusuario(_idusuario integer, _nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean, _foto text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _usuarioduplicado INTEGER;
DECLARE _retorno INTEGER;
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuario WHERE idusuario <> _idusuario) THEN
_usuarioduplicado =null;--(select max(idusuario) from usuario where (dni=_dni or usuario=_usuario or password=_password) and estado=true and idusuario <> _idusuario);

IF _usuarioduplicado IS NULL THEN

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
	estado=_estado,
	foto=_foto
	

 WHERE idusuario=_idusuario;

          _retorno =(select max(idusuario) from usuario)::integer;

 ELSE 
	_retorno=-1;
 END IF;

	RETURN _retorno;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspactualizarusuario(_idusuario integer, _nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean, _foto text) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 139454)
-- Dependencies: 816 9
-- Name: uspactualizarusuariocargo(integer, integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarusuariocargo(_idusuariocargo integer, _idusuario integer, _idcargo integer, _fechaasignado timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspactualizarusuariocargo(_idusuariocargo integer, _idusuario integer, _idcargo integer, _fechaasignado timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 139455)
-- Dependencies: 9 816
-- Name: uspactualizarusuariorol(integer, integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspactualizarusuariorol(_idusuariorol integer, _idusuario integer, _idrol integer, _fechaasignacion timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _usuarioduplicado INTEGER;
DECLARE _retorno INTEGER;
BEGIN	
--IF  EXISTS (SELECT 1 FROM usuariorol WHERE idusuariorol <> _idusuariorol) THEN
	_usuarioduplicado =(select max(idusuariorol) from usuariorol where idrol=_idrol and idusuario=_idusuario and estado=_estado);

IF _usuarioduplicado IS NULL THEN

	UPDATE usuariorol
  SET 
	idusuariorol=_idusuariorol,
	idusuario=_idusuario,
	idrol=_idrol,
	fechaasignacion=_fechaasignacion,
	estado=_estado

 WHERE idusuariorol=_idusuariorol;

            _retorno =(select max(idusuariorol) from usuariorol)::integer;
--END IF;
		--;
ELSE 
	_retorno=-1;
END IF;

	RETURN _retorno;
END;

$$;


ALTER FUNCTION public.uspactualizarusuariorol(_idusuariorol integer, _idusuario integer, _idrol integer, _fechaasignacion timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 325 (class 1255 OID 188766)
-- Dependencies: 816 9
-- Name: uspcambiarestadoflujo(bigint, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspcambiarestadoflujo(_idflujo bigint, _idestadoflujo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM flujo WHERE idflujo <> _idflujo) THEN

UPDATE flujo
SET 
idestadoflujo=_idestadoflujo
WHERE idflujo=_idflujo;
RETURN _idflujo;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspcambiarestadoflujo(_idflujo bigint, _idestadoflujo integer) OWNER TO postgres;

--
-- TOC entry 331 (class 1255 OID 188962)
-- Dependencies: 9 816
-- Name: uspcambiarestadoflujo(bigint, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspcambiarestadoflujo(_idflujo bigint, _idestadoflujo integer, _observacion text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idestadoflujo_actual integer;
DECLARE _bindatendido boolean;
DECLARE _bindestadofinalizado boolean;
BEGIN	

_idestadoflujo_actual=(select idestadoflujo from flujo where idflujo=_idflujo);
_bindatendido=(select bindatendido from flujo where idflujo=_idflujo);
_bindestadofinalizado=(select bindfinal from estadoflujo where idestadoflujo=_idestadoflujo_actual);

if(_bindestadofinalizado=true)
then 
_idflujo=-1;
else

UPDATE flujo
SET 
idestadoflujo=_idestadoflujo,
cuerporespuesta=_observacion,
bindatendido=true,
fecharesolucion=now()
WHERE idflujo=_idflujo;

end if;



RETURN _idflujo;

END;

$$;


ALTER FUNCTION public.uspcambiarestadoflujo(_idflujo bigint, _idestadoflujo integer, _observacion text) OWNER TO postgres;

--
-- TOC entry 373 (class 1255 OID 431461)
-- Dependencies: 816 9
-- Name: uspcambiarestadoflujo(bigint, integer, text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspcambiarestadoflujo(_idflujo bigint, _idestadoflujo integer, _observacion text, _idusuario integer, _idarea integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idestadoflujo_actual integer;
DECLARE _bindatendido boolean;
DECLARE _bindestadofinalizado boolean;
DECLARE _idevento bigint;
DECLARE _idexpediente bigint;
DECLARE _estadoflujo character varying(200);
DECLARE _codigo character varying(500);
DECLARE _arearecepciona character varying(200);
DECLARE _usuariorecepciona character varying(100);
DECLARE _fecrecepciona timestamp without time zone;
DECLARE _diasferiado double precision;
DECLARE _diastranscurrido double precision;
DECLARE _horastranscurrido double precision;
DECLARE _diasatencion double precision;
BEGIN	

	_idestadoflujo_actual=(select idestadoflujo from flujo where idflujo=_idflujo);
	_bindatendido=(select bindatendido from flujo where idflujo=_idflujo);
	_bindestadofinalizado=(select bindfinal from estadoflujo where idestadoflujo=_idestadoflujo_actual);

	if(_bindestadofinalizado=true)
	then 
	_idflujo=-1;
	else

	UPDATE flujo
	SET 
	idestadoflujo=_idestadoflujo,
	cuerporespuesta=_observacion,
	bindatendido=true,
	fecharesolucion=now()
	WHERE idflujo=_idflujo;

	/*Actualizacion y Registro de evento*/
	_idexpediente = (select idexpediente from flujo where idflujo=_idflujo);
	_estadoflujo = (select denominacion from estadoflujo where idestadoflujo=_idestadoflujo and estado=true);
	_codigo = (select codigo from expediente where idexpediente=_idexpediente);
	_arearecepciona = (select denominacion from area where idarea=_idarea);
	_usuariorecepciona = (select usuario from usuario where idusuario=_idusuario);
	_fecrecepciona = (select fecharecepciona from evento where idexpediente=_idexpediente and idareadestino is null);
	_diasferiado = (select count(*) from feriado where fecha between _fecrecepciona and NOW());
	_diastranscurrido = (select extract(days from (NOW() - _fecrecepciona)));
	_horastranscurrido = (select extract(hour from (NOW() - _fecrecepciona)));
	_diasatencion = (select(_diastranscurrido-_diasferiado::decimal+_horastranscurrido/24::decimal)::double precision);
	
	--Actualizacion de Evento
	UPDATE evento
		SET 
		idareadestino=_idarea,
		idusuariodestino=_idusuario,
		areadestino=_arearecepciona,
		usuariodestino=_usuariorecepciona,
		diasatencion=_diasatencion,
		fechadestino= NOW()
		WHERE idexpediente=_idexpediente and idareadestino is null;
	--Fin Actualizacion de Evento

	--Registro de Evento
	_idevento=(select max(idevento) from evento)::integer;
	_idevento=_idevento+1;
	if(_idevento is null) then
	_idevento=1;
	end if;

	INSERT INTO evento(
	idevento, iddocumento, idexpediente, idarearecepciona, idareadestino, 
	idusuariorecepciona, idusuariodestino, estadoevento, denominacion,
	codigo, arearecepciona, areadestino, usuariorecepciona, usuariodestino,
	diasatencion, fecharecepciona, fechadestino, estado) 
	VALUES (_idevento, null, _idexpediente, _idarea, null,
		_idusuario, null, _estadoflujo, _estadoflujo,
		_codigo, _arearecepciona, null, _usuariorecepciona, null,
		0, now(), null, true);
	--Fin Registro de Evento

	/*Fin de Actualizacion y Registro de Evento*/

	end if;

	RETURN _idflujo;

END;

$$;


ALTER FUNCTION public.uspcambiarestadoflujo(_idflujo bigint, _idestadoflujo integer, _observacion text, _idusuario integer, _idarea integer) OWNER TO postgres;

--
-- TOC entry 380 (class 1255 OID 450270)
-- Dependencies: 816 9
-- Name: uspcrearmensaje(bigint, character varying, text, integer, boolean, boolean, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspcrearmensaje(_idexpediente bigint, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _bindrecepcion boolean, _diasrespuesta integer, _idareacioncreacion integer, _idusuariocreacion integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idmensaje integer;

BEGIN	
	_idmensaje =(select max(idmensaje) from mensaje)::integer;
	_idmensaje=_idmensaje+1;
	if(_idmensaje is null) then
	_idmensaje=1;
	end if;	
	

INSERT INTO mensaje(
            idexpediente,idmensaje, asunto, mensaje, prioridad, bindrespuesta,bindrecepcion, diasrespuesta, 
            idareacioncreacion, idusuariocreacion, fechacreacion, estado)
    VALUES (_idexpediente, _idmensaje, _asunto, _mensaje, _prioridad, _bindrespuesta,_bindrecepcion, _diasrespuesta, 
            _idareacioncreacion, _idusuariocreacion, now(), true);



    
		RETURN _idmensaje;

END;

$$;


ALTER FUNCTION public.uspcrearmensaje(_idexpediente bigint, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _bindrecepcion boolean, _diasrespuesta integer, _idareacioncreacion integer, _idusuariocreacion integer) OWNER TO postgres;

--
-- TOC entry 346 (class 1255 OID 380424)
-- Dependencies: 816 9
-- Name: uspderivardocumento(integer, character varying, text, integer, boolean, integer, boolean, integer, integer, timestamp without time zone, bigint, bigint, boolean, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspderivardocumento(_tipodocumento integer, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _diasrespuesta integer, _bindllegadausuario boolean, _idareacioncreacion integer, _idusuariocreacion integer, _fechacreacion timestamp without time zone, _idexpediente bigint, _codigoexpediente bigint, _estado boolean, _codigo_doc character varying, _idarea_destino integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _iddocumento integer;
DECLARE _idrecepcioninterna integer;
DECLARE _idareatipodocumento integer;
DECLARE _codigo integer;

DECLARE _retorno integer;
BEGIN
_iddocumento = (select max(iddocumento) from documento)::integer;
_iddocumento = _iddocumento + 1;
if (_iddocumento is null) then
_iddocumento = 1;
end
if;
INSERT INTO documento(
    iddocumento, tipodocumento, asunto,codigo, mensaje, prioridad, bindrespuesta, diasrespuesta, bindllegadausuario,
    idareacioncreacion, idusuariocreacion, fechacreacion, idexpediente, codigoexpediente, estado)
VALUES(_iddocumento, _tipodocumento, _asunto,_codigo_doc, _mensaje, _prioridad, _bindrespuesta, _diasrespuesta, _bindllegadausuario,
    _idareacioncreacion, _idusuariocreacion, _fechacreacion, _idexpediente, _codigoexpediente, _estado);

--Insertando a recepcion interna
_idrecepcioninterna = (select max(idrecepcioninterna) from recepcioninterna)::integer;
_idrecepcioninterna = _idrecepcioninterna + 1;
if (_idrecepcioninterna is null) then
_idrecepcioninterna = 1;
end if;

INSERT INTO recepcioninterna(
    idrecepcioninterna, idexpediente, iddocumento, idarea_destino,
    idarea_proviene, idusuariorecepciona, idusuarioenvia, idrecepcion_proviene,
    bindentregado, fecharecepcion, bindderivado, bindprimero, fechaderivacion,
    observacion, estado)

VALUES(_idrecepcioninterna, _idexpediente, _iddocumento, _idarea_destino,
    /*_idarea_proviene*/_idareacioncreacion, /*_idusuariorecepciona*/null, /*_idusuarioenvia*/_idusuariocreacion, /*_idrecepcion_proviene*/null,
    /*_bindentregado*/ false,/* _fecharecepcion*/now(), /*_bindderivado*/false, /*_bindprimero*/true, /*_fechaderivacion*/now(),
    /*_observacion*/'', /*_estado*/true);

--Fin de insercion a recepcion interna

--Insertando a areatipodocumento
_idareatipodocumento = (select max(idareatipodocumento) from areatipodocumento)::integer;
_idareatipodocumento = _idareatipodocumento + 1;
if (_idareatipodocumento is null) then
_idareatipodocumento = 1;
end if;
/*obteniendo */
_codigo=(select max(cast(codigo as integer)) from areatipodocumento where idtipodocumento=_tipodocumento and idarea=_idareacioncreacion and idusuario=_idusuariocreacion);
if (_codigo is null) then
_codigo = 1;
end if;

INSERT INTO areatipodocumento(
idareatipodocumento, idtipodocumento, idarea, idusuario, codigo, 
estado)
VALUES (_idareatipodocumento, _tipodocumento, _idareacioncreacion, _idusuariocreacion, (_codigo+1), 
true);

--==========Actualizando el flujo a enviados================
UPDATE flujo
SET idestadoflujo=4
WHERE idexpediente=_idexpediente;



RETURN _iddocumento;
END;
$$;


ALTER FUNCTION public.uspderivardocumento(_tipodocumento integer, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _diasrespuesta integer, _bindllegadausuario boolean, _idareacioncreacion integer, _idusuariocreacion integer, _fechacreacion timestamp without time zone, _idexpediente bigint, _codigoexpediente bigint, _estado boolean, _codigo_doc character varying, _idarea_destino integer) OWNER TO postgres;

--
-- TOC entry 334 (class 1255 OID 279255)
-- Dependencies: 816 9
-- Name: uspderivarexpediente(bigint, integer, integer, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspderivarexpediente(_idrecepcion bigint, _idarea integer, _idprocedimiento integer, _observacion text, _idarea_proviene integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idexpediente bigint;
DECLARE _idrecepcion_insert bigint;
BEGIN

UPDATE recepcion
SET 
    bindentregado = false, fecharecepcion = null, bindderivado = true, 
    fechaderivacion = now(), observacion = _observacion,
    idprocedimiento = _idprocedimiento
WHERE idrecepcion=_idrecepcion;


_idrecepcion_insert = (select max(idrecepcion) from recepcion)::integer;
_idrecepcion_insert = _idrecepcion + 1;
if (_idrecepcion_insert is null) then
_idrecepcion_insert = 1;
end
if;

INSERT INTO recepcion(
idrecepcion, idexpediente, idarea,idarea_proviene,idusuariorecepciona, bindentregado,
fecharecepcion, bindderivado, bindprimero, fechaderivacion, estado, idprocedimiento)
select _idrecepcion_insert, idexpediente, _idarea,_idarea_proviene,null, false,
null, false, false, null, true, _idprocedimiento
from recepcion
where idrecepcion = _idrecepcion;

return _idrecepcion_insert;

END;
$$;


ALTER FUNCTION public.uspderivarexpediente(_idrecepcion bigint, _idarea integer, _idprocedimiento integer, _observacion text, _idarea_proviene integer) OWNER TO postgres;

--
-- TOC entry 363 (class 1255 OID 447804)
-- Dependencies: 816 9
-- Name: uspderivarexpediente_area(bigint, integer, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspderivarexpediente_area(_idflujo bigint, _idusuario_deriva integer, _idarea_derivar integer, _idexpediente bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idflujo_new integer;
BEGIN	
	_idflujo_new =(select max(idflujo) from flujo)::integer;
	_idflujo_new=_idflujo_new+1;
	if(_idflujo_new is null) then
	_idflujo_new=1;
	end if;	

	INSERT INTO flujo(
	idflujo, idflujoparent, idexpediente, idestadoflujo, idusuario, 
	idusuarioenvia, idusuariorecepciona, bindparent, fechaenvio, 
	fechalectura, asunto, descripcion, observacion, binderror, bindicaleido, 
	idenvio, idrespuesta, titulorespuesta, cuerporespuesta, bindatendido, 
	estado, fecharesolucion, idarea)

	SELECT _idflujo_new idflujo,_idflujo idflujoparent,_idexpediente idexpediente,1 idestadoflujo,0 idusuario, 
	_idusuario_deriva idusuarioenvia,NULL idusuariorecepciona,false bindparent,now() fechaenvio, 
	null fechalectura,'DERIVADO' asunto,'DERIVADO AL AREA' descripcion,'DERIVADO' observacion,FALSE binderror,FALSE bindicaleido, 
	NULL idenvio, NULL idrespuesta,'' titulorespuesta,'' cuerporespuesta,FALSE bindatendido, 
	TRUE estado,NULL fecharesolucion,_idarea_derivar idarea
	FROM flujo
	WHERE idflujo=_idflujo;



        RETURN _idflujo_new;
END;
$$;


ALTER FUNCTION public.uspderivarexpediente_area(_idflujo bigint, _idusuario_deriva integer, _idarea_derivar integer, _idexpediente bigint) OWNER TO postgres;

--
-- TOC entry 324 (class 1255 OID 188648)
-- Dependencies: 9 816
-- Name: uspderivarflujo(bigint, bigint, integer, integer, integer, integer, character varying, text, text, boolean, boolean, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspderivarflujo(_idflujoparent bigint, _idexpediente bigint, _idestadoflujo integer, _idusuario integer, _idusuarioenvia integer, _idusuariorecepciona integer, _asunto character varying, _descripcion text, _observacion text, _binderror boolean, _estado boolean, _idenvio bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idflujo integer;

BEGIN	
	_idflujo =(select max(idflujo) from flujo)::integer;
	_idflujo=_idflujo+1;
	if(_idflujo is null) then
	_idflujo=1;
	end if;	
	INSERT INTO flujo(

	idflujo,
	idflujoparent,
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
	estado,
	idenvio,
	bindatendido,
	bindparent )

 VALUES (	
	_idflujo,
	_idflujoparent,
	_idexpediente,
	_idestadoflujo,
	_idusuario,
	_idusuarioenvia,
	_idusuariorecepciona,
	now(),
	null,
	_asunto,
	_descripcion,
	_observacion,
	_binderror,
	_estado ,
	_idenvio,
	false,false
	);

        RETURN _idflujo;

			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspderivarflujo(_idflujoparent bigint, _idexpediente bigint, _idestadoflujo integer, _idusuario integer, _idusuarioenvia integer, _idusuariorecepciona integer, _asunto character varying, _descripcion text, _observacion text, _binderror boolean, _estado boolean, _idenvio bigint) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 139456)
-- Dependencies: 9 816
-- Name: uspeliminaranio(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminaranio(_idanio integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminaranio(_idanio integer) OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 188589)
-- Dependencies: 816 9
-- Name: uspeliminararchivo(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminararchivo(_idarchivo bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM archivo WHERE idarchivo <> _idarchivo) THEN

	UPDATE archivo
  SET 
estado=false

 WHERE idarchivo=_idarchivo;


            RETURN _idarchivo;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminararchivo(_idarchivo bigint) OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 303875)
-- Dependencies: 816 9
-- Name: uspeliminararchivodocumento(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminararchivodocumento(_idarchivodocumento bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM archivodocumento WHERE idarchivodocumento <> _idarchivodocumento) THEN

	UPDATE archivodocumento
  SET 
estado=false

 WHERE idarchivodocumento=_idarchivodocumento;


            RETURN _idarchivodocumento;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminararchivodocumento(_idarchivodocumento bigint) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 139457)
-- Dependencies: 9 816
-- Name: uspeliminararea(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminararea(_idarea integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminararea(_idarea integer) OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 303876)
-- Dependencies: 9 816
-- Name: uspeliminarbandeja(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarbandeja(_idbandeja bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM bandeja WHERE idbandeja <> _idbandeja) THEN

	UPDATE bandeja
  SET 
estado=false

 WHERE idbandeja=_idbandeja;


            RETURN _idbandeja;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminarbandeja(_idbandeja bigint) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 139458)
-- Dependencies: 816 9
-- Name: uspeliminarcargo(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarcargo(_idcargo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarcargo(_idcargo integer) OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 303877)
-- Dependencies: 9 816
-- Name: uspeliminardocumento(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminardocumento(_iddocumento bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM documento WHERE iddocumento <> _iddocumento) THEN

	UPDATE documento
  SET 
estado=false

 WHERE iddocumento=_iddocumento;


            RETURN _iddocumento;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminardocumento(_iddocumento bigint) OWNER TO postgres;

--
-- TOC entry 317 (class 1255 OID 188597)
-- Dependencies: 816 9
-- Name: uspeliminarenvio(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarenvio(_idenvio bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM envio WHERE idenvio <> _idenvio) THEN

	UPDATE envio
  SET 
estado=false

 WHERE idenvio=_idenvio;


            RETURN _idenvio;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminarenvio(_idenvio bigint) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 139459)
-- Dependencies: 9 816
-- Name: uspeliminarestadoflujo(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarestadoflujo(_idestadoflujo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarestadoflujo(_idestadoflujo integer) OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 139460)
-- Dependencies: 816 9
-- Name: uspeliminarexpediente(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarexpediente(_idexpediente bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expediente WHERE idexpediente <> _idexpediente) THEN

	UPDATE expediente
  SET 
estado=false

 WHERE idexpediente=_idexpediente;

INSERT INTO hexpediente(
	idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado, 
	accion)
	SELECT idexpediente, _idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado,'ELIMINAR'
	FROM expediente
	WHERE idexpediente=_idexpediente;


            RETURN _idexpediente;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminarexpediente(_idexpediente bigint) OWNER TO postgres;

--
-- TOC entry 365 (class 1255 OID 414972)
-- Dependencies: 9 816
-- Name: uspeliminarexpediente(bigint, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarexpediente(_idexpediente bigint, _idusuariocargo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expediente WHERE idexpediente <> _idexpediente) THEN

	UPDATE expediente
  SET 
estado=false

 WHERE idexpediente=_idexpediente;

INSERT INTO hexpediente(
	idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado, 
	accion)
	SELECT idexpediente, _idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, now(), bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado,'ELIMINAR'
	FROM expediente
	WHERE idexpediente=_idexpediente;


            RETURN _idexpediente;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminarexpediente(_idexpediente bigint, _idusuariocargo integer) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 139461)
-- Dependencies: 816 9
-- Name: uspeliminarexpedienterequisito(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarexpedienterequisito(_idexpedienterequisito bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM expedienterequisito WHERE idexpedienterequisito <> _idexpedienterequisito) THEN

	delete from expedienterequisito
 WHERE idexpedienterequisito=_idexpedienterequisito;


            RETURN _idexpedienterequisito;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminarexpedienterequisito(_idexpedienterequisito bigint) OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 139462)
-- Dependencies: 816 9
-- Name: uspeliminarferiado(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarferiado(_idferiado integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarferiado(_idferiado integer) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 139463)
-- Dependencies: 816 9
-- Name: uspeliminarflujo(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarflujo(_idflujo bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarflujo(_idflujo bigint) OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 139464)
-- Dependencies: 9 816
-- Name: uspeliminarmodulo(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarmodulo(_idmodulo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarmodulo(_idmodulo integer) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 139465)
-- Dependencies: 816 9
-- Name: uspeliminarprocedimiento(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarprocedimiento(_idprocedimiento integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarprocedimiento(_idprocedimiento integer) OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 303878)
-- Dependencies: 9 816
-- Name: uspeliminarreferencia(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarreferencia(_idreferencia bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM referencia WHERE idreferencia <> _idreferencia) THEN

	UPDATE referencia
  SET 
estado=false

 WHERE idreferencia=_idreferencia;


            RETURN _idreferencia;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminarreferencia(_idreferencia bigint) OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 303879)
-- Dependencies: 9 816
-- Name: uspeliminarregla(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarregla(_idregla integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM regla WHERE idregla <> _idregla) THEN

	UPDATE regla
  SET 
estado=false

 WHERE idregla=_idregla;


            RETURN _idregla;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminarregla(_idregla integer) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 139466)
-- Dependencies: 9 816
-- Name: uspeliminarrequisitos(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarrequisitos(_idrequisitos integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarrequisitos(_idrequisitos integer) OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 139467)
-- Dependencies: 816 9
-- Name: uspeliminarrequisitosexpediente(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarrequisitosexpediente(_idexpediente bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
	delete from expedienterequisito where  idexpediente=_idexpediente;
	return _idexpediente;
END;
$$;


ALTER FUNCTION public.uspeliminarrequisitosexpediente(_idexpediente bigint) OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 139468)
-- Dependencies: 816 9
-- Name: uspeliminarrol(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarrol(_idrol integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarrol(_idrol integer) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 139469)
-- Dependencies: 9 816
-- Name: uspeliminarrolmodulo(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarrolmodulo(_idrolmodulo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarrolmodulo(_idrolmodulo integer) OWNER TO postgres;

--
-- TOC entry 311 (class 1255 OID 303880)
-- Dependencies: 9 816
-- Name: uspeliminartipodocumento(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminartipodocumento(_idtipodocumento integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM tipodocumento WHERE idtipodocumento <> _idtipodocumento) THEN

	UPDATE tipodocumento
  SET 
estado=false

 WHERE idtipodocumento=_idtipodocumento;


            RETURN _idtipodocumento;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminartipodocumento(_idtipodocumento integer) OWNER TO postgres;

--
-- TOC entry 369 (class 1255 OID 423509)
-- Dependencies: 9 816
-- Name: uspeliminartipoprocedimiento(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminartipoprocedimiento(_idtipoprocedimiento integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
--IF  EXISTS (SELECT 1 FROM tipoprocedimiento WHERE idtipoprocedimiento <> _idtipoprocedimiento) THEN

	UPDATE tipoprocedimiento
  SET 
estado=false

 WHERE idtipoprocedimiento=_idtipoprocedimiento;


            RETURN _idtipoprocedimiento;
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspeliminartipoprocedimiento(_idtipoprocedimiento integer) OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 139470)
-- Dependencies: 816 9
-- Name: uspeliminarusuario(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarusuario(_idusuario integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarusuario(_idusuario integer) OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 139471)
-- Dependencies: 9 816
-- Name: uspeliminarusuariocargo(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarusuariocargo(_idusuariocargo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarusuariocargo(_idusuariocargo integer) OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 139472)
-- Dependencies: 9 816
-- Name: uspeliminarusuariorol(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspeliminarusuariorol(_idusuariorol integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspeliminarusuariorol(_idusuariorol integer) OWNER TO postgres;

--
-- TOC entry 330 (class 1255 OID 379958)
-- Dependencies: 9 816
-- Name: uspentregadocumento(bigint, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspentregadocumento(_iddocumento bigint, _idusuariorecepciona integer, _idareadestino integer, _idareaproviene integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _retorno integer;
DECLARE _idbandeja bigint;
DECLARE _idusuariocargo integer;
BEGIN	

	_idusuariocargo=(select idusuario from usuariocargo where idcargo=(select idcargo from cargo where idarea=_idarea and bindjefe=true limit 1 ));

	if(_idusuariocargo=0) then 
		_retorno=-1;
	else
	
		UPDATE recepcioninterna
		SET 
		bindentregado=true,
		idusuariorecepciona=_idusuariorecepciona,
		fecharecepcion= NOW()
		WHERE iddocumento=_iddocumento;


		_idbandeja =(select max(idbandeja) from bandeja)::integer;
		_idbandeja=_idbandeja+1;
		if(_idbandeja is null) then
		_idbandeja=1;
		end if;	


		INSERT INTO bandeja(
            idbandeja, iddocumento, idareaproviene, idareadestino, idusuarioenvia, 
            idusuariodestino, bindrecepcion, idusuariorecepciona, fecharecepciona, 
            fechalectura, fechaderivacion, fecharegistro, estado)
		VALUES (  _idbandeja, _iddocumento, _idareaproviene, _idareadestino, _idusuarioenvia, 
            _idusuariocargo, null, _idusuariorecepciona, now(), 
            null, _fechaderivacion, now(), true);

		_retorno=1;

	end if;

	RETURN _retorno;

END;

$$;


ALTER FUNCTION public.uspentregadocumento(_iddocumento bigint, _idusuariorecepciona integer, _idareadestino integer, _idareaproviene integer) OWNER TO postgres;

--
-- TOC entry 329 (class 1255 OID 379959)
-- Dependencies: 816 9
-- Name: uspentregadocumento(bigint, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspentregadocumento(_iddocumento bigint, _idusuarioenvia integer, _idusuariorecepciona integer, _idareadestino integer, _idareaproviene integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _retorno integer;
DECLARE _idbandeja bigint;
DECLARE _idusuariocargo integer;
BEGIN	

	_idusuariocargo=(select idusuario from usuariocargo where idcargo=(select idcargo from cargo where idarea=2 and bindjefe=true and estado=true limit 1 ) and estado=true);

	if(_idusuariocargo=0) then 
		_retorno=-1;
	else
	
		UPDATE recepcioninterna
		SET 
		bindentregado=true,
		idusuariorecepciona=_idusuariorecepciona,
		fechaderivacion= NOW()
		WHERE iddocumento=_iddocumento;


		_idbandeja =(select max(idbandeja) from bandeja)::integer;
		_idbandeja=_idbandeja+1;
		if(_idbandeja is null) then
		_idbandeja=1;
		end if;	


		INSERT INTO bandeja(
		idbandeja, iddocumento, idareaproviene, idareadestino, idusuarioenvia, 
		idusuariodestino, bindrecepcion, idusuariorecepciona, fecharecepciona, 
		fechalectura, fechaderivacion, fecharegistro, estado)
		VALUES (  _idbandeja, _iddocumento, _idareaproviene, _idareadestino, _idusuarioenvia, 
		_idusuariocargo, null, _idusuariorecepciona, now(), 
		null, now(), now(), true);

		_retorno=1;

	end if;

	RETURN _retorno;

END;

$$;


ALTER FUNCTION public.uspentregadocumento(_iddocumento bigint, _idusuarioenvia integer, _idusuariorecepciona integer, _idareadestino integer, _idareaproviene integer) OWNER TO postgres;

--
-- TOC entry 357 (class 1255 OID 412532)
-- Dependencies: 9 816
-- Name: uspentregadocumento(bigint, bigint, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspentregadocumento(_idrecepcioninterna bigint, _idmensaje bigint, _idusuarioenvia integer, _idusuariorecepciona integer, _idareadestino integer, _idareaproviene integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _retorno integer;
DECLARE _idbandeja bigint;
DECLARE _idusuariocargo integer;
BEGIN	

	_idusuariocargo=(select idusuario from usuariocargo where idcargo=(select idcargo from cargo where idarea=2 and bindjefe=true and estado=true limit 1 ) and estado=true);

	if(_idusuariocargo=0) then 
		_retorno=-1;
	else
	
		UPDATE recepcioninterna
		SET 
		bindentregado=true,
		idusuariorecepciona=_idusuariorecepciona,
		fechaderivacion= NOW()
		WHERE idrecepcioninterna=_idrecepcioninterna;

		UPDATE bandeja
		SET  bindrecepcion=true, 
		idusuariorecepciona=_idusuariorecepciona,fecharecepciona=now()
	
		WHERE idareadestino=_idareadestino
		and idmensaje=_idmensaje;



		_retorno=1;

	end if;

	RETURN _retorno;

END;

$$;


ALTER FUNCTION public.uspentregadocumento(_idrecepcioninterna bigint, _idmensaje bigint, _idusuarioenvia integer, _idusuariorecepciona integer, _idareadestino integer, _idareaproviene integer) OWNER TO postgres;

--
-- TOC entry 375 (class 1255 OID 431373)
-- Dependencies: 816 9
-- Name: uspentregaexpediente(bigint, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspentregaexpediente(_idexpediente bigint, _idusuariorecepciona integer, _idarearecepciona integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _retorno integer;
DECLARE _idflujo bigint;
DECLARE _idexpediente_ins bigint;
DECLARE _idusuariocargo integer;
DECLARE _codigo bigint;
DECLARE _idevento bigint;
DECLARE _arearecepciona character varying(200);
DECLARE _usuariorecepciona character varying(100);
DECLARE _fecregexpediente timestamp without time zone;
DECLARE _diasferiado double precision;
DECLARE _diastranscurrido double precision;
DECLARE _horastranscurrido double precision;
DECLARE _diasatencion double precision;
BEGIN	

	_idusuariocargo=(select case when c.idusuario is null then 0 else c.idusuario end   from recepcion a 
	inner join procedimiento b on a.idprocedimiento=b.idprocedimiento
	left join usuariocargo c on b.idcargoresolutor=c.idcargo
	where idrecepcion=_idexpediente
	and a.estado=true
	and b.estado=true
	and c.estado=true);

	_idexpediente_ins=(select idexpediente from recepcion where idrecepcion=_idexpediente and estado=true);

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

		/*Actualización y Registro de Eventos*/
		
		_fecregexpediente = (select fecharegistro from expediente where idexpediente=_idexpediente_ins);
		_diasferiado = (select count(*) from feriado where fecha between _fecregexpediente and NOW());
		_diastranscurrido = (select extract(days from (NOW() - _fecregexpediente)));
		_horastranscurrido = (select extract(hour from (NOW() - _fecregexpediente)));
		_diasatencion = (select(_diastranscurrido-_diasferiado::decimal+_horastranscurrido/24::decimal)::double precision);
--		_diasatencion = (select (round(_diastranscurrido-_diasferiado::decimal+_horastranscurrido/24::decimal)::TEXT)::double precision);
		_codigo = (select codigo from expediente where idexpediente=_idexpediente_ins);
		_arearecepciona = (select denominacion from area where idarea=_idarearecepciona);
		_usuariorecepciona = (select usuario from usuario where idusuario=_idusuariorecepciona);

		--Actualizacion de Evento
		UPDATE evento
		SET 
		idareadestino=_idarearecepciona,
		idusuariodestino=_idusuariorecepciona,
		areadestino=_arearecepciona,
		usuariodestino=_usuariorecepciona,
		diasatencion=_diasatencion,
		fechadestino= NOW()
		WHERE idexpediente=_idexpediente_ins;
		--Fin Actualizacion de Evento

		--Registro de Evento
		_idevento=(select max(idevento) from evento)::integer;
		_idevento=_idevento+1;
		if(_idevento is null) then
		_idevento=1;
		end if;

		INSERT INTO evento(
		idevento, iddocumento, idexpediente, idarearecepciona, idareadestino, 
		idusuariorecepciona, idusuariodestino, estadoevento, denominacion,
		codigo, arearecepciona, areadestino, usuariorecepciona, usuariodestino,
		diasatencion, fecharecepciona, fechadestino, estado) 
		VALUES (_idevento, null, _idexpediente_ins, _idarearecepciona, null,
			_idusuariorecepciona, null, 'RECEPCIONADO','RECEPCION',
			_codigo, _arearecepciona, null, _usuariorecepciona, null,
			0, now(), null, true);
		--Fin Registro de Evento

		/*fin de Registro y Actualización de ESventos*/

		_idflujo =(select max(idflujo) from flujo)::integer;
		_idflujo=_idflujo+1;
		if(_idflujo is null) then
		_idflujo=1;
		end if;	


		INSERT INTO flujo(
		idflujo, idexpediente, idestadoflujo, idusuario, idusuarioenvia, 
		idusuariorecepciona,bindparent, fechaenvio, fechalectura, asunto, descripcion, 
		observacion, binderror, bindicaleido, estado,idarea)

		VALUES (_idflujo, _idexpediente_ins,1 ,_idusuariorecepciona, _idusuariorecepciona
		,_idusuariocargo,true, now(), null,  'RECEPCION', 'ENVIO AL JEFE DEL AREA PARA LA ATENCION PERTINENTE'
		, 'ENVIO AL JEFE' , FALSE, FALSE, true,_idarearecepciona);
		_retorno=1;

	end if;

	RETURN _retorno;

END;

$$;


ALTER FUNCTION public.uspentregaexpediente(_idexpediente bigint, _idusuariorecepciona integer, _idarearecepciona integer) OWNER TO postgres;

--
-- TOC entry 343 (class 1255 OID 328505)
-- Dependencies: 9 816
-- Name: uspgenerarcodigodocumento(integer, integer, integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspgenerarcodigodocumento(_idtipodocumento integer, _idarea integer, _idusuario integer, _idcargo integer, _firma boolean) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE _retorno character varying(250);
DECLARE _nombretipodocumento character varying(250);
DECLARE _areasuperior character varying(3);
DECLARE _areasolicitante character varying(3);
DECLARE _numerodocumento integer;
DECLARE _esjefe boolean;
DECLARE _abreviaturacargo character varying(15);
DECLARE _iniciales character varying(8);

BEGIN
	_nombretipodocumento = (select denominacion from tipodocumento where idtipodocumento=_idtipodocumento and estado=true);
	_areasuperior = (select a2.codigo from area a1 left join area a2 on a1.idareasuperior = a2.idarea where a1.idarea=_idarea and a1.estado = true and a2.estado = true);
	_areasolicitante = (select codigo from area where idarea=_idarea and estado=true);
	_numerodocumento = (select max(cast(codigo as integer)) from areatipodocumento where idtipodocumento=_idtipodocumento and idarea=_idarea and idusuario=_idusuario and extract(year from fecharegistro)=extract(year from now()));
	_esjefe = (select bindjefe from cargo where idcargo=_idcargo and idarea=_idarea and estado=true);

	if(_numerodocumento IS NULL) then
		_numerodocumento = 1;
	else
		_numerodocumento = _numerodocumento + 1;
	end if;

	if(_firma = true) then
		_retorno = _nombretipodocumento||' Nº'||(select to_char(_numerodocumento,'000'))||'-'||extract(year from now())||'-MPH-A/11.'||_areasolicitante;--11: codigo de Alcaldía

	elsif(_esjefe = false) then
		_abreviaturacargo = (select abreviatura from cargo where idcargo = _idcargo and estado=true);
		_iniciales = (select iniciales from usuario where idusuario=_idusuario and estado=true);
		_retorno = _nombretipodocumento||' Nº'||(select to_char(_numerodocumento,'000'))||'-'||extract(year from now())||'-MPH-A/'||_areasuperior||'.'||_areasolicitante||'-'||_abreviaturacargo||'-'||_iniciales;

	elsif(_areasuperior IS NULL) then
		_retorno = _nombretipodocumento||' Nº'||(select to_char(_numerodocumento,'000'))||'-'||extract(year from now())||'-MPH-A/'||_areasolicitante||'.';

	else
		_retorno = _nombretipodocumento||' Nº'||(select to_char(_numerodocumento,'000'))||'-'||extract(year from now())||'-MPH-A/'||_areasuperior||'.'||_areasolicitante;
	end if;

	RETURN _retorno;
	
END

$$;


ALTER FUNCTION public.uspgenerarcodigodocumento(_idtipodocumento integer, _idarea integer, _idusuario integer, _idcargo integer, _firma boolean) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 139474)
-- Dependencies: 816 9
-- Name: uspinsertaranio(character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertaranio(_denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idanio integer;
DECLARE _retorno integer;
DECLARE _indduplicado integer;
BEGIN	
	_indduplicado=(select max(idanio) from anio where denominacion=_denominacion and estado=true);


if _indduplicado is null then 

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

else
  _retorno=-1; --indica que existe ya un año registrado
end if;

    
		RETURN _retorno;
	--ELSE
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertaranio(_denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 320 (class 1255 OID 188599)
-- Dependencies: 9 816
-- Name: uspinsertararchivo(bigint, character varying, character varying, boolean, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertararchivo(_idflujo bigint, _denominacion character varying, _ruta character varying, _estado boolean, _idenvio bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idarchivo integer;

BEGIN	
	_idarchivo =(select max(idarchivo) from archivo)::integer;
	_idarchivo=_idarchivo+1;
	if(_idarchivo is null) then
	_idarchivo=1;
	end if;	
	INSERT INTO archivo(

	idarchivo,
	idflujo,
	denominacion,
	ruta,
	estado,idenvio )

 VALUES (	_idarchivo,
	_idflujo,
	_denominacion,
	_ruta,
	_estado,_idenvio );


		RETURN _idarchivo;
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertararchivo(_idflujo bigint, _denominacion character varying, _ruta character varying, _estado boolean, _idenvio bigint) OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 303881)
-- Dependencies: 9 816
-- Name: uspinsertararchivodocumento(bigint, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertararchivodocumento(_documento bigint, _codigo character varying, _nombre character varying, _url character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idarchivodocumento integer;
DECLARE _retorno integer;
BEGIN	
	_idarchivodocumento =(select max(idarchivodocumento) from archivodocumento)::integer;
	_idarchivodocumento=_idarchivodocumento+1;
	if(_idarchivodocumento is null) then
	_idarchivodocumento=1;
	end if;	
	INSERT INTO archivodocumento(

	idarchivodocumento,
	documento,
	codigo,
	nombre,
	url,
	estado )

 VALUES (	_idarchivodocumento,
	_documento,
	_codigo,
	_nombre,
	_url,
	_estado );


            _retorno =(select max(idarchivodocumento) from archivodocumento)::integer;
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

$$;


ALTER FUNCTION public.uspinsertararchivodocumento(_documento bigint, _codigo character varying, _nombre character varying, _url character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 348 (class 1255 OID 388758)
-- Dependencies: 816 9
-- Name: uspinsertararchivomensaje(bigint, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertararchivomensaje(_idmensaje bigint, _nombre character varying, _url character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idarchivomensaje bigint;

BEGIN	
	_idarchivomensaje =(select max(idarchivomensaje) from archivomensaje)::integer;
	_idarchivomensaje=_idarchivomensaje+1;

	if(_idarchivomensaje is null) then
	_idarchivomensaje=1;
	end if;	

	INSERT INTO archivomensaje(
            idarchivomensaje, idmensaje, nombre, url, estado)
    VALUES (_idarchivomensaje, _idmensaje, _nombre, _url, _estado);

		RETURN _idarchivomensaje;
	--ELSE

END;

$$;


ALTER FUNCTION public.uspinsertararchivomensaje(_idmensaje bigint, _nombre character varying, _url character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 358 (class 1255 OID 412782)
-- Dependencies: 816 9
-- Name: uspinsertararea(character varying, character varying, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertararea(_denominacion character varying, _abreviatura character varying, _codigo character varying, _idareasuperior integer, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idarea integer;
DECLARE _retorno integer;
DECLARE _areaduplicado integer;
BEGIN	
	_areaduplicado = (select max(idarea) from area where denominacion=_denominacion and estado=true);


if _areaduplicado is null then 
	
	_idarea =(select max(idarea) from area)::integer;
	_idarea=_idarea+1;
	if(_idarea is null) then
	_idarea=1;
	end if;	
	INSERT INTO area(

	idarea,
	denominacion,
	abreviatura,
	codigo,
	idareasuperior,
	estado )

 VALUES (	_idarea,
	_denominacion,
	_abreviatura,
	_codigo,
	_idareasuperior,
	_estado );


            _retorno =(select max(idarea) from area)::integer;

        else

        _retorno=-1;

        end if;

            
		RETURN _retorno;
	--ELSE
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertararea(_denominacion character varying, _abreviatura character varying, _codigo character varying, _idareasuperior integer, _estado boolean) OWNER TO postgres;

--
-- TOC entry 352 (class 1255 OID 388831)
-- Dependencies: 816 9
-- Name: uspinsertarbandeja(bigint, integer, integer, integer, integer, boolean, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarbandeja(_idmensaje bigint, _idareaproviene integer, _idareadestino integer, _idusuarioenvia integer, _idusuariodestino integer, _bindrecepcion boolean, _idusuariorecepciona integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idbandeja integer;

BEGIN	
	_idbandeja =(select max(idbandeja) from bandeja)::integer;
	_idbandeja=_idbandeja+1;
	if(_idbandeja is null) then
	_idbandeja=1;
	end if;	
	INSERT INTO bandeja(

	idbandeja,
	idmensaje,
	idareaproviene,
	idareadestino,
	idusuarioenvia,
	idusuariodestino,
	bindrecepcion,
bindleido,
	idusuariorecepciona,
	idestadobandeja,
	fecharecepciona,
	fechalectura,
	fechaderivacion,
	fecharegistro,
	estado )

 VALUES (	_idbandeja,
	_idmensaje,
	_idareaproviene,
	_idareadestino,
	_idusuarioenvia,
	_idusuariodestino,
	_bindrecepcion,
false,
	_idusuariorecepciona,
	null,
	null,
	null,
	null,
	now(),
	true );


		RETURN _idbandeja;

END;

$$;


ALTER FUNCTION public.uspinsertarbandeja(_idmensaje bigint, _idareaproviene integer, _idareadestino integer, _idusuarioenvia integer, _idusuariodestino integer, _bindrecepcion boolean, _idusuariorecepciona integer) OWNER TO postgres;

--
-- TOC entry 342 (class 1255 OID 303882)
-- Dependencies: 816 9
-- Name: uspinsertarbandeja(bigint, integer, integer, integer, integer, boolean, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarbandeja(_iddocumento bigint, _idareaproviene integer, _idareadestino integer, _idusuarioenvia integer, _idusuariodestino integer, _bindrecepcion boolean, _idusuariorecepciona integer, _fecharecepciona timestamp without time zone, _fechalectura timestamp without time zone, _fechaderivacion timestamp without time zone, _fecharegistro timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idbandeja integer;
DECLARE _retorno integer;
BEGIN	
	_idbandeja =(select max(idbandeja) from bandeja)::integer;
	_idbandeja=_idbandeja+1;
	if(_idbandeja is null) then
	_idbandeja=1;
	end if;	
	INSERT INTO bandeja(
	idbandeja,
	iddocumento,
	idareaproviene,
	idareadestino,
	idusuarioenvia,
	idusuariodestino,
	bindrecepcion,
	idusuariorecepciona,
	fecharecepciona,
	fechalectura,
	fechaderivacion,
	fecharegistro,
	estado )
 VALUES (_idbandeja,
	_iddocumento,
	_idareaproviene,
	_idareadestino,
	_idusuarioenvia,
	_idusuariodestino,
	_bindrecepcion,
	_idusuariorecepciona,
	_fecharecepciona,
	_fechalectura,
	_fechaderivacion,
	_fecharegistro,
	_estado);

	RETURN _idbandeja;

END;

$$;


ALTER FUNCTION public.uspinsertarbandeja(_iddocumento bigint, _idareaproviene integer, _idareadestino integer, _idusuarioenvia integer, _idusuariodestino integer, _bindrecepcion boolean, _idusuariorecepciona integer, _fecharecepciona timestamp without time zone, _fechalectura timestamp without time zone, _fechaderivacion timestamp without time zone, _fecharegistro timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 367 (class 1255 OID 415001)
-- Dependencies: 816 9
-- Name: uspinsertarcargo(integer, character varying, boolean, boolean, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarcargo(_idarea integer, _denominacion character varying, _estado boolean, _bindjefe boolean, _idcargoparent integer, _abreviatura character varying, _nivel integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
	idarea,
	denominacion,
	estado,
	bindjefe,
	idcargoparent,
	nivel,
	abreviatura )

 VALUES (	_idcargo,
	_idarea,
	_denominacion,
	_estado,
	_bindjefe,
	_idcargoparent,
	_nivel,
	_abreviatura );


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

$$;


ALTER FUNCTION public.uspinsertarcargo(_idarea integer, _denominacion character varying, _estado boolean, _bindjefe boolean, _idcargoparent integer, _abreviatura character varying, _nivel integer) OWNER TO postgres;

--
-- TOC entry 360 (class 1255 OID 380531)
-- Dependencies: 9 816
-- Name: uspinsertardocumento(integer, character varying, character varying, text, integer, boolean, integer, boolean, integer, integer, timestamp without time zone, bigint, bigint, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertardocumento(_idtipodocumento integer, _codigo character varying, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _diasrespuesta integer, _bindllegadausuario boolean, _idareacioncreacion integer, _idusuariocreacion integer, _fechacreacion timestamp without time zone, _idexpediente bigint, _codigoexpediente bigint, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _iddocumento integer;
DECLARE _idareatipodocumento bigint;
DECLARE _codigo_areatipo bigint;
DECLARE _retorno integer;
DECLARE _idevento bigint;
DECLARE _arearecepciona character varying(200);
DECLARE _usuariorecepciona character varying(100);
BEGIN	
	_iddocumento =(select max(iddocumento) from documento)::integer;
	_iddocumento=_iddocumento+1;
	if(_iddocumento is null) then
	_iddocumento=1;
	end if;	
	INSERT INTO documento(

	iddocumento,
	idtipodocumento,
	codigo,
	asunto,
	mensaje,
	prioridad,
	bindrespuesta,
	diasrespuesta,
	bindllegadausuario,
	idareacioncreacion,
	idusuariocreacion,
	fechacreacion,
	idexpediente,
	codigoexpediente,
	estado )

 VALUES (	_iddocumento,
	_idtipodocumento,
	_codigo,
	_asunto,
	_mensaje,
	_prioridad,
	_bindrespuesta,
	_diasrespuesta,
	_bindllegadausuario,
	_idareacioncreacion,
	_idusuariocreacion,
	now(),
	_idexpediente,
	_codigoexpediente,
	true );


	--Registro de areatipodocumento
	_idareatipodocumento = (select max(idareatipodocumento) from areatipodocumento)::integer;
	_idareatipodocumento = _idareatipodocumento + 1;
	if (_idareatipodocumento is null) then
	_idareatipodocumento = 1;
	end if;

	_codigo_areatipo=(select max(cast(codigo as integer)) from areatipodocumento where idtipodocumento=_idtipodocumento and idarea=_idareacioncreacion and idusuario=_idusuariocreacion);
	if (_codigo_areatipo is null) then
	_codigo_areatipo = 0;
	end if;

	INSERT INTO areatipodocumento(
	idareatipodocumento, idtipodocumento, idarea, idusuario, codigo, 
	estado)
	VALUES (_idareatipodocumento, _idtipodocumento, _idareacioncreacion, _idusuariocreacion, (_codigo_areatipo+1), 
	true);
	/*fin de registro de areatipodocumento*/

	RETURN _iddocumento;
	
END;

$$;


ALTER FUNCTION public.uspinsertardocumento(_idtipodocumento integer, _codigo character varying, _asunto character varying, _mensaje text, _prioridad integer, _bindrespuesta boolean, _diasrespuesta integer, _bindllegadausuario boolean, _idareacioncreacion integer, _idusuariocreacion integer, _fechacreacion timestamp without time zone, _idexpediente bigint, _codigoexpediente bigint, _estado boolean) OWNER TO postgres;

--
-- TOC entry 354 (class 1255 OID 388832)
-- Dependencies: 816 9
-- Name: uspinsertardocumentomensaje(bigint, bigint, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertardocumentomensaje(_idmensaje bigint, _iddocumento bigint, _idusuariocreacion integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _iddocumentomensaje integer;

BEGIN	
	_iddocumentomensaje =(select max(iddocumentomensaje) from documentomensaje)::integer;
	_iddocumentomensaje=_iddocumentomensaje+1;
	if(_iddocumentomensaje is null) then
	_iddocumentomensaje=1;
	end if;	
	INSERT INTO documentomensaje(

	iddocumentomensaje,
	idmensaje,
	iddocumento,
	fechacreacion,
	idusuariocreacion,
	estado )

 VALUES (	_iddocumentomensaje,
	_idmensaje,
	_iddocumento,
	now(),
	_idusuariocreacion,
	true );

	RETURN _iddocumentomensaje;
	
END;

$$;


ALTER FUNCTION public.uspinsertardocumentomensaje(_idmensaje bigint, _iddocumento bigint, _idusuariocreacion integer) OWNER TO postgres;

--
-- TOC entry 319 (class 1255 OID 188598)
-- Dependencies: 9 816
-- Name: uspinsertarenvio(integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarenvio(_idusuario integer, _fechaenvio timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idenvio integer;
DECLARE _retorno integer;
BEGIN	
	_idenvio =(select max(idenvio) from envio)::integer;
	_idenvio=_idenvio+1;
	if(_idenvio is null) then
	_idenvio=1;
	end if;	
	INSERT INTO envio(

	idenvio,
	idusuario,
	fechaenvio,
	estado )

 VALUES (	_idenvio,
	_idusuario,
	_fechaenvio,
	_estado );


            --_retorno =(select max(idenvio) from envio)::integer;
		RETURN _idenvio;
	--ELSE

			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarenvio(_idusuario integer, _fechaenvio timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 139477)
-- Dependencies: 816 9
-- Name: uspinsertarestadoflujo(character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarestadoflujo(_denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspinsertarestadoflujo(_denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 364 (class 1255 OID 414937)
-- Dependencies: 816 9
-- Name: uspinsertarexpediente(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarexpediente(_idusuariocargo integer, _idprocedimiento integer, _idarea integer, _codigo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _estado boolean, _bindentregado boolean, _bindobservado boolean, _folios integer, _nombredocumento character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
	bindobservado
	,nombredocumento
	,folios
	 )

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
	_bindobservado,
	_nombredocumento,
	_folios);


	INSERT INTO hexpediente(
	idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
	codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
	correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
	bindobservado, fecharecepciona, idusuariorecepciona, estado, 
	accion)
	VALUES (_idexpediente,_idusuariocargo,_idprocedimiento,_idarea,0
	,_codigogen,_dni_ruc,_nombre_razonsocial,_apellidos,_direccion,_telefono,
	_correo,_asunto,_nombredocumento,_folios,now(),null
	,null,null,0,true,'REGISTRO');



	/*registro de recepcion*/

	_idrecepcion =(select max(idrecepcion) from recepcion)::integer;
	_idrecepcion=_idrecepcion+1;
	if(_idrecepcion is null) then
	_idrecepcion=1;
	end if;	



	INSERT INTO recepcion(
	idrecepcion, idexpediente, idarea, idarea_proviene, idusuariorecepciona, 
	idusuarioenvia, idrecepcion_proviene, idprocedimiento, bindentregado, 
	fecharecepcion, bindderivado, bindprimero, fechaderivacion, observacion, 
	estado)
	VALUES (_idrecepcion, _idexpediente, _idarea, 0, null, 
	_idusuariocargo, null, _idprocedimiento, false, 
	now(), false, true, null, 'Enviado desde Mesa de Partes', 
	true);


/*fin de registro de recepcion*/



           
		RETURN _codigogen;
	--ELSE

			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarexpediente(_idusuariocargo integer, _idprocedimiento integer, _idarea integer, _codigo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _estado boolean, _bindentregado boolean, _bindobservado boolean, _folios integer, _nombredocumento character varying) OWNER TO postgres;

--
-- TOC entry 372 (class 1255 OID 431369)
-- Dependencies: 816 9
-- Name: uspinsertarexpediente(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarexpediente(_idusuariocargo integer, _idprocedimiento integer, _idarea integer, _codigo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _estado boolean, _bindentregado boolean, _bindobservado boolean, _folios integer, _nombredocumento character varying, _idarearecepciona integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idexpediente bigint;
DECLARE _idrecepcion bigint;
DECLARE _codigogen bigint;
DECLARE _retorno integer;
DECLARE _anio integer;
DECLARE _idevento bigint;
DECLARE _areadestino character varying(200);
DECLARE _arearecepciona character varying(200);
DECLARE _usuariorecepciona character varying(100);
DECLARE _usuariodestino character varying(100);
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
  bindobservado
  ,nombredocumento
  ,folios
   )

 VALUES ( _idexpediente,
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
  _bindobservado,
  _nombredocumento,
  _folios);

  /*Registro de hexpediente*/
  INSERT INTO hexpediente(
  idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
  codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
  correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
  bindobservado, fecharecepciona, idusuariorecepciona, estado, 
  accion)
  VALUES (_idexpediente,_idusuariocargo,_idprocedimiento,_idarea,0
  ,_codigogen,_dni_ruc,_nombre_razonsocial,_apellidos,_direccion,_telefono,
  _correo,_asunto,_nombredocumento,_folios,now(),null
  ,null,null,0,true,'REGISTRO');
  /*fin de Registro de hexpediente*/


  /*Registro de Recepcion*/
  _idrecepcion =(select max(idrecepcion) from recepcion)::integer;
  _idrecepcion=_idrecepcion+1;
  if(_idrecepcion is null) then
  _idrecepcion=1;
  end if;

  INSERT INTO recepcion(
  idrecepcion, idexpediente, idarea, idarea_proviene, idusuariorecepciona, 
  idusuarioenvia, idrecepcion_proviene, idprocedimiento, bindentregado, 
  fecharecepcion, bindderivado, bindprimero, fechaderivacion, observacion, 
  estado)
  VALUES (_idrecepcion, _idexpediente, _idarea, 0, null, 
  _idusuariocargo, null, _idprocedimiento, false, 
  now(), false, true, null, 'Enviado desde Mesa de Partes', 
  true);
  /*fin de Registro de Recepcion*/


  /*registro de evento*/
  _idevento=(select max(idevento) from evento)::integer;
  _idevento=_idevento+1;
  if(_idevento is null) then
  _idevento=1;
  end if;

  _areadestino=(select denominacion from area where idarea=_idarea);
  _arearecepciona=(select denominacion from area where idarea=_idarearecepciona);
  _usuariorecepciona=(select usuario from usuario where idusuario=_idusuariocargo);

  INSERT INTO evento(
  idevento, iddocumento, idexpediente, idarearecepciona, idareadestino, 
  idusuariorecepciona, idusuariodestino, estadoevento, denominacion,
  codigo, arearecepciona, areadestino, usuariorecepciona, usuariodestino,
  diasatencion, fecharecepciona, fechadestino, estado) 
  VALUES (_idevento, null, _idexpediente, _idarearecepciona, _idarea,
    _idusuariocargo, null, 'INICIALIZADO','REGISTRO/ENVIO EXPEDIENTE',
    _codigogen, _arearecepciona, _areadestino, _usuariorecepciona, null,
    0, now(), null, true);
  /*fin de registro de evento*/
           
  RETURN _codigogen;
  --ELSE

      --END IF;
    --SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarexpediente(_idusuariocargo integer, _idprocedimiento integer, _idarea integer, _codigo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _estado boolean, _bindentregado boolean, _bindobservado boolean, _folios integer, _nombredocumento character varying, _idarearecepciona integer) OWNER TO postgres;

--
-- TOC entry 379 (class 1255 OID 431603)
-- Dependencies: 9 816
-- Name: uspinsertarexpediente(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, boolean, integer, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarexpediente(_idusuariocargo integer, _idprocedimiento integer, _idarea integer, _codigo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _estado boolean, _bindentregado boolean, _bindobservado boolean, _folios integer, _nombredocumento character varying, _idarearecepciona integer, _observacion character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idexpediente bigint;
DECLARE _idrecepcion bigint;
DECLARE _codigogen bigint;
DECLARE _retorno integer;
DECLARE _anio integer;
DECLARE _idevento bigint;
DECLARE _areadestino character varying(200);
DECLARE _arearecepciona character varying(200);
DECLARE _usuariorecepciona character varying(100);
DECLARE _usuariodestino character varying(100);
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
  bindobservado
  ,nombredocumento
  ,folios
   )

 VALUES ( _idexpediente,
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
  _bindobservado,
  _nombredocumento,
  _folios);

  /*Registro de hexpediente*/
  INSERT INTO hexpediente(
  idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, 
  codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, 
  correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, 
  bindobservado, fecharecepciona, idusuariorecepciona, estado, 
  accion)
  VALUES (_idexpediente,_idusuariocargo,_idprocedimiento,_idarea,0
  ,_codigogen,_dni_ruc,_nombre_razonsocial,_apellidos,_direccion,_telefono,
  _correo,_asunto,_nombredocumento,_folios,now(),null
  ,null,null,0,true,'REGISTRO:'||_observacion);
  /*fin de Registro de hexpediente*/


  /*Registro de Recepcion*/
  _idrecepcion =(select max(idrecepcion) from recepcion)::integer;
  _idrecepcion=_idrecepcion+1;
  if(_idrecepcion is null) then
  _idrecepcion=1;
  end if;

  INSERT INTO recepcion(
  idrecepcion, idexpediente, idarea, idarea_proviene, idusuariorecepciona, 
  idusuarioenvia, idrecepcion_proviene, idprocedimiento, bindentregado, 
  fecharecepcion, bindderivado, bindprimero, fechaderivacion, observacion, 
  estado)
  VALUES (_idrecepcion, _idexpediente, _idarea, 0, null, 
  _idusuariocargo, null, _idprocedimiento, false, 
  now(), false, true, null, 'Enviado desde Mesa de Partes', 
  true);
  /*fin de Registro de Recepcion*/


  /*registro de evento*/
  _idevento=(select max(idevento) from evento)::integer;
  _idevento=_idevento+1;
  if(_idevento is null) then
  _idevento=1;
  end if;

  _areadestino=(select denominacion from area where idarea=_idarea);
  _arearecepciona=(select denominacion from area where idarea=_idarearecepciona);
  _usuariorecepciona=(select usuario from usuario where idusuario=_idusuariocargo);

  INSERT INTO evento(
  idevento, iddocumento, idexpediente, idarearecepciona, idareadestino, 
  idusuariorecepciona, idusuariodestino, estadoevento, denominacion,
  codigo, arearecepciona, areadestino, usuariorecepciona, usuariodestino,
  diasatencion, fecharecepciona, fechadestino, estado) 
  VALUES (_idevento, null, _idexpediente, _idarearecepciona, _idarea,
    _idusuariocargo, null, 'INICIALIZADO','REGISTRO/ENVIO EXPEDIENTE',
    _codigogen, _arearecepciona, _areadestino, _usuariorecepciona, null,
    0, now(), null, true);
  /*fin de registro de evento*/
           
  RETURN _codigogen;
  --ELSE

      --END IF;
    --SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarexpediente(_idusuariocargo integer, _idprocedimiento integer, _idarea integer, _codigo integer, _dni_ruc character varying, _nombre_razonsocial character varying, _apellidos character varying, _direccion character varying, _telefono character varying, _correo character varying, _asunto character varying, _estado boolean, _bindentregado boolean, _bindobservado boolean, _folios integer, _nombredocumento character varying, _idarearecepciona integer, _observacion character varying) OWNER TO postgres;

--
-- TOC entry 328 (class 1255 OID 230035)
-- Dependencies: 816 9
-- Name: uspinsertarexpedienterequisito(bigint, bigint, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarexpedienterequisito(_idrequisitos bigint, _idexpediente bigint, _fecha timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idexpediente_insert bigint;
DECLARE _idexpedienterequisito bigint;
DECLARE _retorno integer;
BEGIN	
	_idexpedienterequisito =(select max(idexpedienterequisito) from expedienterequisito)::integer;
	_idexpediente_insert=(select idexpediente from expediente where codigo=_idexpediente and estado=true);
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
	_idexpediente_insert,
	_fecha,
	_estado );


            _retorno =(select max(idexpedienterequisito) from expedienterequisito)::integer;
		RETURN _retorno;
	--ELSE
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarexpedienterequisito(_idrequisitos bigint, _idexpediente bigint, _fecha timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 139480)
-- Dependencies: 9 816
-- Name: uspinsertarferiado(integer, date, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarferiado(_idanio integer, _fecha date, _motivo character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idferiado integer;
DECLARE _retorno integer;
DECLARE _feriadoduplicado integer;
BEGIN	
	_feriadoduplicado = (select max(idferiado) from feriado where fecha=_fecha and motivo=_motivo);


	if _feriadoduplicado is null then 
	
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
		
	--ELSE
	 else 
      _retorno=-1;

      end  if;
		RETURN _retorno;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarferiado(_idanio integer, _fecha date, _motivo character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 139481)
-- Dependencies: 9 816
-- Name: uspinsertarflujo(bigint, integer, integer, integer, integer, timestamp without time zone, timestamp without time zone, character varying, text, text, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarflujo(_idexpediente bigint, _idestadoflujo integer, _idusuario integer, _idusuarioenvia integer, _idusuariorecepciona integer, _fechaenvio timestamp without time zone, _fechalectura timestamp without time zone, _asunto character varying, _descripcion text, _observacion text, _binderror boolean, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspinsertarflujo(_idexpediente bigint, _idestadoflujo integer, _idusuario integer, _idusuarioenvia integer, _idusuariorecepciona integer, _fechaenvio timestamp without time zone, _fechalectura timestamp without time zone, _asunto character varying, _descripcion text, _observacion text, _binderror boolean, _estado boolean) OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 188600)
-- Dependencies: 9 816
-- Name: uspinsertarflujo(bigint, integer, integer, integer, integer, timestamp without time zone, timestamp without time zone, character varying, text, text, boolean, boolean, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarflujo(_idexpediente bigint, _idestadoflujo integer, _idusuario integer, _idusuarioenvia integer, _idusuariorecepciona integer, _fechaenvio timestamp without time zone, _fechalectura timestamp without time zone, _asunto character varying, _descripcion text, _observacion text, _binderror boolean, _estado boolean, _idenvio bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
	estado,
	idenvio )

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
	_estado ,
	_idenvio);

        RETURN _idflujo;

			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarflujo(_idexpediente bigint, _idestadoflujo integer, _idusuario integer, _idusuarioenvia integer, _idusuariorecepciona integer, _fechaenvio timestamp without time zone, _fechalectura timestamp without time zone, _asunto character varying, _descripcion text, _observacion text, _binderror boolean, _estado boolean, _idenvio bigint) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 139482)
-- Dependencies: 816 9
-- Name: uspinsertarmodulo(character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarmodulo(_denominacion character varying, _paginainicio character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idmodulo integer;
DECLARE _retorno integer;
DECLARE _modduplicado integer;
BEGIN
		_modduplicado=(select max(idmodulo) from modulo where denominacion=_denominacion and paginainicio=_paginainicio and estado=true);

 if _modduplicado is null then 
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

      else 
      _retorno=-1;

      end  if;
		RETURN _retorno;
	--ELSE

			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarmodulo(_denominacion character varying, _paginainicio character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 356 (class 1255 OID 389172)
-- Dependencies: 816 9
-- Name: uspinsertarprocedimiento(integer, character varying, character varying, integer, integer, integer, character varying, double precision, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarprocedimiento(_idarea integer, _codigo character varying, _denominacion character varying, _plazodias integer, _idcargoresolutor integer, _idtipoprocedimiento integer, _descripcion character varying, _montototal double precision, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idprocedimiento integer;
DECLARE _retorno integer;
DECLARE _indduplicado integer;
BEGIN
	_indduplicado=(select max(idprocedimiento) from procedimiento where codigo=_codigo and estado=true);

	IF _indduplicado IS NULL THEN
	
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
		idtipoprocedimiento,
		descripcion,
		montototal,
		estado )

		VALUES (
		_idprocedimiento,
		_idarea,
		_codigo,
		_denominacion,
		_plazodias,
		_idcargoresolutor,
		_idtipoprocedimiento,
		_descripcion,
		_montototal,
		_estado );


		_retorno =(select max(idprocedimiento) from procedimiento)::integer;

        else
		_retorno = -1; --indica que existe Número de Código registrado
	end if;


	RETURN _retorno;
		
END;

$$;


ALTER FUNCTION public.uspinsertarprocedimiento(_idarea integer, _codigo character varying, _denominacion character varying, _plazodias integer, _idcargoresolutor integer, _idtipoprocedimiento integer, _descripcion character varying, _montototal double precision, _estado boolean) OWNER TO postgres;

--
-- TOC entry 353 (class 1255 OID 388830)
-- Dependencies: 816 9
-- Name: uspinsertarrecepcioninterna(bigint, integer, integer, integer, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarrecepcioninterna(_idmensaje bigint, _idarea_destino integer, _idarea_proviene integer, _idusuariorecepciona integer, _idusuarioenvia integer, _idrecepcion_proviene bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idrecepcioninterna integer;

BEGIN	
	_idrecepcioninterna =(select max(idrecepcioninterna) from recepcioninterna)::integer;
	_idrecepcioninterna=_idrecepcioninterna+1;
	if(_idrecepcioninterna is null) then
	_idrecepcioninterna=1;
	end if;	
INSERT INTO recepcioninterna(
            idrecepcioninterna, idexpediente, idmensaje, idarea_destino, 
            idarea_proviene, idusuariorecepciona, idusuarioenvia, idrecepcion_proviene, 
            bindentregado, fecharegistro, fecharecepcion, bindderivado, bindprimero, 
            fechaderivacion, observacion, estado)
    VALUES (_idrecepcioninterna, null, _idmensaje, _idarea_destino, 
            _idarea_proviene, _idusuariorecepciona, _idusuarioenvia, _idrecepcion_proviene, 
            false, now(), null, false, true, 
            null, '', true);


 RETURN _idrecepcioninterna;


END;

$$;


ALTER FUNCTION public.uspinsertarrecepcioninterna(_idmensaje bigint, _idarea_destino integer, _idarea_proviene integer, _idusuariorecepciona integer, _idusuarioenvia integer, _idrecepcion_proviene bigint) OWNER TO postgres;

--
-- TOC entry 340 (class 1255 OID 303884)
-- Dependencies: 816 9
-- Name: uspinsertarreferencia(bigint, bigint, timestamp without time zone, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarreferencia(_iddocumento bigint, _iddocumentoreferencia bigint, _fecharegistro timestamp without time zone, _idusuarioregistra integer, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idreferencia integer;
DECLARE _retorno integer;
BEGIN	
	_idreferencia =(select max(idreferencia) from referencia)::integer;
	_idreferencia=_idreferencia+1;
	if(_idreferencia is null) then
	_idreferencia=1;
	end if;	
	INSERT INTO referencia(

	idreferencia,
	iddocumento,
	iddocumentoreferencia,
	fecharegistro,
	idusuarioregistra,
	estado )

 VALUES (	_idreferencia,
	_iddocumento,
	_iddocumentoreferencia,
	_fecharegistro,
	_idusuarioregistra,
	_estado );


            _retorno =(select max(idreferencia) from referencia)::integer;
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

$$;


ALTER FUNCTION public.uspinsertarreferencia(_iddocumento bigint, _iddocumentoreferencia bigint, _fecharegistro timestamp without time zone, _idusuarioregistra integer, _estado boolean) OWNER TO postgres;

--
-- TOC entry 344 (class 1255 OID 379736)
-- Dependencies: 816 9
-- Name: uspinsertarreferencia(bigint, bigint, bigint, integer, integer, integer, integer, integer, boolean, timestamp without time zone, boolean, boolean, timestamp without time zone, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarreferencia(_ididrecepcioninterna bigint, _idexpediente bigint, _iddocumento bigint, _idarea_destino integer, _idarea_proviene integer, _idusuariorecepciona integer, _idusuarioenvia integer, _idrecepcion_proviene integer, _bindentregado boolean, _fecharecepcion timestamp without time zone, _bindderivado boolean, _bindprimero boolean, _fechaderivacion timestamp without time zone, _observacion text, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION public.uspinsertarreferencia(_ididrecepcioninterna bigint, _idexpediente bigint, _iddocumento bigint, _idarea_destino integer, _idarea_proviene integer, _idusuariorecepciona integer, _idusuarioenvia integer, _idrecepcion_proviene integer, _bindentregado boolean, _fecharecepcion timestamp without time zone, _bindderivado boolean, _bindprimero boolean, _fechaderivacion timestamp without time zone, _observacion text, _estado boolean) OWNER TO postgres;

--
-- TOC entry 341 (class 1255 OID 303885)
-- Dependencies: 816 9
-- Name: uspinsertarregla(boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarregla(_subida boolean, _igual boolean, _bajada boolean, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idregla integer;
DECLARE _retorno integer;
BEGIN	
	_idregla =(select max(idregla) from regla)::integer;
	_idregla=_idregla+1;
	if(_idregla is null) then
	_idregla=1;
	end if;	
	INSERT INTO regla(

	idregla,
	subida,
	igual,
	bajada,
	estado )

 VALUES (	_idregla,
	_subida,
	_igual,
	_bajada,
	_estado );


            _retorno =(select max(idregla) from regla)::integer;
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

$$;


ALTER FUNCTION public.uspinsertarregla(_subida boolean, _igual boolean, _bajada boolean, _estado boolean) OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 139484)
-- Dependencies: 816 9
-- Name: uspinsertarrequisitos(integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarrequisitos(_idprocedimiento integer, _denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
END;

$$;


ALTER FUNCTION public.uspinsertarrequisitos(_idprocedimiento integer, _denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 139485)
-- Dependencies: 9 816
-- Name: uspinsertarrol(character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarrol(_denominacion character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idrol integer;
DECLARE _retorno integer;
DECLARE _rolduplicado integer;
BEGIN	

	_rolduplicado=(select max(idrol) from rol where denominacion=_denominacion and estado=true);
	
if _rolduplicado is null then 

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

     else
	_retorno=-1;
    end if;
		RETURN _retorno;
	--ELSE
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarrol(_denominacion character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 302 (class 1255 OID 139486)
-- Dependencies: 816 9
-- Name: uspinsertarrolmodulo(integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarrolmodulo(_idrol integer, _idmodulo integer, _fechaasignacion timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idrolmodulo integer;
DECLARE _retorno integer;
DECLARE _rolmoduloduplicado INTEGER;
BEGIN	

	_rolmoduloduplicado =(select max(idrolmodulo) from rolmodulo where idrol=_idrol and idmodulo=_idmodulo and estado=_estado);

IF _rolmoduloduplicado IS NULL THEN

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
	NOW(),
	_estado );


            _retorno =(select max(idrolmodulo) from rolmodulo)::integer;
		
	--ELSE
ELSE
	_retorno=-1;
END IF;
	RETURN _retorno;
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarrolmodulo(_idrol integer, _idmodulo integer, _fechaasignacion timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 351 (class 1255 OID 388802)
-- Dependencies: 9 816
-- Name: uspinsertartipodocumento(integer, character varying, character varying, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertartipodocumento(_idregla integer, _denominacion character varying, _descripcion character varying, _subida boolean, _igual boolean, _bajada boolean, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idtipodocumento integer;
DECLARE _retorno integer;
BEGIN	
	_idtipodocumento =(select max(idtipodocumento) from tipodocumento)::integer;
	_idtipodocumento=_idtipodocumento+1;
	if(_idtipodocumento is null) then
	_idtipodocumento=1;
	end if;	
	INSERT INTO tipodocumento(

	idtipodocumento,
	idregla,
	denominacion,
	descripcion,
	subida,
	igual,
	bajada,
	estado )

 VALUES (	_idtipodocumento,
	_idregla,
	_denominacion,
	_descripcion,
	_subida,
	_igual,
	_bajada,
	_estado );


            _retorno =(select max(idtipodocumento) from tipodocumento)::integer;
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

$$;


ALTER FUNCTION public.uspinsertartipodocumento(_idregla integer, _denominacion character varying, _descripcion character varying, _subida boolean, _igual boolean, _bajada boolean, _estado boolean) OWNER TO postgres;

--
-- TOC entry 371 (class 1255 OID 423511)
-- Dependencies: 9 816
-- Name: uspinsertartipoprocedimiento(character varying, character varying, integer, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertartipoprocedimiento(_denominacion character varying, _descripcion character varying, _orden integer, _bindactual boolean, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idtipoprocedimiento integer;
DECLARE _retorno integer;
BEGIN	
	_idtipoprocedimiento =(select max(idtipoprocedimiento) from tipoprocedimiento)::integer;
	_idtipoprocedimiento=_idtipoprocedimiento+1;
	if(_idtipoprocedimiento is null) then
	_idtipoprocedimiento=1;
	end if;	
	INSERT INTO tipoprocedimiento(

	idtipoprocedimiento,
	denominacion,
	descripcion,
	orden,
	bindactual,
	estado )

 VALUES (	_idtipoprocedimiento,
	_denominacion,
	_descripcion,
	_orden,
	_bindactual,
	_estado );


            _retorno =(select max(idtipoprocedimiento) from tipoprocedimiento)::integer;
		RETURN _retorno;
	
END;

$$;


ALTER FUNCTION public.uspinsertartipoprocedimiento(_denominacion character varying, _descripcion character varying, _orden integer, _bindactual boolean, _estado boolean) OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 139487)
-- Dependencies: 816 9
-- Name: uspinsertarusuario(character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarusuario(_nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idusuario integer;
DECLARE _retorno integer;
DECLARE _usuarioduplicado integer;
BEGIN	
	_usuarioduplicado =(select max(idusuario) from usuario where (dni=_dni or usuario=_usuario) and estado=_estado);

if _usuarioduplicado is null then

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
   else
   _retorno=-1;
   end if;
  
		RETURN _retorno;
	--ELSE
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarusuario(_nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean) OWNER TO postgres;

--
-- TOC entry 322 (class 1255 OID 164012)
-- Dependencies: 9 816
-- Name: uspinsertarusuario(character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarusuario(_nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean, _creationdate character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idusuario integer;
DECLARE _retorno integer;
DECLARE _usuarioduplicado integer;
BEGIN	
	_usuarioduplicado =(select max(idusuario) from usuario where (dni=_dni or usuario=_usuario) and estado=true);

if _usuarioduplicado is null then

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
	estado ,
	creationdate)

 VALUES (	_idusuario,
	_nombres,
	_apellidos,
	_dni,
	_direccion,
	_telefono,
	_usuario,
	_password,
	_estado,
	_creationdate );


            _retorno =(select max(idusuario) from usuario)::integer;
   else
   _retorno=-1;
   end if;
  
		RETURN _retorno;
	--ELSE
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarusuario(_nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean, _creationdate character) OWNER TO postgres;

--
-- TOC entry 381 (class 1255 OID 459015)
-- Dependencies: 816 9
-- Name: uspinsertarusuario(character varying, character varying, character varying, character varying, character varying, character varying, character varying, boolean, character, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarusuario(_nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean, _creationdate character, _foto text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idusuario integer;
DECLARE _retorno integer;
DECLARE _usuarioduplicado integer;
BEGIN	
	_usuarioduplicado =(select max(idusuario) from usuario where (dni=_dni or usuario=_usuario) and estado=true);

if _usuarioduplicado is null then

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
	estado ,
	creationdate,foto)

 VALUES (	_idusuario,
	_nombres,
	_apellidos,
	_dni,
	_direccion,
	_telefono,
	_usuario,
	_password,
	_estado,
	_creationdate,_foto );


            _retorno =(select max(idusuario) from usuario)::integer;
   else
   _retorno=-1;
   end if;
  
		RETURN _retorno;
	--ELSE
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarusuario(_nombres character varying, _apellidos character varying, _dni character varying, _direccion character varying, _telefono character varying, _usuario character varying, _password character varying, _estado boolean, _creationdate character, _foto text) OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 139488)
-- Dependencies: 816 9
-- Name: uspinsertarusuariocargo(integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarusuariocargo(_idusuario integer, _idcargo integer, _fechaasignado timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
	now(),
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

$$;


ALTER FUNCTION public.uspinsertarusuariocargo(_idusuario integer, _idcargo integer, _fechaasignado timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 139489)
-- Dependencies: 816 9
-- Name: uspinsertarusuariorol(integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspinsertarusuariorol(_idusuario integer, _idrol integer, _fechaasignacion timestamp without time zone, _estado boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _idusuariorol integer;
DECLARE _retorno integer;
DECLARE _usuarioduplicado INTEGER;
BEGIN	

		_usuarioduplicado =(select max(idusuariorol) from usuariorol where idrol=_idrol and idusuario=_idusuario and estado=_estado);

IF _usuarioduplicado IS NULL THEN
	
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
	NOW(),
	_estado );


            _retorno =(select max(idusuariorol) from usuariorol)::integer;

    ELSE
    _retorno=-1;
    END IF;
		RETURN _retorno;
	--ELSE
	
			--END IF;
		--SELECT 1 existe FROM alumno WHERE ced_alu = 2034565;
END;

$$;


ALTER FUNCTION public.uspinsertarusuariorol(_idusuario integer, _idrol integer, _fechaasignacion timestamp without time zone, _estado boolean) OWNER TO postgres;

--
-- TOC entry 361 (class 1255 OID 404567)
-- Dependencies: 816 9
-- Name: uspmarcarleidomensaje(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uspmarcarleidomensaje(_idbandeja bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _bindleido boolean;
DECLARE _retorno bigint;
BEGIN	

_bindleido=(select bindleido from bandeja where idbandeja=_idbandeja);


RAISE NOTICE '_bindleido: %', _bindleido;

IF _bindleido = false then

UPDATE bandeja
SET bindleido=true,fechalectura=now()
WHERE idbandeja=_idbandeja;

_retorno=_idbandeja;

ELSE
 _retorno=-1;
END IF;

	RETURN _retorno;
            
--END IF;
		--;
END;

$$;


ALTER FUNCTION public.uspmarcarleidomensaje(_idbandeja bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 210 (class 1259 OID 139490)
-- Dependencies: 9
-- Name: anio; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE anio (
    idanio integer NOT NULL,
    denominacion character varying(200),
    estado boolean
);


ALTER TABLE public.anio OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 188614)
-- Dependencies: 9
-- Name: archivo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE archivo (
    idarchivo bigint NOT NULL,
    idflujo bigint,
    denominacion character varying(500),
    ruta character varying(500),
    idenvio bigint,
    idrespuesta bigint,
    estado boolean
);


ALTER TABLE public.archivo OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 303830)
-- Dependencies: 9
-- Name: archivodocumento; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE archivodocumento (
    idarchivodocumento bigint NOT NULL,
    documento bigint,
    codigo character varying(500),
    nombre character varying(500),
    url character varying(1000),
    estado boolean
);


ALTER TABLE public.archivodocumento OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 387957)
-- Dependencies: 9
-- Name: archivomensaje; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE archivomensaje (
    idarchivomensaje bigint NOT NULL,
    idmensaje bigint,
    nombre character varying(500),
    url character varying(1000),
    estado boolean
);


ALTER TABLE public.archivomensaje OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 139493)
-- Dependencies: 9
-- Name: area; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE area (
    idarea integer NOT NULL,
    denominacion character varying(200),
    estado boolean,
    abreviatura character varying(20),
    idareasuperior integer,
    codigo character varying(3)
);


ALTER TABLE public.area OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 388193)
-- Dependencies: 9
-- Name: areagrupo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE areagrupo (
    idareagrupo bigint NOT NULL,
    denominacion bigint,
    idusuariocreacion integer,
    estado boolean
);


ALTER TABLE public.areagrupo OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 379759)
-- Dependencies: 2152 9
-- Name: areatipodocumento; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE areatipodocumento (
    idareatipodocumento integer NOT NULL,
    idtipodocumento bigint,
    idarea bigint,
    idusuario bigint,
    codigo integer,
    estado boolean,
    fecharegistro timestamp without time zone DEFAULT now()
);


ALTER TABLE public.areatipodocumento OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 388924)
-- Dependencies: 9
-- Name: bandeja; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bandeja (
    idbandeja bigint NOT NULL,
    idmensaje bigint,
    idareaproviene integer,
    idareadestino integer,
    idusuarioenvia integer,
    idusuariodestino integer,
    bindrecepcion boolean,
    bindleido boolean,
    idusuariorecepciona integer,
    idestadobandeja integer,
    fecharecepciona timestamp without time zone,
    fechalectura timestamp without time zone,
    fechaderivacion timestamp without time zone,
    fecharegistro timestamp without time zone,
    estado boolean
);


ALTER TABLE public.bandeja OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 238225)
-- Dependencies: 9
-- Name: cargo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cargo (
    idcargo integer NOT NULL,
    idarea integer NOT NULL,
    denominacion character varying(200),
    bindjefe boolean,
    idcargoparent integer,
    nivel integer,
    estado boolean,
    abreviatura character varying(15)
);


ALTER TABLE public.cargo OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 388198)
-- Dependencies: 9
-- Name: detalleareagrupo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE detalleareagrupo (
    iddetalleareagrupo bigint NOT NULL,
    idusuariogrupo bigint,
    idarea integer,
    estado boolean
);


ALTER TABLE public.detalleareagrupo OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 388188)
-- Dependencies: 9
-- Name: detalleusuariogrupo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE detalleusuariogrupo (
    iddetalleusuariogrupo bigint NOT NULL,
    idusuariogrupo bigint,
    idusuario integer,
    estado boolean
);


ALTER TABLE public.detalleusuariogrupo OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 172206)
-- Dependencies: 9
-- Name: diasferiado; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE diasferiado (
    count bigint
);


ALTER TABLE public.diasferiado OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 380517)
-- Dependencies: 9
-- Name: documento; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE documento (
    iddocumento bigint NOT NULL,
    idtipodocumento integer,
    codigo character varying(500),
    asunto character varying(300),
    mensaje text,
    prioridad integer,
    bindrespuesta boolean,
    diasrespuesta integer,
    bindllegadausuario boolean,
    idareacioncreacion integer,
    idusuariocreacion integer,
    fechacreacion timestamp without time zone,
    idexpediente bigint,
    codigoexpediente bigint,
    estado boolean
);


ALTER TABLE public.documento OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 387965)
-- Dependencies: 9
-- Name: documentomensaje; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE documentomensaje (
    iddocumentomensaje bigint NOT NULL,
    idmensaje bigint,
    iddocumento bigint,
    fechacreacion timestamp without time zone,
    idusuariocreacion integer,
    estado boolean
);


ALTER TABLE public.documentomensaje OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 188760)
-- Dependencies: 9
-- Name: envio; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE envio (
    idenvio bigint NOT NULL,
    idusuario integer,
    bindrespuesta boolean,
    fechaenvio timestamp without time zone,
    estado boolean
);


ALTER TABLE public.envio OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 387975)
-- Dependencies: 9
-- Name: estadobandeja; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE estadobandeja (
    idestadobandeja integer NOT NULL,
    idusuario integer,
    icono character varying(500),
    denominacion character varying(200),
    estado boolean,
    orden integer,
    bindfinal boolean
);


ALTER TABLE public.estadobandeja OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 139499)
-- Dependencies: 9
-- Name: estadoflujo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE estadoflujo (
    idestadoflujo integer NOT NULL,
    denominacion character varying(200),
    estado boolean,
    orden integer,
    bindfinal boolean
);


ALTER TABLE public.estadoflujo OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 415299)
-- Dependencies: 9
-- Name: evento; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE evento (
    idevento bigint NOT NULL,
    iddocumento bigint,
    idexpediente bigint,
    idarearecepciona integer,
    idareadestino integer,
    idusuariorecepciona integer,
    idusuariodestino integer,
    estadoevento character varying(200),
    denominacion character varying(200),
    codigo character varying(500),
    arearecepciona character varying(200),
    areadestino character varying(3500),
    usuariorecepciona character varying(100),
    usuariodestino character varying(3500),
    diasatencion double precision,
    fecharecepciona timestamp without time zone,
    fechadestino timestamp without time zone,
    estado boolean
);


ALTER TABLE public.evento OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 413463)
-- Dependencies: 2153 2154 2155 9
-- Name: expediente; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE expediente (
    idexpediente bigint NOT NULL,
    idusuariocargo integer,
    idprocedimiento integer,
    idarea integer,
    idpreexpediente bigint,
    codigo bigint NOT NULL,
    dni_ruc character varying(12),
    nombre_razonsocial character varying(300),
    apellidos character varying(250),
    direccion character varying(500),
    telefono character varying(150),
    correo character varying(200),
    asunto character varying(500),
    nombredocumento character varying(500),
    folios integer,
    fecharegistro timestamp without time zone DEFAULT now(),
    bindentregado boolean DEFAULT false,
    bindobservado boolean DEFAULT false,
    fecharecepciona timestamp without time zone,
    idusuariorecepciona integer,
    estado boolean
);


ALTER TABLE public.expediente OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 139511)
-- Dependencies: 2150 9
-- Name: expedienterequisito; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE expedienterequisito (
    idexpedienterequisito bigint NOT NULL,
    idrequisitos integer,
    idexpediente bigint,
    fecha timestamp without time zone DEFAULT now(),
    urlrequisito character varying(500),
    estado boolean
);


ALTER TABLE public.expedienterequisito OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 139518)
-- Dependencies: 9
-- Name: feriado; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE feriado (
    idferiado integer NOT NULL,
    idanio integer,
    fecha date,
    motivo character varying(200),
    estado boolean
);


ALTER TABLE public.feriado OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 188638)
-- Dependencies: 9
-- Name: flujo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE flujo (
    idflujo bigint NOT NULL,
    idflujoparent bigint,
    idexpediente bigint,
    idestadoflujo integer,
    idusuario integer,
    idusuarioenvia integer,
    idusuariorecepciona integer,
    bindparent boolean,
    fechaenvio timestamp without time zone,
    fechalectura timestamp without time zone,
    asunto character varying(500),
    descripcion text,
    observacion text,
    binderror boolean,
    bindicaleido boolean,
    idenvio bigint,
    idrespuesta bigint,
    titulorespuesta character varying(500),
    cuerporespuesta text,
    bindatendido boolean,
    estado boolean,
    fecharesolucion timestamp without time zone,
    idarea integer
);


ALTER TABLE public.flujo OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 414938)
-- Dependencies: 2156 2157 2158 9
-- Name: hexpediente; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hexpediente (
    idhexpediente bigint NOT NULL,
    idusuariocargo integer,
    idprocedimiento integer,
    idarea integer,
    idpreexpediente bigint,
    codigo bigint NOT NULL,
    dni_ruc character varying(12),
    nombre_razonsocial character varying(300),
    apellidos character varying(250),
    direccion character varying(500),
    telefono character varying(150),
    correo character varying(200),
    asunto character varying(500),
    nombredocumento character varying(500),
    folios integer,
    fecharegistro timestamp without time zone DEFAULT now(),
    bindentregado boolean DEFAULT false,
    bindobservado boolean DEFAULT false,
    fecharecepciona timestamp without time zone,
    idusuariorecepciona integer,
    estado boolean,
    accion character varying(200)
);


ALTER TABLE public.hexpediente OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 450237)
-- Dependencies: 9
-- Name: mensaje; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mensaje (
    idmensaje bigint NOT NULL,
    idexpediente bigint,
    asunto character varying(300),
    mensaje text,
    prioridad integer,
    bindrespuesta boolean,
    bindrecepcion boolean,
    diasrespuesta integer,
    idareacioncreacion integer,
    idusuariocreacion integer,
    fechacreacion timestamp without time zone,
    estado boolean
);


ALTER TABLE public.mensaje OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 139527)
-- Dependencies: 9
-- Name: modulo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE modulo (
    idmodulo integer NOT NULL,
    denominacion character varying(100),
    paginainicio character varying(100),
    estado boolean
);


ALTER TABLE public.modulo OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 139530)
-- Dependencies: 9
-- Name: preexpediente; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE preexpediente (
    idpreexpediente bigint NOT NULL,
    idprocedimiento integer,
    idarea integer,
    dni_ruc character varying(12),
    nombre_razonsocial character varying(300),
    apellidos character varying(250),
    direccion character varying(500),
    telefono character varying(150),
    correo character varying(200),
    asunto character varying(500),
    ipenvio character varying(100),
    lat character varying(100),
    lon character varying(100),
    urlcomprobante character varying(500),
    codigocomprobante character varying(200),
    bindaprobado boolean,
    estado boolean
);


ALTER TABLE public.preexpediente OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 139536)
-- Dependencies: 9
-- Name: preexpedienterequisito; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE preexpedienterequisito (
    idpreexpedienterequisito bigint NOT NULL,
    idrequisitos integer,
    idpreexpediente bigint,
    fecha timestamp without time zone,
    urlrequisito character varying(500),
    estado boolean
);


ALTER TABLE public.preexpedienterequisito OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 139542)
-- Dependencies: 9
-- Name: procedimiento; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE procedimiento (
    idprocedimiento integer NOT NULL,
    idcargoresolutor integer,
    idarea integer,
    codigo character varying(20),
    denominacion character varying(1500),
    plazodias integer,
    descripcion character varying(3000),
    bindweb boolean,
    estado boolean,
    idtipoprocedimiento integer,
    montototal double precision
);


ALTER TABLE public.procedimiento OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 271062)
-- Dependencies: 9
-- Name: recepcion; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE recepcion (
    idrecepcion bigint,
    idexpediente bigint,
    idarea integer,
    idarea_proviene integer,
    idusuariorecepciona integer,
    idusuarioenvia integer,
    idrecepcion_proviene bigint,
    idprocedimiento integer,
    bindentregado boolean,
    fecharecepcion timestamp without time zone,
    bindderivado boolean,
    bindprimero boolean,
    fechaderivacion timestamp without time zone,
    observacion character varying(600),
    estado boolean
);


ALTER TABLE public.recepcion OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 388824)
-- Dependencies: 9
-- Name: recepcioninterna; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE recepcioninterna (
    idrecepcioninterna bigint,
    idexpediente bigint,
    idmensaje bigint,
    idarea_destino integer,
    idarea_proviene integer,
    idusuariorecepciona integer,
    idusuarioenvia integer,
    idrecepcion_proviene bigint,
    bindentregado boolean,
    fecharegistro timestamp without time zone,
    fecharecepcion timestamp without time zone,
    bindderivado boolean,
    bindprimero boolean,
    fechaderivacion timestamp without time zone,
    observacion character varying(600),
    estado boolean
);


ALTER TABLE public.recepcioninterna OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 303851)
-- Dependencies: 9
-- Name: referencia; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE referencia (
    idreferencia bigint NOT NULL,
    iddocumento bigint,
    iddocumentoreferencia bigint,
    fecharegistro timestamp without time zone,
    idusuarioregistra integer,
    estado boolean
);


ALTER TABLE public.referencia OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 303856)
-- Dependencies: 9
-- Name: regla; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE regla (
    idregla integer NOT NULL,
    subida boolean,
    igual boolean,
    bajada boolean,
    estado boolean
);


ALTER TABLE public.regla OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 139548)
-- Dependencies: 9
-- Name: requisitos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE requisitos (
    idrequisitos integer NOT NULL,
    idprocedimiento integer,
    denominacion character varying(3000),
    descripcion character varying(4000),
    monto double precision,
    estado boolean
);


ALTER TABLE public.requisitos OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 188633)
-- Dependencies: 9
-- Name: respuesta; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE respuesta (
    idrespuesta bigint NOT NULL,
    idusuario integer,
    fechaenvio timestamp without time zone,
    estado boolean
);


ALTER TABLE public.respuesta OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 139554)
-- Dependencies: 9
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rol (
    idrol integer NOT NULL,
    denominacion character varying(100),
    estado boolean
);


ALTER TABLE public.rol OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 139557)
-- Dependencies: 9
-- Name: rolmodulo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rolmodulo (
    idrolmodulo integer NOT NULL,
    idrol integer,
    idmodulo integer,
    fechaasignacion timestamp without time zone,
    estado boolean
);


ALTER TABLE public.rolmodulo OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 303861)
-- Dependencies: 9
-- Name: tipodocumento; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tipodocumento (
    idtipodocumento integer NOT NULL,
    idregla integer,
    denominacion character varying(250),
    descripcion character varying(500),
    estado boolean,
    orden integer,
    firma boolean,
    subida boolean,
    igual boolean,
    bajada boolean
);


ALTER TABLE public.tipodocumento OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 336711)
-- Dependencies: 2151 9
-- Name: tipoprocedimiento; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tipoprocedimiento (
    idtipoprocedimiento integer NOT NULL,
    denominacion character varying(1500),
    descripcion character varying(1500),
    orden integer,
    estado boolean,
    bindactual boolean DEFAULT true
);


ALTER TABLE public.tipoprocedimiento OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 139560)
-- Dependencies: 9
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuario (
    idusuario integer NOT NULL,
    nombres character varying(200),
    apellidos character varying(200),
    dni character varying(12),
    direccion character varying(200),
    telefono character varying(100),
    usuario character varying(100),
    password character varying(100),
    estado boolean,
    creationdate character(15),
    iniciales character varying(8),
    foto text
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 139566)
-- Dependencies: 9
-- Name: usuariocargo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuariocargo (
    idusuariocargo integer NOT NULL,
    idusuario integer,
    idcargo integer,
    fechaasignado timestamp without time zone,
    estado boolean
);


ALTER TABLE public.usuariocargo OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 388179)
-- Dependencies: 9
-- Name: usuariogrupo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuariogrupo (
    idusuariogrupo bigint NOT NULL,
    denominacion bigint,
    idusuariocreacion integer,
    estado boolean
);


ALTER TABLE public.usuariogrupo OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 139569)
-- Dependencies: 9
-- Name: usuariorol; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuariorol (
    idusuariorol integer NOT NULL,
    idusuario integer,
    idrol integer,
    fechaasignacion timestamp without time zone,
    estado boolean
);


ALTER TABLE public.usuariorol OWNER TO postgres;

--
-- TOC entry 2237 (class 0 OID 139490)
-- Dependencies: 210
-- Data for Name: anio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY anio (idanio, denominacion, estado) FROM stdin;
2016	Año de la Diversificación Productiva y del Fortalecimiento de la Educación	t
\.


--
-- TOC entry 2253 (class 0 OID 188614)
-- Dependencies: 226
-- Data for Name: archivo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY archivo (idarchivo, idflujo, denominacion, ruta, idenvio, idrespuesta, estado) FROM stdin;
1	0	modelo	15122015190302_733478.docx	10	\N	t
2	0	informe	15122015190302_544327.pptx	10	\N	t
3	0	asdasd	17122015084601_86181.doc	11	\N	t
4	0	logo	17122015085612_651787.png	12	\N	t
5	0	logo	17122015085642_722183.png	13	\N	t
6	0	logo	17122015085713_42843.png	14	\N	t
7	0	contrato	17122015100235_762224.xlsx	15	\N	t
8	0	contrato	17122015100309_894414.xlsx	16	\N	t
9	0	1	17122015103338_872912.jpg	20	\N	t
10	0	LOGO	18122015162728_718558.jpg	22	\N	t
11	0	doc	26042016123221_463863.pdf	1	\N	t
\.


--
-- TOC entry 2259 (class 0 OID 303830)
-- Dependencies: 232
-- Data for Name: archivodocumento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY archivodocumento (idarchivodocumento, documento, codigo, nombre, url, estado) FROM stdin;
1	1		INFORME	23082016173505_77447.docx	t
2	1		FOTO	23082016173505_737612.jpg	t
3	3		ASD	26082016122851_127458.jpg	t
4	5		Manual	29082016122930_263779.pdf	t
5	5		informe	29082016122930_808824.docx	t
6	5		pantallasos	29082016122931_2559210.jpg	t
7	5		scrum	29082016122931_472611.xlsx	t
8	5		audio	29082016122931_426362.mp3	t
9	5		video	29082016122931_977168.wmv	t
10	6		INFORME 	29082016124255_971254.docx	t
11	6		MANUAL	29082016124255_414433.pdf	t
12	7		INFORME ARCHIVO	29082016154131_928638.docx	t
13	7		LISTA ITEM	29082016154131_888845.xlsx	t
14	7		MANUAL	29082016154131_59296.pdf	t
15	8		INFORME EN DIGITAL	31082016090414_2055610.docx	t
16	8		FOTO DE 	31082016090415_973735.png	t
17	8		PLANO	31082016090415_903789.pdm	t
18	9		a	20092016134441_2875310.docx	t
19	9		b	20092016134441_361541.docx	t
20	11		MEMORANDO A RESOLVER	27092016103022_474775.docx	t
21	12		INFORME	27092016104242_731849.docx	t
22	13		hosting	10102016150610_651604.docx	t
23	14		DOCUMENTO PRINCIAPL	10102016151956_635495.doc	t
24	0		ASD	11102016095046_7353310.pdf	t
25	0		ASD	11102016095051_288483.pdf	t
26	30		MEMORANDO Nº 002-2016-MPH-A/12.61	17102016150204_547903.doc	t
27	31				t
28	31				t
29	31				t
30	31				t
31	31				t
32	31				t
33	31				t
34	31				t
35	38		PLANO	19102016143455_721285.jpg	t
36	2				t
37	6		Oficio	16112016104824_829454.docx	t
38	7		documento	16112016105309_5905310.png	t
39	8		a	16112016105814_79138.png	t
\.


--
-- TOC entry 2266 (class 0 OID 387957)
-- Dependencies: 239
-- Data for Name: archivomensaje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY archivomensaje (idarchivomensaje, idmensaje, nombre, url, estado) FROM stdin;
1	1	\N	\N	t
2	3	informe	23092016154406_78076.exe	t
3	32	INFORME 001	19102016104221_334244.docx	t
4	33	FOTOGRAFIA 	19102016104648_7963110.jpg	t
5	33	IMAGEN	19102016104648_672312.docx	t
6	35	excel	28102016124110_901662.png	t
7	35	foto	28102016124110_945183.png	t
8	9	foto	14112016165851_643701.png	t
9	20	ajunto esta infor mas	16112016105908_428217.png	t
10	21	asd	16112016110253_217648.jpg	t
11	1	a	17112016164511_775738.sql	t
12	3	informe	22112016090033_745792.rar	t
\.


--
-- TOC entry 2238 (class 0 OID 139493)
-- Dependencies: 211
-- Data for Name: area; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY area (idarea, denominacion, estado, abreviatura, idareasuperior, codigo) FROM stdin;
39	SUB GERENCIA DE PROMOCIÓN EMPRESARIAL Y DESARROLLO RURAL	t	SGPEyDR	38	52
41	GERENCIA DE TRANSPORTES	t	GTT	\N	56
42	SUB GERENCIA DE TRANSITO Y SEGURIDAD VIAL	t	SGTySV	41	57
43	SUB GERENCIA DE CONTROL TECNICO DEL TRANSPORTE PUBLICO	t	SGCTTP	41	58
1	CONCEJO MUNICIPAL	t	CM	\N	10
2	ALCALDIA	t	ALC	\N	11
3	GERENCIA MUNICIPAL	t	GM	\N	12
12	UNIDAD DE ATENCION AL CIUDADANO GESTION DOCUMENTAL Y ARCHIVO	t	UACGDyA	11	29
4	ORGANO DE CONTROL INSTITUCIONAL	t	OCI	\N	20
28	SUB GERENCIA DE PRIMERA INFANCIA NIÑEZ ADOLESCENCIA JUVENTUD Y BIENESTAR SOCIAL	t	SGPINAJyBS	27	43
5	PROCURADURIA PUBLICA MUNICIPAL	t	PPM	\N	21
6	OFICINA DE ASESORIA JURIDICA	t	OAJ	\N	22
7	OFICINA DE PLANEAMIENTO Y PRESUPUESTO	t	OPP	\N	23
8	OFICINA DE PRESUPUESTO Y PLANES	t	OPP	7	24
45	SUB GERENCIA DE SISTEMAS Y TECNOLOGIA	t	SGSSyT	3	61
9	UNIDAD DE RACIONALIZACION	t	UR	7	25
10	UNIDAD DE PROGRAMACION E INVERSIONES	t	UPII	7	26
11	OFICINA DE SECRETARIA GENERAL	t	OSG	\N	28
13	UNIDAD DE RELACIONES PUBLICAS E IMAGEN INSTITUCIONAL	t	URRPPeII	11	27
14	OFICINA DE ADMINISTRACION Y FINANZAS	t	OAFF	\N	30
46	SUB GERENCIA DE SUPERVISION Y LIQUIDACION DE PROYECTOS	t	SGSyLPP	\N	60
29	SUB GERENCIA DE JUVENTUD EDUCACIÓN Y DEPORTE	t	SGJEyD	27	44
15	UNIDAD DE TESORERIA	t	UT	14	31
16	UNIDAD DE CONTABILIDAD	t	UC	14	32
17	UNIDAD DE RECURSOS HUMANOS	t	URRHH	14	33
18	UNIDAD DE ABASTECIMIENTO	t	UA	14	34
44	SUB GERENCIA DE ESTUDIOS GESTION DE INVERSIONES Y CTI	t	SGEEGIyCTI	3	59
19	UNIDAD DE BIENES PATRIMONIALES Y EQUIPO MECANICO	t	UBBPPyEM	14	35
21	UNIDAD DE EJECUTORIA COACTIVA	t	UEC	14	36
20	UNIDAD DE EQUIPO MECANICO	f	UEM	14	\N
22	GERENCIA DE DESARROLLO TERRITORIAL	t	GDT	\N	37
23	SUB GERENCIA DE OBRAS	t	SGOO	22	38
33	GERENCIA DE SERVICIOS MUNICIPALES	t	GSSMM	\N	\N
24	SUB GERENCIA DE ORDENAMIENTO URBANO Y CATASTRO	t	SGOUyC	22	39
25	SUB GERENCIA DE CENTRO HISTORICO	t	SGCH	22	40
26	SUB GERENCIA DE CONTROL URBANO Y LICENCIAS	t	SGCUyL	22	41
27	GERENCIA DE DESARROLLO HUMANO	t	GDH	\N	42
48	INSTITUTO VIAL PROVINCIAL	f	IVP	\N	\N
30	SUB GERENCIA DE PROGRAMA DE ALIMENTACION Y NUTRICION	t	SGPAyN	27	45
31	SUB GERENCIA DE PARTICIPACIÓN VECINAL Y CIUDADANIA	t	SGPVyC	27	47
32	SUB GERENCIA DE REGISTRO CIVIL	t	SGRC	27	46
49	SALA DE REGIDORES	t	SR	\N	\N
50	SAT HUAMANGA	f	SATH	\N	\N
47	SUB GERENCIA DE GESTIÓN DE RIESGOS Y DEFENSA CIVIL	t	SGGRRyDC	3	50
38	GERENCIA DESARROLLO ECONÓMICO Y MEDIO AMBIENTE	t	GDEyA	\N	51
51	GERENCIA DE SEGURIDAD CIUDADANA Y DEFENSA CIVIL	t	GSCyDC	\N	48
34	SUB GERENCIA DE ECOLOGIA Y MEDIO AMBIENTE	t	SGEyMA	38	55
35	UNIDAD DE GESTION DE RESIDUOS SOLIDOS	t	UGRRSS	\N	62
36	SUB GERENCIA DE SERENAZGO	t	SGS	51	49
37	SUB GERENCIA DE COMERCIO LICENCIAS Y FISCALIZACIÓN 	t	SGCLyF	38	53
52	nueva	t	psstmaaas	0	137
53	6546	t	45654654	45	654
54	000003	f	00000003333	0	003
55	AREA PRUEBA ACTUALIZADO	f	AP	3	100
40	SUB GERENCIA DE CULTURA TURISMO Y ARTESANIA	t	SGCTA	38	54
\.


--
-- TOC entry 2271 (class 0 OID 388193)
-- Dependencies: 244
-- Data for Name: areagrupo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY areagrupo (idareagrupo, denominacion, idusuariocreacion, estado) FROM stdin;
\.


--
-- TOC entry 2264 (class 0 OID 379759)
-- Dependencies: 237
-- Data for Name: areatipodocumento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY areatipodocumento (idareatipodocumento, idtipodocumento, idarea, idusuario, codigo, estado, fecharegistro) FROM stdin;
2	2	2	1	1	t	2016-09-13 12:47:33.768
3	8	2	1	1	t	2016-09-13 12:47:33.768
4	8	2	1	2	t	2016-09-13 12:47:33.768
5	5	2	1	1	t	2016-09-13 12:47:33.768
6	5	2	1	2	t	2016-09-13 12:47:33.768
7	5	2	1	3	t	2016-09-13 12:47:33.768
8	5	2	1	4	t	2016-09-13 12:47:33.768
1	1	2	1	1	t	2015-09-13 12:47:33.768
9	5	2	1	5	t	2016-09-20 13:44:40.553
10	1	45	9	1	t	2016-09-26 15:35:48.624
11	3	45	9	1	t	2016-09-27 10:30:22.333
12	5	13	15	1	t	2016-09-27 10:42:42.663
13	1	2	1	2	t	2016-10-10 15:06:10.254
14	4	2	1	1	t	2016-10-10 15:19:56.262
15	1	2	1	3	t	2016-10-12 16:04:14.668
16	1	2	1	4	t	2016-10-13 09:48:04.103
17	1	2	1	5	t	2016-10-13 10:13:34.568
18	1	45	2	1	t	2016-10-13 11:43:11.21
19	1	45	2	2	t	2016-10-13 11:52:39.086
20	8	2	1	3	t	2016-10-14 14:57:00.013
21	8	2	1	4	t	2016-10-14 15:02:49.043
22	8	2	1	5	t	2016-10-14 15:07:58.539
23	8	2	1	6	t	2016-10-14 15:09:31.278
24	8	2	1	7	t	2016-10-14 15:13:18.135
25	8	2	1	8	t	2016-10-14 15:13:39.594
26	8	2	1	9	t	2016-10-14 15:17:02.063
27	8	2	1	10	t	2016-10-14 15:35:09.626
28	8	2	1	11	t	2016-10-14 15:59:22.055
29	8	2	1	12	t	2016-10-17 11:41:52.036
30	3	45	9	2	t	2016-10-17 15:02:04.131
31	5	45	2	1	t	2016-10-17 15:27:47.436
32	8	2	1	13	t	2016-10-18 08:36:47.326
33	8	2	1	14	t	2016-10-18 12:14:51.964
34	8	45	9	1	t	2016-10-18 15:33:35.313
35	8	45	9	2	t	2016-10-19 08:36:03.361
36	8	45	9	3	t	2016-10-19 08:42:00.122
37	8	45	9	4	t	2016-10-19 08:42:16.973
38	3	45	9	3	t	2016-10-19 14:34:54.234
39	8	45	9	5	t	2016-10-28 12:45:49.386
40	8	45	9	6	t	2016-11-04 09:19:08.43
41	1	45	9	2	t	2016-11-04 09:42:51.384
42	1	45	9	3	t	2016-11-04 09:53:17.631
43	0	45	9	1	t	2016-11-04 09:57:16.238
44	1	45	9	4	t	2016-11-04 10:35:04.336
45	8	2	1	15	t	2016-11-04 14:35:52.946
46	8	2	1	16	t	2016-11-08 12:38:33.893
47	8	2	1	17	t	2016-11-08 12:55:57.027
48	8	2	1	18	t	2016-11-08 13:04:22.756
49	8	2	1	19	t	2016-11-10 10:42:34.112
50	8	2	1	20	t	2016-11-10 10:46:31.399
51	8	2	1	21	t	2016-11-10 10:48:24.925
52	8	2	1	22	t	2016-11-10 10:53:53.55
53	8	2	1	23	t	2016-11-10 10:57:09.889
54	8	2	1	24	t	2016-11-10 10:59:59.011
55	8	2	1	25	t	2016-11-10 11:04:21.132
56	8	2	1	26	t	2016-11-10 11:06:35.205
57	8	2	1	27	t	2016-11-10 11:24:39.242
58	8	2	1	28	t	2016-11-10 12:20:33.233
59	5	2	1	6	t	2016-11-14 16:49:24.636
60	8	2	1	29	t	2016-11-14 16:53:14.168
61	1	45	9	5	t	2016-11-15 10:28:00.432
62	1	45	9	6	t	2016-11-15 10:37:12.434
63	1	2	1	6	t	2016-11-16 10:48:24.062
64	1	2	1	7	t	2016-11-16 10:53:09.402
65	4	2	1	2	t	2016-11-16 10:58:14.415
66	2	2	1	2	t	2016-11-18 16:57:42.584
67	8	2	1	30	t	2016-11-21 11:07:16.772
\.


--
-- TOC entry 2274 (class 0 OID 388924)
-- Dependencies: 247
-- Data for Name: bandeja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bandeja (idbandeja, idmensaje, idareaproviene, idareadestino, idusuarioenvia, idusuariodestino, bindrecepcion, bindleido, idusuariorecepciona, idestadobandeja, fecharecepciona, fechalectura, fechaderivacion, fecharegistro, estado) FROM stdin;
50	21	2	19	1	49	f	f	0	\N	\N	\N	\N	2016-11-16 11:02:53.508	t
51	21	2	45	1	2	f	f	0	\N	\N	\N	\N	2016-11-16 11:02:53.508	t
3	9	45	45	9	2	f	f	0	\N	\N	\N	\N	2016-11-14 16:58:49.605	t
5	10	45	2	9	70	f	f	0	\N	\N	\N	\N	2016-11-15 11:35:57.459	t
6	11	45	19	9	49	f	f	0	\N	\N	\N	\N	2016-11-15 11:40:12.744	t
8	11	45	7	9	44	f	f	0	\N	\N	\N	\N	2016-11-15 11:40:12.744	t
12	12	45	19	9	49	f	f	0	\N	\N	\N	\N	2016-11-15 11:40:16.161	t
14	12	45	7	9	44	f	f	0	\N	\N	\N	\N	2016-11-15 11:40:16.161	t
18	13	45	19	9	49	f	f	0	\N	\N	\N	\N	2016-11-15 11:40:23.528	t
20	13	45	7	9	44	f	f	0	\N	\N	\N	\N	2016-11-15 11:40:23.528	t
24	14	45	19	9	49	f	f	0	\N	\N	\N	\N	2016-11-15 11:40:27.115	t
26	14	45	7	9	44	f	f	0	\N	\N	\N	\N	2016-11-15 11:40:27.115	t
30	15	45	19	9	49	f	f	0	\N	\N	\N	\N	2016-11-15 11:57:43.758	t
32	16	45	17	9	12	f	f	0	\N	\N	\N	\N	2016-11-15 12:32:06.403	t
33	16	45	13	9	15	f	f	0	\N	\N	\N	\N	2016-11-15 12:32:06.403	t
34	16	45	18	9	63	f	f	0	\N	\N	\N	\N	2016-11-15 12:32:06.403	t
35	16	45	45	9	2	f	f	0	\N	\N	\N	\N	2016-11-15 12:32:06.403	t
36	16	45	2	9	70	f	f	0	\N	\N	\N	\N	2016-11-15 12:32:06.403	t
37	17	45	21	9	21	f	f	0	\N	\N	\N	\N	2016-11-15 12:35:22.555	t
38	17	45	32	9	19	f	f	0	\N	\N	\N	\N	2016-11-15 12:35:22.555	t
39	17	45	19	9	49	f	f	0	\N	\N	\N	\N	2016-11-15 12:35:22.555	t
40	17	45	15	9	39	f	f	0	\N	\N	\N	\N	2016-11-15 12:35:22.555	t
41	17	45	9	9	11	f	f	0	\N	\N	\N	\N	2016-11-15 12:35:22.555	t
42	18	45	19	9	49	f	f	0	\N	\N	\N	\N	2016-11-15 12:40:48.079	t
43	18	45	44	9	26	f	f	0	\N	\N	\N	\N	2016-11-15 12:40:48.079	t
44	18	45	29	9	7	f	f	0	\N	\N	\N	\N	2016-11-15 12:40:48.079	t
13	12	45	2	9	1	f	t	0	\N	\N	2016-11-15 15:04:24.963	\N	2016-11-15 11:40:16.161	t
25	14	45	2	9	1	f	t	0	\N	\N	2016-11-15 15:04:48.385	\N	2016-11-15 11:40:27.115	t
19	13	45	2	9	1	f	t	0	\N	\N	2016-11-15 15:11:40.704	\N	2016-11-15 11:40:23.528	t
46	19	45	19	9	49	f	f	0	\N	\N	\N	\N	2016-11-15 15:29:20.128	t
48	19	45	2	9	70	f	f	0	\N	\N	\N	\N	2016-11-15 15:29:20.128	t
47	19	45	2	9	1	f	t	0	\N	\N	2016-11-15 15:33:43.37	\N	2016-11-15 15:29:20.128	t
31	15	45	2	9	1	f	t	0	\N	\N	2016-11-16 17:50:56.153	\N	2016-11-15 11:57:43.758	t
49	20	2	45	1	2	t	t	2	\N	2016-11-16 11:00:40.639	2016-11-16 10:59:47.742	\N	2016-11-16 10:59:08.491	t
2	8	2	45	1	9	t	t	2	\N	2016-11-16 11:00:40.639	2016-11-14 16:54:16.506	\N	2016-11-14 16:53:14.449	t
1	7	2	45	1	9	t	t	2	\N	2016-11-16 11:00:40.639	2016-11-10 12:21:04.335	\N	2016-11-10 12:20:33.535	t
4	10	45	45	9	9	t	f	2	\N	2016-11-16 11:00:40.639	\N	\N	2016-11-15 11:35:57.459	t
45	18	45	45	9	2	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 12:40:48.079	t
27	14	45	45	9	2	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:27.115	t
28	14	45	45	9	71	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:27.115	t
29	14	45	45	9	66	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:27.115	t
21	13	45	45	9	2	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:23.528	t
22	13	45	45	9	71	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:23.528	t
23	13	45	45	9	66	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:23.528	t
15	12	45	45	9	2	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:16.161	t
16	12	45	45	9	71	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:16.161	t
17	12	45	45	9	66	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:16.161	t
9	11	45	45	9	2	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:12.744	t
10	11	45	45	9	71	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:12.744	t
11	11	45	45	9	66	t	f	2	\N	2016-11-16 11:00:51.864	\N	\N	2016-11-15 11:40:12.744	t
7	11	45	2	9	1	f	t	0	\N	\N	2016-11-16 17:51:01.075	\N	2016-11-15 11:40:12.744	t
52	1	2	45	1	2	f	f	0	\N	\N	\N	\N	2016-11-17 16:45:11.605	t
53	2	2	45	1	2	f	f	0	\N	\N	\N	\N	2016-11-22 08:22:12.599	t
54	3	45	2	2	1	t	t	1	\N	2016-11-22 12:26:09.657	2016-11-22 11:12:58.625	\N	2016-11-22 09:00:32.781	t
55	4	2	45	1	9	t	f	2	\N	2016-11-22 12:49:32.53	\N	\N	2016-11-22 12:47:19.899	t
56	4	2	45	1	2	t	f	2	\N	2016-11-22 12:49:32.53	\N	\N	2016-11-22 12:47:19.899	t
57	4	2	2	1	70	t	t	70	\N	2016-11-22 12:48:58.284	2016-11-22 13:00:23.17	\N	2016-11-22 12:47:19.899	t
\.


--
-- TOC entry 2257 (class 0 OID 238225)
-- Dependencies: 230
-- Data for Name: cargo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cargo (idcargo, idarea, denominacion, bindjefe, idcargoparent, nivel, estado, abreviatura) FROM stdin;
88	19	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
89	19	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
90	19	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
91	19	TECNICO ADMINISTRATIVO II	f	2	3	t	TAII
244	41	cargo nuevo887	f	34	8887	f	CN87
245	41	CHOFER II	f	197	3	f	CH
111	24	TÉCNICO EN INGENIERÍA III	f	2	3	t	TINGIII
123	26	ASISTENTE EN SERVICIOS DE INFRAESTRUCTURA II	f	2	3	t	ASIII
7	3	GERENTE MUNICIPAL V	f	2	3	t	GMV
8	3	ABOGADO II	f	2	3	t	ABGII
9	3	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
1	2	ALCALDE	t	0	3	t	ALC
2	2	ASESOR II	t	1	3	t	ASEII
10	3	SECRETARIA I	f	2	3	t	SI
52	12	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
11	3	CHOFER II	f	2	3	t	CHII
12	4	DIRECTOR DEL SISTEMA ADMINSITRATIVO III	t	1	2	t	DSAIII
14	4	ESPECIALISTA EN AUDITORIA III	f	2	3	t	EAIII
33	8	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
34	9	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
35	9	ESPECIALISTA EN RACIONALIZACIÓN III	f	2	3	t	ERIII
36	9	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
37	9	ESTADISTICO II	f	2	3	t	EII
38	9	TÉCNICO ADMINISTRATIVO III	f	2	3	t	TAIII
13	4	AUDITOR III	f	2	3	t	AIII
39	9	TÉCNICO ADMINISTRATIVO II	f	2	3	t	TAII
15	4	INGENIERO II	f	2	3	t	INGII
16	4	ABOGADO II	f	2	3	t	ABGII
17	4	ESPECIALISTA EN AUDITORIA II	f	2	3	t	EAII
3	2	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
4	2	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
5	2	SECRETARIA EJECUTIVA IV	f	2	3	t	SEIV
6	2	CHOFER II	f	2	3	t	CHII
18	4	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
19	5	PROCURADOR PÚBLICO MUNICIPAL	f	2	3	t	PPM
20	5	ABOGADO II	f	2	3	t	ABGII
21	6	DIRECTOR DE SISTEMA ADMINISTRATIVO II	t	1	2	t	DSAII
22	6	ABOGADO II	f	2	3	t	ABGII
23	6	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
24	6	TÉCNICO EN ABOGACÍA III	f	2	3	t	TABGIII
25	6	SECRETARIA I	f	2	3	t	SRIAI
26	7	DIRECTOR DE SISTEMA ADMINISTRATIVO II	t	1	2	t	DSAII
27	7	SECRETARIA II	f	2	3	t	SRIAII
28	8	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
29	8	PLANIFICADOR II	f	2	3	t	PII
30	8	ECONOMISTA II	f	2	3	t	ECONII
31	8	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
32	8	ASISTENTE EN SERVICIOS ECONOMICO FINANCIERO I	f	2	3	t	ASSEFI
40	10	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
41	10	ECONOMISTA II	f	2	3	t	ECONII
42	10	INGENIERO II	f	2	3	t	INGII
43	10	TÉCNICO ADMINISTRATIVO III	f	2	3	t	TAIII
44	10	SECRETARIA III	f	2	3	t	SRIAIII
45	11	DIRECTOR DE SISTEMA ADMINISTRATIVO II	t	1	2	t	DSAII
46	11	ABOGADO II (Concejo Municipal)	f	2	3	t	ABGII
47	11	INGENIERO II (Concejo Municipal)	f	2	3	t	INGII
48	11	ESPECIALISTA ADMINISTRATIVO II (Oficina Enlace)	f	2	3	t	EAII
49	11	TÉCNICO ADMINISTRATIVO II	f	2	3	t	TAII
50	11	SECRETARIA II(Concejo Municipal)	f	2	3	t	SRIAII
51	11	SECRETARIA II	f	2	3	t	SRIAII
53	12	TÉCNICO ADMINISTRATIVO III	f	2	3	t	TAIII
54	12	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
55	12	OFICINISTA I	f	2	3	t	OFII
56	12	AUXILIAR EN SISTEMA ADMINISTRATIVO I	f	2	3	t	ASAI
57	13	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
58	13	RELACIONISTA PÚBLICO I	f	2	3	t	RPI
59	13	ESPECIALISTA EN COMUNICACIONES II	f	2	3	t	ECCII
60	14	DIRECTOR DE SISTEMA ADMINISTRATIVO II	t	1	2	t	DSAII
61	14	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
62	14	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
63	15	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
64	15	ESPECIALISTA EN FINANZAS II	f	2	3	t	EFII
65	15	ASISTENTE EN SERVICIO ECONOMICO FINANCIERO I	f	2	3	t	ASEFI
66	15	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
67	15	TECNICO ADMINISTRATIVO II	f	2	3	t	TAII
68	15	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
69	15	AUXILIAR DE SISTEMA ADMINISTRATIVO I	f	2	3	t	ASAI
70	16	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
136	28	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
149	30	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
158	32	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
166	34	DIRECTOR DE PROGRAMA SECTORIAL II	t	1	2	t	DPSII
71	16	CONTADOR II	f	2	3	t	CII
72	16	TECNICO ADMINISTRATIVO II	f	2	3	t	TAII
73	17	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
74	17	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
75	17	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
76	17	ASISTENTE SOCIAL III	f	2	3	t	ASIII
77	17	TÉCNICO ADMINISTRATIVO III	f	2	3	t	TAIII
78	17	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
79	18	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
80	18	ABOGADO II	f	2	3	t	ABGII
81	18	CONTADOR II	f	2	3	t	CII
82	18	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
83	18	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
84	18	TECNICO ADMINISTRATIVO II	f	2	3	t	TAII
85	18	AUXILIAR DE SISTEMA ADMINISTRATIVO I	f	2	3	t	ASAI
86	18	CHOFER I	f	2	3	t	CHI
87	18	SECRETARIA II	f	2	3	t	SRIAII
92	20	DIRECTOR DE SISTEMA ADMINISTRATIVO I	t	1	2	t	DSAI
93	20	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
94	20	MECÁNICO I	f	2	3	t	MECI
95	20	CHOFER I	f	2	3	t	CHI
96	20	OPERADOR DE EQUIPO PESADO I	f	2	3	t	OEPI
97	21	EJECUTOR COACTIVO	t	2	3	t	EC
98	21	AUXILIAR COACTIVO I	f	2	3	t	ACI
99	21	SECRETARIA II	f	2	3	t	SRIAII
100	22	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
101	22	ABOGADO II	f	2	3	t	ABGII
102	22	CHOFER II	f	2	3	t	CHII
103	22	SECRETARIA II	f	2	3	t	SRIAII
104	23	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
105	23	INGENIERO II	f	2	3	t	INGII
106	23	ASISTENTE EN SERVICIO DE INFRAESTRUCTURA II	f	2	3	t	ASIII
107	23	TÉCNICO EN INGENIERÍA III	f	2	3	t	AINGIII
108	23	SECRETARIA II	f	2	3	t	SRIAII
109	24	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
110	24	ARQUITECTO II	f	2	3	t	ARQII
112	25	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
113	25	ARQUITECTO II	f	2	3	t	ARQII
114	25	INGENIERO II	f	2	3	t	INGII
115	25	ABOGADO II	f	2	3	t	ABGII
116	25	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
117	25	TÉCNICO ADMINISTRATIVO II	f	2	3	t	TAII
118	25	AUXILIAR DE SISTEMA ADMINISTRATIVO I	f	2	3	t	ASAI
119	25	SECRETARIA III	f	2	3	t	SRIAIII
120	26	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
121	26	INGENIERO II	f	2	3	t	INGII
122	26	TÉCNICO ADMINISTRATIVO II	f	2	3	t	TAII
124	26	ASISTENTE EN SERVICIOS DE INFRAESTRUCTURA I	f	2	3	t	ASII
125	26	TECNICO EN INGENIERIA III	f	2	3	t	TINGIII
126	26	SECRETARIA II	f	2	3	t	SRIAII
127	27	DIRECTOR DE PROGRAMA SECTORIAL II	t	1	2	t	DPSII
128	27	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
129	27	CHOFER I	f	2	3	t	CHI
130	27	SECRETARIA I	f	2	3	t	SRIAI
131	28	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
132	28	ENFERMERA II	f	2	3	t	ENFRAII
133	28	ASISTENTE SOCIAL III	f	2	3	t	ASIII
134	28	ASISTENTA SOCIAL I	f	2	3	t	ASI
135	28	OBTETRIZ I	f	2	3	t	OBSTETRI
137	28	TECNICO EN ABOGACIA II	f	2	3	t	TABGII
138	28	TÉCNICO ADMINISTRATIVO III	f	2	3	t	TAIII
139	28	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
140	28	TRABAJADOR DE SERVICIOS III	f	2	3	t	TSIII
141	28	SECRETARIA II	f	2	3	t	SRIAII
142	29	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
143	29	ESPECIALISTA EN EDUCACIÓN II	f	2	3	t	EEII
144	29	TÉCNICO ADMINISTRATIVO III	f	2	3	t	TAIII
145	29	TECNICO EN BIBLIOTECA III	f	2	3	t	TBIII
146	29	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
147	29	OFICINISTA I	f	2	3	t	OFII
148	29	SECRETARIA I	f	2	3	t	SRIAI
150	30	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
151	30	NUTRICIONISTA II	f	2	3	t	NUTII
152	30	PROMOTOR SOCIAL I	f	2	3	t	PSI
153	30	TÉCNICO ADMINISTRATIVO II	f	2	3	t	TAII
154	31	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
155	31	PROMOTOR SOCIAL I	f	2	3	t	PSI
156	31	TÉCNICO ADMINISTRATIVO I	f	2	3	t	TAI
157	31	SECRETARIA II	f	2	3	t	SRIAII
159	32	TECNICO ADMINISTRATIVO III	f	2	3	t	TAIII
160	32	TECNICO ADMINISTRATIVO II	f	2	3	t	TAII
161	32	AUXILIAR EN SISTEMA ADMINISTRATIVO I	f	2	3	t	ASAI
162	32	SECRETARIA I	f	2	3	t	SRIAI
163	33	DIRECTOR DE PROGRAMA SECTORIAL II	t	1	2	t	DPSII
164	33	ASESOR ADMINISTRATIVO I	f	2	3	t	AAI
165	33	SECRETARIA II	f	2	3	t	SRIAII
167	34	BIÓLOGO II	f	2	3	t	BIOLII
168	34	INGENIERO II	f	2	3	t	INGII
169	34	TRABAJADOR DE SERVICIOS III	f	2	3	t	TSSIII
170	35	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
171	35	CHOFER I	f	2	3	t	CHI
172	35	TRABAJADOR DE SERVICIOS III	f	2	3	t	TSSIII
173	35	TRABAJADOR DE SERVICIOS II	f	2	3	t	TSSII
174	35	OPERADOR DE EQUIPO PESADO I	f	2	3	t	OEPI
175	35	AUXILIAR DE SISTEMA ADMINSITARTIVO I	f	2	3	t	ASAI
176	35	SECRETARIA II	f	2	3	t	SRIAII
183	37	POLICIA MUNICIPAL I	f	2	3	t	PMI
232	21	ASISTENTE ADMINISTRATIVO	f	97	3	t	AA
231	54	SUBGERENTE	f	2	3	t	SG
230	53	JEFE DE AREA	f	2	3	t	JA
227	48	JEFE DE UNIDAD	f	2	3	t	JU
226	49	REGIDORES	f	2	3	t	RG
225	1	Consejo	f	2	3	t	CSJ
223	47	INGENIERO II	f	2	3	t	INGII
221	46	TÉCNICO ADMINISTRATIVO I	f	2	3	t	TAI
220	46	ESPECIALISTA EN FINANZAS II	f	2	3	t	EFII
219	46	INGENIERO II	f	2	3	t	INGII
218	46	CONTADOR II	f	2	3	t	CONTII
177	36	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
178	36	SECRETARIA II	f	2	3	t	SRIAII
179	37	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
180	37	ESPECIALISTA ADMINISTRATIVO II	f	2	3	t	EAII
181	37	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
182	37	POLICIA MUNICIPAL II	f	2	3	t	PMII
184	37	TRABAJADOR DE SERVICIO III	f	2	3	t	TSIII
185	37	AUXILIAR EN SISTEMA ADMINISTRATIVO I	f	2	3	t	ASAI
186	37	SECRETARIA II	f	2	3	t	SRIAII
187	38	DIRECTOR DE PROGRAMA SECTORIAL II	t	1	2	t	DPSII
188	38	INGENIERO II	f	2	3	t	INGII
189	38	SECRETARIA II	f	2	3	t	SRIAII
190	39	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
191	39	ESPECIALISTA ADMINISTRATIVO I	f	2	3	t	EAI
192	39	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
193	39	TECNICO EN ARCHIVO I	f	2	3	t	TAI
194	40	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
195	40	TÉCNICO EN TURISMO I	f	2	3	t	TTI
196	40	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
197	41	DIRECTOR DE PROGRAMA SECTORIAL II	t	1	2	t	DPSII
198	41	ABOGADO II	f	2	3	t	ABGII
199	41	SECRETARIA II	f	2	3	t	SRIAII
200	42	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
201	42	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
202	43	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
203	43	OFICINISTA III	f	2	3	t	TAIII
204	43	TECNICO ADMINISTRATIVO I	f	2	3	t	TAI
205	43	MECÁNICO I	f	2	3	t	MI
206	43	AUXILIAR DEL SISTEMA ADMINISTRATIVO I	f	2	3	t	ASAI
207	43	ASISTENTE ADMINISTRATIVO I	f	2	3	t	AAI
209	44	INGENIERO II	f	2	3	t	INGII
208	44	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
210	44	ECONOMISTA II	f	2	3	t	ECONII
211	44	TÉCNICO EN INGENIERÍA III	f	2	3	t	TIIII
212	44	TÉCNICO EN INGENIERÍA I	f	2	3	t	TII
213	45	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
214	45	INGENIERO II	f	2	3	t	INGII
215	45	TÉCNICO ADMINISTRATIVO I	f	2	3	t	TAI
216	45	ANALISTA PROGRAMADOR	f	2	3	t	AP
217	46	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
222	47	DIRECTOR DE PROGRAMA SECTORIAL I	t	1	2	t	DPSI
224	47	TECNICO EN SEGURIDAD I	f	2	3	t	TSI
228	50	JEFE SAT	f	2	3	t	JSAT
229	45	ADMINISTRADOR DE SISTEMA	f	2	3	t	ADMS
233	44	SECRETARIA EJECUTIVA	f	208	3	t	SRIAE
234	24	SECRETARIA	f	109	3	t	SRIA
235	34	SECRETARIA	f	166	3	t	SRIA
236	15	SECRETARIA	f	63	3	t	SRIA
237	8	SECRETARIA I	f	28	3	t	SRIAI
238	30	SECRETARIA	f	149	3	t	SRIA
239	19	SECRETARIA	f	88	3	t	SRIA
240	14	SECRETARIO	f	60	3	t	SRIO
241	17	SECRETARIO	f	73	3	t	SRIO
242	47	SECRETARIO	f	222	3	t	SRIO
243	45	SECRETARIO	f	213	3	t	SRIO
\.


--
-- TOC entry 2272 (class 0 OID 388198)
-- Dependencies: 245
-- Data for Name: detalleareagrupo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY detalleareagrupo (iddetalleareagrupo, idusuariogrupo, idarea, estado) FROM stdin;
\.


--
-- TOC entry 2270 (class 0 OID 388188)
-- Dependencies: 243
-- Data for Name: detalleusuariogrupo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY detalleusuariogrupo (iddetalleusuariogrupo, idusuariogrupo, idusuario, estado) FROM stdin;
\.


--
-- TOC entry 2252 (class 0 OID 172206)
-- Dependencies: 225
-- Data for Name: diasferiado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY diasferiado (count) FROM stdin;
0
\.


--
-- TOC entry 2265 (class 0 OID 380517)
-- Dependencies: 238
-- Data for Name: documento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY documento (iddocumento, idtipodocumento, codigo, asunto, mensaje, prioridad, bindrespuesta, diasrespuesta, bindllegadausuario, idareacioncreacion, idusuariocreacion, fechacreacion, idexpediente, codigoexpediente, estado) FROM stdin;
1	8	PROVEIDO Nº 028-2016-MPH-A/11.11	DERIVADO PRUEBA 	DERIVADO PRUEBA 	0	f	0	f	2	1	2016-11-10 12:20:33.233	0	1	t
2	5	INFORME Nº 006-2016-MPH-A/11.11			0	f	0	f	2	1	2016-11-14 16:49:24.636	0	0	t
3	8	PROVEIDO Nº 029-2016-MPH-A/11.11	derivar documendo para su antencion	descripcion mas detallada para hacer la derivacion	0	f	0	f	2	1	2016-11-14 16:53:14.168	0	3	t
5	1	OFICIO Nº 006-2016-MPH-A/12.61	oficio6	oficio6	0	f	0	f	45	9	2016-11-15 10:37:12.434	3	3	t
6	1	OFICIO Nº 006-2016-MPH-A/11.11			0	f	0	f	2	1	2016-11-16 10:48:24.062	0	0	t
7	1	OFICIO Nº 007-2016-MPH-A/11.11			0	f	0	f	2	1	2016-11-16 10:53:09.402	0	0	t
8	4	MEMORANDO MULTIPLE Nº 002-2016-MPH-A/11.11	a	a	0	f	0	f	2	1	2016-11-16 10:58:14.415	0	0	t
4	1	OFICIO Nº 005-2016-MPH-A/12.61	oficio5	oficio5	0	f	0	f	45	9	2016-11-15 10:28:00.432	3	3	t
9	2	OFICIO MULTIPLE Nº 002-2016-MPH-A/11.11	asd	asd	0	f	0	f	2	1	2016-11-18 16:57:42.584	4	4	t
10	8	PROVEIDO Nº 030-2016-MPH-A/11.11	asd	asd	0	f	0	f	2	1	2016-11-21 11:07:16.772	6	6	t
\.


--
-- TOC entry 2267 (class 0 OID 387965)
-- Dependencies: 240
-- Data for Name: documentomensaje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY documentomensaje (iddocumentomensaje, idmensaje, iddocumento, fechacreacion, idusuariocreacion, estado) FROM stdin;
1	7	1	2016-11-10 12:20:33.588	1	t
2	8	3	2016-11-14 16:53:14.521	1	t
3	10	4	2016-11-15 11:35:57.618	9	t
4	11	5	2016-11-15 11:40:12.86	9	t
5	12	5	2016-11-15 11:40:16.207	9	t
6	13	5	2016-11-15 11:40:23.561	9	t
7	14	5	2016-11-15 11:40:27.182	9	t
8	15	4	2016-11-15 11:57:44.622	9	t
9	16	5	2016-11-15 12:32:06.459	9	t
10	17	4	2016-11-15 12:35:22.623	9	t
11	18	5	2016-11-15 12:40:49.296	9	t
12	18	4	2016-11-15 12:40:49.296	9	t
13	19	5	2016-11-15 15:29:20.197	9	t
14	20	8	2016-11-16 10:59:08.545	1	t
15	1	8	2016-11-17 16:45:11.675	1	t
16	3	9	2016-11-22 09:00:32.835	2	t
17	4	3	2016-11-22 12:47:19.953	1	t
18	4	2	2016-11-22 12:47:19.953	1	t
\.


--
-- TOC entry 2256 (class 0 OID 188760)
-- Dependencies: 229
-- Data for Name: envio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY envio (idenvio, idusuario, bindrespuesta, fechaenvio, estado) FROM stdin;
1	1	\N	2016-04-26 00:00:00	f
\.


--
-- TOC entry 2268 (class 0 OID 387975)
-- Dependencies: 241
-- Data for Name: estadobandeja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY estadobandeja (idestadobandeja, idusuario, icono, denominacion, estado, orden, bindfinal) FROM stdin;
\.


--
-- TOC entry 2239 (class 0 OID 139499)
-- Dependencies: 212
-- Data for Name: estadoflujo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY estadoflujo (idestadoflujo, denominacion, estado, orden, bindfinal) FROM stdin;
1	PENDIENTE	t	1	f
2	RESUELTO	t	3	t
3	OBSERVADO	t	2	f
4	DERIVADO	t	4	t
\.


--
-- TOC entry 2277 (class 0 OID 415299)
-- Dependencies: 250
-- Data for Name: evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY evento (idevento, iddocumento, idexpediente, idarearecepciona, idareadestino, idusuariorecepciona, idusuariodestino, estadoevento, denominacion, codigo, arearecepciona, areadestino, usuariorecepciona, usuariodestino, diasatencion, fecharecepciona, fechadestino, estado) FROM stdin;
1	\N	6	12	45	5	66	INICIALIZADO	REGISTRO/ENVIO EXPEDIENTE	6	UNIDAD DE ATENCION AL CIUDADANO GESTION DOCUMENTAL Y ARCHIVO	SUB GERENCIA DE SISTEMAS Y TECNOLOGIA	ventanilla4	ggamboa	0	2016-11-22 11:10:57.408	2016-11-22 11:26:02.437	t
2	\N	6	45	\N	66	\N	RECEPCIONADO	RECEPCION	6	SUB GERENCIA DE SISTEMAS Y TECNOLOGIA	\N	ggamboa	\N	0	2016-11-22 11:26:02.437	\N	t
\.


--
-- TOC entry 2275 (class 0 OID 413463)
-- Dependencies: 248
-- Data for Name: expediente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY expediente (idexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, bindobservado, fecharecepciona, idusuariorecepciona, estado) FROM stdin;
1	1	269	2	\N	1	70021899	ERICK	ESCALANTE OLANO	ASD			ASD	INORME	15	2016-11-21 12:31:15.889	f	f	\N	\N	t
2	5	327	45	\N	2	43724871	DENIS JACk	OCHOA BERROCAL	JR TA	00318759	ddd	44444	4444	4	2016-11-22 08:29:39.88	f	f	\N	\N	t
3	5	341	45	\N	3	43724871	DENIS JACK	OCHOA BERROCAL	JR TA	00318759	ddd	8787877	787878	7	2016-11-22 10:16:38.467	f	f	\N	\N	t
4	5	341	45	\N	4	43724871	DENIS JACK	OCHOA BERROCAL	JR TA	00318759	ddd	2332	2323	23	2016-11-22 10:45:28.164	f	f	\N	\N	t
5	5	341	45	\N	5	43724871	DENIS JACK	OCHOA BERROCAL	JR TA	00318759	ddd	54545	55454	4	2016-11-22 11:06:37.414	f	f	\N	\N	t
6	5	341	45	\N	6	43724871	DENIS JACK	OCHOA BERROCAL	JR TA	00318759	ddd	232323232	23	23	2016-11-22 11:10:57.408	f	f	\N	\N	t
\.


--
-- TOC entry 2240 (class 0 OID 139511)
-- Dependencies: 213
-- Data for Name: expedienterequisito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY expedienterequisito (idexpedienterequisito, idrequisitos, idexpediente, fecha, urlrequisito, estado) FROM stdin;
1	26	4	2016-10-13 00:00:00	\N	t
2	27	4	2016-10-13 00:00:00	\N	t
3	28	4	2016-10-13 00:00:00	\N	t
4	29	4	2016-10-13 00:00:00	\N	t
5	30	4	2016-10-13 00:00:00	\N	t
6	31	4	2016-10-13 00:00:00	\N	t
7	32	4	2016-10-13 00:00:00	\N	t
8	33	4	2016-10-13 00:00:00	\N	t
9	34	4	2016-10-13 00:00:00	\N	t
10	35	4	2016-10-13 00:00:00	\N	t
11	36	4	2016-10-13 00:00:00	\N	t
12	37	4	2016-10-13 00:00:00	\N	t
13	38	4	2016-10-13 00:00:00	\N	t
14	39	4	2016-10-13 00:00:00	\N	t
15	40	4	2016-10-13 00:00:00	\N	t
16	41	4	2016-10-13 00:00:00	\N	t
17	42	4	2016-10-13 00:00:00	\N	t
18	43	4	2016-10-13 00:00:00	\N	t
19	44	4	2016-10-13 00:00:00	\N	t
20	45	4	2016-10-13 00:00:00	\N	t
21	46	4	2016-10-13 00:00:00	\N	t
22	47	4	2016-10-13 00:00:00	\N	t
23	48	4	2016-10-13 00:00:00	\N	t
24	49	4	2016-10-13 00:00:00	\N	t
49	943	7	2016-10-17 00:00:00	\N	t
50	944	7	2016-10-17 00:00:00	\N	t
51	940	7	2016-10-17 00:00:00	\N	t
52	941	7	2016-10-17 00:00:00	\N	t
53	942	7	2016-10-17 00:00:00	\N	t
54	945	7	2016-10-17 00:00:00	\N	t
55	946	7	2016-10-17 00:00:00	\N	t
56	947	7	2016-10-17 00:00:00	\N	t
57	948	7	2016-10-17 00:00:00	\N	t
58	949	7	2016-10-17 00:00:00	\N	t
59	950	7	2016-10-17 00:00:00	\N	t
60	951	7	2016-10-17 00:00:00	\N	t
61	952	7	2016-10-17 00:00:00	\N	t
62	266	33	2016-11-08 00:00:00	\N	t
63	267	33	2016-11-08 00:00:00	\N	t
64	268	33	2016-11-08 00:00:00	\N	t
65	269	33	2016-11-08 00:00:00	\N	t
66	270	33	2016-11-08 00:00:00	\N	t
67	271	33	2016-11-08 00:00:00	\N	t
68	272	33	2016-11-08 00:00:00	\N	t
69	273	33	2016-11-08 00:00:00	\N	t
70	274	33	2016-11-08 00:00:00	\N	t
71	275	33	2016-11-08 00:00:00	\N	t
72	276	33	2016-11-08 00:00:00	\N	t
73	1180	2	2016-11-14 12:59:07.912	\N	t
74	1181	2	2016-11-14 12:59:07.912	\N	t
75	1182	2	2016-11-14 12:59:07.912	\N	t
76	1183	2	2016-11-14 12:59:07.912	\N	t
77	1184	2	2016-11-14 12:59:07.912	\N	t
78	1185	2	2016-11-14 12:59:07.912	\N	t
79	1186	2	2016-11-14 12:59:07.912	\N	t
80	1187	2	2016-11-14 12:59:07.912	\N	t
81	26	5	2016-11-21 09:04:58.92	\N	t
82	27	5	2016-11-21 09:04:58.92	\N	t
83	28	5	2016-11-21 09:04:58.92	\N	t
84	29	5	2016-11-21 09:04:58.92	\N	t
85	30	5	2016-11-21 09:04:58.92	\N	t
86	31	5	2016-11-21 09:04:58.92	\N	t
87	32	5	2016-11-21 09:04:58.92	\N	t
88	33	5	2016-11-21 09:04:58.92	\N	t
89	34	5	2016-11-21 09:04:58.92	\N	t
90	35	5	2016-11-21 09:04:58.92	\N	t
91	36	5	2016-11-21 09:04:58.92	\N	t
92	37	5	2016-11-21 09:04:58.92	\N	t
93	38	5	2016-11-21 09:04:58.92	\N	t
94	39	5	2016-11-21 09:04:58.92	\N	t
95	40	5	2016-11-21 09:04:58.92	\N	t
96	41	5	2016-11-21 09:04:58.92	\N	t
97	42	5	2016-11-21 09:04:58.92	\N	t
98	43	5	2016-11-21 09:04:58.92	\N	t
99	44	5	2016-11-21 09:04:58.92	\N	t
100	45	5	2016-11-21 09:04:58.92	\N	t
101	46	5	2016-11-21 09:04:58.92	\N	t
102	47	5	2016-11-21 09:04:58.92	\N	t
103	48	5	2016-11-21 09:04:58.92	\N	t
104	49	5	2016-11-21 09:04:58.92	\N	t
\.


--
-- TOC entry 2241 (class 0 OID 139518)
-- Dependencies: 214
-- Data for Name: feriado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY feriado (idferiado, idanio, fecha, motivo, estado) FROM stdin;
1	2016	2016-01-01	AÑO NUEVO	t
2	2016	2016-01-02	SABADO	t
3	2016	2016-01-03	DOMINGO	t
4	2016	2016-01-09	SABADO	t
5	2016	2016-01-10	DOMINGO	t
6	2016	2016-01-16	SABADO	t
7	2016	2016-01-17	DOMINGO	t
8	2016	2016-01-23	SABADO	t
9	2016	2016-01-24	DOMINGO	t
10	2016	2016-01-30	SABADO	t
11	2016	2016-01-31	DOMINGO	t
12	2016	2016-02-06	SABADO	t
13	2016	2016-02-07	DOMINGO	t
14	2016	2016-02-13	SABADO	t
15	2016	2016-02-14	DOMINGO	t
16	2016	2016-02-20	SABADO	t
17	2016	2016-02-21	DOMINGO	t
18	2016	2016-02-27	SABADO	t
19	2016	2016-02-28	DOMINGO	t
20	2016	2016-03-05	SABADO	t
21	2016	2016-03-06	DOMINGO	t
22	2016	2016-03-12	SABADO	t
23	2016	2016-03-13	DOMINGO	t
24	2016	2016-03-19	SABADO	t
25	2016	2016-03-20	DOMINGO	t
26	2016	2016-03-24	JUEVES SANTO	t
27	2016	2016-03-25	VIERNES SANTO	t
28	2016	2016-03-26	SABADO	t
29	2016	2016-03-27	DOMINGO	t
30	2016	2016-04-02	SABADO	t
31	2016	2016-04-03	DOMINGO	t
32	2016	2016-04-09	SABADO	t
33	2016	2016-04-10	DOMINGO	t
34	2016	2016-04-16	SABADO	t
35	2016	2016-04-17	DOMINGO	t
36	2016	2016-04-23	SABADO	t
37	2016	2016-04-24	DOMINGO	t
38	2016	2016-04-30	SABADO	t
39	2016	2016-05-01	DOMINGO	t
40	2016	2016-05-07	SABADO	t
41	2016	2016-05-08	DOMINGO	t
42	2016	2016-05-14	SABADO	t
43	2016	2016-05-15	DOMINGO	t
44	2016	2016-05-21	SABADO	t
45	2016	2016-05-22	DOMINGO	t
46	2016	2016-05-28	SABADO	t
47	2016	2016-05-29	DOMINGO	t
48	2016	2016-06-04	SABADO	t
49	2016	2016-06-05	DOMINGO	t
50	2016	2016-06-11	SABADO	t
51	2016	2016-06-12	DOMINGO	t
52	2016	2016-06-18	SABADO	t
53	2016	2016-06-19	DOMINGO	t
54	2016	2016-06-25	SABADO	t
55	2016	2016-06-26	DOMINGO	t
56	2016	2016-06-29	DIA DE SAN PEDRO Y SAN PABLO	t
57	2016	2016-07-02	SABADO	t
58	2016	2016-07-03	DOMINGO	t
59	2016	2016-07-09	SABADO	t
60	2016	2016-07-10	DOMINGO	t
61	2016	2016-07-16	SABADO	t
62	2016	2016-07-17	DOMINGO	t
63	2016	2016-07-23	SABADO	t
64	2016	2016-07-24	DOMINGO	t
65	2016	2016-07-28	FIESTAS PATRIAS	t
66	2016	2016-07-29	FIESTAS PATRIAS	t
67	2016	2016-07-30	SABADO	t
68	2016	2016-07-31	DOMINGO	t
69	2016	2016-08-06	SABADO	t
70	2016	2016-08-07	DOMINGO	t
71	2016	2016-08-13	SABADO	t
72	2016	2016-08-14	DOMINGO	t
73	2016	2016-08-20	SABADO	t
74	2016	2016-08-21	DOMINGO	t
75	2016	2016-08-27	SABADO	t
76	2016	2016-08-28	DOMINGO	t
77	2016	2016-08-30	DIA DE SANTA ROSA DE LIMA	t
78	2016	2016-09-03	SABADO	t
79	2016	2016-09-04	DOMINGO	t
80	2016	2016-09-10	SABADO	t
81	2016	2016-09-11	DOMINGO	t
82	2016	2016-09-17	SABADO	t
83	2016	2016-09-18	DOMINGO	t
84	2016	2016-09-24	SABADO	t
85	2016	2016-09-25	DOMINGO	t
86	2016	2016-10-01	SABADO	t
87	2016	2016-10-02	DOMINGO	t
88	2016	2016-10-08	SABADO	t
89	2016	2016-10-09	DOMINGO	t
90	2016	2016-10-15	SABADO	t
91	2016	2016-10-16	DOMINGO	t
92	2016	2016-10-22	SABADO	t
93	2016	2016-10-23	DOMINGO	t
94	2016	2016-10-29	SABADO	t
95	2016	2016-10-30	DOMINGO	t
96	2016	2016-11-01	DIA DE TODOS LOS SANTOS	t
97	2016	2016-11-05	SABADO	t
98	2016	2016-11-06	DOMINGO	t
99	2016	2016-11-12	SABADO	t
100	2016	2016-11-13	DOMINGO	t
101	2016	2016-11-19	SABADO	t
102	2016	2016-11-20	DOMINGO	t
103	2016	2016-11-26	SABADO	t
104	2016	2016-11-27	DOMINGO	t
105	2016	2016-12-03	SABADO	t
106	2016	2016-12-04	DOMINGO	t
107	2016	2016-12-08	DIA DE LA INMACULADA CONCEPCION	t
108	2016	2016-12-10	SABADO	t
109	2016	2016-12-11	DOMINGO	t
110	2016	2016-12-17	SABADO	t
111	2016	2016-12-18	DOMINGO	t
112	2016	2016-12-24	SABADO	t
113	2016	2016-12-25	DOMINGO	t
114	2016	2016-12-31	SABADO	t
\.


--
-- TOC entry 2255 (class 0 OID 188638)
-- Dependencies: 228
-- Data for Name: flujo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY flujo (idflujo, idflujoparent, idexpediente, idestadoflujo, idusuario, idusuarioenvia, idusuariorecepciona, bindparent, fechaenvio, fechalectura, asunto, descripcion, observacion, binderror, bindicaleido, idenvio, idrespuesta, titulorespuesta, cuerporespuesta, bindatendido, estado, fecharesolucion, idarea) FROM stdin;
1	\N	1	4	1	1	1	t	2016-11-21 12:31:28.411	2016-11-21 12:34:26.02	RECEPCION	ENVIO AL JEFE DEL AREA PARA LA ATENCION PERTINENTE	ENVIO AL JEFE	f	t	\N	\N	\N	ASD	t	t	2016-11-21 15:04:39.16	2
2	\N	6	1	66	66	9	t	2016-11-22 11:26:02.437	\N	RECEPCION	ENVIO AL JEFE DEL AREA PARA LA ATENCION PERTINENTE	ENVIO AL JEFE	f	f	\N	\N	\N	\N	\N	t	\N	45
\.


--
-- TOC entry 2276 (class 0 OID 414938)
-- Dependencies: 249
-- Data for Name: hexpediente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY hexpediente (idhexpediente, idusuariocargo, idprocedimiento, idarea, idpreexpediente, codigo, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, correo, asunto, nombredocumento, folios, fecharegistro, bindentregado, bindobservado, fecharecepciona, idusuariorecepciona, estado, accion) FROM stdin;
1	1	269	2	0	1	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	REGISTRO DE OFICIO	\N	0	2016-10-03 15:36:09.166	\N	\N	\N	0	t	REGISTRO
1	1	269	2	\N	1	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	REGISTRO DE OFICIO	asdasdasdasdasd	0	2016-10-03 15:36:09.166	f	f	\N	\N	t	ACTUALIZACION
1	1	269	2	\N	1	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	REGISTRO DE OFICIO	asdasdasdasdasd	0	2016-10-03 15:36:09.166	f	f	\N	\N	t	ACTUALIZACION
1	1	269	2	\N	1	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	REGISTRO DE OFICIO	asdasdasdasdasd	0	2016-10-03 15:36:09.166	f	f	\N	\N	f	ELIMINAR
2	9	269	2	0	1	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	asdasd	oficio asdasdasd	15	2016-10-03 15:55:56.374	\N	\N	\N	0	t	REGISTRO
2	1	269	2	\N	1	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	asdasd	oficio asdasdasd	14	2016-10-03 15:55:56.374	f	f	\N	\N	t	ACTUALIZACION
2	1	269	2	\N	1	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	asdasd	oficio asdasdasd	14	2016-10-03 15:57:37.433	f	f	\N	\N	f	ELIMINAR
3	1	269	2	0	1	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	asdasdasd	asdasd	15	2016-10-04 11:28:42.626	\N	\N	\N	0	t	REGISTRO
4	1	11	25	0	2	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	123123	123123	12	2016-10-13 15:38:09.091	\N	\N	\N	0	t	REGISTRO
5	1	11	25	0	3	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	12	12	12	2016-10-13 15:41:56.656	\N	\N	\N	0	t	REGISTRO
6	3	317	45	0	4	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	sin asunto	45127	10	2016-10-14 15:24:30.598	\N	\N	\N	0	t	REGISTRO
7	1	172	43	0	5	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	asdasd	solcitud	12	2016-10-17 14:56:16.356	\N	\N	\N	0	t	REGISTRO
8	1	317	45	0	6	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	asdasd	oficio	12	2016-10-17 14:57:52.381	\N	\N	\N	0	t	REGISTRO
9	3	269	2	0	7	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	CARTA 	ADJUNTO OFICIO	5	2016-10-18 08:35:23.525	\N	\N	\N	0	t	REGISTRO
10	3	269	2	0	8	12345678	JOSE CARLOS	MOLINA QUIJANDRIA	JRO LIBERTAD 458			SOLICITUD DE INFORMACION DEL PORTAL WEB	OFICIO 001 	12	2016-10-18 12:08:42.731	\N	\N	\N	0	t	REGISTRO
10	3	269	2	\N	8	12345678	JOSE CARLOS	MOLINA QUIJANDRIA	JRO LIBERTAD N 458	966565656	jose@hotmail.com	SOLICITUD DE INFORMACION DEL PORTAL WEB	OFICIO 001 	12	2016-10-18 12:09:32.17	f	f	\N	\N	t	ACTUALIZACION
11	1	317	45	0	9	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	SOLICUTD DE INFORMACION DE TRANSPARENCIA	OFICION 001	10	2016-10-18 15:31:35.417	\N	\N	\N	0	t	REGISTRO
12	1	269	2	0	10	12345678	JOSE CARLOS	MOLINA QUIJANDRIA	JRO LIBERTAD N 458	966565656	jose@hotmail.com	TELEFONICA	DOCUMENTO	10	2016-10-19 08:32:19.284	\N	\N	\N	0	t	REGISTRO
12	1	317	45	\N	10	12345678	JOSE CARLOS	MOLINA QUIJANDRIA	JRO LIBERTAD N 458	966565656	jose@hotmail.com	TELEFONICA	DOCUMENTO	10	2016-10-19 08:33:07.079	f	f	\N	\N	t	ACTUALIZACION
13	3	317	45	0	11	12345678	JOSE CARLOS	MOLINA QUIJANDRIA	JRO LIBERTAD N 458	966565656	jose@hotmail.com	ACCESO A LA INFORMACION	OFICIO 001	12	2016-10-19 14:30:17.523	\N	\N	\N	0	t	REGISTRO
14	1	341	45	0	12	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	PRUEBA DE EVENTO	NINGUNO	13	2016-10-26 14:17:23.565	\N	\N	\N	0	t	REGISTRO
15	3	341	45	0	13	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	SIN ASUNTO	2	2	2016-10-27 15:59:07.698	\N	\N	\N	0	t	REGISTRO
16	5	327	45	0	14	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	ASUNTOOOOOO	1	1	2016-10-28 08:41:56.448	\N	\N	\N	0	t	REGISTRO
17	5	317	45	0	15	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	1	1	1	2016-10-28 09:06:13.055	\N	\N	\N	0	t	REGISTRO
18	5	327	45	0	16	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	PRIMER ASUNTO	1	1	2016-10-28 10:22:01.889	\N	\N	\N	0	t	REGISTRO
19	5	341	45	0	17	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	SEGUNDO ASUNTO	2	2	2016-10-28 10:22:20.462	\N	\N	\N	0	t	REGISTRO
20	5	327	45	0	18	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	PRUEBA DE RECEPCION	4	4	2016-10-28 12:30:24.45	\N	\N	\N	0	t	REGISTRO
21	5	341	45	0	19	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	EEEEEE	3	3	2016-10-28 12:37:09.533	\N	\N	\N	0	t	REGISTRO
22	1	317	45	0	20	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	SOLCITA INFORMACION	SOLICTUD	15	2016-10-28 12:43:17.316	\N	\N	\N	0	t	REGISTRO
23	5	341	45	0	21	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	OTRA PRUEBA	5	5	2016-10-28 13:24:34.426	\N	\N	\N	0	t	REGISTRO
24	5	341	45	0	22	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK@gmail.com	4	4	4	2016-11-03 15:08:50.724	\N	\N	\N	0	t	REGISTRO
25	5	341	45	0	23	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	TETETETETE	3	4	2016-11-03 16:32:31.939	\N	\N	\N	0	t	REGISTRO
26	5	341	45	0	24	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	PRUEBA 1	1	1	2016-11-03 16:38:38.698	\N	\N	\N	0	t	REGISTRO
27	5	341	45	0	25	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	ASUNTO PRUEBA1	2	2	2016-11-03 16:42:18.672	\N	\N	\N	0	t	REGISTRO
28	5	341	45	0	26	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	PRUEBA MAÑANA 1	5	4	2016-11-03 16:45:18.997	\N	\N	\N	0	t	REGISTRO
29	5	341	45	0	27	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	PRUEBA MAÑANA2	2	3	2016-11-03 16:45:38.226	\N	\N	\N	0	t	REGISTRO
30	5	341	45	0	28	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	PRUEBA MAÑANA 3	3	5	2016-11-03 16:46:03.544	\N	\N	\N	0	t	REGISTRO
31	1	317	45	0	29	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	ASD	ESCALANTE OLANO	15	2016-11-04 14:01:56.022	\N	\N	\N	0	t	\N
31	1	317	45	\N	29	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	ASD	ESCALANTE OLANO	15	2016-11-04 14:02:21.272	f	f	\N	\N	t	\N
31	1	317	45	\N	29	12345678	JOSE CARLOS	MOLINA QUIJANDRIA	JRO LIBERTAD N 458	966565656	jose@hotmail.com	ASD	ESCALANTE OLANO	15	2016-11-04 14:02:42.574	f	f	\N	\N	t	\N
31	1	317	45	\N	29	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	JOSE CARLOS	ESCALANTE OLANO	15	2016-11-04 14:06:48.763	f	f	\N	\N	t	ACTUALIZACION:MODIFICADO PRUEBA
31	1	317	45	\N	29	43724871	DENIS JACK	OCHOA BERROCAL	JR.TA 107	318759	DJACK	SOLICITO RECOMENDACION	ESCALANTE OLANO	15	2016-11-04 14:09:47.72	f	f	\N	\N	t	ACTUALIZACION:MODIFICADO PARA ATENDER OTRA SOLICITUD
32	1	269	2	0	30	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	ASDASD	SOLICITUD	15	2016-11-04 15:05:15	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
33	1	50	26	0	31	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	ASDASDASD	ASDASDASD	15	2016-11-08 09:25:59.583	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
33	1	269	2	\N	31	70021899	ERICK SIMON 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	970952134	ericks.escalanteolano@gmail.com	ASDASDASD	ASDASDASD	15	2016-11-08 09:26:35.487	f	f	\N	\N	t	ACTUALIZACION:ACTUALIZO POR ESQUIVOCACION
1	1	269	2	0	1	70021899	ERICK 	ESCALANTE OLANO	ASCI	-	ericks.es@gmail.com	SOLICITO INTOMACION ACADEMICA	SOLICITUD	15	2016-11-08 12:55:12.374	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
1	1	269	2	0	1	70021899	ERICK	a	A	a	a	SOLICITO INFORMACION DE PAGINA WEB	SOLI	15	2016-11-08 12:58:32.794	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
2	1	269	2	0	2	70021899	ERICK	a	A	a	a	NINGUNO	INFORME	10	2016-11-08 15:24:13.729	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
3	1	269	2	0	3	70021899	ERICK	a	A	a	a	NINGUNO	SOLCITUD	15	2016-11-10 10:36:25.799	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
4	1	269	2	0	4	70021899	ERICK	a	A	a	a	NUEVO DERIVAR	NUEVO DERIVAR	10	2016-11-10 10:47:47.875	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
1	9	269	2	0	1	70021899	ERICK 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12			NUEVO REGISTRO 01	SOLICUTD	15	2016-11-10 10:52:45.804	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
2	9	269	2	0	2	70021899	ERICK 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	1234	eick	SOLICITA INFORMACION	SOLCIUTD DE INFORMACION	15	2016-11-10 10:56:02.963	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
3	1	269	2	0	3	70021899	ERICK 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12			INFORME DE REVISION DE SISTEMAS	ASD	12	2016-11-10 10:59:22.066	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
4	1	269	2	0	4	70021899	ERICK 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12			ASD	ASD	10	2016-11-10 11:03:56.365	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
5	1	269	2	0	5	70021899	ERICK 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12			ASD	ASD	10	2016-11-10 11:06:03.034	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
6	1	269	2	0	6	70021899	ERICK 	ESCALANTE OLANO	ASOC BASILIO AUQUI MZ Ñ LOTE 12	ASD	ASD	ASD	ASD	15	2016-11-10 11:23:53.78	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
1	9	269	2	0	1	700218899	ASASD	ASD	ASD	asd	asd	ASD	ASDASD	10	2016-11-10 12:15:06.47	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
1	1	269	2	\N	1	700218899	ASASD	ASD	ASD	asd	asd	123123	ASDASD	10	2016-11-11 10:43:56.127	f	f	\N	\N	t	ACTUALIZACION:12
2	3	206	43	0	2	70021899	JOSE CARLOS	QUISPE MENDOZA	JRO LIBERTAD NRO	9666	-	SOLICTA LICENCIA DE CONDUCIR	NINGUNO	12	2016-11-14 12:56:01.876	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
2	3	206	43	\N	2	70021899	JOSE CARLOS	QUISPE MENDOZA	JRO LIBERTAD NRO	9666	-	SOLICITA LA LICENCIA DE CONDUCIR	NINGUNO	12	2016-11-14 12:59:07.814	f	f	\N	\N	t	ACTUALIZACION:POR ERROR DE INGRESO A LA SOLICITUD
3	1	269	2	0	3	12345678	JOSE 	QUISPE QUISPE	DIR	9	e	SOLICUTA INFORMACION	SOLICUTD	15	2016-11-14 16:14:19.733	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
4	1	269	2	0	4	12345678	JOSE 	QUISPE QUISPE	DIR	9	e	NUEVO REGISTRO	A	15	2016-11-14 16:20:27.147	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
5	1	11	25	0	5	12345678	JOSE 	QUISPE QUISPE	DIR	9	e	ASDASD	ASDASD	15	2016-11-21 09:03:20.991	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
5	1	11	25	\N	5	12345678	JOSE 	EWRWERW	DIR	9	e	ASDASD	ASDASD	15	2016-11-21 09:04:58.826	f	f	\N	\N	t	ACTUALIZACION:QWEQWEQWE
6	1	269	2	0	6	12345678	JOSE 	QUISPE QUISPE	DIR	9	e	SOLICTUD	SOLICITUD	10	2016-11-21 09:19:38.004	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
7	1	269	2	0	7	70021899	JOSE CARLOS	QUISPE MENDOZA	JRO LIBERTAD NRO	9666	-	SOLICUTD DE INFORMACION	SOLICITUD	10	2016-11-21 10:02:29.145	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
8	1	269	2	0	8	70021899	JOSE CARLOS	QUISPE MENDOZA	JRO LIBERTAD NRO	9666	-	NINGUNO	SLICTUD	15	2016-11-21 11:02:25.035	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
9	1	269	2	0	9	70021899	JOSE CARLOS	QUISPE MENDOZA	JRO LIBERTAD NRO	9666	-	ASD	ASD	1	2016-11-21 11:54:08.157	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
10	1	269	2	0	10	70021899	JOSE CARLOS	QUISPE MENDOZA	JRO LIBERTAD NRO	9666	-	ASD	ASD	11	2016-11-21 11:59:11.943	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
11	5	327	45	0	11	43724871	DENIS JACK	OCHOA BERROCAL	JR TA Nº 107	066318759	djack@hotmail.com	PRUEBAAAAAA	PRUEBAAAAAA	4	2016-11-21 12:15:11.559	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
1	1	269	2	0	1	70021899	ERICK	ESCALANTE OLANO	ASD			ASD	INORME	15	2016-11-21 12:31:15.889	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
2	5	327	45	0	2	43724871	DENIS JACk	OCHOA BERROCAL	JR TA	00318759	ddd	44444	4444	4	2016-11-22 08:29:39.88	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
3	5	341	45	0	3	43724871	DENIS JACK	OCHOA BERROCAL	JR TA	00318759	ddd	8787877	787878	7	2016-11-22 10:16:38.467	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
4	5	341	45	0	4	43724871	DENIS JACK	OCHOA BERROCAL	JR TA	00318759	ddd	2332	2323	23	2016-11-22 10:45:28.164	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
5	5	341	45	0	5	43724871	DENIS JACK	OCHOA BERROCAL	JR TA	00318759	ddd	54545	55454	4	2016-11-22 11:06:37.414	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
6	5	341	45	0	6	43724871	DENIS JACK	OCHOA BERROCAL	JR TA	00318759	ddd	232323232	23	23	2016-11-22 11:10:57.408	\N	\N	\N	0	t	REGISTRO:NUEVO REGISTRO
\.


--
-- TOC entry 2278 (class 0 OID 450237)
-- Dependencies: 251
-- Data for Name: mensaje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY mensaje (idmensaje, idexpediente, asunto, mensaje, prioridad, bindrespuesta, bindrecepcion, diasrespuesta, idareacioncreacion, idusuariocreacion, fechacreacion, estado) FROM stdin;
1	2	a	a	1	f	t	3	2	1	2016-11-17 16:45:11.455	t
2	0	asd	asd	3	f	f	3	2	1	2016-11-22 08:22:07.279	t
3	1	prueba 02	prueba 02	3	f	t	5	45	2	2016-11-22 09:00:32.63	t
4	6	prueba 03	asd	3	f	t	3	2	1	2016-11-22 12:47:19.785	t
\.


--
-- TOC entry 2242 (class 0 OID 139527)
-- Dependencies: 215
-- Data for Name: modulo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY modulo (idmodulo, denominacion, paginainicio, estado) FROM stdin;
5	asdasd	asdasd	f
4	Tramite	bandeja/ViewBandeja.jsp	f
3	Recepcion Externa	recepcion/ViewRecepcionDoc.jsp	f
6	Recepcion Interna	recepcion/ViewRecepcionInterna.jsp	f
8	Documentos	tramite/ViewDocumento.jsp	f
1	Mesa de Partes	mesa-de-partes	t
2	Administracion	administracion	t
7	Bandeja	bandeja	t
\.


--
-- TOC entry 2243 (class 0 OID 139530)
-- Dependencies: 216
-- Data for Name: preexpediente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY preexpediente (idpreexpediente, idprocedimiento, idarea, dni_ruc, nombre_razonsocial, apellidos, direccion, telefono, correo, asunto, ipenvio, lat, lon, urlcomprobante, codigocomprobante, bindaprobado, estado) FROM stdin;
\.


--
-- TOC entry 2244 (class 0 OID 139536)
-- Dependencies: 217
-- Data for Name: preexpedienterequisito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY preexpedienterequisito (idpreexpedienterequisito, idrequisitos, idpreexpediente, fecha, urlrequisito, estado) FROM stdin;
\.


--
-- TOC entry 2245 (class 0 OID 139542)
-- Dependencies: 218
-- Data for Name: procedimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY procedimiento (idprocedimiento, idcargoresolutor, idarea, codigo, denominacion, plazodias, descripcion, bindweb, estado, idtipoprocedimiento, montototal) FROM stdin;
1	45	11	F-32.31-OSG	1.Acceso a la informacion que posea o produzca la Municipalidad	7	Base Legal TUO de la Ley de Transparencia y Acceso a la Información Pública, Decreto Supremo N° 043-2003-PCM (24-04-03)-Art.11 Reglamento de la Ley de Transparencia y Acceso a la Información Pública, Decreto Supremo Nº 070-2013-PCM, Arts. 5 y 10. (14-06-13). Notas: *El derecho de trámite se establece en función al costo de reproducción del medio que contiene la información solicitada. *Conforme al Reglamento de la Ley de Transparencia y Acceso a la Información Pública, la información solicitada puede ser remitida a la dirección electrónica proporcionada por el solicitante en caso se haya considerado dicho medio para el acceso a la información pública.	\N	t	1	0
2	45	11	F-32.31-OSG	SERVICIOS PRESTADOS EN EXCLUSIVIDAD: 1.Emision de copias simples certificadas de documentos	7	Base Legal Ley Nº 27444 (11.04.01). Arts. 37, 107 y 110	\N	t	1	0
3	104	23	F-32.33-SGO	Apoyo con Maquinaria	2	'	\N	t	1	0
4	104	23	F-32.33-SGO	Apoyo en obra menor	2	'	\N	t	1	0
5	104	23	F-32.33-SGO	Donacion de Materiales	2	'	\N	t	1	0
6	109	24	F-32.34-SGPUyC	2.Certificado de Codigo Unico Catastral	4	Base Legal: Ley N° 27972, Art. 79º, Num. 1.4, 1.4.2 (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley N° 28294, Art. 14º, Num. 5 (21-07-04) D.S. N° 005-2006-JUS, Art. 39º (12-02-06) Directiva 001-2006-SNCP/CNC (17-04-06) R.M. Nº 155-2006-VIVIENDA, Art. 182º (14-06-06)	\N	t	1	0
7	109	24	F-32.34-SGPUyC	3.Certificado de Parametros Urbanisticos y Edificatorios	5	Base Legal: Ley Nº 29090, Art. 14º, Num. 2 (25-09-07) Ley N° 29566, Art. 5° (28-07-2010) D.S. Nº 008-2013-VIVIENDA. Arts. 5, (04-05-13)	\N	t	1	0
8	109	24	F-32.34-SGPUyC	4.Certificado de Zonificacion y Vias	5	Base Legal: Ley Nº 29090, Art. 14º, Num. 2 (25-09-07) Ley N° 29566, Art. 5° (28-07-2010) D.S. Nº 008-2013-VIVIENDA. Arts. 5, (04-05-13)	\N	t	1	0
9	109	24	F-32.34-SGPUyC	5.Certificado Negativo de Codigo Catastral	4	Base Legal: Ley N° 27972, Art. 79º, Num. 1.4, 1.4.2 (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley N° 28294, Art. 14º, Num. 5 (21-07-04) D. S. N° 005-2006-JUS, Art. 39º (12-02-06) Directiva 001-2006-SNCP/CNC (17-04-06) R.M. Nº 155-2006-VIVIENDA, Art. 182º (14-06-06)	\N	t	1	0
10	109	24	F-32.34-SGPUyC	Copia de Planos	1	'	\N	t	1	0
11	112	25	F-32.35-SGCH	6.Licencia de Edificacion - modalidad C Inmuebles declarados bienes integrantes del patrimonio cultural de la Nacion (Aprobacion con evaluacion previa del proyecto por la Comision Tecnica) 6.1.Para Conservacion, restauracion 6.2.Para puesta en valor	25	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 Notas: a)Todos los documentos serán presentados por duplicado b) El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c) Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante. d) La Póliza CAR o la Póliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio. e) Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 días calendarios, en caso de no haberlo declarado en el FUE. f) Se podrá adjuntar las copias de los planos del Anteproyecto aprobado, de encontrarse vigente su aprobación, el cual tendrá efecto vinculante para el procedimiento cuando se trate del mismo proyecto sin modificaciones, aun cuando hayan variado los parámetros urbanísticos y edificatorios con los que fue aprobado. g) En caso de proyectos de gran magnitud, los planos podrán ser presentados en secciones con escala conveniente que permita su fácil lectura, conjuntamente con el plano del proyecto integral. h) Se requiere la intervención del Delegado Ad Hoc del INDECI en proyectos de edificaciones de uso residencial mayores de cinco (5) pisos hasta diez (10) pisos. No se requiere su participación en edificaciones de vivienda de más de cinco (5) pisos en las cuales la circulación común llegue sólo hasta el quinto piso, y el (los) piso(s) superior(es) forme(n) una unidad inmobiliaria. i) Se requiere la intervención del delegado Ad Hoc del CGBVP en proyectos de edificación de uso residencial mayores de diez (10) pisos y las edificaciones establecidas en las modalidades C y D de uso diferente al residencial y de concurrencia masiva de público. j) Después de la notificación del último dictamen Conforme del Proyecto, debe designarse al responsable de obra. k) El inicio de la ejecución de las obras autorizadas estará sujeto a la presentación de los requisitos 17, 18, 19 y 20	t	t	1	0
12	112	25	F-32.35-SGCH	6.Licencia de Edificacion - modalidad C Inmuebles declarados bienes integrantes del patrimonio cultural de la Nacion (Aprobacion con evaluacion previa del proyecto por la Comision Tecnica) 6.3.Obra nueva, ampliacion, a verificacion administrativa remodelacion, acondicionamiento y adecuacion arquitectonica en inmuebles ubicados en el ambito del centro historico y otros	25	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 25 y 31 Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Arts. 3.1, 42.3, 47, 51, 52 y 54, (04-05-13) O.M. N° 037-2007-MPH/A, Art. 184° y 185° (16-08-07)	t	t	1	0
13	112	25	F-32.35-SGCH	6.Licencia de Edificacion - modalidad C Inmuebles declarados bienes integrantes del patrimonio cultural de la Nacion (Aprobacion con evaluacion previa del proyecto por la Comision Tecnica) 6.4.Demoliciones totales de a verificacion administrativa edificaciones (de 5 o mas pisos de altura o aquellas que requieran el uso de explosivos)	25	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 25 y 31 Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Arts. 3.1, 42.3, 47, 51, 52 y 54, (04-05-13) *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante. d)La Póliza CAR o la Póliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio. e)Debe comunicarse el inicio de las obras de demolición con una antelación de 15 días calendarios, en caso de no haberlo declarado en el FUE. f)Después de la notificación del último dictamen Conforme del Proyecto, debe designarse al responsable de obra. g)El inicio de la ejecución de las obras autorizadas estará sujeto a la presentación de los requisitos 14, 15, 16 y 17	\N	t	1	0
14	112	25	F-32.35-SGCH	7.Modificacion de proyectos y/o licencias de edificacion 7.1.Modificacion de proyectos en las modalidad C - comision tecnica (antes de emitida la Licencia de Edificacion)	25	'	\N	t	1	0
15	112	25	F-32.35-SGCH	7.Modificacion de proyectos y/o licencias de edificacion 7.2.Modificacion de licencia en la modalidad C- Comision Tecnica (modificaciones sustanciales)	25	'	\N	t	1	0
16	112	25	F-32.35-SGCH	8.Pre-declaratoria de edificacion (para la Modalidad C)	5	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA Art. 62 y 47 (04-05-13) *Nota: El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene	\N	t	1	0
17	112	25	F-32.35-SGCH	9.Conformidad de obra y declaratoria de edificacion sin variaciones (para la Modalidad C)	5	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA Art. 63 y 47 (04-05-13) *Notas: a)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. b)Solo para edificaciones para fines de vivienda multifamiliar, a solicitud del administrado se podrá extender la Conformidad de Obra a nivel de casco habitable	\N	t	1	0
18	112	25	F-32.35-SGCH	10.Conformidad de obra y declaratoria de edificacion con variacion para edificaciones con licencia modalidad C (para modificaciones no sustanciales	15	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA Art. 64 y 47 (04-05-13) *Nota: El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda firmados por el propietario o por el solicitante y los profesionales que interviene	\N	t	1	0
19	112	25	F-32.35-SGCH	11.Anteproyecto en consulta modalidad C	8	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA Art. 61 (04-05-13) *Nota: Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
20	112	25	F-32.35-SGCH	12.Revalidacion de Licencia de Edificacion	10	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Art. 11. Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 4 (04-05-13) *Nota: La Revalidación de Licencia solo procede para los casos en que la licencia hubiera sido otorgada con posterioridadal 06.10.2003, fecha de publicación del Decreto Supremo Nº 027-2003-VIVIENDA, y será otorgada dentro de los diez (10) días hábiles de presentada	\N	t	1	0
21	112	25	F-32.35-SGCH	13.Prorroga de la licencia de edificacion o de habilitacion urbana	3	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Art. 11 Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 3 (04-05-13) * Nota: La prórroga deberá solicitarse dentro de los 30 días calendarios anteriores al vencimiento de la licencia materia de prórroga	\N	t	1	0
22	112	25	F-32.35-SGCH	14.Autorizacion en area de uso publico para instalacion domiciliaria del servicio de agua, desague	5	Base Legal Ley Orgánica de Municipalidades, Ley Nº 27972 (27.05.03). Art. 79 Decreto Legislativo que establece medidas para propiciar la inversión en materia de servicios públicos y obras públicas de infraestructura, Decreto Legislativo Nº 1014 (16.05.08). Arts. 4 y 5 Decreto Supremo Nº 004-2012- EF (12.02.12) Anexo Nº 03 RCD. Nº 042-2011-SUNASS-CD *Nota: Según lo establecido en el Artículo 4 del D. Leg. Nº 1014, no se podrán establecer montos mayores al 1% UIT vigente por concepto del derecho	\N	t	1	0
23	112	25	F-32.35-SGCH	15.Autorizacion en area de uso publico para instalacion domiciliaria del servicio de energia electrica y telecomunicaciones (antenas)	30	Base Legal Ley Orgánica de Municipalidades, Ley Nº 27972 (27.05.03). Art. 79 Decreto Legislativo que establece medidas para propiciar la inversión en materia de servicios públicos y obras públicas de infraestructura, Decreto Legislativo Nº 1014 (16.05.08). Arts. 4 y 5 Ley para la expansión de infraestructura en Telecomunicaciones, Ley Nº 29022 (20.05.07) Reglamento de la Ley Nº 29022, Decreto Supremo Nº 039-2007-MTC (13.11.07) *Nota: Según lo establecido en el Artículo 4 del D. Leg. Nº 1014, no se podrán establecer montos mayores al 1% UIT vigente por concepto del derecho	\N	t	1	0
24	112	25	F-32.35-SGCH	16.Autorizacion para la ocupacion de area de uso publico con cerco de obras para materiales de construccion e instalaciones provisionales de casetas u otras	30	Base Legal Ley Orgánica de Municipalidades, Ley Nº 27972 (27.05.03). Art. 79 Decreto Legislativo que establece medidas para propiciar la inversión en materia de servicios públicos y obras públicas de infraestructura, Decreto Legislativo Nº 1014 (16.05.08). Arts. 4 y 5. D.S. Nº 01-2006-VIVIENDA Norma G.030, Art. 41º (08-06-06)	\N	t	1	0
25	112	25	F-32.35-SGCH	17.Autorizacion de ubicacion de anuncios toldos y avisos publicitarios 17.1.Para anuncios y avisos publicitarios	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 27 (28-02-12) *Nota: En caso de bienes inmuebles declarados Bienes Culturales Inmuebles de la Nación (Monumentos); la instalación de anuncios publicitarios requiere autorización previa de la Dirección Regional de Cultura	\N	t	1	0
26	112	25	F-32.35-SGCH	17.Autorizacion de ubicacion de anuncios toldos y avisos publicitarios 17.2.Para toldos y parasoles de tela en el centro historico	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 18 y 28 (28-02-12) *Nota: El color del diseño será de color entero y conforme a lo establecido en la cartilla y/o guía vigente, en marco a la O.M. N° 006-2012-MPH/A	\N	t	1	0
27	112	25	F-32.35-SGCH	18.Autorizacion temporal por campaÑas publicitarias o eventos temporales de tipo cultural, institucional y social (hasta por 15 dias) - Gigantografias o banner (madera) - Anuncios tipo pasacalle - Afiches o carteles	4	Base Legal Ley Nº 27972 (27.05.03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 17, num. k y 21 (28-02-12) *Nota: Los afiches o carteleras serán autorizados solamente detrás de los escaparates o vitrinas de mamparas o en lugares autorizados por la Municipalidad	\N	t	1	0
28	112	25	F-32.35-SGCH	19.Autorizacion para la colocacion de los anuncios publicitarios en las carteleras municipales	4	Base Legal Ley Nº 27972 (27.05.03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 41 y 44 (28-02-12) *Nota: Las carteleras Municipales dentro del Centro Histórico seran de 1 m de ancho x 2.10 de alto y podran contener dos (02) afiches de 60 cm x 90 cm cada uno	\N	t	1	0
29	112	25	F-32.35-SGCH	20.Renovacion de la autorizacion de ubicacion de anuncios y avisos publicitarios	4	Nota: En caso de autobuses, taxis y otros vehículos dedicados a la prestación de servicio de transporte público de pasajeros consignara en la solicitud de renovación el número de certificado de operación y su fecha de expedición	\N	t	1	0
72	120	26	F-32.36-SGCUyL	35.Anteproyecto en consulta 35.2.Para las Modalidades C y D	8	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 61 (04-05-13) *Nota: Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
30	112	25	F-32.35-SGCH	21.Certificado de posesion para predio urbano 21.1.Certificado de posesion para instalacion de servicios basicos	3	Base Legal: *Ley Nº 27972 - Art. 79º (27-05-2003) *Ley Nº 27444, Art. 44º, Num* 44.1 (11-04-2001) *Ley Nº 28687, Art. 26º (17-03-2006) *D.S* Nº 017-2006-VIVIENDA, Art. 27º (27-07-2006) *Nota: El Certificado o Constancia de Posesión tendrá vigencia hasta la efectiva instalación de los servicios básicos en el inmueble	\N	t	1	0
31	112	25	F-32.35-SGCH	21.Certificado de posesion para predio urbano 21.2.Certificado de posesion para prescripcion adquisitiva de dominio, rectificacion de area, titulo supletorio	3	Base Legal: *Ley Nº 27972 - Art. 79º (27-05-2003) *Ley Nº 27444, Art. 44º, Num* 44.1 (11-04-2001) *Ley Nº 28687, Art. 26º (17-03-2006) *D.S* Nº 017-2006-VIVIENDA, Art. 27º (27-07-2006)	\N	t	1	0
32	112	25	F-32.35-SGCH	22.Certificado de Numeracion de Inmueble	5	Base Legal: Ley Nº 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 29090, Art. 33º (25-09-07) D.S. Nº 008-2013-VIVIENDA. Arts. 49 (04-05-13)	\N	t	1	0
33	112	25	F-32.35-SGCH	23.Certificado de Codigo Unico Catastral	4	Base Legal: Ley N° 27972, Art. 79º, Num. 1.4, 1.4.2 (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley N° 28294, Art. 14º, Num. 5 (21-07-04) D. S. N° 005-2006-JUS, Art. 39º (12-02-06) Directiva 001-2006-SNCP/CNC (17-04-06) R.M. Nº 155-2006-VIVIENDA, Art. 182º (14-06-06)	\N	t	1	0
34	112	25	F-32.35-SGCH	24.Certificado de Parametros Urbanisticos y Edificatorios	5	Base Legal: Ley Nº 29090, Art. 14º, Num. 2 (25-09-07) Ley N° 29566, Art. 5° (28-07-2010) D.S. Nº 008-2013-VIVIENDA. Art. 5.2 (04-05-13)	\N	t	1	0
35	112	25	F-32.35-SGCH	25.Certificado de Zonificacion y Vias	5	Base Legal: Ley Nº 29090, Art. 14º, Num. 2 (25-09-07) Ley N° 29566, Art. 5° (28-07-2010) D.S. Nº 008-2013-VIVIENDA. Art. 5.1 (04-05-13)	\N	t	1	0
36	112	25	F-32.35-SGCH	SERVICIOS PRESTADOS EN EXCLUSIVIDAD: 1.Visacion de Planos y Memoria Descriptiva	3	Base Legal: Ley Nº 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) R.M. Nº 010-93-JUS TUO CPC, Arts. 504º y 505º (23-04-93) RSNRP N° 248-2008-SUNARP-SN, Art. 20°, (28-08-08)	\N	t	1	0
37	112	25	F-32.35-SGCH	Autorizacion de Rotura de Pistas y Veredas	5	'	\N	t	1	0
38	112	25	F-32.35-SGCH	Autorizacion para Obra Menor	5	'	\N	t	1	0
39	112	25	F-32.35-SGCH	Certificado de Alineamiento	5	'	\N	t	1	0
40	112	25	F-32.35-SGCH	Delimitacion Propiedad Privada	\N	'	\N	t	1	0
41	112	25	F-32.35-SGCH	Duplicado Licencia Obra	\N	'	\N	t	1	0
42	112	25	F-32.35-SGCH	Licencia de Obra para Cerco Perimetrico de Mas de 20m Hasta 1000m de Longitud	\N	'	\N	t	1	0
43	112	25	F-32.35-SGCH	Licencia de Obra para Demolicion	\N	'	\N	t	1	0
44	120	26	F-32.36-SGCUyL	26.Licencia de Edificacion-Modalidad A 26.1.Vivienda unifamiliar de hasta 120 m2 construidos (siempre que constituya la unica edificacion en el lote)	1	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090. 2) Las obras que requieran la ejecución de sótanos o semisótanos, a una profundidad de excavación mayor a 1.50 m. y colinden con edificaciones existentes. *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante. d)Se podrá optar por la presentación de un proyecto adquirido en el Banco de Proyectos de la Municipalidad respectiva	\N	t	1	0
45	120	26	F-32.36-SGCUyL	26.Licencia de Edificacion-Modalidad A 26.2.Ampliacion de vivienda unifamiliar (la sumatoria del area construida existente y la proyectada no deben exceder los 200 m2)	1	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090. 2)Las obras que requieran la ejecución de sótanos o semisótanos, a una profundidad de excavación mayor a 1.50 m. y colinden con edificaciones existentes *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
46	120	26	F-32.36-SGCUyL	26.Licencia de Edificacion-Modalidad A 26.3.Ampliaciones consideradas obras menores (segun lo establecido en el Reglamento Nacional de Edificaciones RNE)	1	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090. 2) Las obras que requieran la ejecución de sótanos o semisótanos, a una profundidad de excavación mayor a 1.50 m. y colinden con edificaciones existentes *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
47	120	26	F-32.36-SGCUyL	26.Licencia de Edificacion-Modalidad A 26.4.Remodelacion de vivienda unifamiliar (sin modificacion estructural ni cambio de uso, ni aumento de area construida)	1	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090. 2)Las obras que requieran la ejecución de sótanos o semisótanos, a una profundidad de excavación mayor a 1.50 m. y colinden con edificaciones existentes *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
116	120	26	F-32.36-SGCUyL	Revalidacion de Licencia de Edificacion(Despues de su Vencimiento)	\N	'	\N	t	1	0
48	120	26	F-32.36-SGCUyL	26.Licencia de Edificacion-Modalidad A 26.5.Construccion de cercos (de mas de 20 ml, siempre que el inmueble no se encuentre bajo el regimen de propiedad exclusiva y propiedad comun)	1	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090. 2)Las obras que requieran la ejecución de sótanos o semisótanos, a una profundidad de excavación mayor a 1.50 m. y colinden con edificaciones existentes *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
49	120	26	F-32.36-SGCUyL	26.Licencia de Edificacion-Modalidad A 26.6.Demolicion total (de edificaciones menores de 5 pisos de altura)	1	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090. 2) Demoliciones que requieran el uso de explosivos *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
50	120	26	F-32.36-SGCUyL	26.Licencia de Edificacion-Modalidad A 26.7.Obras de caracter militar (de las Fuerzas Armadas), de caracter policial (Policia Nacional del Peru) y establecimientos penitenciarios	1	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090 *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
51	120	26	F-32.36-SGCUyL	27.Licencia de Edificacion-Modalidad B 27.1.Edificaciones para fines de vivienda unifamiliar, multifamiliar, quinta o condominios de vivienda unifamiliar y/o multifamiliar (no mayores a 5 pisos siempre que el proyecto tenga un maximo de 3,000 m2. de area construida	15	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090 *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesionales responsable de los mismos y firmados por el propietario o solicitante. d)La Poliza CAR o la Poliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio. e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 dias calendarios, en caso de no haberlo declarado en el FUE	\N	t	1	0
52	120	26	F-32.36-SGCUyL	27.Licencia de Edificacion-Modalidad B 27.2.Cercos (en inmuebles que se encuentren bajo el regimen de propiedad exclusiva y propiedad comun)	15	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090 *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante. e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 dias calendarios, en caso de no haberlo declarado en el FUE	\N	t	1	0
53	120	26	F-32.36-SGCUyL	27.Licencia de Edificacion-Modalidad B 27.3.Obras de ampliacion o remodelacion de una edificacion existente (con modificacion estructural, aumento del area construida o cambio de uso)	15	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090. A solicitud del Administrado: Se podrá solicitar licencia para obras de ampliación, remodelación y demolición parcial en un mismo expediente debiendo presentarse los requisitos exigidos para cada uno de estos procedimientos *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesionales responsable de los mismos y firmados por el propietario o solicitante. d)La Poliza CAR o la Poliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio. e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 días calendarios, en caso de no haberlo declarado en el FUE	\N	t	1	0
73	120	26	F-32.36-SGCUyL	36.Licencia de edificacion en vias de regularizacion (solo para edificaciones construidas sin licencia o que no tengan conformidad de obra y que hayan sido ejecutadas entre el 20 de julio de 1999 hasta el 27 de setiembre de 2008)	15	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA ,Art. 69 (04-05-13) *Notas: a)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y el profesional que interviene. b) Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable o constatador de los mismos y firmados por el propietario o solicitante. c) La regularización de edificaciones que cuenten con Licencia y no tengan conformidad de obra, no estan afectas al pago de multa por construir sin licencia 27 de setiembre de 2008	\N	t	1	0
117	142	29	F-37.39-SGECDyR	Alquiler de Complejo Deportivo (Maravillas)	\N	'	\N	t	1	0
54	120	26	F-32.36-SGCUyL	27.Licencia de Edificacion-Modalidad B 27.4.Demolicion parcial	15	No están consideradas en esta modalidad: 1) Las obras de edificación en bienes inmuebles que constituyan Patrimonio Cultural de la Nación declarado por el Ministerio de Cultura, e incluida en la lista a la que se hace referencia en el inciso f) del Art. 3 numeral 2 de la Ley N° 29090 *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesionales responsable de los mismos y firmados por el propietario o solicitante. d)La Poliza CAR o la Poliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio. e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 días calendarios, en caso de no haberlo declarado en el FUE	\N	t	1	0
55	120	26	F-32.36-SGCUyL	28.Licencia de edificacion-Modalidad C (Aprobacion con evaluacion previa del proyecto por la Comision Tecnica) 28.1.Para vivienda multifamiliar, quinta o condominios que incluyan vivienda multifamiliar (de mas de 5 pisos y/o mas de 3,000 m2 de area construida). 28.2.Edificaciones para fines diferentes de vivienda (a excepcion de las previstas en la Modalidad D). 28.3.Edificaciones de uso mixto con vivienda. 28.4.Intervenciones que se desarrollen en bienes culturales inmuebles (previamente declarados). 28.5.Edificaciones para localescomerciales, culturales, centros de diversion y salas de espectaculos (que individualmente o en conjunto cuenten con un maximo de 30,000 m2 de area construida). 28.6.Edificaciones para mercados (que cuenten con un maximo de 15,000 m2 de area construida). 28.7.Locales para espectaculos deportivos (de hasta 20,000 ocupantes). 28.8.Todas las demas edificaciones no contempladas en las Modalidades A, B y D	25	Notas: a)Todos los documentos serán presentados por duplicado. b) El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesionales responsable de los mismos y firmados por el propietario o solicitante. d)La Poliza CAR o la Poliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 dias calendarios, en caso de no haberlo declarado en el FUE. f)Se podrá adjuntar las copias de los planos del Anteproyecto aprobado, de encontrarse vigente su aprobación, el cual tendrá efecto vinculante para el procedimiento cuando se trate del mismo proyecto sin modificaciones, aún cuando hayan variado los parámetros urbanísticos y Edificatorios con los que fue aprobado. g)En caso de proyectos de gran magnitud, los planos podrán ser presentados en secciones con escala conveniente que permita su fácil lectura, conjuntamente con el plano del proyecto integral. h)Se requiere la intervención del Delegado Ad Hoc del INDECI en proyectos de edificaciones de uso residencial mayores de cinco (5) pisos hasta diez (10) pisos. No se requiere su participación en edificaciones de vivienda de más de cinco (5) pisos en las cuales la circulación común llege sólo Hasta el quinto piso, y el (los) piso(s) superior(es) forme(n) una unidad inmobiliaria. i)Se requiere la intervención del delegado Ad Hoc del CGBVP en proyectos de edificación de uso residencial mayores de diez (10) pisos y las edificaciones establecidas en las modalidades C y D de uso diferente al residencial y de concurrencia masiva de público. j)Despues de la notificación del último dictámen Conforme del Proyecto, debe designarse al responsable de obra. k)El inicio de la ejecución de las obras autorizadas estará sujeto a la presentación de los requisitos 15, 16, 17 y 18	\N	t	1	0
56	120	26	F-32.36-SGCUyL	28.Licencia de Edificacion-Modalidad C (Aprobacion con evaluacion previa del proyecto por la Comision Tecnica) 28.9.Demoliciones totales de edificaciones (de 5 o mas pisos de altura o aquellas que requieran el uso de explosivos)	25	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 25 y 31. Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Arts. 3.1, 42.3, 47, 51, 52 y 54, (04-05-13) *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesionales responsable de los mismos y firmados por el propietario o solicitante. d)La Poliza CAR o la Poliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 dias calendarios, en caso de no haberlo declarado en el FUE. f)Despues de la notificación del último dictámen Conforme del Proyecto, debe designarse al responsable de obra. g)El inicio de la ejecución de las obras autorizadas estará sujeto a la presentación de los requisitos 14, 15, 16 y 17	\N	t	1	0
57	120	26	F-32.36-SGCUyL	29.Licencia de Edificacion-Modalidad C (Aprobacion con evaluacion previa del proyecto por Revisores Urbanos) 29.1.Para vivienda multifamiliar, quinta o condominios que incluyan vivienda multifamiliar (de mas de 5 pisos y/o mas de 3,000 m2 de area construida). 29.2.Edificaciones para fines diferentes de vivienda (a excepcion de las previstas en la Modalidad D). 29.3.Edificaciones de uso mixto con vivienda. 29.4.Intervenciones que se desarrollen en bienes culturales inmuebles (previamente declarados). 29.5.Edificaciones para locales comerciales, culturales, centros de diversion y salas de espectaculos (que individualmente o en conjunto cuenten con un maximo de 30,000 m2 de area construida). 29.6.Edificaciones para mercados (que cuenten con un maximo de 15,000 m2 de area construida). 29.7.Locales para espectaculos deportivos (de hasta 20,000 ocupantes). 29.8.Todas las demas edificaciones no contempladas en las Modalidades A, B y D	5	Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesionales responsable de los mismos y firmados por el propietario o solicitante. d)La Poliza CAR o la Poliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 dias calendarios, en caso de no haberlo declarado en el FUE. f)Se podrá adjuntar las copias de los planos del Anteproyecto aprobado, de encontrarse vigente su aprobación, el cual tendrá efecto vinculante para el procedimiento cuando se trate del mismo proyecto sin modificaciones, aún cuando hayan variado los parámetros urbanísticos y edificatorios con los que fue aprobado. g)En caso de proyectos de gran magnitud, los planos podrán ser presentados en secciones con escala conveniente que permita su fácil lectura, conjuntamente con el plano del proyecto integral. h)El inicio de la ejecución de las obras autorizadas estará sujeto a la presentación de los requisitos 14, 15, 16 y 17	\N	t	1	0
58	120	26	F-32.36-SGCUyL	29.Licencia de Edificacion-Modalidad C (Aprobacion con evaluacion previa del proyecto por Revisores Urbanos) 29.9.Demoliciones totales de edificaciones (de 5 o mas pisos de altura o aquellas que requieran el uso de explosivos)	5	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 25 y 31. Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Arts. 42.3, 47, 51, 57 y 58, (04-05-13) *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesionales responsable de los mismos y firmados por el propietario o solicitante. d)La Poliza CAR o la Poliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 dias calendarios, en caso de no haberlo declarado en el FUE. f)El inicio de la ejecución de las obras autorizadas estará sujeto a la presentación de los requisitos 15, 16, 17 y 18	\N	t	1	0
74	120	26	F-32.36-SGCUyL	37.Revalidacion de licencia de edificacion o de habilitacion urbana	10	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Art. 11. Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 4 (04-05-13) *Nota: La Revalidación de Licencia solo procede para los casos en que la licencia hubiera sido otorgada con posterioridadal 06.10.2003, fecha de publicación del Decreto Supremo Nº 027-2003-VIVIENDA, y será otorgada dentro de los diez (10) días hábiles de presentada	\N	t	1	0
75	120	26	F-32.36-SGCUyL	38.Prorroga de la licencia de edificacion o de habilitacion urbana	3	Base Legal Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Art. 11. Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 3 (04-05-13)	\N	t	1	0
59	120	26	F-32.36-SGCUyL	30.Licencia de Edificacion-Modalidad D (Aprobacion con evaluacion previa del proyecto por la Comision Tecnica) 30.1.Edificaciones para fines de industria. 30.2.Edificaciones para locales comerciales, culturales, centros de diversion y salas de espectaculos (que individualmente o en conjunto cuenten con mas de 30,000 m2 de area construida). 30.3.Edificaciones para mercados (que cuenten con mas de 15,000 m2 de area construida). 30.4.Locales de espectaculos deportivos (de mas de 20,000 ocupantes). 30.5.Edificaciones para fines educativos, salud, hospedaje, establecimientos de expendio de combustibles y terminales de transporte	25	Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesionales responsable de los mismos y firmados por el propietario o solicitante. d)La Poliza CAR o la Poliza de Responsabilidad Civil se entrega el día útil anterior al inicio de la obra y debe tener una vigencia igual o mayor a la duración del proceso edificatorio e)Debe comunicarse el inicio del proceso edificatorio con una antelación de 15 dias calendarios, en caso de no haberlo declarado en el FUE. f)Se podrá adjuntar las copias de los planos del Anteproyecto aprobado, de encontrarse vigente su aprobación, el cual tendrá efecto vinculante para el procedimiento cuando se trate del mismo proyecto sin modificaciones, aún cuando hayan variado los parámetros urbanísticos y Edificatorios con los que fue aprobado. g)En caso de proyectos de gran magnitud, los planos podrán ser presentados en secciones con escala conveniente que permita su fácil lectura, conjuntamente con el plano del proyecto integral. h)Se requiere la intervención del Delegado Ad Hoc del INDECI en proyectos de edificaciones de uso residencial mayores de cinco (5) pisos hasta diez (10) pisos. No se requiere su participación en edificaciones de vivienda de más de cinco (5) pisos en las cuales la circulación común llege sólo Hasta el quinto piso, y el (los) piso(s) superior(es) forme(n) una unidad inmobiliaria. i)Se requiere la intervención del delegado Ad Hoc del CGBVP en proyectos de edificación de uso residencial mayores de diez (10) pisos y las edificaciones establecidas en las modalidades C y D de uso diferente al residencial y de concurrencia masiva de público. j)Despues de la notificación del último dictámen Conforme del Proyecto, debe designarse al responsable de obra. k)El inicio de la ejecución de las obras autorizadas estará sujeto a la presentación de los requisitos 15, 16, 17 y 18	\N	t	1	0
60	120	26	F-32.36-SGCUyL	31.Modificacion de proyectos y/o Licencias de Edificacion 31.1.Modificacion de proyectos en la Modalidad B (antes de emitida la Licencia de Edificacion)	15	'	\N	t	1	0
61	120	26	F-32.36-SGCUyL	31.Modificacion de proyectos y/o Licencias de Edificacion 31.2.Modificacion de proyectos en las modalidades C y D - Comision tecnica (antes de emitida la Licencia de Edificacion)	25	'	\N	t	1	0
62	120	26	F-32.36-SGCUyL	31.Modificacion de proyectos y/o Licencias de Edificacion 31.3.Modificacion de licencia en la Modalidad A (modificaciones sustanciales)	25	'	\N	t	1	0
63	120	26	F-32.36-SGCUyL	31.Modificacion de proyectos y/o Licencias de Edificacion 31.4.Modificacion de licencia en la Modalidad B (modificaciones sustanciales)	15	'	\N	t	1	0
64	120	26	F-32.36-SGCUyL	31.Modificacion de proyectos y/o Licencias de Edificacion 31.5.Modificacion de licencia en la modalidad C y D - Comision tecnica (modificaciones sustanciales)	25	'	\N	t	1	0
65	120	26	F-32.36-SGCUyL	31.Modificacion de proyectos y/o Licencias de Edificacion 31.6.Modificacion de licencia en la Modalidad C - Revisores urbanos (modificaciones sustanciales)	5	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 47, 50, 51, 52, 57 y 60, (04-05-13) *Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c)Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y por los Revisores Urbanos; y firmados por el propietario o solicitante. d)Las modificaciones no sustanciales, son aquellas que no implican disminución de los parámetros urbanísticos y edificatorios aplicables, disminución de las condiciones mínimas de diseño previstas en el Reglamento Nacional de Edificaciones, aumento del área techada, incremento de la densidad neta y/o cambio de uso; las cuales podrán ser regularizadas en el trámite de Conformidad de Obra. e)En caso las modificaciones propuestas generen un cambio de modalidad de aprobación, éstas deberán ser aprobadas de acuerdo a lo regulado para la nueva modalidad, debiendo cumplir con los requisitos exigidos para ella. No aplicable para licencias otorgadas en la Modalidad A	\N	t	1	0
66	120	26	F-32.36-SGCUyL	32.Pre-Declaratoria de edificacion (para todas las Modalidades: A, B, C y D)	5	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA Art. 62 y 47 (04-05-13) Nota: b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene *Nota: El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene	\N	t	1	0
67	120	26	F-32.36-SGCUyL	33.Conformidad de obra y declaratoria de edificacion sin variaciones (para todas las Modalidades: A, B, C y D)	5	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 63 y 47 (04-05-13) *Notas: a)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. b)Solo para edificaciones para fines de vivienda multifamiliar, a solicitud del administrado se podrá extender la Conformidad de Obra a nivel de casco habitable	\N	t	1	0
68	120	26	F-32.36-SGCUyL	34.Conformidad de obra y declaratoria de edificacion con variaciones (para modificaciones no sustanciales	5	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 64 y 47 (04-05-13) *Nota: El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene	\N	t	1	0
69	120	26	F-32.36-SGCUyL	34.Conformidad de obra y declaratoria de edificacion con variaciones (para modificaciones no sustanciales	10	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 64 y 47 (04-05-13) *Nota: El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene	\N	t	1	0
70	120	26	F-32.36-SGCUyL	34.Conformidad de obra y declaratoria de edificacion con variaciones (para modificaciones no sustanciales	15	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 64 y 47 (04-05-13) *Nota: El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene	\N	t	1	0
71	120	26	F-32.36-SGCUyL	35.Anteproyecto en consulta 35.1.Para las Modalidades A y B	3	Base Legal Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA, Art. 61 (04-05-13) *Nota: Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	t	1	0
76	120	26	F-32.36-SGCUyL	39.Licencia de habilitacion urbana a verificacion administrativa Modalidad B	20	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 16 y 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Arts. 17, 25 y 32, (04-05-13) Se sujetan a esta modalidad: a) Las habilitaciones urbanas de unidades prediales no mayores de cinco (05) hectáreas que constituyan islas rústicas y que conformen un lote único, siempre y cuandoel lote no se encuentre afecto al Plan Víal Provincial o Metropolitano. b) Las habilitaciones urbanas de predios que cuenten con un Planeamiento Integralaprobado con anterioridad.	\N	t	1	0
77	120	26	F-32.36-SGCUyL	40.Licencia de habilitacion urbana Modalidad C (Aprobacion con evaluacion previa del proyecto por Revisores Urbanos)	5	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 16 y 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA y modificatorias (27.09.08). Arts. 17, 25, 33 y 34, (04-05-13) Se sujetan a esta modalidad: a) Las habilitaciones urbanas que se vayan a ejecutar por etapas con sujeción a un Planeamiento Integral. b) Las habilitaciones urbanas con construcción simultánea que soliciten venta garantizada de lotes. c) Las habilitaciones urbanas con construcción simultánea de viviendas en las que el número, dimensiones de lotes a habilitar y tipo de viviendas a edificar se definan en el proyecto, siempre que su finalidad sea la venta de viviendas edificadas	\N	t	1	0
78	120	26	F-32.36-SGCUyL	41.Licencia de habilitacion urbana Modalidad C (Aprobacion con evaluacion previa del proyecto por la Comision Tecnica)	50	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 16 y 31 *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA - Arts. 17 25, 32 y 33, (04-05-13) Se sujetan a esta modalidad: a) Las habilitaciones urbanas que se vayan a ejecutar por etapas con sujeción a un Planeamiento Integral. b) Las habilitaciones urbanas con construcción simultánea que soliciten venta garantizada de lotes. c) Las habilitaciones urbanas con construcción simultánea de viviendas en las que el número, dimensiones de lotes a habilitar y tipo de viviendas a edificar se definan en el proyecto, siempre que su finalidad sea la venta de viviendas edificadas.	\N	t	1	0
79	120	26	F-32.36-SGCUyL	42.Licencia de habilitacion urbana Modalidad D (Aprobacion con evaluacion previa del proyecto por la Comision Tecnica)	50	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 16 y 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA - Arts. 17 25, 32 y 33, (04-05-13) Se sujetan a esta modalidad: a) Las habilitaciones urbanas de predios que no colinden con áreas urbanas o que dichas áreas aledañas cuenten con proyectos de habilitación urbana aprobados y no ejecutados, por tanto, la habilitación urbana del predio requiera de la formulación de un Planeamiento Integral b) Las habilitaciones urbanas de predios que colinden con Zonas Arqueológicas, inmuebles previamente declarados como bienes culturales, o con Áreas Naturales Protegidas. c) Para fines industriales, comerciales o usos especiales.	\N	t	1	0
80	120	26	F-32.36-SGCUyL	43.Modificacion de proyectos de habilitacion urbana (Modalidad B)	10	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 16 y 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Art. 35, (04-05-13)	\N	t	1	0
81	120	26	F-32.36-SGCUyL	43.Modificacion de proyectos de habilitacion urbana (Modalidad C (Revisor Urbano))	5	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 16 y 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Art. 35, (04-05-13)	\N	t	1	0
82	120	26	F-32.36-SGCUyL	43.Modificacion de proyectos de habilitacion urbana (Modalidad C y D (Comision Tecnica))	20	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 10, 16 y 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Art. 35, (04-05-13)	\N	t	1	0
83	120	26	F-32.36-SGCUyL	44.Recepcion de obras de habilitacion urbana 44.1.Sin variaciones (Modalidades B, C y D)	10	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 19 y 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Arts. 25 y 36 (04-05-13)	\N	t	1	0
84	120	26	F-32.36-SGCUyL	44.Recepcion de obras de habilitacion urbana 44.2.Con variaciones que no se consideren sustanciales (Modalidad B, C y D con Revisores Urbanos y Comision Tecnica)	10	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 19 y 31 *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Arts. 25 y 36 (04-05-13)	\N	t	1	0
85	120	26	F-32.36-SGCUyL	45.Independizacion o parcelacion de terrenos rusticos	10	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Arts. 25, 27 y 28, (04-05-13)	\N	t	1	0
86	120	26	F-32.36-SGCUyL	46.Subdivision de lote urbano	10	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Art. 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Arts. 25, 29 y 30, (04-05-13)	\N	t	1	0
87	120	26	F-32.36-SGCUyL	47.Regularizacion de habilitaciones urbanas ejecutadas	20	Base Legal *Ley de Regulación de Habilitaciones Urbanas y de Edificaciones, Ley Nº 29090 y modificatorias (25.09.07). Arts. 30 y 31. *Reglamento de Licencias de Habilitación Urbana y Licencias de Edificación, Decreto Supremo Nº 008-2013-VIVIENDA. Arts. 25, 38 y 39, (04-05-13)	\N	t	1	0
88	120	26	F-32.36-SGCUyL	48.Autorizacion en area de uso publico para instalacion domiciliaria del servicio de agua, desague	5	Base Legal Ley Orgánica de Municipalidades, Ley Nº 27972 (27.05.03). Art. 79. Decreto Legislativo que establece medidas para propiciar la inversión en materia de servicios públicos y obras públicas de infraestructura, Decreto Legislativo Nº 1014 (16.05.08). Arts. 4 y 5. Decreto Supremo Nº 004-2012- EF (12.02.12). Anexo Nº 03. RCD. Nº 042-2011-SUNASS-CD. Ley N° 30056, Art. 5 (02-07-2013)	\N	t	1	0
115	120	26	F-32.36-SGCUyL	Revalidacion de Licencia de Edificacion(Antes de su Vencimiento)	\N	'	\N	t	1	0
89	120	26	F-32.36-SGCUyL	49.Autorizacion en area de uso publico para instalacion domiciliaria del servicio de energia electrica y telecomunicaciones (antenas)	30	Base Legal Ley Orgánica de Municipalidades, Ley Nº 27972 (27.05.03). Art. 79. Decreto Legislativo que establece medidas para propiciar la inversión en materia de servicios públicos y obras públicas de infraestructura, Decreto Legislativo Nº 1014 (16.05.08). Arts. 4, 5 Ley para la expansión de infraestructura en Telecomunicaciones, Ley Nº 29022 (20.05.07). Reglamento de la Ley Nº 29022, Decreto Supremo Nº 039-2007-MTC (13.11.07).	\N	t	1	0
90	120	26	F-32.36-SGCUyL	50.Autorizacion para la ocupacion de area de uso publico con cerco de obras para materiales de construccion e instalaciones provisionales de casetas u otras	30	Base Legal Ley Orgánica de Municipalidades, Ley Nº 27972 (27.05.03). Art. 79. Decreto Legislativo que establece medidas para propiciar la inversión en materia de servicios públicos y obras públicas de infraestructura, Decreto Legislativo Nº 1014 (16.05.08).	\N	t	1	0
91	120	26	F-32.36-SGCUyL	51.Autorizacion para instalacion de cableado subterraneo (Redes de Telecomunicaciones) (No incluye ningun tipo de canalizacion subterranea)	30	Base Legal Ley Orgánica de Municipalidades, Ley Nº 27972 (27.05.03). Art. 79. Ley para la expansión de infraestructura en Telecomunicaciones, Ley Nº 29022 (20.05.07). Arts. 2, literal c, 5 y 7. Reglamento de la Ley Nº 29022, Decreto Supremo Nº 039-2007-MTC (13.11.07). Arts. 4, 6, 11 y 12. TUO de la Ley de Telecomunicaciones, Decreto Supremo Nº 013-93-TCC (06.05.93). Art. 33. Decreto Legislativo que establece medidas para propiciar la inversión en materia de servicios públicos y obras públicas de infraestructura, Decreto Legislativo Nº 1014 (16.05.08). Ley Nº 29432 (09.11.09) que prorroga la Cuarta disposicion Transitoria y Final de la Ley 29022 Ley Nº 29868 (29.05.12) que restablece la vigencia de la Ley 29022	\N	t	1	0
92	120	26	F-32.36-SGCUyL	52.Certificado de posesion para predio urbano 52.1.Certificado de posesion para instalacion de servicios basicos	3	Base Legal: *Ley Nº 27972 - Art. 79º (27-05-2003) *Ley Nº 27444, Art. 44º, Num* 44.1 (11-04-2001) Ley Nº 28687, Art. 26º (17-03-2006) *D.S* Nº 017-2006-VIVIENDA, Art. 27º (27-07-2006)	\N	t	1	0
93	120	26	F-32.36-SGCUyL	52.Certificado de posesion para predio urbano 52.2.Certificado de posesion para prescripcion adquisitiva de dominio, rectificacion de area, titulo supletorio	3	Base Legal: *Ley Nº 27972 - Art. 79º (27-05-2003) *Ley Nº 27444, Art. 44º, Num* 44.1 (11-04-2001) *Ley Nº 28687, Art. 26º (17-03-2006) *D.S* Nº 017-2006-VIVIENDA, Art. 27º (27-07-2006)	\N	t	1	0
94	120	26	F-32.36-SGCUyL	53.Certificado de numeracion de inmueble	5	Base Legal: Ley Nº 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 29090, Art. 33º (25-09-07) D.S. Nº 008-2013-VIVIENDA. Arts. 49 (04-05-13)	\N	t	1	0
95	120	26	F-32.36-SGCUyL	54.Delimitacion de propiedad privada	5	Base Legal: Ley Nº 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) R.M. Nº 010-93-JUS TUO CPC, Arts. 504º y 505º (23-04-93)	\N	t	1	0
96	120	26	F-32.36-SGCUyL	55.Autorizacion para extraccion de materiales de los alveos o cauces de los rios	30	Base legal Ley Nº 27972, Arts. 69º y 79º (27-05-03) Ley Nº 28221, Arts. 1º, 3º y 6º (11-05-04)	\N	t	1	0
97	120	26	F-32.36-SGCUyL	56.Autorizacion de ubicacion de anuncios y avisos publicitarios 56.1.Para anuncios sencillos	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 29, (28-02-12)	\N	t	1	0
98	120	26	F-32.36-SGCUyL	56.Autorizacion de ubicacion de anuncios y avisos publicitarios 56.2.Para paneles monumentales	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 29, (28-02-12)	\N	t	1	0
99	120	26	F-32.36-SGCUyL	56.Autorizacion de ubicacion de anuncios y avisos publicitarios 56.3.Para avisos luminosos, iluminados o de proyeccion	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 29, (28-02-12)	\N	t	1	0
100	120	26	F-32.36-SGCUyL	57.Autorizacion temporal por campaÑas de publicidad exterior (hasta 1 mes) - Banderolas - Gigantografias - Afiches o carteles - Objetos inflables	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 21, (28-02-12)	\N	t	1	0
101	120	26	F-32.36-SGCUyL	58.Autorizacion para la colocacion de los anuncios publicitarios en las carteleras municipales	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 41,44, (28-02-12)	\N	t	1	0
102	120	26	F-32.36-SGCUyL	59.Renovacion de la autorizacion de ubicacion de anuncios y avisos publicitarios 59.1.Para anuncios sencillos, avisos luminosos, iluminados o de proyeccion	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 31, (28-02-12)	\N	t	1	0
103	120	26	F-32.36-SGCUyL	59.Renovacion de la autorizacion de ubicacion de anuncios y avisos publicitarios 59.2.Para paneles monumentales	4	Base Legal: Ley N° 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) Ley Nº 28976 Art. 10º, (05-02-2007) O.M. N° 006-2012-MPH/A, Art. 31, (28-02-12)	\N	t	1	0
104	120	26	F-32.36-SGCUyL	SERVICIOS PRESTADOS EN EXCLUSIVIDAD: 1.Visacion de plano y memoria descriptiva	3	Base Legal: Ley Nº 27972, Art. 79º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) R.M. Nº 010-93-JUS TUO CPC, Arts. 504º y 505º (23-04-93) RSNRP N° 248-2008-SUNARP-SN, Art. 20°, (28-08-08)	\N	t	1	0
105	120	26	F-32.36-SGCUyL	Autorizacion de Rotura de Pistas y Veredas y o Apertura de Zanjas	5	'	\N	t	1	0
106	120	26	F-32.36-SGCUyL	Autorizacion para Obra Menor	\N	'	\N	t	1	0
107	120	26	F-32.36-SGCUyL	Certificado de Alineamiento	\N	'	\N	t	1	0
108	120	26	F-32.36-SGCUyL	Certificado de Indices de Estacionamiento	\N	'	\N	t	1	0
109	120	26	F-32.36-SGCUyL	Certificado Ubicacion de Predio Dentro o Fuera del Area de Expansion Urbana	\N	'	\N	t	1	0
110	120	26	F-32.36-SGCUyL	Duplicado de Licencia de Obra	\N	'	\N	t	1	0
111	120	26	F-32.36-SGCUyL	Planeamiento Integral	8	'	\N	t	1	0
112	120	26	F-32.36-SGCUyL	Rectificacion de Resolucion Gerencial	1	'	\N	t	1	0
113	120	26	F-32.36-SGCUyL	Regularizacion de Habilitacion Urbana	\N	'	\N	t	1	0
114	120	26	F-32.36-SGCUyL	Regularizacion de Licencia de Edificacion	1	'	\N	t	1	0
118	142	29	F-37.39-SGECDyR	Alquiler del Local Cine Teatro Municipal	15	'	\N	t	1	0
119	154	31	F-38.41-SGPV	60.Certificado Domiciliario	2	Base Legal: Ley N º 28862 Ley que elimina la atribución a la PNP a expedir certificados domiciliarios del numeral 4 del artículo 8º de la Ley Nº 27238, Ley de la PNP.	\N	t	1	0
120	154	31	F-38.41-SGPV	61.Registro y Reconocimiento de las Organizaciones Sociales en el Registro Unico de Organizaciones Sociales (RUOS)	3	Base Legal: Ley Nº 27972, Art. 84º (27-05-09). O. M. Nº 009-2001-MPH/A (27-05-03) 	\N	t	1	0
121	154	31	F-38.41-SGPV	62.Actualizacion de Organizaciones Sociales Inscritas en el Registro Unico de Organizaciones Sociales (ROUS)	3	Base Legal: O. M. Nº 009-2001-MPH/A (27-05-03) a) Cambio de nombre o denominación b) Cambio de domicilio c) Aumento o disminución del número de miembros	\N	t	1	0
122	149	30	F-37.40-SGPAyN	Creacion de Albergues, Casa Hogares	\N	'	\N	t	1	0
123	149	30	F-37.40-SGPAyN	Creacion de Comedores Populares	3	'	\N	t	1	0
124	149	30	F-37.40-SGPAyN	Reempadronamiento de Comedores Populares	3	'	\N	t	1	0
125	149	30	F-37.40-SGPAyN	Solicitud de Donacion de Alimentos	3	'	\N	t	1	0
126	149	30	F-37.40-SGPAyN	Solicitud de Donacion de Alimentos a Cambio de Obra Social	\N	'	\N	t	1	0
127	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.1.Inscripcion ordinaria 63.1.1.Nacimiento ocurrido en el Distrito (Dentro de los 60 dias calendarios establecidos por Ley)	1	Base Legal Ley Nº 27972, Art. 40° y 73º (27-05-2003) Ley N° 2744, Art. 44° y 45° (11-04-01) D.S. Nº 0156-2004-EF, Arts. 68º (15-11-04) Ley Nº 29462, Art. 2º (28-11-04) Ley Nº 26497, Arts. 46º, 47º y 51º (12-07-95) D.S. Nº 015-98-PCM, Arts. 15º, Inc. C) 23º 24º, 25º y 26º (25-04-98) Ley Nº 28720 Art. 1º (25-04-06) Ley Nº 28862, Art. 3º (07-08-06)	\N	t	1	0
128	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.1.Inscripcion ordinaria 63.1.2.Nacimiento ocurrido en otro Distrito	1	Base Legal Ley Nº 27972, Art. 40° y 73º (27-05-2003) Ley N° 2744, Art. 44° y 45° (11-04-01) D.S. Nº 0156-2004-EF, Arts. 68º (15-11-04) Ley Nº 29462, Art. 2º (28-11-04) Ley Nº 26497, Arts. 46º, 47º y 51º (12-07-95) D.S. Nº 015-98-PCM, Arts. 15º, Inc. C) 23º 24º, 25º y 26º (25-04-98) Ley Nº 28720 Art. 1º (25-04-06) Ley Nº 28862, Art. 3º (07-08-06)	\N	t	1	0
129	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.2.Inscripcion extemporanea 63.2.1.Menor de edad (Fuera de los 60 dias calendarios establecidos por Ley)	3	Base Legal Ley Nº 27972, Art. 40° y 73º (27-05-2003) Ley N° 2744, Art. 44° y 45° (11-04-01) D.S. Nº 0156-2004-EF, Arts. 68º (15-11-04) Ley Nº 29462, Art. 2º (28-11-04) Ley Nº 26497, Arts. 46º, 47º y 51º (12-07-95) D.S. Nº 015-98-PCM, Arts. 15º, Inc. C) 23º 24º, 25º y 26º (25-04-98) Ley Nº 28720 Art. 1º (25-04-06) Ley Nº 28862, Art. 3º (07-08-06)	\N	t	1	0
130	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.2.Inscripcion extemporanea 63.2.2.Mayor de edad	3	Base Legal Ley Nº 27972, Art. 40° y 73º (27-05-2003) Ley N° 2744, Art. 44° y 45° (11-04-01) D.S. Nº 0156-2004-EF, Arts. 68º (15-11-04) Ley Nº 29462, Art. 2º (28-11-04) Ley Nº 26497, Arts. 46º, 47º y 51º (12-07-95) D.S. Nº 015-98-PCM, Arts. 15º, Inc. C) 23º 24º, 25º y 26º (25-04-98) Ley Nº 28720 Art. 1º (25-04-06) Ley Nº 28862, Art. 3º (07-08-06)	\N	t	1	0
131	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.3.Inscripcion judicial de nacimientos	1	Base Legal Ley Nº 26102, Art. 169º (09-12-97)	\N	t	1	0
132	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.4.Inscripcion de adopcion de hijos 63.4.1.Por mandato judicial de menor de edad	3	Base Legal D. Leg. Nº 768, Arts. 749º, 781º y 785º (23-04-93) Ley Nº 26981, Art. 12 º (01-10-98) Ley Nº 27337, Art. 128º (07-08-00) Ley Nº 26662, Art. 21º al 23º (13-10-98)	\N	t	1	0
133	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.4.Inscripcion de adopcion de hijos 63.4.2.Por via administrativa de menor de edad	3	Base Legal D. Leg. Nº 768, Arts. 749º, 781º y 785º (23-04-93) Ley Nº 26981, Art. 12 º (01-10-98) Ley Nº 27337, Art. 128º (07-08-00) Ley Nº 26662, Art. 21º al 23º (13-10-98)	\N	t	1	0
134	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.4.Inscripcion de adopcion de hijos 63.4.3.Por mandato judicial de mayor de edad	3	Base Legal D. Leg. Nº 768, Arts. 749º, 781º y 785º (23-04-93) Ley Nº 26981, Art. 12 º (01-10-98) Ley Nº 27337, Art. 128º (07-08-00) Ley Nº 26662, Art. 21º al 23º (13-10-98)	\N	t	1	0
135	158	32	F-37.42-SGRC	63.Inscripcion de nacimientos 63.4.Inscripcion de adopcion de hijos 63.4.4.Por via notarial de mayor de edad	3	Base Legal D. Leg. Nº 768, Arts. 749º, 781º y 785º (23-04-93) Ley Nº 26981, Art. 12 º (01-10-98) Ley Nº 27337, Art. 128º (07-08-00) Ley Nº 26662, Art. 21º al 23º (13-10-98)	\N	t	1	0
136	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.1.Reconocimiento 64.1.1.Directo	1	Base Legal Ley Nº 27972, Art. 73º numeral 2.7 (27-05-2003) D. Leg. Nº 295, Arts. 389º y 394º (25-07-84) Ley Nº 26497, Arts. 41º, 43º y 44º (12-07-95) D.S. Nº 015-98-PCM, Arts. 22º y 36º (25-04-98) Código Procesal Civil Art. 826 Ley Nº 26662 (22.09.1996) Código Civil, art 252, Ley 27444, art 37, 38 y 39 (11-04-2001)	\N	t	1	0
137	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.1.Reconocimiento 64.1.2.Por escritura publica, orden notarial y/o judicial	2	Base Legal Ley Nº 27972, Art. 73º numeral 2.7 (27-05-2003) D. Leg. Nº 295, Arts. 389º y 394º (25-07-84) Ley Nº 26497, Arts. 41º, 43º y 44º (12-07-95) D.S. Nº 015-98-PCM, Arts. 22º y 36º (25-04-98) Código Procesal Civil Art. 826 Ley Nº 26662 (22.09.1996) Código Civil, art 252, Ley 27444, art 37, 38 y 39 (11-04-2001)	\N	t	1	0
138	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.2.Rectificaciones administrativas 64.2.1.Por error y omision atribuibles al registrador	10	Base Legal Ley Nº 26497, Arts. 40º y 44º (12-07-95) D.S. Nº 015-98-PCM, Arts. 22º y 36º (25-04-98)	\N	t	1	0
139	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.2.Rectificaciones administrativas 64.2.2.Por error y omision no atribuibles al registrador	15	Base Legal Ley Nº 26497, Arts. 40º y 44º (12-07-95) D.S. Nº 015-98-PCM, Arts. 22º y 36º (25-04-98)	\N	t	1	0
140	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.2.Rectificaciones administrativas 64.2.3.Por orden notarial y/o judicial	3	Base Legal Ley Nº 26497, Arts. 40º y 44º (12-07-95) D.S. Nº 015-98-PCM, Arts. 22º y 36º (25-04-98)	\N	t	1	0
173	202	43	F-51.53-SGCTTP	74.Autorizacion para prestar servicio de transporte publico 74.2.Para servicio urbano e interurbano	30	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 55º (21-04-09)	\N	t	1	0
141	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.3.Inscripcion de matrimonio 64.3.1.Por mandato judicial	2	Base Legal D.S. Nº 015-98-PCM, Arts. 22º y 36º (25-04-98) Código Procesal Civil Art. 826	\N	t	1	0
142	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.4.Inscripcion de disolucion matrimonial (divorcio)	2	Base Legal D. S. Nº 015-98-PCM, Art. 43º (25-04-98)	\N	t	1	0
143	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.5.Cancelacion de inscripcion de actas 64.5.1.Administrativa	3	Base Legal Ley Nº 26497, Art. 57º (12-07-95) D.S. Nº 015-98-PCM, Art. 77º (25-04-98)	\N	t	1	0
144	158	32	F-37.42-SGRC	64.Inscripciones y anotaciones textuales (marginales y reversas del acta) 64.5.Cancelacion de inscripcion de actas 64.5.2.Por orden judicial	3	Base Legal Ley Nº 26497, Art. 57º (12-07-95) D.S. Nº 015-98-PCM, Art. 77º (25-04-98)	\N	t	1	0
145	158	32	F-37.42-SGRC	65.Inscripcion de defuncion 65.1.Inscripcion ordinaria	1	Base Legal Ley Nº 27972, Art. 73º numeral 2.7 (27-05-2003) D.S. Nº 03-94-SA, Art. 49 (12.10.1994) Ley N º 26497, Arts. 44º y 45º (12-07-95) D.S. N º 015-98-PCM, Arts. 49º al 51º (25-04-98) Ley 27444 art 37, 38 y 39 (11-04-2001)	\N	t	1	0
146	158	32	F-37.42-SGRC	65.Inscripcion de defuncion 65.2.Inscripcion por mandato judicial	1	Base Legal Ley Nº 28413, Ley que regula la ausencia por desaparición forzada durante el período 1980-2000, (11-12-04)	\N	t	1	0
147	158	32	F-37.42-SGRC	66.Matrimonio civil 66.1.Mayor de edad	30	Base Legal Ley Nº 27972, Art. 20º numeral 6 (27-05-2003) Código Civil Art. 241º Código Civil Art. 248º Ley N º 26497, Arts. 40º, 41º y 42º(12-07-95) D.S. N º 015-98-PCM, Arts. 43º, 44º, 46° al 48° (25/04/98)	\N	t	1	0
148	158	32	F-37.42-SGRC	66.Matrimonio civil 66.2.Menor de edad	30	Base Legal Código Civil Art. 244º	\N	t	1	0
149	158	32	F-37.42-SGRC	66.Matrimonio civil 66.3.Divorciados	30	Base Legal Código Civil Art. 243º	\N	t	1	0
150	158	32	F-37.42-SGRC	66.Matrimonio civil 66.4.Viudos	30	Base Legal Código Civil Art. 243º, inc. 2, y 248º	\N	t	1	0
151	158	32	F-37.42-SGRC	67.Dispensa de publicacion del aviso del edicto matrimonial	2	Base Legal Ley Nº 27972, Art. 73º numeral 2.7 (27-05-2003) Codigo Civil, Art. 252 Ley 27444, Art. 37º, 38º y 39 (11-04-2001)	\N	t	1	0
152	158	32	F-37.42-SGRC	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 1.Emision de copias certificadas de partidas de nacimiento, matrimonio y defuncion a)Copia para uso nacional	1	Base Legal Ley Nº26497, Art. 45º (12-07-95) D.S. Nº 015-98-PCM, Art. 4º y 62º (25-04-98)	\N	t	1	0
153	158	32	F-37.42-SGRC	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 1.Emision de copias certificadas de partidas de nacimiento, matrimonio y defuncion b)Copia para uso en el extranjero	1	Base Legal Ley Nº26497, Art. 45º (12-07-95) D.S. Nº 015-98-PCM, Art. 4º y 62º (25-04-98)	\N	t	1	0
154	158	32	F-37.42-SGRC	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 2.Emision de certificado de inscripcion en los registros civiles	1	Base Legal Ley Nº 27444, Art 44,Num 441 (11-04-11)	\N	t	1	0
155	158	32	F-37.42-SGRC	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 3.Emision de certificado negativo de inscripcion en los registros civiles	1	Base Legal Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01)	\N	t	1	0
156	158	32	F-37.42-SGRC	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 4.Emision de certificado de solteria	1	Base Legal Ley Nº 26497, Art 45º (12-07-95)	\N	t	1	0
157	158	32	F-37.42-SGRC	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 5.Emision de certificado de viudez	1	Base Legal Ley Nº 26497, Art 45º (12-07-95)	\N	t	1	0
158	158	32	F-37.42-SGRC	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 6.Postergacion de fecha de matrimonio	1	Base Legal Ley Nº 27444,Atc 44º Nuem 44.1 (11-04-01)	\N	t	1	0
159	158	32	F-37.42-SGRC	Certificado Negativo de Inscripcion en los Registros Civiles	1	'	\N	t	1	0
160	158	32	F-37.42-SGRC	Inscripcion Administrativa de Adultos	\N	'	\N	t	1	0
161	179	37	F-43.47-SGCMyPM	68.Autorizacion para uso comercial de la via publica (temporal)	15	Base Legal O.M. Nº 11-2004-MPH-CM, Art. 5° (16-03-04)	\N	t	1	0
162	179	37	F-43.47-SGCMyPM	69.Autorizacion para venta al minoreo y ambulante en ferias y fiestas patronales/tradicionales (autorizadas para el evento)	1	Base Legal: Ley Nº 27972, Art. 83º (27-05-03) O.M. Nº 11-2004-MPH-CM, (16-03-04)	\N	t	1	0
163	179	37	F-43.47-SGCMyPM	70.Concesion de puestos vacantes en los diferentes mercados por un aÑo	10	Base Legal: Ley Nº 27972, Art. 83º (27-05-03) O.M. Nº 12-2004-MPH-CM, Art. 37° (16-03-04)	\N	t	1	0
164	179	37	F-43.47-SGCMyPM	71.Renovacion de concesion de puestos por un aÑo	6	Base Legal: Ley Nº 27972, Art. 83º (27-05-03) Decreto de Alcaldía N° 026-2004-MPH/A, Art.4 (03-12-2004)	\N	t	1	0
165	179	37	F-43.47-SGCMyPM	72.Derecho de ausentarse del puesto de venta en los diferentes mercados	5	Base Legal: Ley Nº 27972, Art. 83º (27-05-03) O.M. Nº 12-2004-MPH-CM, Art. 27° (16-03-04)	\N	t	1	0
166	179	37	F-43.47-SGCMyPM	73.Autorizacion de mejoramiento de infraestructura metalica u otro en puesto de mercados	2	Base Legal: Ley Nº 27972, Art.83º (27-05-03) O.M. Nº 12-2004-MPH-CM, Art. 18° (16-03-04)	\N	t	1	0
167	179	37	F-43.47-SGCMyPM	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 1.Constancia de conformidad de pesas y medidas	\N	Base Legal: Ley Nº 27972, Art. 83º (27-05-03) O.M. Nº 12-2004-MPH-CM, Art. 6° (16-03-04)	\N	t	1	0
168	179	37	F-43.47-SGCMyPM	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 2.Constancia de conduccion o negativo de puestos en los mercados de la Municipalidad Provincial de Huamanga	\N	Base Legal: Ley Nº 27972, Art.83º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01)	\N	t	1	0
169	179	37	F-43.47-SGCMyPM	Alquiler de Tiendas y Camara Frigorifica Mensual (Vigencia 1 AÑo)	\N	'	\N	t	1	0
170	179	37	F-43.47-SGCMyPM	Autorizacion Venta de Azado y Frutas en Lugares Autorizados	\N	'	\N	t	1	0
171	179	37	F-43.47-SGCMyPM	Certificado de Calidad de Alimentos de Produccion Primaria y Productos Procesados	\N	'	\N	t	1	0
172	202	43	F-51.53-SGCTTP	74.Autorizacion para prestar servicio de transporte publico 74.1.Para servicio de vehiculos menores- mototaxis (vigencia hasta seis aÑos)	30	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 49º al 58º (21-04-09) D.S. Nº 058-2003-MTC, Arts. 148º al 158º (03-03-04) O.M. Nº 034-2008-MPH/A (26-08-08) DS 055-2010-MTC Arts.7 y 14 (02-12-10) OM 016-2012-MPH/A, Arts. 12, 13 y 15 (24-07-12)	\N	t	1	0
174	202	43	F-51.53-SGCTTP	74.Autorizacion para prestar servicio de transporte publico 74.3.Para servicio de taxi urbano y colectivo	30	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 55º (21-04-09) D.S. Nº 058-2003-MTC, Arts. 25º (21-04-09)	\N	t	1	0
175	202	43	F-51.53-SGCTTP	75.Renovacion de autorizacion para prestar servicio de transporte publico 75.1.Para servicio de vehiculos menores-mototaxis	30	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 49º al 58º (21-04-09) D.S. Nº 058-2003-MTC, Arts. 148º al 158º (03-03-04) O.M. Nº 034-2008-MPH/A (26-08-08) DS 055-2010-MTC Arts.7 y 14 (02-12-10) OM 016-2012-MPH/A, Arts. 12, 13 y 15 (24-07-12)	\N	t	1	0
176	202	43	F-51.53-SGCTTP	75.Renovacion de autorizacion para prestar servicio de transporte publico 75.2.Para servicio urbano e interurbano	30	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 55º (21-04-09)	\N	t	1	0
177	202	43	F-51.53-SGCTTP	75.Renovacion de autorizacion para prestar servicio de transporte publico 75.3.Para servicio de taxi urbano y colectivo	30	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 55º (21-04-09) D.S. Nº 058-2003-MTC, Arts. 25º (21-04-09)	\N	t	1	0
178	202	43	F-51.53-SGCTTP	76.Autorizacion para servicio eventual por feria y celebracion de fiestas patronales (Hasta 7 dias, vehiculos que prestan servicio urbano)	15	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 49º y 51º (21-04-09)	\N	t	1	0
179	202	43	F-51.53-SGCTTP	77.Incremento de flota vehicular 77.1.Para servicio urbano e interurbano	15	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 60º (21-04-09)	\N	t	1	0
180	202	43	F-51.53-SGCTTP	77.Incremento de flota vehicular 77.2.Para servicio de taxi urbano y colectivo	15	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 60º (21-04-09) D.S. Nº 058-2003-MTC, Arts. 25º (21-04-09)	\N	t	1	0
181	202	43	F-51.53-SGCTTP	78.Sustitucion de flota vehicular 78.1.Para servicio de vehiculos menores-mototaxis (por unica vez)	15	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 60º (21-04-09) D.S. Nº 058-2003-MTC, Arts. 148º al 158º (03-03-04) O.M. Nº 034-2008-MPH/A (26-08-08) DS 055-2010-MTC Arts.7 y 14 (02-12-10) OM 016-2012-MPH/A, Arts. 54 (24-07-12)	\N	t	1	0
182	202	43	F-51.53-SGCTTP	78.Sustitucion de flota vehicular 78.2.Para servicio urbano e interurbano	15	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 60º (21-04-09)	\N	t	1	0
183	202	43	F-51.53-SGCTTP	78.Sustitucion de flota vehicular 78.3.Para servicio de taxi urbano y colectivo	15	Base Legal: Ley Nº 27972, Art. 81º (27/05/03) D.S. Nº 017-2009-MTC, Arts. 60º (21-04-09) D.S. Nº 058-2003-MTC, Arts. 25º (21-04-09)	\N	t	1	0
184	202	43	F-51.53-SGCTTP	79.Autorizacion para prestar el servicio turistico (camioneta rural, omnibus)	30	Base Legal: D. S. Nº 017-2009-MTC, Art. 49 y 52º (21-04-09) D. S. Nº 003-2005-MTC, Art. 12º (23-04-05)	\N	t	1	0
185	202	43	F-51.53-SGCTTP	80.Ampliacion y/o modificacion de ruta	30	Base Legal: Ley Nº 27181, Art. 17 (08-10-99) D. S. Nº 017-2009-MTC, Art. 60 (21-04-09)	\N	t	1	0
186	202	43	F-51.53-SGCTTP	81.Tarjeta unica de circulacion	10	Base Legal: D. S. Nº 017-2009-MTC, Art. 64 (21-04-09) OM N° 016-2012-MPH/A, Art. 26° (19-07-12)	\N	t	1	0
187	202	43	F-51.53-SGCTTP	82.Renovacion de tarjeta unica de circulacion	10	Base Legal: D. S. Nº 017-2009-MTC, Art. 64 (21-04-09) OM N° 016-2012-MPH/A, Art. 40° (19-07-12)	\N	t	1	0
188	202	43	F-51.53-SGCTTP	83.Autorizacion especial para mototaxis (delivery y otros)	15	Base Legal: OM N° 016-2012-MPH/A, Art. 39 (24-07-12)	\N	t	1	0
189	202	43	F-51.53-SGCTTP	84.Renovacion de la autorizacion especial para mototaxis	30	Base Legal: OM N° 016-2012-MPH/A, Art. 40 (24-07-12)	\N	t	1	0
190	202	43	F-51.53-SGCTTP	85.Autorizacion especial para motos lineales (transporte de carga)	15	Base Legal: OM N° 016-2012-MPH/A, Art. 41 (19-07-12)	\N	t	1	0
191	202	43	F-51.53-SGCTTP	86.Renovacion de la autorizacion especial para motos lineales	15	Base Legal: OM N° 016-2012-MPH/A, Art. 41 (24-07-12)	\N	t	1	0
192	202	43	F-51.53-SGCTTP	87.Modificacion de resolucion de autorizacion para prestar servicio de transporte publico por cambio de denominacion social, gerente y otros	20	Base Legal Ley Nº 27972, Art. 81º (27-05-03) D. S. Nº 017-2009-MTC, Art. 60 (21-04-09)	\N	t	1	0
193	202	43	F-51.53-SGCTTP	88.Autorizacion para el servicio de embarque y desembarque a vehiculos publicos y particulares (en horas autorizadas)	10	Base Legal Ley Nº 27972, Art. 81º (27-05-03) Ley Nº 27181, Art. 17 (08-10-99)	\N	t	1	0
194	202	43	F-51.53-SGCTTP	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 1.Duplicado de tarjeta unica de circulacion	\N	Base Legal Ley Nº 27972, Art. 81º (27-05-03) D. S. Nº 017-2009-MTC, Art. 64 (21-04-09)	\N	t	1	0
195	202	43	F-51.53-SGCTTP	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 2.Constancia de verificacion fisico mecanica del vehiculo (por seis meses)	\N	Base Legal Ley Nº 27972, Art. 81º (27-05-03) D. S. Nº 017-2009-MTC, Art. 74 (21-04-09) OM N° 016-2012-MPH/A, Art.8 (24-07-12)	\N	t	1	0
196	202	43	F-51.53-SGCTTP	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 3.Duplicado de constancia de verificacion fisico mecanica	\N	Base Legal Ley Nº 27972, Art. 81º (27-05-03) Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) D. S. Nº 017-2009-MTC, Art. 74 (21-04-09)	\N	t	1	0
197	202	43	F-51.53-SGCTTP	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 4.Sticker vehicular municipal (mototaxis)	\N	Base Legal Ley Nº 27444, Art. 44º, Num. 44.1 (11-04-01) OM N° 016-2012-MPH/A, Art.4 (24-07-12)	\N	t	1	0
198	202	43	F-51.53-SGCTTP	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 5.Liberacion vehicular del deposito municipal de vehiculos	\N	Base Legal: Ley Nº 27181, Arts. 10º y 11º (08-10-99) D.S. Nº 003-2003-MTC, Art. 1º (18-01-03) O.M. Nº 004-2002-MPH/A, Art. 26º (12-03-02) D.LEG. N° 957, Art. 318° y 319° (29-07-04) OM N° 016-2012-MPH/A, Art. 50 (24-07-12)	\N	t	1	0
199	202	43	F-51.53-SGCTTP	Autorizacion para Estacionamiento de Vehiculos de Carga	30	'	\N	t	1	0
200	202	43	F-51.53-SGCTTP	Certificado de Habilitacion Vehicular	10	'	\N	t	1	0
201	202	43	F-51.53-SGCTTP	Duplicado de Certificado de Habilitacion Vehicular	5	'	\N	t	1	0
202	202	43	F-51.53-SGCTTP	Duplicado de Verificacion Fisico Mecanico	\N	'	\N	t	1	0
203	202	43	F-51.53-SGCTTP	Licencia de Conducir Vehiculos Menores B-I	10	'	\N	t	1	0
204	202	43	F-51.53-SGCTTP	Permiso de Operaciones para Brindar el Servicio de Carga	\N	'	\N	t	1	0
205	202	43	F-51.53-SGCTTP	Renovacion de Habilitacion Vehicular	30	'	\N	t	1	0
206	202	43	F-51.53-SGTSV	89.Licencia de conducir Clase B 89.1.Categoria II-a y b	10	Base Legal: OM N° 022-2012-MPH/A, Arts. 13 y 15 (16-11-12)	\N	t	1	0
207	202	43	F-51.53-SGTSV	89.Licencia de conducir Clase B 89.2.Categoria II-c	\N	Base Legal: OM N° 022-2012-MPH/A, Arts. 13 y 15 (16-11-12)	\N	t	1	0
208	202	43	F-51.53-SGTSV	90.Revalidacion de licencia de conducir	10	Base Legal: OM N° 022-2012-MPH/A, Art. 13° (16-11-12)	\N	t	1	0
209	202	43	F-51.53-SGTSV	91.Recategorizacion de licencia de conducir (Clase B, Categoria II-a y b)	10	Base Legal: OM N° 022-2012-MPH/A, Art. 13° (16-11-12)	\N	t	1	0
210	202	43	F-51.53-SGTSV	92.Canje de licencia de conducir	10	Base Legal: OM N° 022-2012-MPH/A, Art. 17° (16-11-12)	\N	t	1	0
211	202	43	F-51.53-SGTSV	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 1.Duplicado de licencia de conducir de Vehiculos Menores	2	Base Legal: OM N° 022-2012-MPH/A , Art. 14 (16-11-12)	\N	t	1	0
212	197	41	F-51.53-SGCTTP	Medios Impugnatorios	\N	'	\N	t	1	0
213	197	41	F-51.53-SGCTTP	Permiso de Operaciones Carga-Ampliacion Modificacion Ruta	\N	'	\N	t	1	0
214	197	41	F-51.53-SGCTTP	Permisos y Autorizaciones	\N	'	\N	t	1	0
215	197	41	F-51.53-SGCTTP	Resoluciones y Autorizaciones	\N	'	\N	t	1	0
216	222	47	F-12.57-SGDCyGR	93.Inspeccion Tecnica de Seguridad en Defensa Civil (Basica)	7	Base Legal: Ley Nº 27972, Arts. 73º y 85º (27-05-03) Decreto Ley Nº 19338, Arts. 2º y 3º (29-03-72) D. S. Nº 066-2007-PCM, Arts. 9º y 39º (05-08-07)	\N	t	1	0
217	222	47	F-12.57-SGDCyGR	94.Inspeccion Tecnica de Seguridad en Defensa Civil Ex-post hasta 100 m2 y capacidad de almacenamiento no mayor a 30% del area total del local	7	Aplicable, entre otros, para: * caso de denegatoria de renovación de certificado a local que cuente con licencia de funcionamiento * inspecciones a módulos o stands que formen parte de galerías o mercados autorizados	\N	t	1	0
218	222	47	F-12.57-SGDCyGR	95.Inspeccion Tecnica de Seguridad en Defensa Civil Ex-ante mayor a 100 m2 hasta 500 m2	7	Aplicable, entre otros, para: *Caso de denegatoria de renovación de certificado a local que cuente con licencia de funcionamiento * inspecciones a módulos o stands que formen parte de galerías o mercados autorizados	\N	t	1	0
219	222	47	F-12.57-SGDCyGR	96.Renovacion del certificado de inspeccion tecnica basica de seguridad en defensa civil ex post hasta 100 m2 y capacidad de almacenamiento no mayor a 30% del area total del local	7	Base Legal Ley Nº 27972 (27.05.03). Arts. 40 y 79 numeral 1.4.6. Ley Nº 27444 (11.04.01). Arts. 34, 35, 44 y 45 Ley Nº 29060 (07.07.07). Decreto Supremo Nº 156-2004-EF (15.11.04). Art. 68. Ley Nº 28976 (05.02.07). Arts. 8 numerales 1 y 2, y 11 y 15 Decreto Supremo Nº 066-2007-PCM (05.08.07). Arts. 1, 9 numeral 1, 18, 35, 38, 39, 40, 41 y 10ma. Disposición Complementaria y Final. Manual para la Ejecución de Inspecciones Técnicas de Seguridad en Defensa Civil. Numeral 2.1.	\N	t	1	0
220	222	47	F-12.57-SGDCyGR	97.Renovacion del certificado de inspeccion tecnica basica de seguridad en defensa civil ex ante mayor a 100 m2 hasta 500 m2	7	Base Legal Ley Nº 27972 (27.05.03). Arts. 40 y 79 numeral 1.4.6. Ley Nº 27444 (11.04.01). Arts. 34, 35, 44 y 45. Ley Nº 29060 (07.07.07). Decreto Supremo Nº 156-2004-EF (15.11.04). Art. 68. Ley Nº 28976 (05.02.07). Arts. 8 numerales 1 y 2, y 11 y 15 Decreto Supremo Nº 066-2007-PCM (05.08.07). Arts. 1, 9 numeral 1, 18, 35, 38, 39, 40, 41 y 10ma. Disposición Complementaria y Final Manual para la Ejecución de Inspecciones Técnicas de Seguridad en Defensa Civil. Numeral 2.1 	\N	t	1	0
221	222	47	F-12.57-SGDCyGR	98.Inspeccion Tecnica de Seguridad en Defensa Civil (Temporal) Evento y o Espectaculo Publico hasta 3000 Espectadores	7	Base Legal: Ley Nº 27972, Arts. 73º y 85º (27-05-03) Decreto Ley Nº 19338, Arts. 2º y 3º (29-03-72) D. S. Nº 066-2007-PCM, Arts. 10º, Num. 5, 12º y 39º (05-08-07)	\N	t	1	0
222	222	47	F-12.57-SGDCyGR	99.Inspeccion Tecnica en Defensa Civil (Temporal) a circos, ferias, juegos mecanicos y o similares	7	Base Legal: Ley N° 27972, Arts. 73º y 85º (27-05-03) Decreto Ley Nº 19338, Arts. 2º y 3º (29-03-72) D. S. N° 066-2007-PCM, Art. 10º, Num. 5, 12º y 39º (05-08-07)	\N	t	1	0
223	222	47	F-12.57-SGDCyGR	SERVICIOS PRESTADOS EN EXCLUSIVIDAD 1.Duplicado del certificado de inspeccion tecnica basica de seguridad en defensa civil	\N	Base Legal Ley Nº 27972 (27.05.03). Arts. 40 y 79 numeral 1.4.6. Ley Nº 27444 (11.04.01). Arts. 44, 45 y 160. Decreto Supremo Nº 156-2004-EF (15.11.04). Art. 68.	\N	t	1	0
224	222	47	F-12.57-SGDCyGR	Copia Certificada de Inspeccion Ocular y Otros Documentos	\N	'	\N	t	1	0
225	222	47	F-12.57-SGDCyGR	Inspeccion Ocular a Viviendas Particulares, Talleres, Canales, Etc	7	'	\N	t	1	0
226	222	47	F-12.57-SGDCyGR	Inspeccion Tecnica de Seguridad de Defensa Civil para Cambio de Domicilio	\N	'	\N	t	1	0
227	170	35	F-43.45-SGLyO	Autorizacion para Elaboracion de Alfombras en la Via Publica (Sin uso de aserrin, yeso, anilina)	\N	'	\N	t	1	0
228	170	35	F-43.45-SGLyO	Autorizacion para Tala de Arboles en Areas de Dominio Publico Parques, Jardines y Similares (Excepto Molle y Especies en Veda)	1	'	\N	t	1	0
229	170	35	F-43.45-SGLyO	Autorizacion para Tala o Supresion de Arbol Emplazado en Jardines o Espacios Privados Ubicados en Zona Urbana del Distrito de Ayacucho	\N	'	\N	t	1	0
230	170	35	F-43.45-SGLyO	Donacion/Intercambio de Plantones y/o Plantas	1	'	\N	t	1	0
231	170	35	F-43.45-SGLyO	Eliminacion de Desmonte y/o Basura en Zonas Criticas	1	'	\N	t	1	0
232	170	35	F-43.45-SGLyO	Implementacion de Areas Verdes	\N	'	\N	t	1	0
233	170	35	F-43.45-SGLyO	Implementacion de Parques	\N	'	\N	t	1	0
234	170	35	F-43.45-SGLyO	Mantenimiento de Areas Verdes, Parques, Vias Publicas	\N	'	\N	t	1	0
235	170	35	F-43.45-SGLyO	Practicar Juegos Deportivos y o Ejercicios Fisicos Dentro de las Areas Verdes	\N	'	\N	t	1	0
236	170	35	F-43.45-SGLyO	Realizar Yunzas o Cortamontes en las Vias Publicas de Mayor Circulacion Vehicular Obstaculizando la Fluidez	1	'	\N	t	1	0
237	170	35	F-43.45-SGLyO	Reforestacion	\N	'	\N	t	1	0
238	170	35	F-43.45-SGLyO	ReHabilitacion de Canales y Cuneta	\N	'	\N	t	1	0
239	170	35	F-43.45-SGLyO	ReHabilitacion de Vias Publicas	\N	'	\N	t	1	0
240	170	35	F-43.45-SGLyO	Utilizar las Areas Verdes de uso Privado Cualquiera sea su Naturaleza sin Autorizacion Municipal	\N	'	\N	t	1	0
241	170	35	F-43.45-SGLyO	Verter Materiales de Construccion u Otros Servicios de Cualquier Naturaleza Toxica o Peligrosa en las Areas Verdes	\N	'	\N	t	1	0
242	170	35	F-43.45-SGLyO	Visita Presencial de Viveros	\N	'	\N	t	1	0
243	177	36	F-43.46-SGS	Apoyo de Seguridad en Ferias	2	'	\N	t	1	0
244	177	36	F-43.46-SGS	Instalacion de Casetas de Vigilancia	4	'	\N	t	1	0
245	177	36	F-43.46-SGS	Reconocimiento de Juntas de Vigilancia	\N	'	\N	t	1	0
246	177	36	F-43.46-SGS	Seguridad a los Eventos Escolares	\N	'	\N	t	1	0
247	177	36	F-43.46-SGS	Solicitud de Videos de Camara de Vigilancia	1	'	\N	t	1	0
248	177	36	F-43.46-SGS	Transcripcion de Cuaderno de Ocurrencias de Centro de Operaciones	\N	'	\N	t	1	0
249	190	39	F-48.49-SGPMDP	Prestamo de Centro Municipal de Asesoramiento y Mypes	\N	'	\N	t	1	0
250	190	39	F-48.49-SGPMDP	Realizacion de Ferias	1	'	\N	t	1	0
251	194	40	F-48.50-SGTyA	Alquiler de Carpas	2	'	\N	t	1	0
252	200	42	F-51.52-SGTySV	Duplicado de Certificado de Curso Capacitacion	5	'	\N	t	1	0
253	21	6	F-12.13-OAJ	Apelacion	\N	'	\N	t	1	0
254	142	29	F-37.39-SGECDyR	Copia certificada de documentos administrativos	\N	'	\N	t	1	0
255	142	29	F-37.39-SGECDyR	Procedimiento Coactivo	\N	'	\N	t	1	0
256	142	29	F-37.39-SGECDyR	Autorizacion Varios	\N	'	\N	t	1	0
257	142	29	F-37.39-SGECDyR	Reconsideracion	\N	'	\N	t	1	0
258	187	38	F-13.49-GDE	Certificados	\N	'	\N	t	1	0
259	187	38	F-13.49-GDE	Duplicado de Apertura de Establecimiento	\N	'	\N	t	1	0
260	187	38	F-13.49-GDE	Turismo Artesania	\N	'	\N	t	1	0
261	187	38	F-13.49-GDE	Varios	\N	'	\N	t	1	0
262	120	26	F-32.36-SGCUyL	Reconsideracion de notificacion preventiva	30	RECONSIDERACION DE NOTIFICACION PREVENTIVA	\N	t	1	0
263	88	19	F-29.31-UBPySG	Entrega de placas	2	ENTREGA DE PLACAS DE LOS VEHICULOS	\N	t	1	0
264	7	3	F-28.31-GM	Solicitudes y oficios	7	SOLICITUDES Y OFICIOS	\N	t	1	0
265	45	11	F-32.31-OSG	Solicitudes, cartas y oficios	7	SOLICITUDES, CARTAS Y OFICIOS	\N	t	1	0
266	217	46	F-54.31-SGSLP	Pre-liquidacion, obras, oficios	7	PRE-LIQUIDACION, OBRAS, OFICIOS	\N	t	1	0
267	112	25	F-32.35-SGCH	Anulacion de multas	7	ANULACION DE MULTAS	\N	t	1	0
268	73	17	F-23.31-URH	Permiso salud, convocatorias, y otros	7	PERMISO, SALUD, CONVOCATORIAS, Y OTROS	\N	t	1	0
270	100	22	F-28.31-GDT	Invitacion, solicitudes, memos, cartas y otros	7	INVITACION, SOLICITUDES, MEMOS, CARTAS,OTROS	\N	t	1	0
271	158	32	F-37.42-SGRC	Oficios de fiscalia, minist. publico, otros	7	OFICIOS DE FISCALIA, MINIST. PUBLICO, OTROS	\N	t	1	0
272	163	33	F-27.31-GSM	Cartas, oficios, otros	7	CARTAS, OFICIOS, OTROS	\N	t	1	0
273	197	41	F-51.53-SGTSV	Sustitucion vehicular, otros	7	SUSTITUCION VEHICULAR, OTROS	\N	t	1	0
274	79	18	F-21.53-UA	Registro de Proveedores	7	Registros de Proveedores	\N	t	1	0
275	142	29	F-37.39-SGECDyR	Oficios, Solicitudes, Otros	7	OFICIOS, SOLICITUDES, OTROS	\N	t	1	0
276	222	47	F-12.57-SGDCyGR	Otros, defensa civil	7	OTROS, ETC	\N	t	1	0
277	179	37	F-43.47-SGCMyPM	Multas, locales y otros, varios	7	MULTAS, LOCALES Y OTROS VARIOS	\N	t	1	0
278	60	14	F-12.57-SGDCyGR	Estados finacieros, otros, varios	7	ESTADOS FINACIEROS, OTROS, VARIOS	\N	t	1	0
279	26	7	F-15.16-OPP	Varios, otros	7	VARIOS, OTROS	\N	t	1	0
280	149	30	F-37.40-SGPAyN	Oficios, otros	7	OFICIOS, OTROS	\N	t	1	0
281	222	47	F-12.57-SGDCyGR	Plazos, devoluciones y otros	7	PLAZOS, DEVOLUCIONES Y OTROS	\N	t	1	0
282	158	32	F-37.42-SGRC	Otros	1	OTROS	\N	t	1	0
283	112	25	F-32.35-SGCH	Varios, otros	7	VARIOS, OTROS	\N	t	1	0
284	225	1	F-01.31-CM	Otros concejo municipal	1	otros concejo municipal	\N	t	1	0
285	12	4	F-07.31-OCI	Otros organo de control institucional	1	otros organo de control institucional	\N	t	1	0
286	19	5	F-09.32-PPM	Otros procuraduria municipal	1	otros procuraduria municipal	\N	t	1	0
287	21	6	F-12.13-OAJ	Otros oficina de asesoria juridica	1	otros oficina de asesoria juridica	\N	t	1	0
288	26	7	F-15.16-OPP	Otros oficina de planeamiento y presupuesto	1	otros oficina de planeamiento y presupuesto	\N	t	1	0
289	28	8	F-16.16-OPP	Otros oficina de presupuesto y planes	1	otros oficina de presupuesto y planes	\N	t	1	0
290	34	9	F-19.21-URE	Otros unidad de racionalizacion y estadistica	1	otros unidad de racionalizacion y estadistica	\N	t	1	0
291	40	10	F-20.25-UPI	Otros unidad de programacion e inversiones	1	otros unidad de programacion e inversiones	\N	t	1	0
292	45	11	F-32.31-OSG	Otros secretaria general	7	otros secretaria general	\N	t	1	0
293	52	12	F-22.26-UTDyA	Otros unidad de tramite documentario y archivo	7	otros unidad de tramite documentario y archivo	\N	t	1	0
294	57	13	F-24.28-UCeII	Otros imagen institucional	7	otros imagen institucional	\N	t	1	0
295	63	15	F-25.29-UT	Otros unidad de tesoreria	7	otros unidad de tesoreria	\N	t	1	0
296	70	16	F-26.19-UC	Otros unidad de contabilidad	7	otros unidad de contabilidad	\N	t	1	0
297	79	18	F-21.53-UA	Otros unidad de abastecimiento	7	otros unidad de abastecimiento	\N	t	1	0
298	88	19	F-29.31-UBPySG	Otros unidad de bienes patrimoniales y servicios generales	7	otros unidad de bienes patrimoniales y servicios generales	\N	t	1	0
299	92	20	F-33.35-UEM	Otros unidad de equipo mecanico	7	otros unidad de equipo mecanico	\N	t	1	0
300	97	21	F-34.36-UEC	Otros unidad de ejecutoria coactiva	7	otros unidad de ejecutoria coactiva	\N	t	1	0
301	104	23	F-32.33-SGO	Otros subgerencia de obras, otros obras	7	otros subgerencia de obras, otros obras	\N	t	1	0
302	109	24	F-32.34-SGPUyC	Otros planeamiento urbano y catastro, otros subgerencia de planeamiento y catastro	7	otros planeamiento urbano y catastro, otros subgerencia de planeamiento y catastro	\N	t	1	0
303	112	25	F-32.35-SGCH	Otros centro historico, otros subgerencia de centro historico	7	otros centro historico, otros subgerencia de centro historico	\N	t	1	0
304	120	26	F-32.36-SGCUyL	Otros control urbano y licencias.	7	otros control urbano y licencias.	\N	t	1	0
305	127	27	F-35.37-GDH	Otros desarrollo humano	7	Otros desarrollo humano	\N	t	1	0
306	131	28	F-33.38-SGPINAJyBS	Otros primera infancia, niÑez adolescencia	7	Otros primera infancia, niñez adolescencia	\N	t	1	0
307	154	31	F-38.41-SGPV	Otros participacion vecinal	7	Otros participacion vecinal	\N	t	1	0
308	166	34	F-36.39-SGEyMA	Otros ecologia y medio ambiente	7	Otros ecologia y medio ambiente	\N	t	1	0
309	170	35	F-43.45-SGLyO	Otros limpieza y ornato	7	Otros limpieza y ornato	\N	t	1	0
310	177	36	F-43.46-SGS	Otros serenazgo, otros sub gerencia de serenazgo	7	Otros serenazgo, otros sub gerencia de serenazgo	\N	t	1	0
311	190	39	F-48.49-SGPMyDP	Otros mypes y desarrollo productivo	7	Otros mypes y desarrollo productivo	\N	t	1	0
312	194	40	F-48.50-SGTyA	Otros turismo y artesania	7	Otros turismo y artesania	\N	t	1	0
313	197	41	F-51.53-SGCTTP	Otros Transportes, Otros gerencia de transportes	7	Otros Transportes, Otros gerencia de transportes	\N	t	1	0
314	200	42	F-51.52-SGTySV	Otros Transito y seguridad vial	7	Otros Transito y seguridad vial	\N	t	1	0
315	202	43	F-51.52-SGTySV	Otros control tecnico y transporte publico	7	Otros control tecnico y transporte publico	\N	t	1	0
316	208	44	F-41.43-SGEyP	Otros estudios y proyectos	7	Otros estudios y proyectos	\N	t	1	0
317	213	45	F-42.44-SGSyT	Otros sistemas y tecnologia	7	Otros sistemas y tecnologia	\N	t	1	0
318	217	46	F-54.31-SGSLP	Otros supervicion y liquidacion	7	Otros supervicion y liquidacion	\N	t	1	0
319	149	30	F-37.40-SGPAyN	Vaso de leche	7	Vaso de leche	\N	t	1	0
321	226	49	F-55.53-SR	Oficios, invitaciones, otros	7	OFICIOS, INVITACIONES, OTROS	\N	t	1	0
322	227	48	F-56.58-IVP	Oficios, invitaciones, otros	7	OFICOS, INVITACIONES, OTROS.	\N	t	1	0
323	228	50	F-57.59-SATH	Otros, SAT	7	OTROS, SAT	\N	t	1	0
324	229	45	F-42.44-SGSyT	Procedimiento para migracion	0	Procedimiento para migracion	\N	t	1	0
325	230	53	DM	OFICIOS, INVITACIONES, SOLICITUDES Y OTROS	7	OFICIOS, INVITACIONES, SOLICITUDES Y OTROS	\N	t	1	0
326	231	54	URS	SOLICITUDES, VARIOS	7	SOLICITUDES, VARIOS	\N	t	1	0
327	214	45	abcd	abcd	3	abcd	\N	t	\N	\N
328	198	41	123	123	123	123	\N	t	\N	\N
330	197	41	12345	12345	123	12345	\N	t	\N	\N
331	200	42	12	12	12	12	\N	t	\N	\N
332	203	43	1	1	1	1	\N	t	\N	\N
333	37	9	21	21	21	21	\N	t	\N	\N
341	213	45	no tupa	NO TUPA	400	2344444	\N	t	2	400
334	24	6	f-nuevo	f-nuevo	10	f-nuevo	\N	t	2	\N
343	190	39	F-49.49-SGPMDP	Procedimiento Prueba 2	5	descriion detllada de procedimiento	\N	f	1	15
344	197	41	LICEASD	ASD	8	ASDASD	\N	t	5	150
338	190	39	11	1	1	1	\N	f	1	1
337	193	39	123456	otro123	5	tecnico archivo 123	\N	f	2	4
339	190	39	321123	321123	321	321123	\N	f	1	321
329	193	39	f-nuevo2	f-nuevo2	34	f-nuevo2	\N	f	2	20
335	190	39	f-nuevo22	f-nuevo22	12	f-nuevo22	\N	f	1	12
336	193	39	f-nuevo3232	f-nuevo3434	3	desc	\N	f	2	15
340	199	41	rere	RER	324	234	\N	t	2	234
269	1	2	F-31.31-ALC	Cartas, oficios, otros	7	CARTAS , OFICIOS, OTROS	\N	t	2	0
320	7	3	F-28.31-GM	Otros gerencia municipal	7	otros gerencia municipal	\N	t	2	0
342	179	37	LIC001	ASD	2	ASDASD	\N	t	2	12
\.


--
-- TOC entry 2258 (class 0 OID 271062)
-- Dependencies: 231
-- Data for Name: recepcion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY recepcion (idrecepcion, idexpediente, idarea, idarea_proviene, idusuariorecepciona, idusuarioenvia, idrecepcion_proviene, idprocedimiento, bindentregado, fecharecepcion, bindderivado, bindprimero, fechaderivacion, observacion, estado) FROM stdin;
1	1	2	0	1	1	\N	269	t	2016-11-21 12:31:28.411	f	t	\N	Enviado desde Mesa de Partes	t
2	2	45	0	\N	5	\N	327	f	2016-11-22 08:29:39.88	f	t	\N	Enviado desde Mesa de Partes	t
3	3	45	0	\N	5	\N	341	f	2016-11-22 10:16:38.467	f	t	\N	Enviado desde Mesa de Partes	t
4	4	45	0	\N	5	\N	341	f	2016-11-22 10:45:28.164	f	t	\N	Enviado desde Mesa de Partes	t
5	5	45	0	\N	5	\N	341	f	2016-11-22 11:06:37.414	f	t	\N	Enviado desde Mesa de Partes	t
6	6	45	0	66	5	\N	341	t	2016-11-22 11:26:02.437	f	t	\N	Enviado desde Mesa de Partes	t
\.


--
-- TOC entry 2273 (class 0 OID 388824)
-- Dependencies: 246
-- Data for Name: recepcioninterna; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY recepcioninterna (idrecepcioninterna, idexpediente, idmensaje, idarea_destino, idarea_proviene, idusuariorecepciona, idusuarioenvia, idrecepcion_proviene, bindentregado, fecharegistro, fecharecepcion, bindderivado, bindprimero, fechaderivacion, observacion, estado) FROM stdin;
20	\N	23	19	45	49	9	0	t	2016-10-18 12:22:59.109	\N	f	t	2016-10-18 12:25:09.628		t
21	\N	23	45	45	2	9	0	t	2016-10-18 12:22:59.109	\N	f	t	2016-10-18 12:25:42.828		t
1	\N	6	45	2	9	1	0	t	2016-09-26 15:58:58.344	\N	f	t	2016-09-26 15:59:53.719		t
2	\N	7	2	45	1	9	0	t	2016-09-26 16:16:54.617	\N	f	t	2016-09-26 16:17:29.987		t
3	\N	8	45	2	2	1	0	t	2016-09-27 08:43:02.527	\N	f	t	2016-09-27 08:45:07.823		t
5	\N	10	45	2	66	1	0	t	2016-09-27 08:50:15.637	\N	f	t	2016-09-27 08:53:14.021		t
6	\N	11	45	45	2	9	0	t	2016-09-27 10:32:26.114	\N	f	t	2016-09-27 10:35:36.148		t
8	\N	12	45	13	66	15	0	t	2016-09-27 10:43:43.215	\N	f	t	2016-09-27 10:47:15.487		t
4	\N	10	2	2	1	1	0	t	2016-09-27 08:50:15.637	\N	f	t	2016-09-29 09:19:39.224		t
7	\N	11	2	45	1	9	0	t	2016-09-27 10:32:26.114	\N	f	t	2016-10-14 17:22:31.09		t
9	\N	13	45	2	9	1	0	t	2016-10-13 15:25:41.61	\N	f	t	2016-10-14 17:32:10.079		t
10	\N	14	45	2	9	1	0	t	2016-10-14 15:17:04.277	\N	f	t	2016-10-14 17:32:10.079		t
11	\N	15	45	2	9	1	0	t	2016-10-14 15:35:12.95	\N	f	t	2016-10-14 17:32:10.079		t
12	\N	16	45	2	9	1	0	t	2016-10-14 15:59:23.192	\N	f	t	2016-10-14 17:32:10.079		t
15	\N	19	45	0	0	2	0	f	2016-10-17 15:50:12.646	\N	f	t	\N		t
17	\N	21	45	2	9	1	0	t	2016-10-18 08:36:48.461	\N	f	t	2016-10-18 08:40:30.931		t
16	\N	20	45	45	1	2	0	t	2016-10-18 08:13:08.676	\N	f	t	2016-10-18 12:21:03.01		t
19	\N	23	2	45	0	9	0	f	2016-10-18 12:22:59.109	\N	f	t	\N		t
22	\N	24	19	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
23	\N	24	2	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
24	\N	24	12	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
25	\N	24	9	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
26	\N	24	7	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
27	\N	24	27	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
28	\N	24	33	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
29	\N	24	17	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
30	\N	24	13	45	0	9	0	f	2016-10-18 12:28:19.317	\N	f	t	\N		t
34	\N	30	8	45	0	9	0	f	2016-10-19 08:42:00.271	\N	f	t	\N		t
35	\N	31	2	45	0	9	0	f	2016-10-19 08:42:17.093	\N	f	t	\N		t
36	\N	34	45	45	2	9	0	t	2016-10-19 14:36:48.007	\N	f	t	2016-10-19 14:38:36.222		t
37	\N	36	2	45	0	9	0	f	2016-10-28 12:45:49.532	\N	f	t	\N		t
39	\N	38	18	45	0	9	0	f	2016-11-04 09:42:51.564	\N	f	t	\N		t
40	\N	39	18	45	0	9	0	f	2016-11-04 09:53:17.762	\N	f	t	\N		t
41	\N	41	8	45	0	9	0	f	2016-11-04 10:35:04.535	\N	f	t	\N		t
13	\N	17	45	2	2	1	0	t	2016-10-17 11:41:53.386	\N	f	t	2016-11-04 14:14:49.499		t
42	\N	42	45	2	2	1	0	t	2016-11-04 14:13:51.728	\N	f	t	2016-11-04 14:15:17.762		t
43	\N	43	45	2	9	1	0	t	2016-11-04 14:35:53.321	\N	f	t	2016-11-04 14:37:14.877		t
18	\N	22	45	2	2	1	0	t	2016-10-18 12:14:53.395	\N	f	t	2016-11-10 10:49:15.931		t
44	\N	44	45	2	2	1	0	t	2016-11-08 12:38:42.226	\N	f	t	2016-11-10 10:49:15.931		t
45	\N	45	45	2	2	1	0	t	2016-11-08 12:56:08.099	\N	f	t	2016-11-10 10:49:15.931		t
46	\N	46	45	2	2	1	0	t	2016-11-08 13:04:27.164	\N	f	t	2016-11-10 10:49:15.931		t
47	\N	47	45	2	2	1	0	t	2016-11-10 10:42:34.722	\N	f	t	2016-11-10 10:49:15.931		t
48	\N	48	45	2	2	1	0	t	2016-11-10 10:46:31.639	\N	f	t	2016-11-10 10:49:15.931		t
49	\N	49	45	2	2	1	0	t	2016-11-10 10:48:25.114	\N	f	t	2016-11-10 10:49:15.931		t
14	\N	18	45	45	2	9	0	t	2016-10-17 15:24:23.466	\N	f	t	2016-11-10 10:49:15.931		t
31	\N	25	45	45	2	9	0	t	2016-10-18 15:34:10.348	\N	f	t	2016-11-10 10:49:15.931		t
32	\N	28	45	45	2	9	0	t	2016-10-19 08:36:46.901	\N	f	t	2016-11-10 10:49:15.931		t
33	\N	29	45	45	2	9	0	t	2016-10-19 08:36:55.434	\N	f	t	2016-11-10 10:49:21.442		t
38	\N	37	45	45	2	9	0	t	2016-11-04 09:19:08.714	\N	f	t	2016-11-10 10:49:21.442		t
59	\N	10	2	45	0	9	0	f	2016-11-15 11:35:57.323	\N	f	t	\N		t
60	\N	11	19	45	0	9	0	f	2016-11-15 11:40:12.1	\N	f	t	\N		t
61	\N	11	2	45	0	9	0	f	2016-11-15 11:40:12.1	\N	f	t	\N		t
62	\N	11	7	45	0	9	0	f	2016-11-15 11:40:12.1	\N	f	t	\N		t
64	\N	12	19	45	0	9	0	f	2016-11-15 11:40:16.12	\N	f	t	\N		t
65	\N	12	2	45	0	9	0	f	2016-11-15 11:40:16.12	\N	f	t	\N		t
66	\N	12	7	45	0	9	0	f	2016-11-15 11:40:16.12	\N	f	t	\N		t
68	\N	13	19	45	0	9	0	f	2016-11-15 11:40:23.453	\N	f	t	\N		t
69	\N	13	2	45	0	9	0	f	2016-11-15 11:40:23.453	\N	f	t	\N		t
70	\N	13	7	45	0	9	0	f	2016-11-15 11:40:23.453	\N	f	t	\N		t
72	\N	14	19	45	0	9	0	f	2016-11-15 11:40:27.047	\N	f	t	\N		t
73	\N	14	2	45	0	9	0	f	2016-11-15 11:40:27.047	\N	f	t	\N		t
71	\N	13	45	45	2	9	0	t	2016-11-15 11:40:23.453	\N	f	t	2016-11-16 11:00:51.864		t
67	\N	12	45	45	2	9	0	t	2016-11-15 11:40:16.12	\N	f	t	2016-11-16 11:00:51.864		t
63	\N	11	45	45	2	9	0	t	2016-11-15 11:40:12.1	\N	f	t	2016-11-16 11:00:51.864		t
74	\N	14	7	45	0	9	0	f	2016-11-15 11:40:27.047	\N	f	t	\N		t
76	\N	15	19	45	0	9	0	f	2016-11-15 11:57:43.096	\N	f	t	\N		t
77	\N	15	2	45	0	9	0	f	2016-11-15 11:57:43.096	\N	f	t	\N		t
78	\N	17	21	45	0	9	0	f	2016-11-15 12:35:22.506	\N	f	t	\N		t
79	\N	17	32	45	0	9	0	f	2016-11-15 12:35:22.506	\N	f	t	\N		t
80	\N	17	19	45	0	9	0	f	2016-11-15 12:35:22.506	\N	f	t	\N		t
81	\N	17	15	45	0	9	0	f	2016-11-15 12:35:22.506	\N	f	t	\N		t
82	\N	17	9	45	0	9	0	f	2016-11-15 12:35:22.506	\N	f	t	\N		t
83	\N	18	19	45	0	9	0	f	2016-11-15 12:40:33.483	\N	f	t	\N		t
84	\N	18	44	45	0	9	0	f	2016-11-15 12:40:33.483	\N	f	t	\N		t
85	\N	18	29	45	0	9	0	f	2016-11-15 12:40:33.483	\N	f	t	\N		t
87	\N	19	19	45	0	9	0	f	2016-11-15 15:29:19.94	\N	f	t	\N		t
88	\N	19	2	45	0	9	0	f	2016-11-15 15:29:19.94	\N	f	t	\N		t
55	\N	6	45	2	2	1	0	t	2016-11-10 11:24:39.348	\N	f	t	2016-11-16 11:00:40.639		t
53	\N	4	45	2	2	1	0	t	2016-11-10 11:04:21.459	\N	f	t	2016-11-16 11:00:40.639		t
52	\N	3	45	2	2	1	0	t	2016-11-10 10:59:59.216	\N	f	t	2016-11-16 11:00:40.639		t
51	\N	2	45	2	2	1	0	t	2016-11-10 10:57:10.073	\N	f	t	2016-11-16 11:00:40.639		t
50	\N	1	45	2	2	1	0	t	2016-11-10 10:53:53.752	\N	f	t	2016-11-16 11:00:40.639		t
89	\N	20	45	2	2	1	0	t	2016-11-16 10:59:08.323	\N	f	t	2016-11-16 11:00:40.639		t
54	\N	5	45	2	2	1	0	t	2016-11-10 11:06:35.362	\N	f	t	2016-11-16 11:00:40.639		t
57	\N	8	45	2	2	1	0	t	2016-11-14 16:53:14.401	\N	f	t	2016-11-16 11:00:40.639		t
56	\N	7	45	2	2	1	0	t	2016-11-10 12:20:33.475	\N	f	t	2016-11-16 11:00:40.639		t
58	\N	10	45	45	2	9	0	t	2016-11-15 11:35:57.323	\N	f	t	2016-11-16 11:00:40.639		t
86	\N	18	45	45	2	9	0	t	2016-11-15 12:40:33.483	\N	f	t	2016-11-16 11:00:51.864		t
75	\N	14	45	45	2	9	0	t	2016-11-15 11:40:27.047	\N	f	t	2016-11-16 11:00:51.864		t
90	\N	1	45	2	1	1	0	t	2016-11-17 16:45:11.517	\N	f	t	2016-11-22 09:01:54.429		t
91	\N	3	2	45	1	2	0	t	2016-11-22 09:00:32.679	\N	f	t	2016-11-22 12:26:09.657		t
93	\N	4	2	2	70	1	0	t	2016-11-22 12:47:19.835	\N	f	t	2016-11-22 12:48:58.284		t
92	\N	4	45	2	2	1	0	t	2016-11-22 12:47:19.835	\N	f	t	2016-11-22 12:49:32.53		t
\.


--
-- TOC entry 2260 (class 0 OID 303851)
-- Dependencies: 233
-- Data for Name: referencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY referencia (idreferencia, iddocumento, iddocumentoreferencia, fecharegistro, idusuarioregistra, estado) FROM stdin;
1	3	1	2016-08-26 00:00:00	1	f
2	3	2	2016-08-26 00:00:00	1	f
3	5	1	2016-08-29 00:00:00	1	f
4	6	5	2016-08-29 00:00:00	1	f
5	7	6	2016-08-29 00:00:00	1	f
6	8	2	2016-08-31 00:00:00	1	f
7	8	1	2016-08-31 00:00:00	1	f
8	9	6	2016-09-20 00:00:00	1	f
9	9	5	2016-09-20 00:00:00	1	f
10	31	30	2016-10-17 00:00:00	2	f
11	38	22	2016-10-19 00:00:00	9	f
12	38	30	2016-10-19 00:00:00	9	f
13	2	1	2016-11-14 00:00:00	1	f
14	7	6	2016-11-16 00:00:00	1	f
15	8	7	2016-11-16 00:00:00	1	f
\.


--
-- TOC entry 2261 (class 0 OID 303856)
-- Dependencies: 234
-- Data for Name: regla; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY regla (idregla, subida, igual, bajada, estado) FROM stdin;
\.


--
-- TOC entry 2246 (class 0 OID 139548)
-- Dependencies: 219
-- Data for Name: requisitos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requisitos (idrequisitos, idprocedimiento, denominacion, descripcion, monto, estado) FROM stdin;
1	1	Solicitud dirigida al Director de la Oficina de Secretaria General	Consignando lo siguiente: -Nombres y apellidos completos, número de documento de identificacion que corresponda y domicilio. -De ser el caso, número de teléfono y/o correo electrónico. -Firma del solicitante o huella digital. -Expresión concreta y precisa del pedido de información; asi como cualquier otro dato que propicie la localizacion o facilite la busqueda de la informacion solicitada. -En caso el solicitante conozca la dependencia que posea la informacion debera indicarlo en lasolicitud. -Opcionalmente, la forma o modalidad en la que prefiere el solicitante que la entidad le entregue la información.	\N	t
2	1	Recibo de pago del derecho de trámite. a)Por copia en tamaño A-4 (unidad)	\N	0.20000000000000001	t
3	1	Recibo de pago del derecho de trámite. b)Por CD (unidad)	\N	1.5	t
4	1	Recibo de pago del derecho de trámite. c)Por Copia en Dispositivos de Almacenamiento	\N	2	t
5	2	Presentar solicitud firmada por el solicitante.	\N	\N	t
6	2	En el caso de representación, presentar poder general formalizado mediante designación de persona cierta en el escrito, o mediante carta poder simple con firma del administrado.	\N	\N	t
7	2	Recibo de pago del derecho de trámite. a)Por primera copia	\N	2	t
8	2	Recibo de pago del derecho de trámite. b)Por hoja adicional	\N	2	t
9	6	Solicitud dirigida al Alcalde.	\N	\N	t
10	6	Plano de Ubicación y localización con coordenadas UTM, en formato A-3, firmado por el profesional responsable y propietario	\N	\N	t
11	6	Carta poder vigente, en caso de actuar como representante	\N	\N	t
12	6	Documento que acredite la propiedad: Compra venta, Titulo de propiedad, ficha registral o partida electrónica o copia literal, además adjuntar los siguientes requisitos	según corresponda: -Plano de arquitectura (distribución, cortes y elevaciones) impreso en formato A-3, firmado por el profesional responsable y el propietario, para inscripción del predio Matriz. (sólo en caso de predios bajo el Regimen de Propiedad Horizontal). -Copia de testimonio de acumulación o solicitud de acumulación de lotes dirigida a la SUNARP, con firmas legalizadas, para lotes acumulados. -Copia de Resolución de subdivisión; en caso de subdivisión de lotes.	\N	t
13	6	Copia del comprobante de pago de la tasa municipal correspondiente	\N	65.420000000000002	t
14	7	Solicitud dirigida al Alcalde	\N	\N	t
15	7	Plano de Ubicación y localización con coordenadas UTM, en formato A-3, firmado por el profesional responsable y propietario.	\N	\N	t
16	7	Documento que acredite la propiedad: Compra venta, Titulo de propiedad, ficha registral o partida electrónica o copia literal. derecho, con firma de abogado.	\N	\N	t
17	7	Copia del comprobante de pago de la tasa municipal correspondiente	\N	65.420000000000002	t
18	8	Solicitud dirigida al Alcalde	\N	\N	t
19	8	Plano de Ubicación y localización con coordenadas UTM, en formato A-3, firmado por el profesional responsable y propietario.	\N	\N	t
20	8	Documento que acredite la propiedad: Compra venta, Titulo de propiedad, ficha registral o partida electrónica o copia literal. derecho, con firma de abogado.	\N	\N	t
21	8	Copia del comprobante de pago de la tasa municipal correspondiente.	\N	65.420000000000002	t
22	9	Solicitud dirigida al Alcalde	\N	\N	t
23	9	Plano de Ubicación y localización con coordenadas UTM, en formato A-3, firmado por el profesional responsable y propietario	\N	\N	t
24	9	Documento que acredite la propiedad: Compra venta, Titulo de propiedad, ficha registral o partida electrónica o copia literal	\N	\N	t
25	9	Copia del comprobante de pago de la tasa municipal correspondiente	\N	60.560000000000002	t
26	11	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 1)FUE debidamente suscrito	\N	\N	t
27	11	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 2)Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
28	11	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 3)Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
29	11	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 4)Declaración Jurada de habilitación de los profesionales que suscriben la documentación.	\N	\N	t
30	11	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 5)Resolución emitido por la Dirección Regional de Cultura que aprueba el proyecto, adjuntando el expediente técnico debidamente visado por la Dirección Regional de Cultura	\N	\N	t
31	11	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 6)Copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	238.13999999999999	t
32	11	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 7)Copia de los comprobantes de pago por derecho de revisión	\N	\N	t
33	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 8)En caso se solicite Licencia de Edificación para Remodelación, Ampliación o Puesta en Valor Histórico 1)Planos de arquitectura (plantas, cortes y elevaciones) en los cuales se diferencie la edificación existente de la proyectada y su respectiva memoria descriptiva	Se considera: a)Plano de levantamiento de la edificación graficando con achurado 45 grados, los elementos a eliminar. b)Plano de la edificación resultante, graficando con achurado a 45 grados, perpendicular al anterior, los elementos a edificar. c) Para las obras de Puesta en Valor Histórico se debe graficar en los planos los elementos arquitectónicos con valor histórico monumental propios de la edificación, identificándose aquellos que serán objeto de restauración, aquellos que serán objeto de restauración,	\N	t
34	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 8)En caso se solicite Licencia de Edificación para Remodelación, Ampliación o Puesta en Valor Histórico 2)Planos de estructura y memoria justificativa; en los casos de obras de remodelación, ampliación o puesta en valor y cuando sea necesario en los demás tipo de obra. Debe diferenciarse los elementos estructurales existentes, los que se eliminarán y los nuevos, detallando adecuadamente los empalmes.	\N	\N	t
35	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 8)En caso se solicite Licencia de Edificación para Remodelación, Ampliación o Puesta en Valor Histórico 3)Planos de instalaciones y memoria justificativa, de ser necesario, donde: a) Se diferencien los puntos y salidas nuevos de los que se eliminarán; detallándose adecuadamente los empalmes. b)Se evaluará la factibilidad de servicios teniendo en cuenta la ampliación de cargas eléctricas y de dotación de agua potable	\N	\N	t
103	17	Declaración jurada, firmada por el profesional responsable de obra, manifestando que ésta se ha realizado conforme a los planos aprobados de la licencia de edificación	\N	\N	t
36	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 8)En caso se solicite Licencia de Edificación para Remodelación, Ampliación o Puesta en Valor Histórico 4)Para los proyectos de inmuebles sujetos al Régimen de Propiedad Exclusiva y de Propiedad Común, deberá además presentarse lo siguiente: a)Autorización de la Junta de Propietarios b)Reglamento Interno c)Planos de Independización correspondientes	\N	\N	t
37	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 8)En caso se solicite Licencia de Edificación para Remodelación, Ampliación o Puesta en Valor Histórico 5)En caso se solicite una Licencia Temporal de Edificación y luego de haber obtenido el dictamen Conforme en la especialidad de Arquitectura, deberá además presentarse el Anexo D del FUE	\N	\N	t
38	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 9)Plano de Ubicación y Localización según formato	\N	\N	t
39	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 10)Planos de Arquitectura (plantas, cortes y elevaciones), Estructuras, Instalaciones Sanitarias, Instalaciones Eléctricas y otros, de ser el caso, y las memorias justificativas por especialidad	\N	\N	t
40	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 11)Plano de seguridad y evacuación cuando se requiera la intervención de los delegados Ad Hoc del INDECI o del CGBVP.	\N	\N	t
41	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 12)Plano de Sostenimiento de Excavaciones, de serel caso y de acuerdo a lo establecido en la Norma E 050 del RNE	\N	\N	t
42	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 13)Memoria descriptiva que precise las características de la obra y las edificaciones colindantes; indicando el número de pisos y sótanos; así como fotos en los casos que se presente el Plano de Sostenimiento de Excavaciones	\N	\N	t
43	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 14)Certificado de Factibilidad de Servicios	\N	\N	t
44	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 15)Estudio de Mecánica de Suelos, según los casos que establece el RNE	\N	\N	t
45	11	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 16)Estudios de Impacto Ambiental y de Impacto Vial aprobados por las entidades competentes y en los casos que se requiera. Notas: a)Todos los documentos serán presentados por duplicado. b)El Formulario y sus anexos deben ser visados en todas sus páginas y cuando corresponda, firmados por el propietario o por el solicitante y los profesionales que interviene. c) Todos los planos y documentos técnicos deben estar sellados y firmados por el profesional responsable de los mismos y firmados por el propietario o solicitante	\N	\N	t
46	11	B)VERIFICACIÓN TÉCNICA 17)Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
47	11	B)VERIFICACIÓN TÉCNICA 18)Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
48	11	B)VERIFICACIÓN TÉCNICA 19)Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspección	\N	160.41999999999999	t
49	11	B)VERIFICACIÓN TÉCNICA 20)Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil, según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros	\N	\N	t
50	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 1)FUE debidamente suscrito, por duplicado.	\N	\N	t
51	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 2)Documentación que acredite la propiedad: Copia literal de dominio, escritura de compra venta y/o minuta	\N	\N	t
52	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 3)Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
53	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 4)Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
54	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 5)Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
55	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 6)Memoria Descriptiva del estado actual y de la propuesta, donde se sustenten los criterios adoptados en las intervenciones planteadas (suscrito por profesional correspondiente)	\N	\N	t
56	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 7)Copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	\N	t
57	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 8)Copia de los comprobantes de pago por derecho de revisión a la Comision Tecnica	\N	\N	t
58	12	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 9)Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; ó copia del Certificado de Conformidad ó Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente ó copia del Certificado de Conformidad ó Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
59	12	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 10)Plano de Ubicación y Localización conteniendo: cuadro de áreas (construidas, a intervenir o demoler), linderos del lote, alturas y usos de la edificación existente, a escala 1/500 (suscrito por profesional correspondiente)	\N	\N	t
60	12	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 11)Planos de arquitectura, indicando la construcción existente y la proyectada en los casos de ampliacióny adecuación arquitectónica, ademas adjuntar: - Planos de distribución (indicando el nivel de piso terminado, el uso actual y futuro de cada uno de los ambientes) - Planos de cortes, elevaciones y techos a escala 1/50, o 1/100 (firmado por el profesional correspondiente)	\N	\N	t
61	12	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 12)Plano de conjunto de la zona a intevenir (esc 1/200), si corresponde	\N	\N	t
62	12	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 13)Plano de fachada del contexto cuando se integra el el proyecto o cuando tenga frente a la via publica, indicando los detalles arquitectónicos, si corresponde	\N	\N	t
63	12	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 14)Plano de estructuras con la cimentación, detalle de columnas, losas aligeradas de la cobertura (techos con proyecto de drenaje pluvial) a escala 1/50 (firmado por el profesional correspondiente)	\N	\N	t
64	12	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 15)Planos de instalaciones sanitarias y detalles correspondientes de la edificación proyectada, considerando solución para el desague pluvial de los techos, de la edificación proyectada a escala 1/50 (firmados por el profesional correspondiente)	\N	\N	t
104	17	Comprobante de pago por la tasa municipal respectiva	\N	195.56	t
65	12	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica 16)Planos de instalaciones eléctricas, mecánicas, especiales y detalles correspondientes de la edificación proyectada, a escala 1/50, (firmados por el profesional correspondiente)	\N	\N	t
66	12	B)VERIFICACIÓN TÉCNICA 17)Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
67	12	B)VERIFICACIÓN TÉCNICA 18)Comunicación de la fecha de inicio de la obra en caso no se haya indicado en el FUE	\N	\N	t
68	12	B)VERIFICACIÓN TÉCNICA 19)Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspección	\N	160.41999999999999	t
69	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 1)FUE debidamente suscrito	\N	\N	t
70	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 2)Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
71	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 3)Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
72	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 4)Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
73	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 5)Copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	253.86000000000001	t
74	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 6)Copia de los comprobantes de pago por derecho de revisión	\N	\N	t
75	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 7)Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; ó copia del Certificado de Conformidad ó Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
76	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 8)En caso la edificación no pueda acreditarse con la autorización respectiva, se deberá presentar: 8.1.Plano de ubicación y localización; y 8.2.Plano de planta de la edificación a demoler. diferenciando las áreas a demoler de las remanentes	\N	\N	t
77	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 9)En caso la fábrica se encuentre inscrita en los Registros Públicos, se deberá acreditar que sobre el bien no recaigan cargas y/o gravámenes; ó acreditar la autorización del titular de la carga ó gravamen	\N	\N	t
78	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 10)Plano de Ubicación y Localización conteniendo: cuadro de áreas (construidas, a intervenir o demoler), linderos del lote	\N	\N	t
79	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 11)Planos de distribución por plantas indicando las areas a demoler	\N	\N	t
80	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 12)Memoria descriptiva de los trabajos a realizar y del procedimiento de demolición a utilizar, donde se consideren las medidas de seguridad contempladas en la Norma Técnica G.050 del RNE y demás normas de la materia	\N	\N	t
81	13	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes 13)En caso de uso de explosivos, se deberá presentar además lo siguiente: a)Autorizaciones de las autoridades competentes (DISCAMEC, Comando Conjunto de las Fuerzas y Defensa Civil), según corresponda. b)Copia del cargo del documento dirigido a los propietarios y/u ocupantes de las edificaciones colindantes a la obra, comunicándoles las fechas y horas en que se efectuarán las detonaciones	\N	\N	t
82	13	B)VERIFICACIÓN TÉCNICA 14)Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
83	13	B)VERIFICACIÓN TÉCNICA 15)Comunicación de la fecha de inicio de la obra de demolición en caso no se haya indicado en el FUE	\N	\N	t
84	13	B)VERIFICACIÓN TÉCNICA 16)Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspección.	\N	160.41999999999999	t
85	13	B)VERIFICACIÓN TÉCNICA 17)Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil, según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros mayor a la duración del proceso edificatorio	\N	\N	t
86	14	Solicitud simple dirigida al Alcalde	\N	\N	t
87	14	Documentación técnica exigida para la modalidad C que sean materia de la modificación propuesta	\N	\N	t
88	14	Planos del Proyecto modificado	\N	\N	t
89	14	Copia del comprobante de pago por derecho de revisión, de la Comisión Técnica, de corresponder	\N	\N	t
90	14	Copia del comprobante de pago de la tasa municipal correspondiente	\N	121.78	t
91	15	Anexo H del FUE debidamente suscrito	\N	\N	t
92	15	Copia del comprobante de pago de la tasa municipal correspondiente	\N	191.40000000000001	t
93	15	Copia del comprobante de pago por derecho de revisión de la Comisión Técnica	\N	\N	t
94	15	Documentos exigido para la modalidad C que sean materia de la modificación propuesta	\N	\N	t
95	15	Planos del proyecto modificado 	\N	\N	t
96	15	Factibilidad de Servicios de corresponder	\N	\N	t
97	16	Anexo C del FUE - Pre Declaratoria de Edificación, debidamente suscrito y por triplicado	\N	\N	t
98	16	En caso que titular del derecho a edificar sea una persona distinta a quien inicio el procedimiento de edificación, deberá presentar: a) Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio. b) Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
99	16	Comprobante de pago por la tasa municipal respectiva	\N	93.609999999999999	t
100	17	La sección del FUE - Conformidad de Obra y Declaratoria de Edificación, debidamente suscrito y por triplicado	\N	\N	t
101	17	En caso que titular del derecho a edificar sea una persona distinta a quien inicio el procedimiento de edificación, deberá presentar: a) Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio. b) Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
102	17	Copia de los Planos de Ubicación y de Arquitectura aprobados, correspondiente a la Licencia de Edificación por triplicado	\N	\N	t
488	71	Solicitud simple dirigida al Alcalde	\N	\N	t
105	18	La sección del FUE - Conformidad de Obra y Declaratoria de Edificación, debidamente suscrito y por triplicado	\N	\N	t
106	18	En caso que titular del derecho a edificar sea una persona distinta a quien inicio el procedimiento de edificación, deberá presentar: a) Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio b) Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
107	18	Planos de replanteo por triplicado: planos de ubicación y de arquitectura (plantas, cortes y elevaciones) con las mismas especificaciones de los planos del proyecto aprobado y que correspondan a la obra ejecutada, debidamente suscritos por el solicitante y el profesional responsable o constatador de la obra	\N	\N	t
108	18	Carta que acredite la autorización del proyectista original para realizar las modificaciones, en caso éste no sea el responsable ni el constatador de la obra. 	\N	\N	t
109	18	Declaración jurada de habilidad del profesional responsable o constatador de la obra	\N	\N	t
110	18	Comprobante de pago por derecho de revisión, correspondiente a la especialidad de Arquitectura	\N	\N	t
111	18	Comprobante de pago por la tasa municipal respectiva	\N	217.86000000000001	t
112	19	Solicitud simple dirigida al Alcalde	\N	\N	t
113	19	Plano de Ubicación y Localización según formato	\N	\N	t
114	19	Planos de arquitectura (planta, cortes y elevaciones) en escala 1/100 	\N	\N	t
115	19	Planos de seguridad y evacuación amoblados, en la Modalidad C cuando se requiera la intervención de los delegados Ad Hoc del INDECI o el CGBVP	\N	\N	t
116	19	Declaración jurada de habilidad del profesional que interviene	\N	\N	t
117	19	Copia del comprobante de pago por derecho de revisión, sólo para la modalidad de aprobación C	\N	\N	t
118	19	Comprobante de pago por la tasa municipal respectiva	\N	164.06	t
119	20	Anexo H del FUE ó deL FUHU según corresponda, debidamente suscrito. 	\N	\N	t
120	20	Comprobante de pago de la tasa municipal correspondiente	\N	121.78	t
121	21	Solicitud firmada por el solicitante	\N	\N	t
122	21	Copia del documento que acredite el número de la licencia y/o del expediente	\N	\N	t
123	22	Solicitud simple dirigida al Alcalde	\N	\N	t
124	22	Planos de ubicación y planta detallando características físicas y técnicas	\N	\N	t
125	22	Memoria descriptiva	\N	\N	t
126	22	Permiso de interferencia vial GTU/MML, de ser el caso	\N	\N	t
127	22	Cronograma de avance de obra	\N	\N	t
128	22	Copia del comprobante de pago de la tasa municipal correspondiente	\N	37	t
129	23	Solicitud simple dirigida al Alcalde	\N	\N	t
130	23	Planos de ubicación y planta detallando características físicas y técnicas	\N	\N	t
131	23	Memoria descriptiva	\N	\N	t
132	23	Permiso de interferencia vial GTU/MML, de ser el caso	\N	\N	t
133	23	Cronograma de avance de obra	\N	\N	t
134	23	Copia del comprobante de pago de la tasa municipal correspondiente	\N	37	t
135	24	Solicitud simple dirigida al Alcalde, indicando el numero de Licencia de Edificación	\N	\N	t
136	24	Planos de ubicación y planta detallando características físicas y técnicas (firmado por ingeniero civil, electricista o de telecomunicaciones)	\N	\N	t
137	24	Memoria descriptiva	\N	\N	t
138	24	Cronograma de avance de obra	\N	\N	t
139	24	Copia del comprobante de pago de la tasa municipal correspondiente	\N	58.549999999999997	t
140	25	Solicitud de autorización dirigida al Alcalde	\N	\N	t
141	25	Copia de Licencia de Funcionamiento	\N	\N	t
142	25	Diseño grafico o fotomontaje indicando ubicación en la fachada, dimensiones, materia, color y texto	\N	\N	t
143	25	Autorización de la Dirección Regional de Cultura en caso de bienes declarados	\N	\N	t
144	25	Copia del comprobante de pago de la tasa municipal correspondiente	\N	94.780000000000001	t
145	26	Solicitud de autorización dirigida al Alcalde	\N	\N	t
146	26	Copia de Licencia de Funcionamiento	\N	\N	t
147	26	Diseño de la estructura metálica de tipo plegable de material Lino plastificado pesado-350 Gr/m2	\N	\N	t
148	26	Copia del comprobante de pago de la tasa municipal correspondiente	\N	100.02	t
149	27	Solicitud de autorización dirigida al Alcalde	\N	\N	t
150	27	Fotografía con fotomontaje del elemento de publicidad exterior en el cual se debe apreciar el entorno y el bien o edificación donde se instalaría el elemento	\N	\N	t
151	27	Copia Simple de la Licencia de Funcionamiento del establecimiento con giro a fin al anuncio del elemento publicitario	\N	\N	t
152	27	Autorización escrita del propietario del predio, y/o vehículo para el cual se solicita la autorización de instalación	\N	\N	t
153	27	Constancia de inscripción de constitución como Persona Jurídica en el Registro Público correspondiente, copia de documento que acredite la representación legal y exhibición del DNI del representante legal	\N	\N	t
154	27	Copia del comprobante de pago de la tasa municipal correspondiente	\N	81.680000000000007	t
155	28	Solicitud de autorización dirigida al Alcalde	\N	\N	t
156	28	Fotografía con fotomontaje del elemento de publicidad exterior la misma que deberá contar con las dimensiones y colores establecidos	\N	\N	t
157	28	Copia del comprobante de pago de la tasa municipal correspondiente por día	\N	5	t
158	29	Solicitud de renovación de autorización, indicando el número de la Resolución de autorización	\N	\N	t
159	29	Copia de Licencia de Funcionamiento del establecimiento	\N	\N	t
160	29	Copia del comprobante de pago de la tasa municipal correspondiente	\N	100.02	t
161	30	Solicitud dirigida al Alcalde	\N	\N	t
162	30	Documentos sustentatorios de la propiedad; minuta, Escritura Pública, contrato privado, u otros similares	\N	\N	t
163	30	Copia de constitución de la asociación (en caso necesario)	\N	\N	t
164	30	Plano simple de ubicación del predio	\N	\N	t
165	30	Acta de verificación de posesión efectiva del predio emitida por un funcionario de la municipalidad correspondiente y suscrita por todos los colindantes del predio o acta policial de posesión suscrita por todos los colindantes de dicho predio	\N	\N	t
166	30	Copia del comprobante de pago de la tasa municipal correspondiente	\N	108.03	t
167	31	Solicitud dirigida al Alcalde, indicando el fin del pedido.	\N	\N	t
168	31	Documentos sustentatorios de la propiedad; minuta, Escritura Pública, contrato privado, u otros similares	\N	\N	t
169	31	Copia de constitución de la asociación (en caso necesario)	\N	\N	t
170	31	Plano simple de ubicación del predio	\N	\N	t
171	31	Declaración Jurada firmada por los vecinos colindantes que acreditan la posesión del recurrente	\N	\N	t
172	31	Memoria Descriptiva	\N	\N	t
173	31	Copia del comprobante de pago de la tasa municipal correspondiente	\N	\N	t
174	32	Solicitud dirigida al Alcalde, consignando el número de Resolución de Licencia	\N	\N	t
175	32	Presentar copia de documento que acredite la propiedad	\N	\N	t
176	32	Copia de recibo de agua, luz o teléfono	\N	\N	t
177	32	Copia del comprobante de pago de la tasa municipal correspondiente	\N	115.05	t
178	33	Solicitud dirigida al Alcalde	\N	\N	t
179	33	Plano de Ubicación y Localización a una escala adecuada, detallando caracteristicas tecnicas, areas, linderos y medidas perimétricas, firmado por el profesional y el propietario	\N	\N	t
180	33	Plano de arquitectura (distribución, cortes y elevaciones), en caso corresponda	\N	\N	t
181	33	Copia de testimonio de acumulación o solicitud de acumulación de lotes dirigida a la SUNARP, con firmas legalizadas, en caso corresponda a lotes acumulados	\N	\N	t
182	33	Copia de Resolución de subdivisión; en caso corresponda a subdivisión de lotes	\N	\N	t
183	33	Documento que acredite la propiedad: Compra venta, Titulo de propiedad, ficha registral o copia literal	\N	\N	t
184	33	De actuar como representante, adjuntar carta poder vigente	\N	\N	t
185	33	Copia del comprobante de pago de la tasa municipal correspondiente	\N	71.209999999999994	t
186	34	Solicitud dirigida al Alcalde	\N	\N	t
187	34	Plano de Ubicación y Localización a una escala adecuada, detallando caracteristicas tecnicas, areas, linderos y medidas perimétricas, firmado por el profesional y el propietario	\N	\N	t
188	34	Documento que acredite la propiedad: Compra venta, Titulo de propiedad, ficha registral o copia literal	\N	\N	t
189	34	Copia del comprobante de pago de la tasa municipal correspondiente	\N	71.209999999999994	t
190	35	Solicitud dirigida al Alcalde	\N	\N	t
191	35	Plano de Ubicación y Localización a una escala adecuada, detallando caracteristicas tecnicas, áreas, linderos y medidas perimétricas, firmado por el profesional y el propietario	\N	\N	t
192	35	Documento que acredite la propiedad: Compra venta, Titulo de propiedad, ficha registral o copia literal	\N	\N	t
193	35	Copia del comprobante de pago de la tasa municipal correspondiente	\N	71.209999999999994	t
194	36	Solicitud dirigida al Alcalde	\N	\N	t
195	36	Plano de Ubicación y Localización a una escala adecuada, detallando caracteristicas tecnicas, áreas, linderos y medidas perimétricas, firmado por el profesional y el propietario (Tres juegos)	\N	\N	t
196	36	Memoria Descriptiva	\N	\N	t
197	36	Documento que acredite la propiedad: Escritura Pública, Compra venta, Titulo de propiedad, ficha registral o copia literal	\N	\N	t
198	36	Copia del comprobante de pago de la tasa municipal correspondiente	\N	70.969999999999999	t
199	44	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
200	44	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
201	44	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
202	44	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que intervienen en el proyecto y suscriben la documentación técnica	\N	\N	t
203	44	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	132.5	t
204	44	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
205	44	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones) Estructuras, Instalaciones Sanitarias e Instalaciones Eléctricas	\N	\N	t
206	44	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
207	44	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
208	44	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspección	\N	84.799999999999997	t
209	45	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
210	45	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
211	45	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
212	45	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que intervienen en el proyecto y suscriben la documentación técnica	\N	\N	t
213	45	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	132.5	t
214	45	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
215	45	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de ubicación y Localización según formato	\N	\N	t
216	45	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones), Estructuras, Instalaciones Sanitarias e Instalaciones Eléctricas, donde se diferencien las áreas existentes de las ampliadas	\N	\N	t
411	58	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Informe Técnico Favorable de los Revisores Urbanos	\N	\N	t
217	45	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
218	45	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
219	45	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	84.799999999999997	t
220	46	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
221	46	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
222	46	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
223	46	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que intervienen en el proyecto y suscriben la documentación técnica	\N	\N	t
224	46	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con opia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	132.5	t
225	46	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
226	46	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
227	46	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones)	\N	\N	t
228	46	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
229	46	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
230	46	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	84.799999999999997	t
231	47	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
232	47	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
233	47	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
234	47	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que intervienen en el proyecto y suscriben la documentación técnica	\N	\N	t
235	47	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	132.5	t
236	47	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
237	47	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de ubicación y Localización según formato	\N	\N	t
238	47	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones), Estructuras, Instalaciones Sanitarias e Instalaciones Eléctricas, donde se diferencien las áreas existentes de las remodeladas	\N	\N	t
239	47	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
240	47	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
241	47	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	84.799999999999997	t
242	48	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
243	48	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
244	48	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
245	48	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que intervienen en el proyecto y suscriben la documentación técnica	\N	\N	t
246	48	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	132.5	t
247	48	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
248	48	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
249	48	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de las especialidades que correspondan y sus respectivas memorias descriptivas	\N	\N	t
250	48	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
251	48	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
252	48	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	84.799999999999997	t
253	49	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
254	49	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a demoler y represente al titular, en caso que el solicitante no sea el propietario del predio	\N	\N	t
255	49	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en el caso que el solicitante sea una persona jurídica	\N	\N	t
256	49	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación del profesional que interviene en el proyecto y suscribe la documentación técnica	\N	\N	t
257	49	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	147.93000000000001	t
258	49	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos, en caso no haya sido expedido por la municipalidad; o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
259	49	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso la edificación a demoler no pueda acreditarse con la autorización respectiva, se deberá presentar: 1)Plano de ubicación y localización; y 2)Plano de planta de la edificación a demoler	\N	\N	t
260	49	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso la fábrica se encuentre inscrita en los Registros Públicos, se deberá acreditar que sobre el bien no recaigan cargas y/o gravámenes; o acreditar la autorización del titular de la carga o gravamen	\N	\N	t
261	49	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación	\N	\N	t
262	49	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Carta de Responsabilidad de Obra, firmada por ingeniero civil	\N	\N	t
263	49	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
264	49	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
265	49	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspección	\N	84.799999999999997	t
266	50	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
267	50	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
268	50	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
269	50	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que intervienen en el proyecto y suscriben la documentación técnica	\N	\N	t
270	50	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	132.5	t
271	50	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica (Por Duplicado): Plano de Ubicación	\N	\N	t
272	50	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica (Por Duplicado): Plano Perimétrico	\N	\N	t
273	50	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica (Por Duplicado): Descripción general del proyecto	\N	\N	t
274	50	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
275	50	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
276	50	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	84.799999999999997	t
277	51	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
278	51	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
279	51	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
280	51	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
281	51	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	155.65000000000001	t
282	51	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Factibilidad de Servicios para obra nueva de vivienda multifamiliar	\N	\N	t
283	51	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de ubicación y localización según formato	\N	\N	t
284	51	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones), Estructuras, Instalaciones Sanitarias, Instalaciones Eléctricas y otras, de ser el caso, y las memorias justificativas por especialidad	\N	\N	t
285	51	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Sostenimiento de Excavaciones, de ser el caso y de acuerdo a lo establecido en la Norma E 050 del RNE	\N	\N	t
286	51	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva que precise las características de la obra y las edificaciones colindantes; indicando el número de pisos y sótanos; así como fotos en los casos que se presente el Plano de Sostenimiento de Excavaciones	\N	\N	t
287	51	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos, según los casos que establece el RNE	\N	\N	t
288	51	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros	\N	\N	t
289	51	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
290	51	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
291	51	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	102.7	t
292	52	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
445	62	Copia del comprobante de pago de la tasa municipal correspondiente	\N	117.08	t
293	52	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
294	52	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
295	52	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
296	52	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	155.65000000000001	t
297	52	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del Reglamento Interno y plano de Independización de la unidad inmobiliaria correspondiente	\N	\N	t
298	52	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Autorización de la Junta de Propietarios, de ser el caso y de acuerdo a lo establecido en el Reglamento Interno	\N	\N	t
299	52	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
300	52	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de las especialidades que correspondan y sus respectivas memorias descriptivas	\N	\N	t
301	52	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Sostenimiento de Excavaciones, de ser el caso y de acuerdo a lo establecido en la Norma E 050 del RNE	\N	\N	t
302	52	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva que precise las características de la obra y las edificaciones colindantes; indicando el número de pisos y sótanos; así como fotos en los casos que se presente el Plano de Sostenimiento de Excavaciones	\N	\N	t
303	52	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
304	52	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
305	52	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	102.7	t
306	53	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
307	53	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
308	53	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
309	53	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
310	53	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	155.65000000000001	t
311	53	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
312	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de ubicación y localización según formato	\N	\N	t
313	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones), Estructuras, Instalaciones Sanitarias, Instalaciones Eléctricas y otros, de ser el caso, donde se diferencien las areas existentes de las ampliadas y/o remodeladas; y las memorias justificativas por especialidad	\N	\N	t
314	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Sostenimiento de Excavaciones, de ser el caso y de acuerdo a lo establecido en la el caso y de acuerdo a lo establecido en la	\N	\N	t
315	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva que precise las características de la obra y las edificaciones colindantes; indicando el número de pisos y sótanos; así como fotos en los casos que se presente el Plano de Sostenimiento de Excavaciones	\N	\N	t
316	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Factibilidad de Servicios para obras de ampliación de Vivienda Multifamiliar, obras de remodelación de Vivienda Unifamiliar a Multifamiliar o a otros fines diferentes al de vivienda	\N	\N	t
317	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos, según los casos que establece el RNE	\N	\N	t
318	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros	\N	\N	t
319	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del Reglamento Interno y plano de Independización de la unidad inmobiliaria correspondiente, en caso que el inmueble a intervenir esté sujeto al régimen de propiedad exclusiva y propiedad común	\N	\N	t
320	53	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Autorización de la Junta de Propietarios, de ser el caso y de acuerdo a lo establecido en el Reglamento Interno	\N	\N	t
321	53	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
322	53	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
323	53	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	102.7	t
324	54	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes (por duplicado): FUE debidamente suscrito	\N	\N	t
325	54	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes (por duplicado): Documentación que acredite que cuenta con derecho a demoler y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
326	54	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes (por duplicado): Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
327	54	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes (por duplicado): Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
328	54	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes (por duplicado): Anexo D del FUE con copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	163.37	t
329	54	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes (por duplicado): Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
330	54	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes (por duplicado): En caso la edificación no pueda acreditarse con la autorización respectiva, se deberá presentar: 1)Plano de ubicación y localización; y 2)Plano de planta de la edificación a demoler diferenciando las áreas a demoler de las remanentes	\N	\N	t
331	54	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes (por duplicado): En caso la fábrica se encuentre inscrita en los Registros Públicos, se deberá acreditar que sobre el bien no recaigan cargas y/o gravámenes; o acreditar la autorización del titular de la carga o gravamen	\N	\N	t
332	54	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
333	54	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas), diferenciando las zonas y elementos de la edificación a demoler, así como el perfil y alturas de los inmuebles colindantes, hasta una distancia de 1.50 m de los limites de la propiedad	\N	\N	t
334	54	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva de los trabajos a realizar y del procedimiento de demolición a utilizar, donde se consideren las medidas de seguridad contempladas en la Norma Técnica G.050 del RNE y demás normas de la materia	\N	\N	t
335	54	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros	\N	\N	t
336	54	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Carta de Responsabilidad de Obra, firmada por ingeniero civil	\N	\N	t
337	54	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del Reglamento Interno y plano de independización de la unidad inmobiliaria correspondiente, en caso que el inmueble a intervenir esté sujeto al régimen de propiedad exclusiva y propiedad común	\N	\N	t
338	54	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Autorización de la Junta de Propietarios, de ser el caso y de acuerdo a lo establecido en el Reglamento Interno	\N	\N	t
339	54	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
340	54	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
341	54	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	102.7	t
342	55	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
343	55	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
344	55	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
345	55	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
346	55	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	291.49000000000001	t
347	55	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia de los comprobantes de pago por derecho de revisión	\N	\N	t
348	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
349	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones), Estructuras, Instalaciones Sanitarias, Instalaciones Eléctricas y otros, de ser el caso, y las memorias justificativas por especialidad	\N	\N	t
350	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de seguridad y evacuación cuando se requiera la intervención de los delegados Ad Hoc del INDECI o del CGBVP	\N	\N	t
351	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Sostenimiento de Excavaciones, de ser el caso y de acuerdo a lo establecido en la Norma E 050 del RNE	\N	\N	t
352	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva que precise las características de la obra y las edificaciones colindantes; indicando el número de pisos y sótanos; así como fotos en los casos que se presente el Plano de Sostenimiento de Excavaciones	\N	\N	t
353	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Factibilidad de Servicios	\N	\N	t
354	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos, según los casos que establece el RNE	\N	\N	t
355	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudios de Impacto Ambiental y de Impacto Víal aprobados por las entidades competentes y en los casos que se requiera	\N	\N	t
378	56	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el dictamen Conforme del Proyecto se debe presentar lo siguiente: Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil, según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros. mayor a la duración del proceso edificatorio	\N	\N	t
379	57	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
380	57	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
381	57	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
382	57	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
383	57	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	239	t
356	55	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: En caso se solicite Licencia de Edificación para Remodelación, Ampliación o Puesta en Valor Histórico deberá presentarse lo siguiente: 1)Planos de arquitectura (plantas, cortes y elevaciones) en los cuales se diferencie la edificación existente de la proyectada y su respectiva memoria descriptiva, considerando: a)Plano de levantamiento de la edificación graficando con achurado 45 grados, los elementos a eliminar. b)Plano de la edificación resultante, graficándo con achurado a 45 grados, perpendicular al anterior, los elementos a edificar. c)Para las obras de Puesta en Valor Histórico se debe graficar en los planos los elementos arquitectónicos con valor histórico monumental propios de la edificación, identificándose aquellos que serán objeto de restauración, reconstrucción o conservación, de ser el caso. 2)Planos de estructura y memoria justificativa; en los casos de obras de remodelación, ampliación o puesta en valor y cuando sea necesario en los demás tipo de obra. Debe diferenciarse los elementos estructurales existentes, los que se eliminarán y los nuevos, detallando adecuadamente los empalmes. 3)Planos de instalaciones y memoria justificativa, de ser necesario, donde: a)Se diferencien los puntos y salidas nuevos de los que se eliminarán; detallandose adecuadamente los emplames. b)Se evaluará la factibilidad de servicios teniendo en cuenta la ampliación de cargas eléctricas y de dotación de agua potable. 4)Para los proyectos de inmuebles sujetos al Régimen de Propiedad Exclusiva y de Propiedad Común, deberá además presentarse lo siguiente: a)Autorización de la Junta de Propietarios b)Reglamento Interno c)Planos de Independización correspondientes 5)En caso se solicite una Licencia Temporal de Edificación y luego de haber obtenido el dictamen Conforme en la especialidad de Arquitectura, deberá además presentarse el Anexo D del FUE	\N	\N	t
357	55	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el último dictamen Conforme del Proyecto se debe presentar lo siguiente: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
358	55	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el último dictamen Conforme del Proyecto se debe presentar lo siguiente: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
359	55	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el último dictamen Conforme del Proyecto se debe presentar lo siguiente: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	175.40000000000001	t
360	55	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el último dictamen Conforme del Proyecto se debe presentar lo siguiente: Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil, según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros	\N	\N	t
361	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
362	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
363	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
364	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
365	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	300.44	t
366	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia de los comprobantes de pago por derecho de revisión	\N	\N	t
367	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
368	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso la edificación no pueda acreditarse con la autorización respectiva, se deberá presentar: 1)Plano de ubicación y localización; y 2)Plano de planta de la edificación a demoler diferenciando las áreas a demoler de las remanentes	\N	\N	t
369	56	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso la fábrica se encuentre inscrita en los Registros Públicos, se deberá acreditar que sobre el bien no recaigan cargas y/o gravámenes; o acreditar la autorización del titular de la carga o gravamen	\N	\N	t
370	56	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
371	56	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de plantas a escala 1/75, dimensionados adecuadamente, en el que se delineará las zonas de la fábrica o edificación a demoler, así como del perfil y altura de los inmuebles colindantes a las zonas de la fábrica o edificación a demoler, hasta una distancia de 1.50 m de los límites de propiedad	\N	\N	t
372	56	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de cerramiento del predio, cuando se trate de demolición total	\N	\N	t
373	56	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva de los trabajos a realizar y del procedimiento de demolición a utilizar, donde se consideren las medidas de seguridad contempladas en la Norma Técnica G.050 del RNE y demás normas de la materia	\N	\N	t
374	56	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: En caso de uso de explosivos, se deberá presentar además lo siguiente: a)Autorizaciones de las autoridades competentes (DISCAMEC, Comando Conjunto de las Fuerzas y Defensa Civil), según corresponda. b)Copia del cargo del documento dirigido a los propietarios y/u ocupantes de las edificaciones colindantes a la obra, comunicándoles las fechas y horas en que se efectuarán las detonaciones	\N	\N	t
375	56	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el dictamen Conforme del Proyecto se debe presentar lo siguiente: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
376	56	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el dictamen Conforme del Proyecto se debe presentar lo siguiente: Comunicación de la fecha de inicio de la obra de demolición en caso no se haya indicado en el FUE	\N	\N	t
377	56	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el dictamen Conforme del Proyecto se debe presentar lo siguiente: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	175.40000000000001	t
384	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
446	63	Anexo H del FUE debidamente suscrito	\N	\N	t
659	89	Cronograma de avance de obra	\N	\N	t
385	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones), Estructuras, Instalaciones Sanitarias, Instalaciones Eléctricas y otros, de ser el caso, y las memorias justificativas por especialidad	\N	\N	t
386	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de seguridad y evacuación cuando se requiera la intervención de los delegados Ad Hoc del INDECI o del CGBVP.	\N	\N	t
387	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Sostenimiento de Excavaciones, de ser el caso y de acuerdo a lo establecido en la Norma E 050 del RNE	\N	\N	t
388	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva que precise las características de la obra y las edificaciones colindantes; indicando el número de pisos y sótanos; así como fotos en los casos que se presente el Plano de Sostenimiento de Excavaciones	\N	\N	t
389	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Factibilidad de Servicios	\N	\N	t
390	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos, según los casos que establece el RNE	\N	\N	t
391	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudios de Impacto Ambiental y de Impacto Víal aprobados por las entidades competentes y en los casos que se requiera	\N	\N	t
392	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: En caso se solicite Licencia de Edificación para Remodelación, Ampliación o Puesta en Valor Histórico deberá presentarse lo siguiente: 1)Planos de arquitectura en los cuales se diferencie la edificación existente de la proyectada y su respectiva memoria descriptiva, de acuerdo a lo siguiente: a)Plano de levantamiento de la edificación graficando con achurado 45 grados, los elementos a eliminar. b)Plano de la edificación resultante, graficándo con achurado a 45 grados, perpendicular al anterior, los elementos a edificar. c)Para las obras de Puesta en Valor Histórico se debe graficar en los planos los elementos arquitectónicos con valor histórico monumental propios de la edificación, identificándose aquellos que serán objeto de restauración, reconstrucción o conservación, de ser el caso. 2)Planos de estructura y memoria justificativa; en los casos de obras de remodelación, ampliación o puesta en valor y cuando sea necesario en los demás tipo de obra. Debe diferenciarse los elementos estructurales existentes, los que se eliminarán y los nuevos, detallando adecuadamente los empalmes. 3)Planos de instalaciones y memoria justificativa, de ser necesario, donde: a)Se diferencien los puntos y salidas nuevos de los que se eliminarán; detallandose adecuadamente los emplames. b)Se evaluará la factibilidad de servicios teniendo en cuenta la ampliación de cargas eléctricas y de dotación de agua potable. 4)Para los proyectos de inmuebles sujetos al Régimen de Propiedad Exclusiva y de Propiedad Común, deberá además presentarse lo siguiente: a)Autorización de la Junta de Propietarios b)Reglamento Interno c)Planos de Independización correspondientes	\N	\N	t
393	57	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Informe Técnico Favorable de los Revisores Urbanos	\N	\N	t
394	57	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
395	57	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
396	57	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion.	\N	175.40000000000001	t
397	57	B)VERIFICACIÓN TÉCNICA: Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil, según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros. mayor a la duración del proceso edificatorio	\N	\N	t
398	58	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
399	58	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
400	58	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
401	58	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
402	58	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia de comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	247.94999999999999	t
403	58	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del documento que acredite la declaratoria fábrica o de edificación con sus respectivos planos en caso no haya sido expedido por la municipalidad; o copia del Certificado de Conformidad o Finalización de Obra, o la Licencia de Obra o de Construcción de la edificación existente	\N	\N	t
404	58	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso la edificación no pueda acreditarse con la autorización respectiva, se deberá presentar: a)Plano de ubicación y localización; y b)Plano de planta de la edificación a demoler. diferenciando las áreas a demoler de las remanentes	\N	\N	t
405	58	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso la fábrica se encuentre inscrita en los Registros Públicos, se deberá acreditar que sobre el bien no recaigan cargas y/o gravámenes; o acreditar la autorización del titular de la carga o gravamen	\N	\N	t
406	58	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
407	58	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de plantas a escala 1/75, dimensionados adecuadamente, en el que se delineará las zonas de la fábrica o edificación a demoler, así como del perfil y altura de los inmuebles colindantes a las zonas de la fábrica o edificación a demoler, hasta una distancia de 1.50 m de los límites de propiedad	\N	\N	t
408	58	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de cerramiento del predio, cuando se trate de demolición total	\N	\N	t
409	58	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva de los trabajos a realizar y del procedimiento de demolición a utilizar, donde se consideren las medidas de seguridad contempladas en la Norma Técnica G.050 del RNE y demás normas de la materia	\N	\N	t
410	58	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: En caso de uso de explosivos, se deberá presentar además lo siguiente: a)Autorizaciones de las autoridades competentes (DISCAMEC, Comando Conjunto de las Fuerzas y Defensa Civil), según corresponda. b)Copia del cargo del documento dirigido a los propietarios y/u ocupantes de las edificaciones colindantes a la obra, comunicándoles las fechas y horas en que se efectuarán las detonaciones	\N	\N	t
487	70	Comprobante de pago por la tasa municipal respectiva	\N	265.18000000000001	t
412	58	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
413	58	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra de demolición, en caso no se haya indicado en el FUE	\N	\N	t
414	58	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	175.40000000000001	t
415	58	B)VERIFICACIÓN TÉCNICA: Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil, según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros. mayor a la duración del proceso edificatorio	\N	\N	t
416	59	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUE debidamente suscrito	\N	\N	t
417	59	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
418	59	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
419	59	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que suscriben la documentación	\N	\N	t
420	59	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del comprobante de pago de la tasa municipal correspondiente a la verificación administrativa	\N	327.29000000000002	t
421	59	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia del comprobante de pago por revisión de proyectos	\N	\N	t
422	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Ubicación y Localización según formato	\N	\N	t
423	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Planos de Arquitectura (plantas, cortes y elevaciones), Estructuras, Instalaciones Sanitarias, Instalaciones Eléctricas y otros, de ser el caso, y las memorias justificativas por especialidad	\N	\N	t
424	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de seguridad y evacuación cuando se requiera la intervención de los delegados Ad Hoc del INDECI o del CGBVP	\N	\N	t
425	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Plano de Sostenimiento de Excavaciones, de serel caso y de acuerdo a lo establecido en la Norma E 050 del RNE	\N	\N	t
426	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Memoria descriptiva que precise las características de la obra y las edificaciones colindantes; indicando el número de pisos y sótanos; así como fotos en los casos que se presente el Plano de Sostenimiento de Excavaciones	\N	\N	t
427	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Factibilidad de Servicios	\N	\N	t
428	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos, según los casos que establece el RNE	\N	\N	t
429	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudios de Impacto Ambiental y de Impacto Víal aprobados por las entidades competentes y en losascasos que se requiera	\N	\N	t
430	59	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: En caso se solicite Licencia de Edificación para Remodelación, Ampliación o Puesta en Valor Histórico deberá presentarse lo siguiente: 1)Planos de arquitectura (plantas, cortes y elevaciones) en los cuales se diferencie la edificación existente de la proyectada y su respectiva memoria descriptiva, de acuerdo a lo siguiente: a)Plano de levantamiento de la edificación graficando con achurado 45 grados, los elementos a eliminar. b)Plano de la edificación resultante, graficándo con achurado a 45 grados, perpendicular al anterior, los elementos a edificar. c)Para las obras de Puesta en Valor Histórico se debe graficar en los planos los elementos arquitectónicos con valor histórico monumental propios de la edificación, identificándose aquellos que serán objeto de restauración, reconstrucción o conservación, de ser el caso. 2)Planos de estructura y memoria justificativa; en los casos de obras de remodelación, ampliación o puesta en valor y cuando sea necesario en los demás tipo de obra. Debe diferenciarse los elementos estructurales existentes, los que se eliminarán y los nuevos, detallando adecuadamente los empalmes. 3)Planos de instalaciones y memoria justificativa, de ser necesario, donde: a)Se diferencien los puntos y salidas nuevos de los que se eliminarán; detallandose adecuadamente los emplames. b)Se evaluará la factibilidad de servicios teniendo en cuenta la ampliación de cargas eléctricas y de dotación de agua potable. 4)Para los proyectos de inmuebles sujetos al Régimen de Propiedad Exclusiva y de Propiedad Común, deberá además presentarse lo siguiente: a)Autorización de la Junta de Propietarios b)Reglamento Interno c)Planos de Independización correspondientes 5)En caso se solicite una Licencia Temporal de Edificación y luego de haber obtenido el dictamen Conforme en la especialidad de Arquitectura, deberá además presentarse el Anexo D del FUE.	\N	\N	t
431	59	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el último dictamen Conforme del Proyecto se debe presentar lo siguiente: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
432	59	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el último dictamen Conforme del Proyecto se debe presentar lo siguiente: Comunicación de la fecha de inicio de la obra, en caso no se haya indicado en el FUE	\N	\N	t
433	59	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el último dictamen Conforme del Proyecto se debe presentar lo siguiente: Copia del comprobante de pago de la tasa correspondiente a la verificación técnica por inspeccion	\N	228.69999999999999	t
434	59	B)VERIFICACIÓN TÉCNICA: Despues de haberse notificado el último dictamen Conforme del Proyecto se debe presentar lo siguiente: Póliza CAR (Todo Riesgo Contratista) o la Póliza de Responsabilidad Civil, según las características de las obras a ejecutarse con cobertura por daños materiales y personales a terceros	\N	\N	t
435	60	Solicitud	\N	\N	t
436	60	Copia del comprobante de pago de la tasa municipal correspondiente	\N	115.40000000000001	t
437	60	Documentación técnica necesaria de acuerdo a la modificación propuesta y a la modalidad de aprobación que corresponda	\N	\N	t
438	61	Solicitud	\N	\N	t
439	61	Documentación técnica exigida para las modalidades C y D que sean materia de la modificación propuesta	\N	\N	t
440	61	Planos del Proyecto modificado	\N	\N	t
441	61	Copia del comprobante de pago por derecho de revisión, de la Comisión Técnica, de corresponder	\N	\N	t
442	61	Copia del comprobante de pago de la tasa municipal correspondiente	\N	132.80000000000001	t
443	62	Anexo H del FUE debidamente suscrito	\N	\N	t
444	62	Documentación técnica necesaria exigida para la Modalidad A y de acuerdo a la modificación propuesta	\N	\N	t
447	63	Documentación técnica necesaria exigida para la Modalidad B y de acuerdo a la modificación propuesta	\N	\N	t
448	63	Factibilidades de Servicios de corresponder	\N	\N	t
449	63	Copia del comprobante de pago de la tasa municipal correspondiente	\N	132.5	t
450	64	Anexo H del FUE debidamente suscrito	\N	\N	t
451	64	Copia del comprobante de pago de la tasa municipal correspondiente	\N	237.78999999999999	t
452	64	Copia del comprobante de pago por derecho de revisión de la Comisión Técnica	\N	\N	t
453	64	Documentos exigidos para las modalidades C y D que sean materia de la modificación propuesta	\N	\N	t
454	64	Planos del proyecto modificado	\N	\N	t
455	64	Factibilidad de Servicios de corresponder	\N	\N	t
456	65	Anexo H del FUE debidamente suscrito	\N	\N	t
457	65	Documentos exigidos para la Modalidad C, que sean materia de la modificaciónm propuesta	\N	\N	t
458	65	Informe Técnico Favorable de los Revisores Urbanos	\N	\N	t
459	65	Planos de la modificación propuesta, aprobados por el o los Revisores Urbanos que corresponda	\N	\N	t
460	65	Copia del comprobante de pago de la tasa municipal correspondiente	\N	185.28999999999999	t
461	66	Anexo C del FUE - Pre Declaratoria de Edificación, debidamente suscrito y por triplicado	\N	\N	t
462	66	En caso que titular del derecho a edificar sea una persona distinta a quien inicio el procedimiento de edificación, deberá presentar: a)Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio. b)Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
463	66	Comprobante de pago por la tasa municipal respectiva	\N	97.349999999999994	t
464	67	La sección del FUE - Conformidad de Obra y Declaratoria de Edificación, debidamente suscrito y por triplicado	\N	\N	t
465	67	En caso que titular del derecho a edificar sea una persona distinta a quien inicio el procedimiento de edificación, deberá presentar: a)Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio. b)Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
466	67	Copia de los Planos de Ubicación y de Arquitectura aprobados, correspondiente a la Licencia de Edificación por triplicado	\N	\N	t
467	67	Declaración jurada, firmada por el profesional responsable de obra, manifestando que ésta se responsable de obra, manifestando que ésta se de la licencia de edificación	\N	\N	t
468	67	Comprobante de pago por la tasa municipal respectiva	\N	174.63999999999999	t
469	68	La sección del FUE - Conformidad de Obra y Declaratoria de Edificación, debidamente suscrito y por triplicado	\N	\N	t
470	68	En caso que titular del derecho a edificar sea una persona distinta a quien inicio el procedimiento de edificación, deberá presentar: a)Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio. b)Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
471	68	Comprobante de pago por la tasa municipal respectiva	\N	137.90000000000001	t
472	68	Planos de replanteo por triplicado: planos de ubicación y de arquitectura (plantas, cortes y elevaciones) con las mismas especificaciones de los planos del proyecto aprobado y que correspondan a la obra ejecutada, debidamente suscritos por el solicitante y el profesional responsable o constatador de la obra	\N	\N	t
473	68	Carta que acredite la autorización del proyectista original para realizar las modificaciones, en caso éste no sea el responsable ni el constatador de la obra	\N	\N	t
474	68	Declaración jurada de habilidad del profesional responsable o constatador de la obra	\N	\N	t
475	69	La sección del FUE - Conformidad de Obra y Declaratoria de Edificación, debidamente suscrito y por triplicado	\N	\N	t
476	69	En caso que titular del derecho a edificar sea una persona distinta a quien inicio el procedimiento de edificación, deberá presentar: a)Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio. b)Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
477	69	Comprobante de pago por la tasa municipal respectiva	\N	137.90000000000001	t
478	69	Planos de replanteo por triplicado: planos de ubicación y de arquitectura (plantas, cortes y elevaciones) con las mismas especificaciones de los planos del proyecto aprobado y que correspondan a la obra ejecutada, debidamente suscritos por el solicitante y el profesional responsable o constatador de la obra	\N	\N	t
479	69	Carta que acredite la autorización del proyectista original para realizar las modificaciones, en caso éste no sea el responsable ni el constatador de la obra	\N	\N	t
480	69	Declaración jurada de habilidad del profesional responsable o constatador de la obra	\N	\N	t
481	70	La sección del FUE - Conformidad de Obra y Declaratoria de Edificación, debidamente suscrito y por triplicado	\N	\N	t
482	70	En caso que titular del derecho a edificar sea una persona distinta a quien inicio el procedimiento de edificación, deberá presentar: a)Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio. b)Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
483	70	Planos de replanteo por triplicado: planos de ubicación y de arquitectura (plantas, cortes y elevaciones) con las mismas especificaciones de los planos del proyecto aprobado y que correspondan a la obra ejecutada, debidamente suscritos por el solicitante y el profesional responsable o constatador de la obra	\N	\N	t
484	70	Carta que acredite la autorización del proyectista original para realizar las modificaciones, en caso éste no sea el responsable ni el constatador de la obra	\N	\N	t
485	70	Declaración jurada de habilidad del profesional responsable o constatador de la obra	\N	\N	t
486	70	Comprobante de pago por derecho de revisión, correspondiente a la especialidad de Arquitectura	\N	\N	t
489	71	Plano de Ubicación y Localización según formato	\N	\N	t
490	71	Planos de arquitectura (plantas, cortes y elevaciones) en escala 1/100	\N	\N	t
491	71	Planos de seguridad y evacuación amoblados, en las Modalidades C y D, cuando se requiera la intervención de los delegados Ad Hoc del INDECI o el CGBVP	\N	\N	t
492	71	Declaración jurada de habilidad del profesional que interviene	\N	\N	t
493	71	Copia del comprobante de pago por la tasa municipal respectiva	\N	117.06999999999999	t
494	72	Solicitud simple dirigida al Alcalde	\N	\N	t
495	72	Plano de Ubicación y Localización según formato	\N	\N	t
496	72	Planos de arquitectura (planta, cortes y elevaciones) en escala 1/100	\N	\N	t
497	72	Planos de seguridad y evacuación amoblados, en las Modalidades C y D, cuando se requiera la intervención de los delegados Ad Hoc del INDECI o el CGBVP	\N	\N	t
498	72	Declaración jurada de habilidad del profesional que interviene	\N	\N	t
499	72	Copia del comprobante de pago por derecho de revisión, sólo para las modalidades de aprobación C y D.	\N	\N	t
500	72	Comprobante de pago por la tasa municipal respectiva	\N	209.38	t
501	73	FUE Conformidad de Obra y Declaratoria de Edificación por triplicado	\N	\N	t
502	73	Documentación que acredite que cuenta con derecho a edificar y represente al titular, en caso que el solicitante de la licencia de edificación no sea el propietario del predio	\N	\N	t
503	73	Constitución de la empresa y copia literal del poder expedidos por el Registro de Personas Jurídicas, vigente al momento de presentación de los documentos, en caso que el solicitante sea una persona jurídica	\N	\N	t
504	73	Documentación técnica, firmada por el profesional constatador, compuesta por: a)Plano de Ubicación y Localización según formato. b)Planos de Arquitectura (planrtas, cortes y elevaciones). c)Memoria descriptiva	\N	\N	t
505	73	Documento que acredite la fecha de ejecución de la obra	\N	\N	t
506	73	Carta de seguridad de obra, firmada por un ingeniero civil colegiado	\N	\N	t
507	73	Declaración jurada de habilidad del profesional constatador	\N	\N	t
508	73	En caso de remodelaciones, ampliaciones o demoliciones a regularizar, deberá presentarse además: Copia del documento que acredite la declaratoria de fábrica o de edificación del inmueble, con sus respectivos planos en caso no haya sido expedido por la municipalidad; ó copia del Certificado de Conformidad o Finalización de Obra, ó la Licencia de Obra o de Construcción de la edificación existente que no es materia de regularización	\N	\N	t
509	73	En caso de demoliciones totales o parciales de edificaciones cuya fábrica se encuentre inscrita en el Registro de Predios, se presentará además documento que acredite que sobre él no recaigan cargas y/o gravámenes; ó autorización del titular de la carga o gravámen	\N	\N	t
510	73	Copia del comprobante de pago por la tasa municipal correspondiente	\N	281.39999999999998	t
511	73	Copia del comprobante de pago de la multa por construir sin licencia	\N	\N	t
512	74	Anexo H del FUE ó deL FUHU según corresponda, debidamente suscrito	\N	\N	t
513	74	Comprobante de pago de la tasa municipal correspondiente	\N	119.06	t
514	75	Solicitud firmada por el solicitante	\N	\N	t
515	75	Copia del documento que acredite el número de la licencia y/o del expediente	\N	\N	t
516	76	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUHU por triplicado debidamente suscrito.	\N	\N	t
517	76	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
518	76	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso que el solicitante de la licencia de habilitación urbana no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
519	76	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antiguedad no mayor a treinta (30) días naturales	\N	\N	t
520	76	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
521	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Zonificación y Vías	\N	\N	t
522	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Factibilidad de Servicios de agua, alcantarillado y de energía eléctrica, vigentes	\N	\N	t
523	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Declaración Jurada de inexistencia de feudatarios	\N	\N	t
524	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Documentación técnica, por triplicado, firmada por el solicitante y los profesionales responsables del diseño de acuerdo a lo siguiente: -Plano de ubicación y localización del terreno con coordenadas UTM. -Plano perimétrico y topográfico. -Plano de trazado y lotización con indicación de lotes, aportes, vías y secciones de vías, ejes de trazo y habilitaciones colindantes, en caso sea necesario para comprender la integración con el entorno; plano de pavimentos, con indicación de curvas de nivel cada metro. -Plano de ornamentación de parques, referentes al diseño, ornamentación y equipamiento de las áreas de recreación pública, de ser el caso. -Memoria descriptiva	\N	\N	t
525	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del Planeamiento integral aprobado de corresponder	\N	\N	t
526	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Impacto Ambiental aprobado de corresponder	\N	\N	t
527	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Inexistencia de Restos Arqueológicos en aquellos casos en que el predio esté comprendido en el listado de bienes y ambientes considerados como patrimonio cultural monumental y arqueológico	\N	\N	t
528	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Anexo D del FUHU, adjuntando copia del comprobante de pago correspondiente a la Verificación Administrativa	\N	688.03999999999996	t
529	76	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos	\N	\N	t
530	76	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
531	76	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra	\N	\N	t
532	76	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa municipal correspondiente a la verificación técnica por inspeccion	\N	192.19999999999999	t
533	77	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUHU por triplicado debidamente suscrito	\N	\N	t
534	77	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
535	77	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso que el solicitante de la licencia de habilitación urbana no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
536	77	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
537	77	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
538	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Zonificación y Vías	\N	\N	t
539	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Factibilidad de Servicios de agua, alcantarillado y de energía eléctrica, vigentes	\N	\N	t
540	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Declaración Jurada de inexistencia de feudatarios	\N	\N	t
541	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Documentación técnica, por triplicado, firmada por el solicitante y los profesionales responsables del diseño; y, que cuente con sello "Conforme", especialidad y la firma del Revisor Urbano: -Plano de ubicación y localización del terreno con coordenadas UTM. -Plano perimétrico y topográfico. -Plano de trazado y lotización con indicación de lotes, aportes, vías y secciones de vías, ejes de trazo y habilitaciones colindantes, en caso sea necesario para comprender la integración con el entorno; plano de pavimentos, con indicación de curvas de nivel cada metro. -Plano de ornamentación de parques, referentes al diseño, ornamentación y equipamiento de las áreas de recreación pública, de ser el caso. -Memoria descriptiva	\N	\N	t
542	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del Planeamiento integral aprobado de corresponder	\N	\N	t
543	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Impacto Ambiental aprobado de corresponder	\N	\N	t
544	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Inexistencia de Restos Arqueológicos en aquellos casos en que el predio esté comprendido en el listado de bienes y ambientes considerados como patrimonio cultural monumental y arqueológico	\N	\N	t
545	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Anexo D del FUHU, adjuntando copia del comprobante de pago correspondiente a la Verificación Administrativa	\N	811.83000000000004	t
546	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos con fines de Pavimentación	\N	\N	t
547	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Informe Técnico "Conforme" del Revisor Urbano	\N	\N	t
548	77	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Impacto Vial aprobado de corresponder	\N	\N	t
549	77	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
550	77	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra	\N	\N	t
551	77	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa municipal correspondiente a la verificación técnica por inspeccion	\N	228.80000000000001	t
552	78	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUHU por triplicado debidamente suscrito	\N	\N	t
553	78	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
554	78	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso que el solicitante de la licencia de habilitación urbana no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
555	78	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
556	78	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
557	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Zonificación y Vías	\N	\N	t
558	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Factibilidad de Servicios de agua, alcantarillado y de energía eléctrica, vigentes	\N	\N	t
559	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Declaración Jurada de inexistencia de feudatarios	\N	\N	t
560	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Documentación técnica, por triplicado, de acuerdo a lo siguiente: -Plano de ubicación y localización del terreno con coordenadas UTM. -Plano perimétrico y topográfico. -Plano de trazado y lotización con indicación de lotes, aportes, vías y secciones de vías, ejes de trazo y habilitaciones colindantes, en caso sea necesario para comprender la integración con el entorno; plano de pavimentos, con indicación de curvas de nivel cada metro. -Plano de ornamentación de parques, referentes al diseño, ornamentación y equipamiento de las áreas de recreación pública, de ser el caso. -Memoria descriptiva	\N	\N	t
561	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del Planeamiento integral aprobado, de corresponder	\N	\N	t
562	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Impacto Ambiental aprobado de corresponder	\N	\N	t
563	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Inexistencia de Restos Arqueológicos en aquellos casos en que el predio esté comprendido en el listado de bienes y ambientes considerados como patrimonio cultural monumental y arqueológico	\N	\N	t
564	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del comprobante de pago correspondiente a la Verificación Administrativa	\N	864.33000000000004	t
565	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos con fines de Pavimentación	\N	\N	t
566	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del comprobantes de pago por derecho de revisión de proyectos	\N	\N	t
567	78	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Impacto Vial aprobado, de corresponder	\N	\N	t
568	78	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
569	78	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra	\N	\N	t
570	78	B)VERIFICACIÓN TÉCNICA: Comprobante de pago de la tasa municipal correspondiente a la verificación técnica por inspeccion	\N	228.80000000000001	t
571	79	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: FUHU por triplicado debidamente suscrito	\N	\N	t
572	79	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
573	79	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso que el solicitante de la licencia de habilitación urbana no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
574	79	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
575	79	A)VERIFICACIÓN ADMINISTRATIVA a)Requisitos comunes: Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
576	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Zonificación y Vías	\N	\N	t
577	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Zonificación y Vías, alcantarillado y de energía eléctrica, vigentes	\N	\N	t
578	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Declaración Jurada de inexistencia de feudatarios	\N	\N	t
579	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Documentación técnica, de acuerdo a lo siguiente: -Plano de ubicación y localización del terreno con coordenadas UTM. Plano perimétrico y topográfico. -Plano de trazado y lotización con indicación de lotes, aportes, vías y secciones de vías, ejes de trazo y habilitaciones colindantes, en caso sea necesario para comprender la integración con el entorno; plano de pavimentos, con indicación de curvas de nivel cada metro. -Plano de ornamentación de parques, referentes al diseño, ornamentación y equipamiento de las áreas de recreación pública, de ser el caso. -Memoria descriptiva	\N	\N	t
580	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del Planeamiento integral aprobado de corresponder	\N	\N	t
581	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Impacto Ambiental aprobado, de corresponder.	\N	\N	t
582	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Certificado de Inexistencia de Restos Arqueológicos en aquellos casos en que el predio esté comprendido en el listado de bienes y ambientes considerados como patrimonio cultural monumental y arqueológico	\N	\N	t
583	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del comprobante de pago correspondiente a la Verificación Administrativa	\N	900.13	t
584	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Mecánica de Suelos con fines de Pavimentación	\N	\N	t
585	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Estudio de Impacto Vial aprobado en los supuestos a) y c)	\N	\N	t
586	79	A)VERIFICACIÓN ADMINISTRATIVA b)Documentación Técnica: Copia del compromante de pago por revisión de Proyectos	\N	\N	t
587	79	B)VERIFICACIÓN TÉCNICA: Cronograma de Visitas de Inspección, debidamente suscrito por el Responsable de Obra y el Supervisor Municipal	\N	\N	t
588	79	B)VERIFICACIÓN TÉCNICA: Comunicación de la fecha de inicio de la obra	\N	\N	t
589	79	B)VERIFICACIÓN TÉCNICA: Copia del comprobante de pago de la tasa municipal correspondiente a la verificación técnica por inspeccion	\N	265.80000000000001	t
590	80	Anexo H del FUHU, debidamente suscrito	\N	\N	t
591	80	Planos por triplicado y demàs documentación que sustente su petitorio	\N	\N	t
592	80	Copia del comprobante de pago de la tasa municipal correspondiente	\N	549.14999999999998	t
593	81	Anexo H del FUHU, debidamente suscrito	\N	\N	t
594	81	Planos por triplicado y demàs documentación que sustente su petitorio	\N	\N	t
595	81	El Informe Técnico Conforme del Revisor Urbano	\N	\N	t
596	81	Copia del comprobante de pago de la tasa municipal correspondiente	\N	647.07000000000005	t
597	82	Anexo H del FUHU, debidamente suscrito	\N	\N	t
598	82	Planos por triplicado y demás documentación que sustente su petitorio. 3) REQUISITO: Acompañar nueva 3) REQUISITO: Diferente	\N	\N	t
599	82	Copia del comprobante de pago de la tasa municipal correspondiente	\N	664.97000000000003	t
600	82	Copia del comprobantes de pago por el derecho de Revisión de Proyectos	\N	\N	t
601	83	Sección del FUHU correspondiente a la recepción de obra, por triplicado	\N	\N	t
602	83	Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
603	83	En caso que el solicitante no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
604	83	En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
605	83	Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
606	83	Documentos emitidos por las entidades prestadoras de los servicios públicos otorgando conformidad a las obras de su competencia	\N	\N	t
607	83	Copia legalizada notarialmente de las minutas que acrediten la transferencia de las áreas de aportes a las entidades receptoras de los mismos y/o comprobantes de pago de la redención de los mismos, de ser el caso	\N	\N	t
608	83	Copia del comprobante de pago de la tasa municipal correspondiente	\N	786.49000000000001	t
609	84	Sección del FUHU correspondiente a la recepción de obra, por triplicado	\N	\N	t
610	84	Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
611	84	En caso que el solicitante no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
612	84	En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
613	84	Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
614	84	Documentos emitidos por las entidades prestadoras de los servicios públicos otorgando conformidad a las obras de su competencia	\N	\N	t
660	89	Copia del comprobante de pago de la tasa municipal correspondiente	\N	37	t
615	84	Copia legalizada notarialmente de las minutas que acrediten la transferencia de las áreas de aportes a las entidades receptoras de los mismos y/o comprobantes de pago de la redención de los mismos, de ser el caso	\N	\N	t
616	84	En caso existan modificaciones al proyecto de Habilitación Urbana que no se consideren sustanciales, se deberá presentar por triplicado, y debidamente suscrito por el profesional responsable de la obra y el solicitante, los documentos siguientes: -Plano de replanteo de trazado y lotización. -Plano de ornamentación de parques, cuando se requiera. -Memoria descriptiva correspondiente. -Carta del proyectista original autorizando las modificaciones. En ausencia del proyectista, el administrado comunicará al colegio profesional correspondiente tal situación, asumiendo la responsabilidad por las modificaciones realizadas	\N	\N	t
617	84	Copia del comprobante de pago de la tasa municipal correspondiente	\N	802.20000000000005	t
618	85	FUHU por triplicado debidamente suscrito	\N	\N	t
619	85	Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
620	85	En caso que el solicitante no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
621	85	En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
622	85	Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
623	85	Copia del comprobante de pago de la tasa municipal correspondiente	\N	132.5	t
624	85	Anexo E del FUHU	\N	\N	t
625	85	Certificado de zonificación y vías expedido por la Municipalidad Provincial	\N	\N	t
626	85	Declaración Jurada de inexistencia de feudatarios	\N	\N	t
627	85	Documentación técnica compuesta por: -Plano de ubicación y localización del terreno matriz con coordenadas UTM. -Plano de planeamiento integral con la propuesta de integración a la trama urbana más cercana, señalando el perímetro y el relieve con curvas de nivel, usos de suelo y aportes normativos, en concordancia con el Plan de Desarrollo Urbano aprobado por la Municipalidad Provincial correspondiente. -Plano del predio rustico matriz, indicando perímetro, linderos, áreas, curvas de nivel y nomenclatura original, según antecedentes registrales. -Plano de Independización, señalando la parcela independizada y la(s) parcela(s) remanente(s), indicando perímetro, linderos, área, curvas de nivel y nomenclatura original según antecedentes registrales. -Memoria descriptiva indicando áreas, linderos y medidas perimétricas del predio matriz del área independizada y del área remanente	\N	\N	t
628	86	FUHU por triplicado debidamente suscrito	\N	\N	t
629	86	Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
630	86	En caso que el solicitante no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
631	86	En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
632	86	Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
633	86	Copia del comprobante de pago de la tasa municipal correspondiente	\N	114.40000000000001	t
634	86	Documentación técnica siguiente: -Plano de ubicación y localización del lote materia de subdivisión. -Plano del lote a subdividir, señalando el área, linderos, medidas perimétricas y nomenclatura, según los antecedentes registrales. -Plano de la subdivisión señalando áreas, linderos, medidas perimétricas y nomenclatura de cada sublote propuesto resultante. -Memoria descriptiva, indicando áreas, linderos y medidas perimétricas del lote de subdivisión y de los sublotes propuestos resultantes	\N	\N	t
635	87	FUHU por triplicado debidamente suscrito	\N	\N	t
636	87	Copia literal de dominio expedida por el Registro de Predios, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
637	87	En caso que el solicitante de la licencia de habilitación urbana no sea el propietario del predio, se deberá presentar la escritura pública que acredite el derecho de habilitar	\N	\N	t
638	87	En caso el solicitante sea una persona jurídica, se acompañará vigencia del poder expedida por el Registro de Personas Jurídicas, con una antigüedad no mayor a treinta (30) días naturales	\N	\N	t
639	87	Declaración Jurada de habilitación de los profesionales que interviene en el proyecto y suscriben la documentación técnica	\N	\N	t
640	87	Copia del comprobante de pago de la tasa municipal correspondiente	\N	1252.4400000000001	t
641	87	Certificado de zonificación y vías	\N	\N	t
642	87	Plano de ubicación y localización del terreno	\N	\N	t
643	87	Plano de lotización, conteniendo el pérímetro del terreno, el diseño de la lotización, de las vías, aceras y bermas; y las áreas correspondientes a los aportes. La lotización deberá estar en concordancia con el Plan de Desarrollo Urbano aprobado por la Municipalidad Provincial	\N	\N	t
644	87	Memoria descriptiva, indicando las manzanas, de corresponder, las áreas de los lotes, la numeración y los aportes	\N	\N	t
645	87	Copia legalizada notarialmente de la escritura publica y/o comprobantes de pago por la redención de los aportes que correspondan	\N	\N	t
646	87	Declaración jurada suscrita por el solicitante de la habilitación y el profesional responsable de la obra en la que conste que las obras han sido ejecutadas, total o parcialmente	\N	\N	t
647	87	Plano que indique los lotes ocupados y las alturas de las edificaciones existentes	\N	\N	t
648	87	En caso que se cuente con estudios preliminares aprobados, no corresponde presentar los requisitos indicados en los items 7, 8 y 9, debiendo en su reemplazo presentar: -Resolución y planos de los estuidos preliminares aprobados. -Planos de Repalnteo de la Habiloitación Urbana, de corresponder	\N	\N	t
649	88	Solicitud simple dirigida al Alcalde	\N	\N	t
650	88	Planos de ubicación y planta detallando características físicas y técnicas	\N	\N	t
651	88	Memoria descriptiva	\N	\N	t
652	88	Permiso de interferencia vial GTU/MML, de ser el caso	\N	\N	t
653	88	Cronograma de avance de obra	\N	\N	t
654	88	Copia del comprobante de pago de la tasa municipal correspondiente	\N	37	t
655	89	Solicitud simple dirigida al Alcalde	\N	\N	t
656	89	Planos de ubicación y planta detallando características físicas y técnicas	\N	\N	t
657	89	Memoria descriptiva	\N	\N	t
658	89	Permiso de interferencia vial GTU/MML, de ser el caso	\N	\N	t
661	90	Solicitud simple dirigida al Alcalde, indicando el numero de Licencia de Edificacion	\N	\N	t
662	90	Planos de ubicación y planta detallando características físicas y técnicas (firmado por ingeniero civil, electricista o de telecomunicaciones)	\N	\N	t
663	90	Memoria descriptiva	\N	\N	t
664	90	Cronograma de avance de obra	\N	\N	t
665	90	Copia del comprobante de pago de la tasa municipal correspondiente	\N	85.299999999999997	t
666	91	Carta simple del Operador dirigida al titular de la entidad	\N	\N	t
667	91	Copia de la resolución emitida por el Ministerio mediante la cual se otorga concesión al Operador para prestar el servicio público de telecomunicaciones expedida por el Ministerio o en el caso de las empresas de valor añadido, de la resolución a que se refiere el artículo 33 del TUO de la Ley de Telecomunicaciones	\N	\N	t
668	91	De ser el caso memoria descriptiva y planos de ubicación detallando las características físicas y técnicas de las instalaciones materia de trámite, suscritos por un ingeniero civil y/o electrónico o de telecomunicaciones, según corresponda, ambos colegiados, adjuntando el certificado de inscripción y habilidad vigentes expedido por el Colegio de Ingenieros del Perú	\N	\N	t
669	91	Permiso de interferencia vial GTU/MML	\N	\N	t
670	91	Cronograma de avance de obra	\N	\N	t
671	91	Copia del comprobante de pago de la tasa municipal correspondiente	\N	82.700000000000003	t
672	92	Solicitud dirigida al Alcalde	\N	\N	t
673	92	Documentos sustentatorios de la propiedad; minuta, Escritura Pública, contrato privado, u otros similares	\N	\N	t
674	92	Copia de constitución de la asociación (en caso necesario)	\N	\N	t
675	92	Plano simple de ubicación del predio	\N	\N	t
676	92	Acta de verificación de posesión efectiva del predio emitida por un funcionario de la municipalidad correspondiente y suscrita por todos los colindantes del predio o acta policial de posesión suscrita por todos los colindantes de dicho predio	\N	\N	t
677	92	Copia del comprobante de pago de la tasa municipal correspondiente	\N	93.200000000000003	t
678	93	Solicitud dirigida al Alcalde, indicando el fin del pedido	\N	\N	t
679	93	Documentos sustentatorios de la propiedad; minuta, Escritura Pública, contrato privado, u otros similares	\N	\N	t
680	93	Copia de constitución de la asociación (en caso necesario)	\N	\N	t
681	93	Plano simple de ubicación del predio	\N	\N	t
682	93	Declaración Jurada firmada por los vecinos colindantes que acreditan la posesión del recurrente	\N	\N	t
683	93	Memoria Descriptiva	\N	\N	t
684	93	Copia del comprobante de pago de la tasa municipal correspondiente	\N	93.200000000000003	t
685	94	Solicitud dirigida al Alcalde, consignando el numero de Resolucion de Licencia	\N	\N	t
686	94	Presentar copia de documento que acredite la propiedad	\N	\N	t
687	94	Copia de recibo de agua, luz o teléfono	\N	\N	t
688	94	Copia del comprobante de pago de la tasa municipal correspondiente	\N	88.099999999999994	t
689	95	Solicitud dirigida al Alcalde	\N	\N	t
690	95	Minuta de compra venta, escritura pública o copia literal	\N	\N	t
691	95	Plano perimétrico y ubicación del predio	\N	\N	t
692	95	Copia del comprobante de pago de la tasa municipal correspondiente	\N	114.45	t
693	96	Solicitud dirigida al Alcalde, señalando el número de RUC de la empresa, persona jurídica o natural, describiendo el sistema de extracción y características de la maquinaria a ser utilizadas y plazo de extracción solicitada	\N	\N	t
694	96	Memoria descriptiva que contenga la descripción del tipo de material a extraerse, volumen del mismo (expresado en metros cúbicos), así como ubicación y área donde se derecho, con firma de abogado. realizará la operación de extracción	\N	\N	t
695	96	Documento de Opinión técnica vinculante de la Autoridad Local del Agua, para el otorgamiento de autorizaciones de extracción de material de acarreo en cauces naturales de agua	\N	\N	t
696	96	Plano de zonificación y ubicación a escala 1/5000 de la zona a extraer con los puntos de inicio y final, así como el acceso debidamente autorizado por la Municipalidad, en coordenadas de UTM	\N	\N	t
697	96	Plano de ubicación de las instalaciones de clasificación y acopio si las hubiere	\N	\N	t
698	96	Declaración Jurada de Compromiso para la preservación de álveos, cauces de los ríos y canteras en la jurisdicción del Distrito de Ayacucho	\N	\N	t
699	96	Copia del comprobante de pago de la tasa municipal correspondiente	\N	100.66	t
700	97	Solicitud de autorizacion dirigida al Alcalde	\N	\N	t
701	97	Fotografía con fotomontaje del elemento de publicidad exterior en el cual se debe apreciar el entorno y el bien o edificación donde se instalaría el elemento	\N	\N	t
702	97	Copia Simple de la Licencia de Funcionamiento del establecimiento con giro a fin al anuncio del elemento publicitario	\N	\N	t
703	97	Autorización escrita del propietario del predio, y/o vehiculo para el cual se solicita la autorización de instalación	\N	\N	t
704	97	Constancia de inscripción de constitución como Persona Jurídica en el Registro Público correspondiente, copia de documento que acredite la representación legal y exibición del DNI del representante legal	\N	\N	t
705	97	Copia del comprobante de pago de la tasa municipal correspondiente	\N	129.87	t
706	98	Solicitud de autorizacion dirigida al Alcalde	\N	\N	t
707	98	Fotografía con fotomontaje del elemento de publicidad exterior en el cual se debe apreciar el entorno y el bien o edificación donde se instalaría el elemento	\N	\N	t
708	98	Copia Simple de la Licencia de Funcionamiento del establecimiento con giro a fin al anuncio del elemento publicitario	\N	\N	t
709	98	Autorización escrita del propietario del predio, y/o vehiculo para el cual se solicita la autorización de instalación	\N	\N	t
710	98	Constancia de inscripción de constitución como Persona Jurídica en el Registro Público correspondiente, copia de documento que acredite la representación legal y exibición del DNI del representante legal	\N	\N	t
711	98	Especificaciones tecnicas y Plano de Estructuras a escala conveniente, certificado por el profesional responsable	\N	\N	t
712	98	Copia del comprobante de pago de la tasa municipal correspondiente	\N	145.30000000000001	t
713	99	Solicitud de autorizacion dirigida al Alcalde	\N	\N	t
714	99	Fotografía con fotomontaje del elemento de publicidad exterior en el cual se debe apreciar el entorno y el bien o edificación donde se instalaría el elemento	\N	\N	t
715	99	Copia Simple de la Licencia de Funcionamiento del establecimiento con giro a fin al anuncio del elemento publicitario	\N	\N	t
716	99	Autorización escrita del propietario del predio, y/o vehiculo para el cual se solicita la autorización de instalación	\N	\N	t
717	99	Constancia de inscripción de constitución como Persona Jurídica en el Registro Público correspondiente, copia de documento que acredite la representación legal y exibición del DNI del representante legal	\N	\N	t
718	99	Descripcion de las instalaciones eléctricas	\N	\N	t
719	99	Copia del comprobante de pago de la tasa municipal correspondiente	\N	176.16999999999999	t
720	100	Solicitud de autorizacion dirigida al Alcalde	\N	\N	t
721	100	Fotografía con fotomontaje del elemento de publicidad exterior en el cual se debe apreciar el entorno y el bien o edificación donde se instalaría el elemento	\N	\N	t
722	100	Copia Simple de la Licencia de Funcionamiento del establecimiento con giro a fin al anuncio del elemento publicitario	\N	\N	t
723	100	Autorización escrita del propietario del predio, y/o vehiculo para el cual se solicita la autorización de instalación	\N	\N	t
724	100	Constancia de inscripción de constitución como Persona Jurídica en el Registro Público correspondiente, copia de documento que acredite la representación legal y exibición del DNI del representante legal	\N	\N	t
725	100	Copia del comprobante de pago de la tasa municipal correspondiente	\N	99.010000000000005	t
726	101	Solicitud de autorizacion dirigida al Alcalde	\N	\N	t
727	101	Fotografía con fotomontaje del elemento de publicidad exterior la misma que debera contar con las dimensiones y colores establecidos	\N	\N	t
728	101	Copia del comprobante de pago de la tasa municipal correspondiente por dia	\N	5	t
729	102	Solicitud de renovacion de autorizacion, indicando el numero de la resolucion de autorización	\N	\N	t
730	102	Copia Simple de la Licencia de Funcionamiento del establecimiento	\N	\N	t
731	102	Copia del comprobante de pago de la tasa municipal correspondiente	\N	109.29000000000001	t
732	103	Solicitud de renovacion de autorizacion, indicando el número de la resolucion de autorizacion	\N	\N	t
733	103	Copia Simple de la Licencia de Funcionamiento del establecimiento	\N	\N	t
734	103	Certificado de estabilidad estructural firmado por un profesional responsable	\N	\N	t
735	103	Copia del comprobante de pago de la tasa municipal correspondiente	\N	124.72	t
736	104	Solicitud dirigida al Alcalde	\N	\N	t
737	104	Plano de Ubicación y Localización a una escala adecuada, detallando caracteristicas tecnicas, áreas, linderos y medidas perimétricas, firmado por el profesional y el propietario (Tres juegos)	\N	\N	t
738	104	Memoria Descriptiva	\N	\N	t
739	104	Documento que acredite la propiedad: Escritura Pública, Compra venta, Titulo de propiedad, ficha registral o copia literal	\N	\N	t
740	104	Copia del comprobante de pago de la tasa municipal correspondiente	\N	86.159999999999997	t
741	119	Solicitud dirigida al Alcalde	\N	\N	t
742	119	Croquis de ubicación de domicilio	\N	\N	t
743	119	Copia simple de DNI y recibo de agua o luz	\N	\N	t
744	119	Copia del comprobante de pago de la tasa municipal correspondiente	\N	21.879999999999999	t
745	120	Solicitud dirigida al Alcalde	\N	\N	t
746	120	Croquis de ubicación de domicilio	\N	\N	t
747	120	Copia de Estatuto y Acta de Constitución	\N	\N	t
748	120	Copia de Acta de Elección del Órgano Directivo	\N	\N	t
749	120	Nómina de Miembros del Órgano Directivo	\N	\N	t
750	120	Copia simple de DNI de los miembros del Órgano Directivo	\N	\N	t
751	120	Copia del comprobante de pago de la tasa municipal correspondiente	\N	34.850000000000001	t
752	121	Solicitud dirigida al Alcalde	\N	\N	t
753	121	Copia legalizada del Libro de Actas de Asamblea General del acuerdo de modificacion correspondiente	\N	\N	t
754	121	Padrón o Registro actualizado de miembros	\N	\N	t
755	121	Copia de DNI de los miembros de la Junta Directiva Vigente	\N	\N	t
756	121	Copia del comprobante de pago de la tasa municipal correspondiente	\N	\N	t
757	127	Certificado del Nacido Vivo (original), expedido, firmado y sellado por el profesional competente del establecimiento de salud, donde se atendió el parto	\N	\N	t
758	127	Presentar DNI(s) original(es) vigentes de los padres	\N	\N	t
759	128	Certificado del Nacido Vivo (original), expedido, firmado y sellado por el profesional competente del establecimiento de salud, donde se atendió el parto	\N	\N	t
760	128	Presentar DNI(s) original(es) vigentes de los padres	\N	\N	t
761	128	Constancia de no inscripción de ocurrencia del lugar de nacimiento y viceverza emitida por la jefatura de la Oficina de Registro de Estado Civil o de quién haga sus veces	\N	\N	t
762	128	Certificado Domiciliario Municipal o Notarial (para los padres que domicilian fuera del distrito de Ayacucho)	\N	\N	t
763	129	Solicitud según formato	\N	\N	t
764	129	Declaración Jurada de Inscripción Extemporánea, suscrita por dos personas mayores de edad en presencia del Registrador (FORMATO GRATUITO)	\N	\N	t
765	129	Certificado del Nacido Vivo, otorgado por profesional competente del establecimiento de salud donde se atendió el parto; o en su defecto cualquiera de los siguientes documentos: *Constancia otorgado por persona autorizada por el MINSA, de haber atendido o constatado el parto. *Partida de Bautismo original certificada por autoridad del Arzobispado. *Certificado de Estudios con mención de grados cursados	\N	\N	t
766	129	Constancia de no inscripción de ocurrencia del lugar de nacimiento y viceverza emitida por la jefatura de la Oficina de Registro de Estado Civil o de quién haga sus veces	\N	\N	t
767	129	Certificado Domiciliario Municipal o Notarial (para los padres que domicilian fuera del distrito de Ayacucho)	\N	\N	t
768	129	Presentar DNI(s) original(es) vigentes de los padres y de los testigos	\N	\N	t
769	130	Solicitud según formato	\N	\N	t
770	130	Declaración Jurada de Inscripción Extemporánea, suscrita por dos personas mayores de edad en presencia del Registrador (FORMATO GRATUITO)	\N	\N	t
771	130	Certificado del Nacido Vivo, otorgado por profesional competente del establecimiento de salud donde se atendió el parto; o en su defecto cualquiera de los siguientes documentos: *Partida de Bautismo original certificada por autoridad del Arzobispado. *Certificado de Estudios con mención de grados cursados	\N	\N	t
772	130	Presentar copia fedatada del DNI(s) del titular y testigos	\N	\N	t
773	130	*Para personas que nacieron fuera del Distrito de Ayacucho, además presentar: Constancia de no inscripción de ocurrencia del lugar de nacimiento y viceverza emitida por la jefatura de la Oficina de Registro de Estado Civil o de quién haga sus veces	\N	\N	t
774	130	*Para personas que nacieron fuera del Distrito de Ayacucho, además presentar: Certifiado Domiciliario Municipal o Notarial	\N	\N	t
775	131	Oficio y partes judiciales conteniendo la copia certificada de la Resolución Judicial firme que declara el abandono legal del menor de edad	\N	\N	t
776	132	Oficio y Parte con Resolución Judicial consentida o ejecutoriada, según corresponda	\N	\N	t
777	132	Presencia de los adoptantes intervinientes o representantes legales con sus DNIs (original y vigente), en caso de extranjeros presentar original y copia simple del Carné de Extranjería o Pasaporte	\N	\N	t
778	132	Documento que acredite la representación, en caso de representantes legales	\N	\N	t
779	132	Copia del comprobante de pago de la tasa municipal correspondiente	\N	39.899999999999999	t
780	133	Oficio y Resolución Administartiva expedida por autoridad competente, si se trata de menores en abandono legal	\N	\N	t
781	133	Presencia de los adoptantes intervinientes o representantes legales con sus DNIs (original y vigente), en caso de documentación probatoria, con interpretación de las pruebas extranjeros presentar original y copia simple del Carné de firma de abogado. producidas o cuestiones de puro Extranjería o Pasaporte	\N	\N	t
782	133	Documento que acredite la representación, en caso de representantes legales	\N	\N	t
783	133	Copia del comprobante de pago de la tasa municipal correspondiente	\N	13.9	t
784	134	Oficio y Parte con Resolución Judicial consentida o ejecutoriada, según corresponda	\N	\N	t
785	134	Copia Certificada del Acta de Nacimiento original, materia de archivamiento, siempre que el Acta Original sea conservada por una Oficina de Registros del estado Civil	\N	\N	t
786	134	Presencia de los adoptantes intervinientes o representantes legales con sus DNIs (original y vigente), en caso de extranjeros presentar original y copia simple del Carné de Extranjería o Pasaporte	\N	\N	t
787	134	Documento que acredite la representación, en caso de representantes legales	\N	\N	t
788	134	Copia del comprobante de pago de la tasa municipal correspondiente	\N	48	t
789	135	Oficio de la Notaria correspondiente, acompañando el Testimonio de la Escritura Pública según corresponda	\N	\N	t
790	135	Copia Certificada del Acta de Nacimiento original, materia de archivamiento, siempre que el Acta Original sea documentación probatoria, con interpretación de las pruebas conservada por una Oficina de Registros del estado Civil	\N	\N	t
791	135	Presencia de los adoptantes intervinientes o representantes legales con sus DNIs (original y vigente), en caso de extranjeros presentar original y copia simple del Carné de Extranjería o Pasaporte	\N	\N	t
792	135	Documento que acredite la representación, en caso de representantes legales	\N	\N	t
793	135	Copia del comprobante de pago de la tasa municipal correspondiente	\N	39.799999999999997	t
794	136	Presencia de los padres y exhibición de sus DNIs (original y vigente)	\N	\N	t
795	136	Copia del comprobante de pago de la tasa municipal correspondiente	\N	26.300000000000001	t
796	137	Oficio, Escritura pública de reconocimiento notarial, sentencia Judicial Firme y Resolución consentida o 3) REQUISITO: Acompañar nueva 3) REQUISITO: Diferente ejecutoriada, según corresponda	\N	\N	t
797	137	Presencia de los padres y exhibición de sus DNIs (original y vigente)	\N	\N	t
798	137	Copia del comprobante de pago de la tasa municipal correspondiente	\N	37	t
799	138	Solicitud escrita por el interesado si es mayor de edad, o por la parte legitimida si es menor de edad o por su representante legal	\N	\N	t
800	138	Partida o Acta original observada por el RENIEC u otra instancia correspondiente	\N	\N	t
801	138	Copia simple del DNI del solicitante, las personas que no cuenten con el DNI presentar: Declaración Jurada simple de no contar con DNI	\N	\N	t
802	139	Solicitud escrita por el interesado si es mayor de edad, o por la parte legitimida si es menor de edad o por su representante legal	\N	\N	t
803	139	Partida o Acta original observada por el RENIEC u otra instancia correspondiente	\N	\N	t
804	139	Copia simple del DNI del solicitante, las personas que no cuenten con el DNI presentar: Declaración Jurada simple de no contar con DNI	\N	\N	t
805	139	Copia del comprobante de pago de la tasa municipal correspondiente	\N	20	t
806	139	*Aquellos que no cuenten con Registros en el Distrito de Ayacucho, además presentar: En caso de Actas de Nacimiento: Copia certificada del Acta de Nacimiento de los padres y/o declarantes o partida de bautismo de estos, este último caso inscritas antes del 14 de noviembre de 1936	\N	\N	t
807	139	*Aquellos que no cuenten con Registros en el Distrito de Ayacucho, además presentar: En caso de Actas de Matrimonio: Copia certificada del Acta de Nacimiento de los contrayentes y/o de los testigo o partida de bautismo este último caso inscritas antes del 14 de noviembre 1936	\N	\N	t
808	139	*Aquellos que no cuenten con Registros en el Distrito de Ayacucho, además presentar: En caso de Actas de Defunción: Copia certificada de Acta de Nacimiento del Difunto y/o cónyuge o de los padres o constancia de inscripción de RENIEC o partida de bautismo este último caso inscritas antes del 14 de noviembre de 1936 o acta de matrimonio del difunto	\N	\N	t
809	140	Oficio, Partes notariales o Sentencia Judicial Firme y Resolución consentida o ejecutariada, según corresponda	\N	\N	t
810	140	Copia del comprobante de pago de la tasa municipal correspondiente	\N	24.300000000000001	t
811	141	Oficio, Partes Judiciales conteniendo copia certificada de la Resolución firme que dispone la inscripción en el Registro Civil, emitidos por el Juzgado competente	\N	\N	t
812	141	Copia del comprobante de pago de la tasa municipal correspondiente	\N	56.5	t
813	142	Oficio, Partes notariales o Sentencia Judicial Firme, Resolución consentida o ejecutariada, o Resolución de Alcaldía, según corresponda	\N	\N	t
814	142	Copia del comprobante de pago de la tasa municipal correspondiente	\N	24.300000000000001	t
815	143	Solicitud del interesado si es mayor de edad, o la parte legitimada si es menor de edad	\N	\N	t
816	143	Copia certificada legible y completa de las actas sujeta a materia	\N	\N	t
817	143	Copia de DNI del solicitante, de no contar con DNI, declaración jurada simple	\N	\N	t
818	143	Copia del comprobante de pago de la tasa municipal correspondiente	\N	32.700000000000003	t
819	144	Oficio, Sentencia Judicial Firme y Resolución consentida o ejecutoriada	\N	\N	t
820	144	Copia del comprobante de pago de la tasa municipal correspondiente	\N	30	t
943	172	Copia fotostática de la tarjeta de identificación vehicular de todos los vehículos, emitidas por la SUNARP	\N	\N	t
821	145	Certificado de defunción debidamente firmado y sellado por profesional competente, sólo en el caso que en la localidad no hubiera un médico que pueda acreditar la defunción, se aceptará la Declaración Jurada de la autoridad política, judicial y/o religiosa	\N	\N	t
822	145	Entrega del DNI original del fallecido o Declaración Jurada de pérdida suscrita por el declarante	\N	\N	t
823	145	Presentar DNI del declarante, en caso de extranjeros presentar original y copia simple del Carné de Extranjería o Pasaporte	\N	\N	t
824	145	En caso de muerte violenta, presentar: -Parte judicial del juez competente. -Oficio y parte con la Resolución Judicial consentida o ejecutoriada, según corresponda	\N	\N	t
825	146	Oficio, Sentencia Judicial Firme y Resolución consentida o ejecutariada	\N	\N	t
826	146	Copia del comprobante de pago de la tasa municipal correspondiente	\N	30.300000000000001	t
827	147	Carpeta Matrimonial y Formatos	\N	\N	t
828	147	Actas (partidas) de nacimientos, originales y vigentes de los Contrayentes	\N	\N	t
829	147	Certificado Domiciliario Municipal o Notarial, que acredite la residencia de los contrayente	\N	\N	t
830	147	Certificado Médico Pre-Nupcial (Hospital o Centro de Salud), expedida no menor a 30 días	\N	\N	t
831	147	Certificado de Soltería de los contrayentes del lugar de su procedencia o Declaración Jurada Notarial	\N	\N	t
832	147	Copia fedatada de los DNIs de los contrayentes	\N	\N	t
833	147	Copia fedatada de los DNIs de los contrayentes	\N	\N	t
834	147	Dos tetigos mayores de edad y copia fedatada de sus DNIs	\N	\N	t
835	147	Publicación del Aviso del Edicto Matrimonial (Municipio)	\N	\N	t
836	147	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Dentro de la Municipalidad Provincial de Huamanga (S.G. Registro Civil)	\N	98.299999999999997	t
837	147	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Fuera de la Municipalidad Provincial de Huamanga (Domicilio Contrayentes)	\N	132.80000000000001	t
838	147	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Ceremonia Matrimonial Masiva	\N	\N	t
839	148	Carpeta Matrimonial y Formatos	\N	\N	t
840	148	Actas (partidas) de nacimientos, originales y vigentes de los Contrayentes	\N	\N	t
841	148	Certificado Domiciliario Municipal o Notarial, que acredite la residencia de los contrayentes	\N	\N	t
842	148	Certificado Médico Pre-Nupcial (Hospital o Centro de Salud), expedida no menor a 30 días	\N	\N	t
843	148	Certificado de Soltería de los contrayentes del lugar de su procedencia o Declaración Jurada Notarial	\N	\N	t
844	148	Copia fedatada de los DNIs de los contrayentes	\N	\N	t
845	148	Copia fedatada de los DNIs de los contrayentes	\N	\N	t
846	148	Dos tetigos mayores de edad y copia fedatada de sus DNIs	\N	\N	t
847	148	Publicación del Aviso del Edicto Matrimonial (Municipio)	\N	\N	t
848	148	Consentimiento Judicial o Notarial para matrimonio civil	\N	\N	t
849	148	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Dentro de la Municipalidad Provincial de Huamanga (S.G. Registro Civil)	\N	98.299999999999997	t
850	148	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Fuera de la Municipalidad Provincial de Huamanga (Domicilio Contrayentes)	\N	132.80000000000001	t
851	149	Carpeta Matrimonial y Formatos	\N	\N	t
852	149	Actas (partidas) de nacimientos, originales y vigentes de los Contrayentes	\N	\N	t
853	149	Certificado Domiciliario Municipal o Notarial, que acredite la residencia de los contrayentes	\N	\N	t
854	149	Certificado Médico Pre-Nupcial (Hospital o Centro de Salud), expedida no menor a 30 días	\N	\N	t
855	149	Certificado de Soltería de los contrayentes del lugar de su procedencia o Declaración Jurada Notarial	\N	\N	t
856	149	Copia fedatada de los DNIs de los contrayentes	\N	\N	t
857	149	Copia fedatada de los DNIs de los contrayentes.	\N	\N	t
858	149	Dos tetigos mayores de edad y copia fedatada de sus DNIs	\N	\N	t
859	149	Publicación del Aviso del Edicto Matrimonial (Municipio)	\N	\N	t
860	149	Copias certificadas de acta de matrimonio con la anotación de la disolución del vínculo matrimonial	\N	\N	t
861	149	Declaración Jurada de no administrar bienes de hijos menores o inventario judicial	\N	\N	t
862	149	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Dentro de la Municipalidad Provincial de Huamanga (S.G. Registro Civil).	\N	98.299999999999997	t
863	149	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Fuera de la Municipalidad Provincial de Huamanga (Domicilio Contrayentes)	\N	132.80000000000001	t
864	150	Carpeta Matrimonial y Formatos	\N	\N	t
865	150	Actas (partidas) de nacimientos, originales y vigentes de los Contrayentes	\N	\N	t
866	150	Certificado Domiciliario Municipal o Notarial, que acredite la residencia de los contrayentes	\N	\N	t
867	150	Certificado Médico Pre-Nupcial (Hospital o Centro de Salud), expedida no menor a 30 días	\N	\N	t
868	150	Certificado de Soltería de los contrayentes del lugar de su procedencia o Declaración Jurada Notarial	\N	\N	t
869	150	Copia fedatada de los DNIs de los contrayentes	\N	\N	t
870	150	Copia fedatada de los DNIs de los contrayentes	\N	\N	t
871	150	Dos tetigos mayores de edad y copia fedatada de sus DNIs	\N	\N	t
872	150	Publicación del Aviso del Edicto Matrimonial (Municipio)	\N	\N	t
873	150	Copias certificadas de acta de matrimonio con la anotación de la disolución del vínculo matrimonial	\N	\N	t
874	150	Copia certificada de Acta de Defunción del cónyuge fallecido	\N	\N	t
875	150	Copia certificada del Acta de Matrimonio	\N	\N	t
876	150	Declaración Jurada de no administrar bienes de hijos menores o inventario judicial	\N	\N	t
877	150	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Dentro de la Municipalidad Provincial de Huamanga (S.G. Registro Civil)	\N	98.299999999999997	t
878	150	Copia del comprobante de pago de la tasa municipal correspondiente, para los siguientes casos: Fuera de la Municipalidad Provincial de Huamanga (Domicilio Contrayentes)	\N	132.80000000000001	t
879	151	Solicitud dirigido al Alcalde de la Municipalidad	\N	\N	t
880	151	Copia simple de DNI del solicitante	\N	\N	t
944	172	Copia fotostática de la Póliza de Seguro Obligatoria contra accidentes de tránsito(SOAT) vigente o CAT autorizados en la Provincia de Huamanga conforme a Ley	\N	\N	t
881	151	Alguno de los siguientes documentos: Documento que acredite causa razonable para la dispensa, como: -Declaració Jurada Notarial por más de 3 años de convivencia. -Certificado médico de gravidez original. -Copia del acta certificada de nacimiento del hijo	\N	\N	t
882	151	Copia del comprobante de pago de la tasa municipal correspondiente	\N	22.800000000000001	t
883	152	Derecho de Trámite, de acuerdo a los siguientes casos: Copia certificada simple del libro matriz	\N	11	t
884	152	Derecho de Trámite, de acuerdo a los siguientes casos: Copia certificada Impresa a PAD del libro matriz	\N	13	t
885	153	Copia certificada del libro matriz con firma legalizada por el Alcalde	\N	22	t
886	153	Impresión a PAD del libro matriz con firma legalizada por el Alcalde.	\N	24	t
887	154	Solicitud dirigida al Alcalde	\N	\N	t
888	154	Copia simple del DNI del solicitante, sino cuenta con DNI presentar una declaración jurada simple	\N	\N	t
889	154	Copia del comprobante de pago de la tasa municipal correspondiente	\N	15.5	t
890	155	Solicitud dirigida al Alcalde	\N	\N	t
891	155	Copia simple de DNI del solicitante de no contar con DNI presentar una declaración jurada simple	\N	\N	t
892	155	Partida de Bautismo original y certificada y/o Declaración Jurada Notarial.	\N	\N	t
893	155	Copia del comprobante de pago de la tasa municipal correspondiente	\N	14.800000000000001	t
894	156	Copia legalizada del DNI del titular y/o constancia de inscripción en RENIEC	\N	\N	t
895	156	Copia del comprobante de pago de la tasa municipal correspondiente	\N	10.1	t
896	157	Solicitud dirigida al Alcalde	\N	\N	t
897	157	Copia legalizada del Acta de Defunción	\N	\N	t
898	157	Copia simple del DNI del solicitante, sino cuenta con DNI presentar una declaración jurada simple	\N	\N	t
899	157	Copia del comprobante de pago de la tasa municipal correspondiente	\N	15.5	t
900	158	Solicitud dirigida al Alcalde	\N	\N	t
901	158	Copia del comprobante de pago de la tasa municipal correspondiente	\N	20	t
902	161	Solicitud simple dirigida al Alcalde	\N	\N	t
903	161	Para los casos de personas juridicas,presentar la Copia Literal debidamente inscrita en los Registros publicos y/o presentar el padron precisando la identificacion , el DNI y el domicilio actual de cada socio	\N	\N	t
904	161	Copia del comprobante de pago de la tasa municipal correspondiente	\N	82.040000000000006	t
905	162	Solicitud dirigida al Alcalde	\N	\N	t
906	162	Para grupos asociados, adjuntar padrón y estatuto	\N	\N	t
907	162	Pago de derecho por autorización a: Comerciantes de Empresas Transnacionales 	\N	71	t
908	162	Pago de derecho por autorización a: Comerciantes locales, foráneos	\N	50.100000000000001	t
909	162	Pago de derecho por autorización a: OTROS GIRO/ NEGOCIOS: Comidas puesto C/U	\N	50.100000000000001	t
910	162	Pago de derecho por autorización a: OTROS GIRO/ NEGOCIOS: Flores puesto c/u	\N	50.100000000000001	t
911	162	Pago de derecho por autorización a: OTROS GIRO/ NEGOCIOS: Chichas, dulces, jugos, golosinas, otros	\N	15	t
912	162	Pago de derecho por autorización a: OTROS GIRO/ NEGOCIOS: Wuahuas	\N	37	t
913	162	Pago de derecho por autorización a: OTROS GIRO/ NEGOCIOS: Juegos mecánicos y electrónicos por cada juego	\N	37	t
914	162	Pago de derecho por autorización a: OTROS GIRO/ NEGOCIOS: Muyuchi, helados/mes.	\N	35.5	t
915	162	Pago de derecho por autorización a: EN FIESTAS TRADICIONALES: Juegos recreativos por cada juego	\N	37	t
916	162	Pago de derecho por autorización a: EN OTRAS FECHAS: Juegos recreativos por cada juego	\N	37	t
917	163	Solicitud dirigida al Alcalde	\N	\N	t
918	163	Copia del comprobante de pago de la tasa municipal correspondiente, según ubicación de puestos: Santa Clara	\N	200	t
919	163	Copia del comprobante de pago de la tasa municipal correspondiente, según ubicación de puestos: Playa Grau, Terminal Pesquero	\N	170.09999999999999	t
920	163	Copia del comprobante de pago de la tasa municipal correspondiente, según ubicación de puestos: Carlos F Vivanco	\N	170.09999999999999	t
921	163	Copia del comprobante de pago de la tasa municipal correspondiente, según ubicación de puestos: Magdalena	\N	170.09999999999999	t
922	163	Copia del comprobante de pago de la tasa municipal correspondiente, según ubicación de puestos: Mariscal Cáceres	\N	170.09999999999999	t
923	163	Copia del comprobante de pago de la tasa municipal correspondiente, según ubicación de puestos: Otros Mercados	\N	170.09999999999999	t
924	164	Solicitud dirigida al Alcalde	\N	\N	t
925	164	Copia del comprobante de pago de la tasa municipal correspondiente	\N	35.5	t
926	165	Solicitud dirigida al Alcalde	\N	\N	t
927	165	Copia del comprobante de pago de la tasa municipal correspondiente: Permiso para ausentarse Hasta 30 días	\N	35.5	t
928	165	Copia del comprobante de pago de la tasa municipal correspondiente: Permiso para ausentarse Hasta 90 días ( Más de 90 días, pierde el derecho de conductor)	\N	49	t
929	166	Solicitud dirigida al Alcalde	\N	\N	t
930	166	Informe de Inspeccion tecnica del profesional autorizado	\N	\N	t
931	166	Copia del comprobante de pago de la tasa municipal correspondiente	\N	82.040000000000006	t
932	167	Solicitud dirigida al Alcalde	\N	\N	t
933	167	Copia del comprobante de pago de la tasa municipal correspondiente (Convenio INDECOPI): Depósito y grifos	\N	10.199999999999999	t
934	167	Copia del comprobante de pago de la tasa municipal correspondiente Balanzas: Plataforma	\N	5.0999999999999996	t
935	167	Copia del comprobante de pago de la tasa municipal correspondiente Balanzas: Reloj	\N	5.0999999999999996	t
936	167	Copia del comprobante de pago de la tasa municipal correspondiente Balanzas: Plataforma (mas de 100 Kg.)	\N	35.5	t
937	168	Solicitud dirigida al Alcalde	\N	\N	t
938	168	Presentar el DNI vigente	\N	\N	t
939	168	Copia del comprobante de pago de la tasa municipal correspondiente	\N	10	t
940	172	Solicitud bajo la forma de Declaración Jurada, indicando el DNI, domicilio y nombre del representante legal y Registro Único de Contribuyente (RUC)	\N	\N	t
941	172	Copia fotostática del Testimonio de Constitución de la Persona Jurídica	\N	\N	t
942	172	Copia de ficha literal vigente de la Partida Registral expedida por Oficina Registral correspondiente, con una antigüedad mayor a treinta (30) días calendario	\N	\N	t
945	172	Declaración Jurada donde se comprometa auxiliar de inmediato a la víctima de los accidentes de tránsito	\N	\N	t
946	172	Relación de propietarios, conductores y vehículos afiliados al Transportador autorizado, con indicación de la placa, marca, modelo, Color y número de serie	\N	\N	t
947	172	Copia fotostática de las Licencias de Conducir de los conductores afiliados y con la categoría correspondiente BII-C, emitida Por la Municipalidad Provincial de Huamanga	\N	\N	t
948	172	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
949	172	Constancia de no adeudar papeleta de infracción al tránsito y transporte	\N	\N	t
950	172	Padrón de vehículos con antigüedad no mayor a ocho años, a dos años más previa constatación técnica, con motor de cuatro tiempos y con el color establecido por la municipalidad	\N	\N	t
951	172	Código de paraderos incluidos en el Plan Regulador de Vehículos Menores para la Provincia de Huamanga (Opcional)	\N	\N	t
952	172	Copia del comprobante de pago de la tasa municipal correspondiente	\N	1512.8499999999999	t
953	173	Solicitud dirigida al Alcalde, indicando el numero de RUC	\N	\N	t
954	173	Copia literal de la Constitución de la Empresa inscrita en la Oficina Registral SUNARP en la que indica, objeto social, representante legal y socios hábiles	\N	\N	t
955	173	Estudio de Mercado según ruta firmado por un profesional colegiado en la materia, adjuntando plano de recorrido	\N	\N	t
956	173	Padrón de la flota vehicular, cantidad y características, del vehiculo	\N	\N	t
957	173	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
958	173	Copia fotostática de las tarjetas de propiedad de los vehiculos	\N	\N	t
959	173	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
960	173	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
961	173	Padrón de conductores, indicando nombre, Numero de Licencia, clase y categoría	\N	\N	t
962	173	Copia de Licencias de conducir vigente de los conductores de los vehículos, Categoría A-II B como mínimo	\N	\N	t
963	173	Licencia de Funcionamiento del terminal y/o Estacion de Ruta Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
964	173	Adjuntar la vigencia de poder no mayor a 30 dias de haber sido expedida por la SUNARP	\N	\N	t
965	173	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Urbano/ anual	\N	3550	t
966	173	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Interurbano/ anual	\N	2130	t
967	174	Solicitud dirigida al Alcalde, indicando el numero de RUC	\N	\N	t
968	174	Copia literal de la Constitución de la Empresa inscrita en la Oficina Registral SUNARP en la que indica, objeto social, representante legal y socios hábiles	\N	\N	t
969	174	Estudio de Mercado según ruta firmado por un profesional colegiado en la materia	\N	\N	t
970	174	Padrón de la flota vehicular, cantidad y características, del vehiculo	\N	\N	t
971	174	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
972	174	Copia fotostática de las tarjetas de propiedad de los vehiculos	\N	\N	t
973	174	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
974	174	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
975	174	Padrón de conductores, indicando nombre, Numero de Licencia, clase y categoría	\N	\N	t
976	174	Copia de Licencias de conducir vigente de los conductores de los vehículos, Categoría A-II B como mínimo	\N	\N	t
977	174	Licencia de Funcionamiento del Centro de Operación de la Empresa	\N	\N	t
978	174	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
979	174	Adjuntar la vigencia de poder no mayor a 30 dias de haber sido expedida por la SUNARP	\N	\N	t
980	174	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Taxi Urbano/anual	\N	308.08999999999997	t
981	174	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Taxi Colectivo/anual	\N	204	t
982	175	Solicitud dirigida al Alcalde	\N	\N	t
983	175	Copia fotostática del seguro obligatorio contra accidente de trabajo y/o CAT, vigentes	\N	\N	t
984	175	Padrón de vehículos y conductores del transportador autorizado	\N	\N	t
985	175	Copia fotostática fedateada de la prueba del gasómetro	\N	\N	t
986	175	Copia fotostática fedateada de las tarjeta de identificación vehicular mas el DNI emitidas por la SUNARP	\N	\N	t
987	175	Copia fotostática fedateada de licencia de conducir de los Con la categoría correspondiente B-II-C, emitida por la Municipalidad Provincial de Huamanga	\N	\N	t
988	175	Adjuntar la vigencia de poder no mayor a 30 dias de haber sido expedida por la SUNARP	\N	\N	t
989	175	Copia del comprobante de pago de la tasa municipal correspondiente	\N	1512.8499999999999	t
990	176	Solicitud dirigida al Alcalde	\N	\N	t
991	176	Copia literal de la Constitución de la Empresa inscrita en la Oficina Registral SUNARP en la que indica, objeto social, representante legal y socios hábiles	\N	\N	t
992	176	Padrón de la flota vehicular, cantidad y características, del vehiculo	\N	\N	t
993	176	Constancia de Verificación Físico-Mecánica aprobado.	\N	\N	t
994	176	Copia fotostática de las tarjetas de propiedad de los vehiculos	\N	\N	t
995	176	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
996	176	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
997	176	Padrón de conductores, indicando nombre, Numero de Licencia clase y categoría	\N	\N	t
998	176	Copia de Licencias de conducir vigente de los conductores de los vehículos, Categoría A-II B como mínimo	\N	\N	t
999	176	Licencia de Funcionamiento del terminal y/o Estacion de Ruta	\N	\N	t
1000	176	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1001	176	Adjuntar la vigencia de poder no mayor a 30 dias de haber sido expedida por la SUNARP	\N	\N	t
1002	176	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Urbano	\N	2840	t
1003	176	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Interurbano	\N	2130	t
1004	177	Solicitud dirigida al Alcalde	\N	\N	t
1005	177	Copia literal de la Constitución de la Empresa inscrita en la Oficina Registral SUNARP en la que indica, objeto social, representante legal y socios hábiles	\N	\N	t
1006	177	Padrón de la flota vehicular, cantidad y características, del vehiculo	\N	\N	t
1007	177	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
1008	177	Copia fotostática de las tarjetas de propiedad de los vehículos	\N	\N	t
1009	177	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
1010	177	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
1011	177	Padrón de conductores, indicando nombre, Numero de Licencia, clase y categoría	\N	\N	t
1012	177	Copia de Licencias de conducir vigente de los conductores de los vehículos, Categoría A-II B como mínimo	\N	\N	t
1013	177	Licencia de Funcionamiento del Centro de Operación de la Empresa	\N	\N	t
1014	177	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1015	177	Adjuntar la vigencia de poder no mayor a 30 dias de haber sido expedida por la SUNARP	\N	\N	t
1016	177	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Taxi Urbano	\N	308.08999999999997	t
1017	177	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Taxi Colectivo	\N	188.38999999999999	t
1018	178	Solicitud dirigida al Alcalde, indicando el numero de Resolución de Autorizacion para prestar el servicio de transporte urbano	\N	\N	t
1019	178	Croquis de recorrido	\N	\N	t
1020	178	Tasa Municipal correspondiente para servicio urbano, autorizado para el Máximo 50% de su flota vehicular, adjuntando el Padron vehicular, Tarjeta Unica de Circulacion y el SOAT vigente de todos los vehiculos autorizados	\N	281.19	t
1021	179	Solicitud dirigida al Alcalde, indicando el numero de Resolucion de Autorizacion para prestar el servicio de transporte urbano e interurbano	\N	\N	t
1022	179	Copia de Acta de Junta de socios, autorizando el incremento vehicular	\N	\N	t
1023	179	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
1024	179	Copia fotostática de las tarjetas de propiedad de los vehículos	\N	\N	t
1025	179	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
1026	179	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
1027	179	Copia de Licencias de conducir vigente de los conductores de los vehículos, Categoría A-II B como mínimo	\N	\N	t
1028	179	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1029	179	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Urbano	\N	118.14	t
1030	179	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Interurbano	\N	120.42	t
1031	180	Solicitud dirigida al Alcalde, indicando el numero de Resolucion de Autorizacion para prestar el servicio de transporte taxi	\N	\N	t
1032	180	Copia de Acta de Junta de socios, autorizando el incremento vehicular	\N	\N	t
1033	180	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
1034	180	Copia fotostática de las tarjetas de propiedad de los vehículos	\N	\N	t
1035	180	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
1036	180	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
1037	180	Copia de Licencias de conducir vigente de los conductores de los vehículos, Categoría A-II B como mínimo	\N	\N	t
1038	180	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1039	180	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Taxi Urbano	\N	99.920000000000002	t
1040	180	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Taxi Colectivo	\N	105.13	t
1041	181	Solicitud dirigida al Alcalde, indicando el numero de Resolucion de Autorizacion para prestar el servicio de transporte de mototaxi	\N	\N	t
1042	181	Copia fotostática de la tarjeta de identificación vehicular de todos los vehículos, emitidas por la SUNARP	\N	\N	t
1043	181	Copia fotostática de la Póliza de Seguro Obligatoria contra accidentes de tránsito(SOAT) vigente o CAT autorizados en la Provincia de Huamanga conforme a Ley	\N	\N	t
1044	181	Declaración Jurada donde se comprometa auxiliar de inmediato a la víctima de los accidentes de tránsito	\N	\N	t
1045	181	Copia fotostática de las Licencias de Conducir de los conductores afiliados y con la categoría correspondiente BII-C, emitida Por la Municipalidad Provincial de Huamanga	\N	\N	t
1046	181	Constancia de no adeudar papeleta de infracción al tránsito y transporte	\N	\N	t
1047	181	Copia del comprobante de pago de la tasa municipal correspondiente	\N	167.13999999999999	t
1048	182	Solicitud dirigida al Alcalde, indicando el numero de Resolucion de Autorizacion para prestar el servicio de transporte urbano e interurbano	\N	\N	t
1049	182	Copia de Acta de Junta de socios, autorizando la sustitucion vehicular	\N	\N	t
1050	182	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
1051	182	Copia fotostática de las tarjetas de propiedad de los vehiculos	\N	\N	t
1052	182	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
1053	182	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
1054	182	Copia de Licencias de conducir vigente de los conductores de los vehículos, Categoría A-II B como mínimo	\N	\N	t
1055	182	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1056	182	Devolucion de la Tarjeta Unica de Circulacion del vehiculo sustituido, si no contara con dicha tarjeta presentar Declaracion Jurada simple	\N	\N	t
1057	182	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Urbano	\N	125.94	t
1058	182	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Interurbano	\N	114.77	t
1059	183	Solicitud dirigida al Alcalde, indicando el numero de Resolución de Autorizacion para prestar el servicio de transporte de taxi.	\N	\N	t
1060	183	Copia de Acta de Junta de socios, autorizando la sustitucion vehicular	\N	\N	t
1061	183	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
1062	183	Copia fotostática de las tarjetas de propiedad de los vehiculos	\N	\N	t
1063	183	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
1064	183	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
1065	183	Copia de Licencias de conducir vigente de los conductores de los vehículos, Categoría A-II B como mínimo	\N	\N	t
1206	209	Certifica do de estudios (como mínimo primaria)	\N	\N	t
1066	183	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1067	183	Devolucion de la Tarjeta Unica de Circulacion del vehiculo sustituido, si no contara con dicha tarjeta presentar Declaracion Jurada simple	\N	\N	t
1068	183	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Taxi Urbano	\N	125.94	t
1069	183	Copia del comprobante de pago de la tasa municipal correspondiente, Para servicio Taxi Colectivo	\N	99.920000000000002	t
1070	184	Solicitud dirigida al Alcalde	\N	\N	t
1071	184	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
1072	184	Copia certificado SOAT vigente	\N	\N	t
1073	184	Croquis de recorrido	\N	\N	t
1074	184	Copia de tarjeta de propiedad	\N	\N	t
1075	184	Copia de la Licencia de Conducir (A-II B como mínimo)	\N	\N	t
1076	184	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1077	184	Copia del comprobante de pago de la tasa municipal correspondiente	\N	115.09	t
1078	185	Solicitud dirigida al Alcalde, indicando el numero de Resolución de Autorizacion para prestar el servicio de transporte urbano e interurbano	\N	\N	t
1079	185	Croquis de recorrido propuesto bifurcación, ampliación y/o reducción	\N	\N	t
1080	185	Estudio Técnico-Económico de factibilidad, firmado por un profesional	\N	\N	t
1081	185	Copia del comprobante de pago de la tasa municipal correspondiente, Servicio urbano	\N	2000	t
1082	185	Copia del comprobante de pago de la tasa municipal correspondiente, Servicio inter urbano	\N	1775	t
1083	185	Copia del comprobante de pago de la tasa municipal correspondiente, Servicio turístico/carga	\N	532.5	t
1084	186	Solicitud dirigida al Alcalde, indicando el numero de Resolucion de Autorizacion para prestar el servicio de transporte público	\N	\N	t
1085	186	Copia de Licencia de conducir vigente del conductor	\N	\N	t
1086	186	Copia fotostática de la tarjeta de propiedad del vehículo	\N	\N	t
1087	186	Certificado de Seguro Obligatorio (SOAT) vigente	\N	\N	t
1088	186	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1089	186	Constancia de Verificación Físico-Mecánica vigente	\N	\N	t
1090	186	Copia del comprobante de pago de la tasa municipal correspondiente	\N	55.259999999999998	t
1091	187	Solicitud dirigida al Alcalde, indicando el numero de Resolucion de Autorizacion para prestar el servicio de transporte publico vigente	\N	\N	t
1092	187	Copia de Licencia de conducir vigente del conductor	\N	\N	t
1093	187	Copia fotostática de la tarjeta de propiedad del vehículo	\N	\N	t
1094	187	Certificado de Seguro Obligatorio (SOAT) vigente.	\N	\N	t
1095	187	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1096	187	Constancia de Verificación Físico-Mecánica vigente	\N	\N	t
1097	187	Adjuntar la Tarjeta Unica de Circulacion vencida (original)	\N	\N	t
1098	187	Copia del comprobante de pago de la tasa municipal correspondiente	\N	55.259999999999998	t
1099	188	Solicitud bajo la forma de declaración jurada, indicando el número de Documento Nacional de Identidad (DNI), domicilio, nombre de Representante legal y Registro Único de Contribuyente (RUC)	\N	\N	t
1100	188	Copia fotostática del testimonio de constitución de la persona jurídica	\N	\N	t
1101	188	Copia de la ficha literal o partida registral de ser el caso	\N	\N	t
1102	188	Copia fotostática de la tarjeta de propiedad emitida por la SUNARP	\N	\N	t
1103	188	Copia fotostática del seguro obligatorio contra accidentes de tránsito	\N	\N	t
1104	188	Copias fotostáticas de certificado constatación de características	\N	\N	t
1105	188	Copia del comprobante de pago de la tasa municipal correspondiente	\N	112.93000000000001	t
1106	189	Solicitud bajo la forma de declaración jurada, indicando el número de Documento Nacional de Identidad (DNI), domicilio, nombre de Representante legal y Registro Único de Contribuyente (RUC)	\N	\N	t
1107	189	Copia simple del seguro obligatorio contra accidentes de tránsito (SOAT)	\N	\N	t
1108	189	Copia simple de la Constancia de Verificación Físico Mecánico Vehicular	\N	\N	t
1109	189	Copia del comprobante de pago de la tasa municipal correspondiente	\N	99.920000000000002	t
1110	190	Solicitud dirigida al Alcalde	\N	\N	t
1111	190	Tarjeta de Propiedad	\N	\N	t
1112	190	Licencia de Conducir B-II-B. Como mínimo	\N	\N	t
1113	190	Copia del SOAT vigente	\N	\N	t
1114	190	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
1115	190	Record de papeletas otorgado por el SATH	\N	\N	t
1116	190	Copia simple de Licencia de funcionamiento	\N	\N	t
1117	190	Copia del comprobante de pago de la tasa municipal correspondiente	\N	91.25	t
1118	190	Copia simple de la Autorización por la Osinergmin, en caso de Transporte de balones de Gas	\N	\N	t
1119	191	Solicitud al Gerente Municipal	\N	\N	t
1120	191	Copia Tarjeta de Propiedad	\N	\N	t
1121	191	Licencia de Conducir B-II-B. Como mínimo	\N	\N	t
1122	191	Copia del DNI del conductor	\N	\N	t
1123	191	Copia del SOAT vigente	\N	\N	t
1124	191	Record de papeletas otorgado por el SATH	\N	\N	t
1125	191	Copia simple de Licencia de funcionamiento	\N	\N	t
1126	191	Adjuntar la tarjeta de circulación original vencida	\N	\N	t
1127	191	Derecho de Tramitación	\N	\N	t
1128	191	Copia simple de la Autorización por la Osinergmin, en caso de Transporte de balones de Gas	\N	86.909999999999997	t
1129	192	Solicitud dirigida al Alcalde, indicando el numero de Resolucion de Autorizacion para prestar el servicio de transporte publico vigente	\N	\N	t
1130	192	Copia de la ficha registral con vigencia no mayor a 30 días de haber sido expedida por la SUNARP (Oficina Registral de Ayacucho)	\N	\N	t
1131	192	Copia literal de testimonio	\N	\N	t
1132	192	Copia de acta de junta de socios que autorice las modficaciones correspondientes	\N	\N	t
1133	192	Copia del comprobante de pago de la tasa municipal correspondiente	\N	57.259999999999998	t
1134	193	Solicitud dirigida al Alcalde, adjuntando plano simple de ubicacion	\N	\N	t
1135	193	Copia fotostática de la tarjeta de propiedad del vehículo	\N	\N	t
1136	193	Constancia de Verificación Físico-Mecánica aprobado	\N	\N	t
1137	193	Certificado de Seguro Obligatorio (SOAT) vigente, por cada vehículo	\N	\N	t
1138	193	Constancia de no adeudar PIT, expedidas por SAT-Huamanga	\N	\N	t
1139	193	Copia de Licencias de conducir vigente del conductor	\N	\N	t
1140	193	Certificado de capacitación del conductor del vehículo en el Reglamento de Tránsito, emitido por las entidades autorizadas	\N	\N	t
1141	193	Copia del comprobante de pago de la tasa municipal correspondiente	\N	308.08999999999997	t
1142	194	Solicitud dirigida al Alcalde, indicando el numero de la Tarjeta Unica de Circulacion inicial	\N	\N	t
1143	194	Copia de la Tarjeta de Propiedad del vehiculo	\N	\N	t
1144	194	Constancia de denuncia policial por perdida o robo	\N	\N	t
1145	194	Copia del comprobante de pago de la tasa municipal correspondiente	\N	40.57	t
1146	195	Tarjeta de propiedad del vehículo	\N	\N	t
1147	195	Ticket de analisis de la emision de gases del vehiculo (gasometro)	\N	\N	t
1148	195	Derecho de pago por tasa municipal segun: Moto taxis	\N	45.219999999999999	t
1149	195	Derecho de pago por tasa municipal segun: Automóviles	\N	47.399999999999999	t
1150	195	Derecho de pago por tasa municipal segun: Minivan	\N	54.299999999999997	t
1151	195	Derecho de pago por tasa municipal segun: Camion (mayor y menor)	\N	61.920000000000002	t
1152	195	Derecho de pago por tasa municipal segun: Camioneta	\N	54.299999999999997	t
1153	195	Derecho de pago por tasa municipal segun: Camioneta Rural	\N	54.299999999999997	t
1154	195	Derecho de pago por tasa municipal segun: Ómnibus	\N	64.290000000000006	t
1155	195	Derecho de pago por tasa municipal segun: Otros	\N	64.290000000000006	t
1156	196	Solicitud dirigida al Alcalde, indicando el número de la Constancia de Verificacion Físico Mecánica	\N	\N	t
1157	196	Copia de la Tarjeta de Propiedad del vehículo	\N	\N	t
1158	196	Constancia de denuncia policial por perdida o robo	\N	\N	t
1159	196	Derecho de trámite	\N	45.219999999999999	t
1160	197	Copia del comprobante de pago de la tasa municipal correspondiente	\N	30.149999999999999	t
1161	198	Presenta el DNI vigente del solicitante	\N	\N	t
1162	198	Copia simple de la Boleta de Internamiento	\N	\N	t
1163	198	Copia simple de la Tarjeta de Identificación Vehicular	\N	\N	t
1164	198	Comprobante de Pago de multa	\N	\N	t
1165	198	Copia simple de la Licencia de Conducir	\N	\N	t
1166	198	Copia del comprobante de pago de la tasa municipal correspondiente: Moto taxis	\N	15.869999999999999	t
1167	198	Copia del comprobante de pago de la tasa municipal correspondiente: Motocicletas (Lineal) y triciclos	\N	15.869999999999999	t
1168	198	Copia del comprobante de pago de la tasa municipal correspondiente: Taxi urbano	\N	15.869999999999999	t
1169	198	Copia del comprobante de pago de la tasa municipal correspondiente: Servicio de Transporte escolar	\N	15.869999999999999	t
1170	198	Copia del comprobante de pago de la tasa municipal correspondiente: Servicio de Carga y mudanza: Camioneta-camión	\N	15.869999999999999	t
1171	198	Copia del comprobante de pago de la tasa municipal correspondiente: Servicio Urbano e Interurbano (Interdistrital): Camioneta rural	\N	15.869999999999999	t
1172	198	Copia del comprobante de pago de la tasa municipal correspondiente: Servicio Urbano e Interurbano (Interdistrital): Ómnibus	\N	20.219999999999999	t
1173	198	Copia del comprobante de pago de la tasa municipal correspondiente: Particulares: Camión Mayor	\N	20.219999999999999	t
1174	198	Copia del comprobante de pago de la tasa municipal correspondiente: Particulares: Camión Menor	\N	20.219999999999999	t
1175	198	Copia del comprobante de pago de la tasa municipal correspondiente: Particulares: Tráiler: Mayor	\N	20.219999999999999	t
1176	198	Copia del comprobante de pago de la tasa municipal correspondiente: Particulares: Tráiler: Menor	\N	20.219999999999999	t
1177	198	Copia del comprobante de pago de la tasa municipal correspondiente: Particulares: Tráiler: Camionetas	\N	15.869999999999999	t
1178	198	Copia del comprobante de pago de la tasa municipal correspondiente: Particulares: Tráiler: Automóviles	\N	15.869999999999999	t
1179	198	Copia del comprobante de pago de la tasa municipal correspondiente: Particulares: Tráiler: Motocicletas.	\N	15.869999999999999	t
1180	206	Edad mínima 18 años (presentar DNI vigente)	\N	\N	t
1181	206	Dos fotografías de frente, tamaño carné a colores, en fondo blanco	\N	\N	t
1182	206	Certificado domiciliario expedido por Notario Público, Juzgado de Paz o Certificado de Trabajo, para los que tienen DNI de otras provincias o departamentos	\N	\N	t
1183	206	Certificado de aptitud psicosomática (Otorgado por el establecimiento	\N	\N	t
1184	206	Aprobar el examen del reglamento de tránsito	\N	\N	t
1185	206	Aprobar el examen de manejo para la categoría correspondiente	\N	\N	t
1186	206	Primaria completa (adjuntar copia certificada del certificado de estudios originales)	\N	\N	t
1187	206	Copia del comprobante de pago de la tasa municipal correspondiente	\N	68.989999999999995	t
1188	207	Edad mínima 18 años (presentar DNI vigente)	\N	\N	t
1189	207	Dos fotografías de frente, tamaño carné a colores, en fondo blanco	\N	\N	t
1190	207	Certificado domiciliario expedido por Notario Público, Juzgado de Paz o Certificado de Trabajo, para los que tienen DNI de otras provincias o departamentos	\N	\N	t
1191	207	Certificado de aptitud psicosomática (Otorgado por el establecimiento	\N	\N	t
1192	207	Aprobar el examen del reglamento de tránsito	\N	\N	t
1193	207	Aprobar el examen de manejo para la categoría correspondiente	\N	\N	t
1194	207	Primaria completa (adjuntar copia certificada del certificado de estudios originales)	\N	\N	t
1195	207	Certificado de estudios.(Mínimo primaria completa, deberá adjuntar Copia certificada o legalizada)	\N	\N	t
1196	207	Certificado de capacitación del conductorde transporte de personas	\N	\N	t
1197	207	Copia del comprobante de pago de la tasa municipal correspondiente	\N	68.989999999999995	t
1198	208	Solicitud dirigida al Alcalde	\N	\N	t
1199	208	Dos (02) fotografías de frente, tamaño carné a colores fondo blanco	\N	\N	t
1200	208	Certificado domiciliario, expedido por la autoridad competente	\N	\N	t
1201	208	Certificado de aptitud psicosomática	\N	\N	t
1202	208	Aprobar el examen de reglamento de tránsito	\N	\N	t
1203	208	Derecho de Tramitación	\N	52.079999999999998	t
1204	209	Solicitud dirigida al Gerente Municipal	\N	\N	t
1205	209	Devolución de la licencia de conducir anterior o constancia de haber obtenido la licencia por revalidar (por recategorizar)	\N	\N	t
1207	209	Dos (02) fotografías de frente tamaño carné a colores fondo blanco	\N	\N	t
1208	209	Copia de DNI	\N	\N	t
1209	209	Certificado de aptitud psicosomática	\N	\N	t
1210	209	Certificado de práctica de manejo	\N	\N	t
1211	209	Certificado de capacitación emitida por la escuela de conductores autorizado por el MTC	\N	\N	t
1212	209	Examen de reglamento de tránsito	\N	\N	t
1213	209	Derecho de Tramitación	\N	48.909999999999997	t
1214	210	Solicitud dirigida al gerente Municipal	\N	\N	t
1215	210	Copia del (DNI) o reporte del RENIEC	\N	\N	t
1216	210	Edad mínima: 18 años de edad	\N	\N	t
1217	210	Dos (02) fotografías de frente tamaño carné a colore fondo blanco	\N	\N	t
1218	210	Primaria completa. (Adjuntar copiadel certificado de estudios generales)	\N	\N	t
1219	210	Certificado de aptitud psicosomática, otorgado por el establecimiento de salud, certificado por la autoridada competente	\N	\N	t
1220	210	Aprobar el examen de reglamento de tránsito	\N	\N	t
2121	210	Aprobar el examen de manejo para la categoría correspondiente	\N	\N	t
1222	210	Entrega de la licencia de la provincia de origen	\N	\N	t
1223	210	Derecho de Tramitación	\N	52.079999999999998	t
1224	211	Solicitud dirigida al Gerente Municipal	\N	\N	t
1225	211	Una (01) fotografía de frente tamaño carné a colores en fondo blanco	\N	\N	t
1226	211	Copia del Documento Nacional de Identidad (DNI)	\N	\N	t
1227	211	Derecho de Tramitación	\N	33.270000000000003	t
1228	216	Solicitud con carácter de Declaración Jurada	\N	\N	t
1229	216	Plan de contingencia y seguridad	\N	\N	t
1230	216	Plano de ubicación	\N	\N	t
1231	216	Plano de distribución	\N	\N	t
1232	216	Copia del comprobante de pago de la tasa municipal correspondiente, Hasta 100 M2	\N	66.780000000000001	t
1233	216	Copia del comprobante de pago de la tasa municipal correspondiente, Mayor a 100 M2 hasta 500 M2	\N	174.08000000000001	t
1234	216	Nota: El pago por Levantamiento de observaciones se realizará despues del informe de Observaciones, Hasta 100 M2	\N	29.600000000000001	t
1235	216	Nota: El pago por Levantamiento de observaciones se realizará despues del informe de Observaciones, Mayor a 100 M2 hasta 500 M2	\N	81.400000000000006	t
1236	217	Solicitud con carácter de Declaración Jurada	\N	\N	t
1237	217	Declaración Jurada de Observancia de las condiciones de Seguridad, según por formato aprobado por el Reglamento de Inspecciones	\N	\N	t
1238	217	Copia del comprobante de pago de la tasa municipal correspondiente	\N	66.780000000000001	t
1239	217	Nota: El pago por Levantamiento de observaciones se realizará después del informe de Observaciones	\N	29.600000000000001	t
1240	218	Solicitud con carácter de Declaración Jurada	\N	\N	t
1241	218	Cartilla de seguridad y/o plan de seguridad en Defensa Civil (incluye plano de Evacuación y Circulación a escala 1/100, 1/200 ó 1/500)	\N	\N	t
1242	218	Plano de ubicación	\N	\N	t
1243	218	Plano de distribución	\N	\N	t
1244	218	Copia del comprobante de pago de la tasa municipal correspondiente	\N	174.08000000000001	t
1245	218	Nota: El pago por Levantamiento de observaciones se realizará después del informe de Observaciones	\N	81.400000000000006	t
1246	219	Solicitud con carácter de Declaración Jurada	\N	\N	t
1247	219	Declaración jurada de no haber realizado modificación alguna al objeto de inspección	\N	\N	t
1248	219	Cartilla de Seguridad, Plan de Seguridad en Defensa Civil o copia de Planes de Contigencia debidamente aprobados y actualizados, según corresponda	\N	\N	t
1249	219	Protocolos u otros documentos que hayan perdido vigencia y que forman parte del expediente en poder de la administración	\N	\N	t
1250	219	Copia del comprobante de pago de la tasa municipal correspondiente	\N	66.780000000000001	t
1251	219	Nota: *El pago por Levantamiento de observaciones se realizara despues del informe de Observaciones. *Según el artículo 41 del Decreto Supremo Nº 066-2007-PCM, si en el procedimiento de renovación del Certificado de Inspección Técnica de Seguridad en Defensa Civil, el órgano ejecutante de la ITSDC verifica que no se mantiene el cumplimiento de las normas de seguridad en materia de Defensa Civil, se emite el Informe Técnico correspondiente y se da por finalizado el procedimiento, debiendo el administrado tramitar una nueva inspección	\N	29.600000000000001	t
1252	220	Solicitud con carácter de Declaración Jurada	\N	\N	t
1253	220	Declaración jurada de no haber realizado modificación alguna al objeto de inspección	\N	\N	t
1254	220	Cartilla de Seguridad, Plan de Seguridad en Defensa	\N	\N	t
1255	220	Defensa Civil o copia de Planes de Contingencia debidamente aprobados y actualizados, según corresponda	\N	\N	t
1256	220	Protocolos u otros documentos que hayan perdido vigencia y que forman parte del expediente en poder de la administración	\N	\N	t
1257	220	Copia del comprobante de pago de la tasa municipal correspondiente	\N	174.08000000000001	t
1258	220	Nota: El pago por Levantamiento de observaciones se realizará despues del informe de Observaciones. *Según el artículo 41 del Decreto Supremo Nº 066-2007-PCM, si en el procedimiento de renovación del Certificado de Inspección Técnica de Seguridad en Defensa Civil, el órgano ejecutante de la ITSDC verifica que no se mantiene el cumplimiento de las normas de seguridad en materia de Defensa Civil, se emite el informe Técnico correspondiente y se da por finalizado el procedimiento, debiendo el administrado tramitar una nueva inspección	\N	81.400000000000006	t
1259	221	Solicitud con carácter de Declaración Jurada	\N	\N	t
1260	221	Cartilla de seguridad y/o plan de seguridad en Defensa Civil (incluye plano de Evacuación y Circulación a escala 1/100, 1/200 ó 1/500)	\N	\N	t
1261	221	Plano de ubicación	\N	\N	t
1262	221	Plano de distribución	\N	\N	t
1263	221	Contrato de Seguridad Privada	\N	\N	t
1264	221	Contrato de local y artísticas	\N	\N	t
1265	221	Asistencia médica preventiva (Documento de apoyo de Paramédicos)	\N	\N	t
1266	221	Copia del comprobante de pago de la tasa municipal correspondiente	\N	211.08000000000001	t
1267	221	Nota: El pago por Levantamiento de observaciones se realizara después del informe de Observaciones	\N	81.400000000000006	t
1268	222	Solicitud con carácter de Declaración Jurada	\N	\N	t
1269	222	Plano de ubicación y distribución	\N	\N	t
1270	222	Plan de Contingencia y Seguridad	\N	\N	t
1271	222	Copia del comprobante de pago de la tasa municipal correspondiente	\N	211.08000000000001	t
1272	222	Nota: El pago por Levantamiento de observaciones se realizara después del informe de Observaciones	\N	81.400000000000006	t
1273	223	Solicitud con carácter de Declaración Jurada, en el cual se debe indicar el número del certificado de Inspección Técnica cuyo duplicado se solicita	\N	\N	t
1274	223	Copia del comprobante de pago de la tasa municipal correspondiente	\N	22.379999999999999	t
2122	105	AUTORIZACION 	\N	\N	t
2123	212	DNI legalizado	\N	\N	t
\.


--
-- TOC entry 2254 (class 0 OID 188633)
-- Dependencies: 227
-- Data for Name: respuesta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY respuesta (idrespuesta, idusuario, fechaenvio, estado) FROM stdin;
\.


--
-- TOC entry 2247 (class 0 OID 139554)
-- Dependencies: 220
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rol (idrol, denominacion, estado) FROM stdin;
1	Mesa de partes	t
2	Administrador	t
3	Secretario	t
4	Jefe de Area	t
5	nuevo rol	f
\.


--
-- TOC entry 2248 (class 0 OID 139557)
-- Dependencies: 221
-- Data for Name: rolmodulo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rolmodulo (idrolmodulo, idrol, idmodulo, fechaasignacion, estado) FROM stdin;
1	1	1	2015-10-14 15:17:21.431	t
2	2	2	2015-10-15 11:57:57.948	t
3	2	1	2015-10-15 11:58:03.938	t
4	2	3	2015-10-15 13:04:30.573	t
5	2	4	2015-11-03 12:22:28.033	t
6	3	3	2015-11-24 10:26:28.808	t
8	4	4	2016-02-12 10:51:38.666	t
7	2	5	2015-12-07 11:45:18.215	f
9	2	6	2016-04-15 15:27:34.252	t
10	2	7	2016-08-16 11:30:43.663	t
11	2	8	2016-09-12 15:04:11.485	t
12	1	7	2016-11-14 15:23:59.492	t
\.


--
-- TOC entry 2262 (class 0 OID 303861)
-- Dependencies: 235
-- Data for Name: tipodocumento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipodocumento (idtipodocumento, idregla, denominacion, descripcion, estado, orden, firma, subida, igual, bajada) FROM stdin;
1	0	OFICIO	\N	t	2	t	t	f	f
2	0	OFICIO MULTIPLE	\N	t	3	t	t	f	f
4	0	MEMORANDO MULTIPLE	\N	t	5	f	f	t	t
5	0	INFORME	\N	t	6	f	t	t	f
6	0	INFORME TECNICO	\N	t	7	f	t	t	f
7	\N	CARTA	\N	t	8	f	f	f	t
8	0	PROVEIDO	\N	t	1	f	f	t	t
9	0	NOTA DE PEDIDO	\N	t	9	f	f	t	f
3	0	MEMORANDO	MEMORANDO	t	4	f	t	t	t
\.


--
-- TOC entry 2263 (class 0 OID 336711)
-- Dependencies: 236
-- Data for Name: tipoprocedimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipoprocedimiento (idtipoprocedimiento, denominacion, descripcion, orden, estado, bindactual) FROM stdin;
3	qwe	qwe	3	f	t
4	123	123	4	f	t
5	TUPA 2017	A	3	t	f
2	Procedimientos No TUPA	Procedimientos contemplados fuera de los documentos TUPA	2	t	t
1	Procedimientos TUPA 2014	Procedimientos contemplados en TUPA s	1	t	t
\.


--
-- TOC entry 2249 (class 0 OID 139560)
-- Dependencies: 222
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuario (idusuario, nombres, apellidos, dni, direccion, telefono, usuario, password, estado, creationdate, iniciales, foto) FROM stdin;
72	JOSE	CONTRERAS VERA	12345678	JRON LIBERTAB 123	9666666	jcontreras	1234	t	001479154866817	\N	\N
1	admin	admin	admin	12345678	966	admin	1234	t	\N	AA	data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/4QBiRXhpZgAASUkqAAgAAAABAGmHBAABAAAAGgAAAAAAAAABAIaSBwAsAAAALAAAAAAAAABBU0NJSQAAACh3d3cucGhvLnRvKSBQaG90b0VuZ2luZTo6Q29sbGFnZTo6MQAA/9sAQwAGBAUGBQQGBgUGBwcGCAoQCgoJCQoUDg8MEBcUGBgXFBYWGh0lHxobIxwWFiAsICMmJykqKRkfLTAtKDAlKCko/9sAQwEHBwcKCAoTCgoTKBoWGigoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgo/8AAEQgFAALQAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8AiAwTmgk84Jp2c5wM+tIOD71znSLyB603JxTutIM570IQoBByDxQeSeOaMEHrmgZBPr70wFxjg0o4BpuTgdKcckUxXGkD15NG3tnJpQPzFPUEde9ILkW3J6Yo2nOQcYqUqOo60jAnjGfpSER7c9x+FGMg89Kfsxye1KRgHjBxTQEQGfSjaQScnFPwOo/SkIJOCeOtMBhGScimsvBx2qXtwKQd896QEAy3HGaTawPTIqTBB4FKw+bHpTEyIqT7UFcY5zUmODxz0pADk5FAiEg7jxShSB1p7DsRSY6kcUDQ3HPPNKBjpSgA5JpCOAc0XHcOvBoxlTmgHP0p3Tpnmgm4zjPt05ppGCcHpU2ATg00xgHPagLjRnPFAPJ4pSMDjpTkUEZoC4igH6UhAJwBzTlO5gMdKU8dMUAMK4XjrTNueD196lbO3ik4Oc9aAIwOR04oIwT6U/acE8+wpOOhzmgRHtIGaAAACM5NPPWgA56Z5oAiI4PqKbtBOcVNtB4OBmk24J9MUWC5A4I9TSA8+gqbHc0zZk8cUgEwBUeSMipWQ5qNgRk+tUA3OTwKXI6Gm4PQGlAIAJoC43OMkGkJyTnvSnBJxkZpAp70CHIQQQaDnPNJtGOSaUDpQNAOme9Iee9PGCBgUwjmkAgyM4PFKM8/4Uo4FIM/QUwA8DrTc4wAKdg4OaUDFAEXU5xg0Dg8mpNuM9PamkHnOKBiAZ5FIVBGKUcdcYoPHQUguQ7Bgg96a0K+g9anPOMUmM/SmIgaIYB7GmeWB2xVpunbimsvy84oHcqspHYYphBPAPWrW3g5puwelAECrgnOTSMMVMUIGAaYyZAycH0oAjAHU9aa5A4GMmnsv5ikZCRyOlMYigYxS8c8UzBHOOKQEgcjj3oJHkjOATk0EDHWo+c5B6U5W4wfWgB4GOD2qOQgnGc1JnIJpvYkjmgCIjBOMc8UBTgkjinlcmlGACO1A0RlSEyOlCkHr2FSL0wBmlK4/HtQO5EMe9SduelIRjnvSE5wKBiZBznoKVVAOcdqAMHnpTx6DpUiE5wQDQBz7UAdeKXHHHFAxp6nHehAQcgcUuMZ680oGPpQB2gGAfWgDP0p+MjNCqQDk4qShhXk+lOxgDnmnBQCSaGAJyPpTAhAIyTmlCknqak24zkGgL83BoER45p6jrnr2p4Xn1o245A5oC4AYPNDYPGKcFwBng5pQACc80gGBTSheOhzTwOT70qjA96dgISDnBAoK4JGKkIx170g5JzTAj2EA4zikUAZPUVNjgnpQygqAO9BNyEqCOOuKaFHTHNTFcDFNAAJPegLkZjwDimmPk/5xU2GPPTNKQMcDrQIg289c0MP0qRQMkAUp60AQBCeTSBCTknAHarAGM03Gc0AReWMYphXnH5VaCkj2qI8HgUAQhQT05FKo6k8VKExTNhBJB70AIcAe9KAccjOacEPWlHUA0AR7fmx2pFXLEdhUjoeoPWk2EDrQBGBiTAzQV6nFS4Hbk0nQYxzQBEO/vRtB9aeVI5FJQBHyDz0pvc4qbAxk0ijIJz0pEkYGe3NGfSpD6gU3aRzzTAjOCeaOvHUUrA5+X9aRV9+tABtJzkYxShc5Pp1pygnqc0nT8etADQOT3pjICelWBtzSFAWwBQMrbBj/wCtUTqehq6y4BGPxqMpzimIqbefegKasNGOeOaZsIGcUAMwDxijjBGMU/aSRSbTuIFIBqqCKUqCM+lOC4zS4GDmgYzaCcimleMYyalXAGeKUjOKBEO09zxSEdec1NimYHOaYEW0EEnOKRqkIOOelAXI5xQMiIyfp7UEEVKVGBj9KbtzmkBF36kAUvT60/YSTj9aYUIPPWgQ0AfWg85yKTB64OKdjjk0wGgEnnpS4B4p2CVOBSYIAz0oQ0RlMGhgCOlSN05700g9aAIgowMdT60uwAYB+tO5HbpTdxJHGD3oAjaIZODTXi4BABqYEc5pTjHBoAqNCRwOBTDFzxzVw84xSjnOaLjKBDAnrQM9+tXQqkZxTPKBHSi4FUdOnNB9u9WjEMEfrUZiIOR+VAiDke1PQgnNKyHk8A00A5wBQNCPz060gGOTSgEZJGR60E8ADpQUHWlzxSDoMDilPHSgSHAetIO9IWJOOlAPJH4UgDHJpSPWkBzg0oyScd6EM7kYC0uMjpShSM8jAoHoeKQxoBFOHXGO9GDk0qqSeeKQDdpJINIqkEjrUpBH+NKgGPf3pgR7RjNOUGnBfwpQMk56UWAQrkcdRSAEHHHFSBTggClCjBz1osBEAB9aDzg08rzkdqMZ9xTAYR0/nRgin9B0o429KBNjAuTyelHUkCnHgg0wjJJHFIQ3tg0YznNGaNucnOOO1ACDqRnmlOBkA88U0DnvSnB5/CmA3oTSAc05uoHT8aQ5GfpQAEc9qPXA6UgGTk04DuD1oECDA+agpk570oGOeaDkkkHrxSEM2gcdqAgB5Oc04qQMnmlUEmmAwrxkCm7cn+dTkde1NC5OR9KQETKccdBTD8wxVhhjPfNIiAZ9KAIAABx09aTbk5zUp5yB0pMfhTAj2HPPSkZcjI/SpgvOCc96bgknHSgCILxyKTZ2HT2p4GCBzTiCcjPSgRHtwODzSFTz1JqUcnBpp5OBnIoAh28HPemiPB68VOF4Oe9AXAx3oAiC7c880jJwD3p5AOM0HGRnOBSAYVIUcc0JjnJwaVsAZyaMA4xTGxX5GByT3qMDBI704j+HGPelIIIz0FAhm3qD1FBGVGRUhxk01hwQKAGGMEZXrUezqADmps7fyoDcUwIPLOOgpyxg5J/KpVxzntSkAjmgCFkAIwKRgQDjrU6Lk9Oac0eeuKAKeCaawJNWWTb0qJwRnjmgCLtzz7UEenGKcBgnNIc49RQFxmD9DS7cjg80pXJyDSqME5P5UANJ2g+tKqhuoOfWnMoJ5HWhFwO2KAIiuT2pPLBqVhnpxTAp5OeKAE4+gNJtHP8AWpAOeKOSSMUgK5AzikIyMDrU23PUcUuwDkGmMr7TjmmshxnpU7LxkdqTHNAFcoMZzmmBTk4qwwPOAKYykEkdaAIiDgUAk8YqYLkYIP1ppTAznNICM8jng0YPBzzT9oPegZA560AM5z/Sj1zyKcR60jA+tACFc8HoaQqAeaccY44oPQetFhoZ5QIPPBpn2cc8ip14BzR3B5ouUV1iIJHPFNMfUYOat8HOB+NBXI4oApFCOT2700LgnPSrpjH1phiznjFICrtGDxmljGDyKmMNDIQPfHamgO2K478ClAzzSgYPJz9RShTntSGhu3PtQAQSaewwcCl25zmmA3AII4z70oUkcHilC4Iz608LgfWgVxg4HJpVXJAHSpAvUdqRF+Yn0FAChSBxTivGAOfWnxjmn7QCcd6QiqVx+NIOMnHPpUxGSSKaVHXOKYXI8euaMDr0p7A59qMDuKQEbjIwOtQhTzuAH0qwcdRgU3qcYoAi2jBP5U1RnIHWpSuc5/OjGO1BJEeAeeR2o25wacB1PSj2oGRMMnnoPWgAnOKkZSeMcilGMYwKYESgAEc5pwAySadj2pwTIyaBEXToaAD61KRnoOBSDJ+tAxpBIxTdxAxin5xwR1pCADnNAgBJHAph45zUp4GOtJt60CI/x5pUHJzxTjxkYGaAM8mgBuACfWhhxycGnkYPFIQT2oAjHI75oxx/On7cDnoKUgYGO9A7kJB+tI3HbipiMHnsKTGQRjigCEDIz2owMgnOaeQcmmnOQKBCNwKawOMinlCGyaTnkc80FEYyScDimuvHFSjABpuCetAiBkyozxinqlPKA9TShQBxQBEQQcjpTuo/CnFT270uMUCIgOOfpSdPepsDHIprDngUARBck5o5zwOKlIGcCggdqAIWHPHFOTlSfSn7M5pdpA5FAAmOecUMCc4NKCApz1NO+XbnNAEWM9aidMkn0qz+IxSsuE4AzQBnEH3pp445xVmRcMeBio8DGT0FMRHggcdaUDntTv50EdcigaE9eKApI9qkUgA5HNLkduKAZHtABzTVXnmpQw7ijqf5UCIWU5wOKQDk9yKsYyD60wrg5GPegZEcdxTT1xmpXXPT8qiZSAc0AIeMjtTeCT6inLx16U3Azj1NIBjEAc9aYOhJHNSFQT05o29aYDAMDqaDgjHWnKOTzwKQ98DGaQEe3nFDDuP0p9N7cHmgZGcgEmm9eKlAyTmmMuDQA08de9ITzilCknkYoA70AJzS8kYoOAOOTSBiDxQUOUYGDSg9aTJwaMgmkMcBgc0Hgcc0p+vWmc88/nQIB0OTzTW6c45pegPGaackHPSmK53G088U7HHvUgxnikAznFBSIymevJ96UKcEHrUwHU4pDgjrQMYqnIwAcdaeFyDzjNCAkDqKcOOKRIY/SlAJb5cUY9qcnB5FACqCM5xSdyTxTwMnI6UDGSQc5oAQAZJxUbqDz3qbsaZyST/OgCNhhcDFM2jGc1Ntz1pDgDHagCvkZxTPr+dSleCQBTcUCI2HvwabyKlAJPIpCozzmmIbjOKdxg+tAAOcU4J0BHBoGRFcnv6UpUYwf0qcREkkUhjO7P6UARBCWwOR3p/lNg4A6+tSogB5HvUjA4OOtAEHlYxgCmlBklR9asYOPU0zBB6ZFArkPlg8/pTdhzgDirJQAe2KYwIPB4oEQYwevSnAE5wOlPIyc8dKToCCBigRCcE9OaQAmnnrz09qDkDigYzBx65pe3Ip2MigDnoaAGEZpAMY7CpT16Cjbgcn8qAIT6DnmkOO1SEDPfOKQDNADdowSeeKYAOoFSkelN6cUAQseQKbwalC5zk1GV9DmgYAYzyaY2AetSKDnGRzQVwDnFAEeKQDpUwHGKTbhuAcCgRGfUDNAXJz0qZeeQCKU8DPY0ARKueMUnl5PbFSYIJ5604DPOKAuRFMA8flQFxyRipVIHBp64Y4IyKBFYJ83FSxoMYI/OpQgBPFKy+2aAIJEGMKKYsIPUfhVgqT0OKXGAB6d6AK7RAdsH0puwj61aIIyc8VA4OTkUAQOAePzqtKhC8DmrbdT0H41GwHOcZoGV1A6Gl2EHPankDJxnNAGV4JzQBG2MnApccc0oRvw7mlb7wH8NAhgHQ45pDjPXFTYpuz5higY0Zx170nQc9DUqj2x60m0ZoAh5z04oZQTg9Kl2kEA00jGQRQIrugFNC5B55qds8cU0qM8dKYyMLj3pCMds1IQQOaZnt1oAjbAJIpnbnvUjDLc9qTaOvSgBhXrTSvGM8n0qXpn06U0Dn0FAEe0gdP1prYP0xUr4xgVC2elACDnp0AphY5wad0UHJphBJBA4oGBznFIOpJqTbwaTaQMmkAi5GeeBRuyeB+NByc4pAQPWgB5Gec0w9SM8UoPHAo6kk8Y9qChc44pOD1H50DkUg6kd6BHe4x3pwH+RSAHkHNOGBwKCwxjOM5pMDODTwPalHQ+tBNxMAdqXHHH86UdRmlyOnekA0YBIoIAH65oxg8mlAyeScdhQAo6e4o6HoPwpQMHJPFB5Oe1ADgOD1pmODTxwCfWkPK9aBDSvqaaVHYd6djKigZHagCNlB4Hem7CB2qTgHkGkOew+tMCLHPPagKCxyTUgUd+pqQLnPODQBWxg8GnqDnJ5p2zDdM4p+M8UCuIGxz0pSMnil27TyOlAx1zjFAXGEEHk8U8/5NKQCOOoFN5zmgQoxnpSBRntmnjgHuKRuMdjRYBrLlcA01l4/xqQccdvWkKk/SgREQQcDH5U1sEdamOQBkc0wgZyRzQBCynoDSBT9cdqnxkE4prLzxQBGAD2p30FIAeSe1OAx7UANx7mkIHQc1JjI9/emkYzkUARbOCe3vTduBxnipj7CkUEE5I5oAi9iKaVzVgqOtMYAAnPNAFcqR3qJgc9asNzz/ADqIpk5oAYmc5HTpTgpIINO24FKD1zQMAhAPOaFDYp4xg4xS57YoER44xmgrkDIqTbzSgcdKAIgvt+NKQQOADUmMN+FJzzzQAwjngcetIgIJNSHpjHNMUN2FNIBVBPJzTjngGhQRwTQFPJoGGOTjn8KaCAxz3p6g8gjmkC4OaAEA4Oc1GwB5PP0qUg9ODUR+9SsIruowTTAp64zVlyCcEYFMZQBkAGgCqyHBx14pyKetSHOee9LgEcnB9KAI9uCQBmmMmOSOKmGSeTxSgdQenagZAB1HGKXAOMetO8vg8ZFGCAAABQIbt/KjAAyetSbeoBFIB/OgBpHekK5B4qQDNG07SOntQBVZCT/SmADJBq0RgnjmmBQSc9aAKxXk9cUwqMdcVZdcjHSmFNo55pgViM5yeaa3TgVKV49zTdvPOKAIuhoJGDxT8HPAox170ARYB9eOaYU55NTAdjxTSvOSaBkTRnGM/hTCDk5AqxjjPNNZTjvzQBDggA9u9OC5HtTtpxzSE4HTpQA0gAcDp7U1lGCQaljAcHPGO3rUVzPHAVBzvYgAAZNIYiKcHNGCeOgqZADyQBTgBkZ6ntQBX2kDPWkHANWnj+tRMMZGCMUAd6cE4HAowARkHNHJ6cc804j9KCgA69hSY9KMknANOGQMc9aQCbQRkjmkA64qSkC8E80ANKjHeheM+tPHIxikHBwKAFPIwTzSFRnBz7U/b3Io25I4oENC5GPSk28cn8BUgXHQYNGPWgCPoOM0YOck8U9gCOf0oGMEHmmBHtBNAXFS8DPFNHegTAKCQQBinDaBjqaac4+XtTlCnJ9KBAE4J6UBODgVIMAEd6TpnIoAiZeeppQgAGe9PbHGeppduWB7DtQ0AgUAEgU04AwOlPPXB/CmMDkY5pCGZ4ORxQOeKeAOhpMDPFADSB6UvQcZzTuT16U0nGRmmgGEE5NN25GORU2Rj04phORkjmgYxsgGmHPBp4Ocg0ZBXnpTAYRxkdaRgQvrUg56U8qDgHtQBXXLA4HNOAJPIwelT7QDkdaGUEcmkIh2cEcZqLbg+nvVkpyCD9aa3XBXIoArsCAcGmYJBzVraO+aiZAc9cDmnYCHZwcimMg7VYcEA+lN+nSkBBjjnNMYY4BqwBkHrimbMEnNCAjXjj8SaN/JHan7Rg8YpoU7cAH60WAerZHIp3B6UxUwcZOKkx2oAQYOcE0nTjPJo6fWgZPJ6dKEAbDg04Lgd6VTjOc4p5FMZGq4JGOlH3fXPpTh0zk0HAYcdaQhrAkZIwabtPepG5OKjbPUGgB4BAqMgc5xRvznOQRTN2evT3pAIyZzn8KjZcDGeKl3ZHB6d6aeMUARKmOtMK4zUx4zj600LnnOaYDFXngUEc96mGADxTCM8nigCHncQOlBzgU9AASWz7UpznNCAjI4yKXB9OKcAQDmkC5GcUxiLjnI/Cndvem9Tz60obGR2pCEKjkjFMZBnj9Kf246U0MDnNADNgCnJ5qOQYAHrUnUn2prckYoAgI9RUZBPvUzLg8n8KbsGSefpTAh56UmPTpUxHsKTbkcUARbcjFMZB71MRxgZHvSHOCMk0ARAZxQwzn0p44HINN/A4oAZtA96jdc9sVPge9Jjk+hoAqMrop25z2AqCG1cOZJG3SH9K0yhI4pAhXk4PegZFtIXHTI5pyLjryfSpgMg00DnJ70hjPY8U1lDA44qUqDmoySOgzihCud3jngcUrDAwKeOR70H3pFjAMde1BBIOKdgnPNIFHvQICpHekUZ608HA55pM/SgAIAxkcUuAeaXp1pACcn9KAGnIGBzS+nHGKUZPGBn1pxAPBHFAXGdRnNNBxz+lSFeuQc+lNC5BJ4piuHGM9qbjOeacV7UgxjAoC4vGMDk0zPA55p4BFAVSSDQIaO+Dmnrnb70gUCnLnBpCGgHqKcxPSlIPbpR0HI+tO4xpGDz+FGScgHApx5B+lNGMHii4gPJGe3FOUg5GeaYOeMc0oX86QC4x1oPA96auRnNKcjj1oAViCKjIBB7GgnjpQTx0NVYYxs8UNk8U49O9IBk0AM2jByaTHHFSbcjOKawOOOtADQMHHOBTgxzTRweacB6CgCQsD0pRyOM1GFwOak6YApAIeB14pp5zin8HrzScYxzQIjYetN74xU5Hy9qbgAc0DITn0GKYFGCDx3qxj0xTGGSeaYFZhjgZoVfXpUxjwfakVVz0oAiAGSDRjnAHFTBRu4HPvQV60AQkEDp37U3aSc9RU5Bx1FIU446UhEJTJPX1pdhxgdKkPTBo28cdKAI1Qn2p4zyAaApHekA5OOtADscAUijk56ilPb1pdvIJoAifOSe1RseKmkABx2ph4P9aAIjzTHzkntUmeTTW79qAG8Y+tNJzTxjrTWFIBM44yT2pOBQScc9aQcZxTAkQhgQMGmbCHznI9KEG0nHAqVBnrnFAEZUZ6UFQBUzYwMCjaDSAg2g+9BXAwe9S7Rk4FG0HIxQBCFXBz0prAKak244xxSSJkEgUwIDnOM01u/apgvcgk01+fT6UARDg+uaUgY9KcoPanMuAKAISp/+vTGAqfj8aaRknuKAIFXJ9aGTBNTBcZI60MBtzQBW2n3pCM1MoJ5GMU0qcnnn2oAgZQBzyaTbweuam2+tMIJBwOlMCPGBkZzTSMHJOKmCk+1NZd2c9aAGbuBg0nJ6in7eORnFN6Hj0oBBg4ODTDycZxS7jnGRRjuOtAABgcjj3ppTPNO5I55FHI4oA7tRz9DSn6UvGPel2kDPTNSWMHc0A+tPKjGRjPSmnpz1oARsnpSYyDTh069aXAwTxQAwNnjHIpTkY4xmlHGcd6TlgT3oFcUnatIclupA9KdwBzTSB1yRmgQ4Ecgc/Wl28YJ4oUAj5T+dJhtvWmgGkjJAFGBjPenBCKRs4OO1ACBTg45pP4TSp054pOnTFMAA755pV7jvRkEHHSlxgcc96TEO6e9NLZ4AoHTJ6elBBPTpSAQdKbgmnk4B24zTCTk8UAIc5BHNPByeaTJ29uaQH1oAXPr3oPWjseOaM57UARhsE4pwPqKBS4OM5/KqGJgnrScenNO7ZNJnigBD0pBg/4UvHakAyfpQA0jn60L0I7CnMvHNNIFAASKVcEcnmkGBmlXBBLUgFHsaBz260Kc8EfSlB2jA5oEAJGc5pp5Bp+cjGMUDjjjmhANAppBHQ1Ifu80zr60AIQMc/nSBQRxTwPXmkBBJxQAzb6dRSbeKee9IMkYoAYMDIHNHanHk5HUUgXnOOKAEx6g0jdCOlPNIFzkCgBiqRzS4AJ4FPHH0oAz60AMPIxjmjnB5zTgv480jYB4FADGGeMVCy7eDVg9MjionGRx1oAizim4znNSleDimEc4pAR4PWkxwafkjIFNByDnqaAGAYHak59KkA5PrSHr05oAY33SKEJAxn8aDzmgcDpTEOGfXNPJ4461FSgjJ4oBEyg4OetNMZ6g4FNBKkjORUgbI9KQyMqR1p2OD607OR6gUcH0FAEO09DzTHQsRjHXmp8cknFMZcjigCIKAaVhyc9KdwO2SKRsk8CmBDsOTSOuKnwfamtkk8Y4oAh6A5FM7YzT9vrTSBt96dgG8fQCmnkZFO6DFJg/nSAaBwSaRhzx0p2cDpmlbGPp2oAjPBJPSmjqakyCCcfjTMf5FADMZFNKjJJGalA9KY/OT2oEQ4JJwKBnOafjr1ph60xg3Tim5zye1LxjJ60gx360Ad8AuCR+tBycEdDQmKCDnrSKHgcUhAJwacnPvT+OmKQrkQjwCaRQcEmp12jg9/WmhQAQMUBcaoyMYxTWTByOKmxtHTmk5JOaYFcK2cE5pfL55OfxqzjcKYQRz2osAxRg88CmtjqOvpTyOe1MI68U0gEJ5AoPp60oUkdqbtI60ABBAIP4UzByQeBUkmWGD+dNPIAPWkA0nBGOlAanHOOKauCcE0wDdu4p24kYGKaRn7vamKCCQMkUWAf1GBSUYGMmgtz26UCsO3YB7imZ5z2pg6kkmlbApWAeT6dKAQcgZzTcg49Kazbc5BPPakBKB+VKR+VR78jA60oY0APYelN6DrzS5GOTzUZbOT2FNDQoyOgpR1600SqSQc08AepouIQ4OKRvSpKYxyaYxgGSRRt7DinDj6ilGS1FwDueaUck00k5xjpTucZqRCgALzQQMZ4xTc54oBzkA00A7GRnsKZg84NPAIXvSEcYxQA1iFU7sYoA9qZLCk8eyVcqCCB7g1MAQvOMUARtmkPFSYHU00g85PFAEYzj607PXFJjJzR1PFACE04cHOOaOlL60ANPXgdaUY5zSgcUhH09qAD6dPWmtnJHWndBR+tAELdcUh54qVl4qIDnOOlADRgg5qIjrUrU0r+IoAjIzxTCufrUwXBPbNMZT1FADOh5pAPSnknnpTQeuc0ANbjpzTcH0qTt9aTknjHFAmMCnGfehvfrTmzzzTTk9e1CEITTckng4NPAHJJ4pMZORigoUkg4BBp3J4PWmgYOTT0UE5yaADI4zQ2McGnEDBxTQvekA0KMcdc804jBpM4PqRTmJOCelAEYOQBQQCMindc4FIehxjNMCLA56nNRMDngZFTMD3NNPC0wIiPxqNuB71MByc9qacEjg4pAQLycUrHtjmnsMZxSDucUAQ8k0nQHPU9KeMZwaTBxn+VMBmTjpxSE5FP5GB+lIwwc9R2pCI24HApoHt19KkBBGeeaABjjPNMCIL/+qjoamIyelNI5wPzoA7cYAIApwx1JxTTxnFIPm65pFEynjI5FAPJzkGmgEDAxinKfWgBV68HOaeFwc59zUedp4HFPHP0oAUnOQD+NITSEDtTVGQcnp2oAf0I9KCR0NNBIPNLjI4oATjJ9KUDPShBk0oHY8CgBpG3rTSM/WpCo9aTHf0oArl+oApQox71LjJPTNNZc0hEfUnnmmOmAf51KF+YcmkcZyKpDRGBgcc0jdM4NPA2tzS5BBx1oAiw2eKCO+OakA74+tIwFAEeeM+lNJz6ZqbHX0qMqB6GgBgHtSmMlcHkVKF/E0rJkc8mgCAg4pGJHbJFSAYJyfalbGcUhEWTjJ60ozg5/KlZQQQw5ppGeKAGso54GfanIDt9KUr09qjIIbIPFAEhOMDNAJJOcYFRAkMT1p5OfrQBKretKCO3WogCD7U5R7UgJBgknilAycCm4UA4pUJyKAAjGaVVH40pOOaFPHGaoYA9qAM07A696axyOKQg43dDShQepNJyBSscEg0AI3fFRjI6kYqRuaaehz0oAaMHkdO9IQByKUHqB0pVwcg0ANAJxilCn0xR0bjpTgc9DzQA0elGOOacfryKQcEk96AGDoc0mTkgY+tPbgVHgmgBeh5zTNvvx3p/QdKQr74oAiZemDxTWHB4p56kHpTTg8UANBz1xTTyOMZp+0cnNIcA0AR465NNC4BxwPepcA59KYwwOO/rQAzHXFNxjp1p2PlyetJ1NArCjnjHHrUY+VsnvUoBC4puMDBpiGsBx6U0DAOOfanPyBjrSZO08UhoVTnORzTlPHFMAwM560qHGRxj1oGKMnPJFNII6UoYdKaTk55NADgeMAUmTyOtAOAcUYOc0AGdvQUnB5z+FKDnqeaQge9AmMbjp+FIFPQ8mlPXkdKOTn+tMExDxmm7Qc4IJpzDnnpSAYJHrSGRkY645pNuciidTIAqtg55NPJ+XjjAoAiKgdhmm9c8U7vnPNKcEHBoAiKgjJPNNKk/Wn454oXIJAOaAGBQBg9KAoBNTptIOR1NIVxwCKAIcZ64zTCuQQOpqdl5yBxTCoOfUcUAdjjBIo46jFOwcg0gAz0oRVgGe/SnqME56UgwaCDjg0CHj8acAAOcVACR9KmB49c0IAPf0po4PuaXIPfmg43CgBnU+9PA4xSDr7UowT15oAQHr1FKCTz2peCc8UmM98UAP6r70gBA9qb93kc0Bz2pCDbjNMOc/WnE5JJpH5Ix2oAM7ccZNN54OKd0GaGGQSOtNDRG3PXpSAHHHSgZC896cgzmmAw56ninBcjrmlIxnNCrgc/nQAm3aORmkVQTyKeSF60gznNIBg6nigjJ4p4HHNJt9+KYDAo5LU0rnnpUh75puRuOeQKGAxlz2qPack9qmb5jkU1l3E4pWERk4U/0pmFIyQamCkN81M5bpSAaoU4x096UcE8cUmCppQSM55oAUdOKF9zSAnNCg5NADgcn1pwx1P5U1QB0608LxzTQIX7wOaFOM5P0oAwSBSbcdaYxwbn9KYTjg9acOmcCmNktxSES0gJJ5HHWmbjjGcH2p4OASetAAeBgc00jIAoLZPSlAPQUANA4PenAccUYPAqQgAcUARhQRzzTMDdx2qQjAPFMPJI4oATOM/nQCM5o6ZzSHGDQA4jJGKb0yOlGSBkU4kEdKAGZwDimYzz3qULgEjmmdie4oAjIGTjrTSpz/AFp+c01hnHagBoJwc0hBxnNKwOODxTdpJ5oAQYOcUh5z6ihuCBShQB1zQIYMbSMc00DHWnsOc0mMdKBjOR1pCcnpxS9TjNGOvrQJiYOOaQ8A55pWAAHek6jntTENB45oyOgycU76U3ocYoC40cEkDilGCc5pTxgUmOCaB3F6ZoySOtIOnNKOBSC4hJFJye4pxII+tNzj60xADk4NJ69+aU4PcUijk0AJjn2po6k9Kk4II701uMnrQAmBmkOM0v6cUhHNIdyMgZGKCOuOtOHA5FNxwcUwuMxg9KTHJwBTyeR3pM4pAKCOnSg/WmDjOacrDGD0oAG9D0pjAeuT6U4sCOB0pOoBFCGdWkmeCMfWpO4NRLyBkU8DHekUSdenSlzkZFRgYU4J60+POT6UxBkUZ9Ka2M04AcmgAJ68UpAYZPGKDgUwnJwOnpQA5VOevWl2kHrTWHQqRxS7sEE9MUAIGYk5xjtTQ+W2g4PpSOe6jNMCoZMlTn1oAsrjBAIzilVccHvTVUKMjtTlYHnB4pCIEmVnZMcg45qTOD160xoVEjSAHcfenKMnnjFAD9oIFMGM4B4HanNkg4PPamxqR8z4zTGKFGOaCMD/AAp/Y0wc4IpgBGQfWm528VJ6460nbpSAaBlc0gANP6nmkJAbHY0hDCSKOvejOWPagfhVIY0ctyePSgqAcj8qdxnOOaTuTQAh4BOBimdTnvUmeCKauA2OxpAJt3A8nNM2kdeKlyAeaazryDSERhc5yc01uuKeB+tISBwaAIwMgilzxgdaM88HinqoPI5oAIx69qk5HSmxqBmnj2poBM/lTWBJGOlPNKcnp2pjGop70bMgkZxTs8HBoVtoHPNAERiJJAPFKIyB1zUqgkknvSkZHFIREqEHmlXO48UvIbnpTloAaMnqe9OwAKTIGTSgEqc0AIRnmo+RTwcUMARjNAEe7JORTGOTjFPJG4gjpTQo3H86ADBFLjilOMUZx1oAbyOe1IwBHBpwcNkU096AG7duc0xxz7VI+NpqFjhSTQAEcU0ng4pQwZeab1PBFAhqjjJpeCOKG4HH40gx2oBCNgYpuecAc0px1NM9cHmgYdCM0ZGeTUW4qDuPJNRbiWJXJIpiZO33TTMkEAjrTDI2DgUKWbBJ6UCsPlcqQFAI71G8ndeaGByTg4POaaMdcUAIHYjjkilBYdQTTdx7cU5WbJORigCUKSvGeKQg+tAnXvxTlIJyG4oAbtOMGkIwDjIqUjj+VJjA5oArjgjOR/WlZ8EAdDRIOT6VAzbRjgmgCZpAAcikWQE4JIqMHjkdaUEEgY5oAm4z14xR368VAzAHFIrFSedw9KALG3AJpMDbx0piyKR7+lKHUg4z70AJj0pSMDkA05P0ozk0BcjAxyaCAetOPPHYGkGCeKAuJt4zTQQeOfoKkIB71GcjGOtA7nTI27sR6VKvC8nNQRSoRtX7wHNSg8EkUiiUHigkZJGai/OnK2PlJ57UAPyTnpxSB/mxz0oGSCTSMNoJxnHpQA4sMdKjXgnJyO1RjLOAwIB7VNtIwOCOlAC5J5HSlAEiFWGKXJBAAzQGPOQc0ACgIAABinOOMAZNKhz2wR2NSZCgcZpCGMFXAY7c9KULluvFSEDvgn3qON90jKAQBxmgAwT0IxTNmWPHFPKjJwTnrxQwBxyaaAaUIzg0KhB+Y5qQE+vFRs5HXFAwpNpHQ05WUj0xQCMnHOKYCYIHI5pQQRxinYyeetMZMdKTEGM9MYpMBT3NAXHBNAwvXtSARlzyKbtzwRjFPDA5xTWJpjEGAKTHymnLzwetB5XPSmAwA5wTTHU4yKeTzkd6PbFICIZ2kimYPcdKn+6OlDhWUnuKQiDNNyWJzUuVHWo846ZoAUYAwaVSFPA600nPGaWgBynGc1IGB9KhzgcYJpyuAOlAEvHagZxnOBUQkzj1pyuccjmquMcfwoC5bmkDim7tpyORRcCyowO2DQxBUgVXEh7kH2pTJuY4OBRcBxBJ5pGJA4FMyexJp287ecc0ACdOaf2zg1EzAA9zSqSq9eaQh5IJ460wk5wKCvPB5oC45JBoCwgOeopwA60DHXnmmhhjFACkDvUcpG3IqQAHvTWAHHHNAEIbuCacDxk01l2kAHimsSPcUASHBGRUbjAoUjbzTJG4wKAI3UnpgHpSAEdMVJSdQcDFADcnHP5UEcgikA5IznNO6ZoAjcE9OAKjZgFHHNTMwBx1NQyELyOtAEDu3G7GDTA2GY568Ukjc801gT070wHcg8GnhgAT3qNSVGMZp+Pl5HJ70AKCSOc49aYxxwOlPYFkxkimbefbpSAZ9aAO1OA45oC0ybCKo3c/lU428cGoeh4p4IHIoAsdelRyNzgUiyAg5NICOSaAGyHA96rlTuPFWWdSMGmEr260ARHPamDIOFH51NtzyOlNYBf/AK1ADe/Pp2pVxgk8fWlVWIzmlC4zmgCPHIHWlc9VU0jghhjpSlM8jtQAsLsMhuRUuQecio1BI4FIAehzQA9zwMGgqRgjmozlTgKSKeWIAJGB70AOLAA5zzTeCR7dKaWDd/akHTr3oA3Ydocbep5Oauq4bjHNU40JYnjjpU+7G3B5FIsnOBx39KYqfeZuMdDQSNuTyT6VJbxuqnzCMdhQAillGTgj070oDMRtOAfWnKAWODxTwwztA5oATYPoRUYYrwBk9easLgvz0okUEcgZ9aAIhkD3qRFAPPWmqrDOeh709MsSCOB0NAClRye9Kp45o5JHWnL16UgGEEnJ6YppBPQ8e1SdRgU3GBgdB7UIBvCsQG+brTgR09KFUZ3HrRweaBDJCc4FIASPm6indT0pGB7cU0CDbx9aApHQ80f0pVODz+tAxqls884pzZJ5PFBPXGKa2DwTkmkxA3JJzSjBOKTb1wcGl2kNnPFACH9Kb7kihl9TTCu0jPSmMcx7gZPtR1Gc9RTYyC23gHsKftAGTQBHyMDFOQ56g5o7jHNAPqOlCAHXuAcVEVyOM5qTdjpQGA420hEJjYdBRtJzxyKmbB7GhVINAFcKScEcUhB3YHSpmUnIFRMrD0JoAF2qDntSA8njg0hHP9KcowOaAAEL0pdxPJFN6nB6U4A/hQAgY5Py/ShsnpmlPPHahOQeaAG5x9aUnBOKCuOeKHAOCetAEingetBHtxSIwwOMU/AIoAYFwc85o3cnIPSnlgOKibB6daaYCnjBBo3cYJ5FRnI6HmgdD39KYyQPx70gbj2qPgnnmlB+bBpASKwJpHAJyOooGO/FGAT1/WgQ1l3Nk8YqNgBnFPI5OM4prgkGgBjFSOlMYqvPJFK4xyTTccHNABgHkcik5IIHFLnA6U3k85pANAYDg04kBcmms2M7eTTHO4ZJ470wIXfJ4PFROzEY6VMyrt65FMK7jgYzQBAORg9KXPzAYpzIynPFBAB45NMBwUAZPBp6qD71F8xBPb3pyscdOM9aAHtHnGCRg5oWMtyBxRyenH0qTOFGSOKQEITLMCQBQVIzjkVJnLZA/GmlscYzQBGQByTz3xTQVPGalGw5yMUgRQTgfnTJETaCRxmnlRjJHAoVQTkgbqfznkDFAELDIyBTApCsMDNSsQO/BpvQ8c0AMUHjI4p3GTkUuR3oXBJzQAm3HIPFKMe2KftUDGKRsbeB1oAjKA9aYwIyMcCphyeaRsZIoAYCdvHAoAIJz0pcHHtTwB26UARk5OAMUjqWwDTypxx1zQfu89e1AEDJjpwfSlVeOakzSHGCcZ9qAN8DBPH41LGin8KceaB1yaRZIABg4HFS5DflULDjFG4KOAc0hEoCg+n0pGRWB+9SIT1bpTieSAfyoASNCqjcxZhT2HHFRu+OAMmlUlhyeetMY8Hj5qFfadvrTSvUZOKbuwcAZ96AJhnHvTuvPao0OeSadjggUgG5yc9qcWAWmBSMnr2oUFhyOlMADFvTFIMEnn6UuNqnIzTA2c8YAoAkA56008k+1G7jrimHk+1IQBdufc5oY4IyOPWkLYPtSA5OCO1MYpJyec0AnmmgnJ9KBz2xQBKDk4PPenqOOajAx0PFPRjuwaQiMsQxXaacpypDClbnrQAe54pjG4AOccikIJ5JwKeR36etJ15AoAawAGcZNNHsMVNjIOetMbpgDikIjPTjrSqeDnqDS8Y7UwHrnpQOwoYnNJzzSj1zRnJzxQIAMnvTGK9Mc1KPukdqiIwxx0oAaEGCx603JIqUng8HFR4zyOlADXPTihScYxR1bA6UBPm55A6UAKlOA49KULjPfFAOR70AN5JNNIPSlxxTjkjIoAaRgc0A4HfFOIqM4HGKAH9+vFISOc0i9DimnnFABgEUoXGcd6Qjjg0L8oOetACEHIo3AH3pep5pG60AKGJHHFCg5yTzTckDkUoPfpVXGOJOSaY2e3NOLD1pAMdKkRHtbvSMuWqQZ5yKaVyTg4xxQAzBAPQCo39uKGzyM5IpnzFcN+dACbR2bmmyKQPWgkZpc+vQ9eKAGcEfQUm09e9SBQOVPBpjhiQR2oAayMy5JApojIPPWpCcjDZHanEEKCOg70AQmPgDn3qWKMAYxwKMgjBYCn5wowRmmAixqMjvTWjBbrxT2b5ckUcEccGgQwIuMA0wooOC3NWFVfy70wqrEjuKAKuApI549akRxjABJp21GJBOT7U2NQrHLcU0IkK9wvNKoPVhgUM6E4LYNOBU9Dk0ARhASSRxTGHbFWDwMmo+Oe1AFdlJPakAwSpxzUzDiomyTk9qYAAV6kmnAZB9aapJODz70pO0HqRQA8KMHrxSFcnk0igjnnHpTsnPApAJs4wOlKYG9achJ5JOKlBJoAquCox70xslcY5q20YbOR+NR+QQOvNAEGwnrik2HcAv41MkRz1PvUhQAdM0wNsnjpigcEEmo8jcwPYUqr3BqSyUsMcUIw74JphPFKpGRxxQxE3JFIvDelJuGDg00Ek5zSAeRweeaevI4wKjXO6nbWPIHFMY4pkdTTcYGBk0+NGwxOc9qljQ5yRQAxAQoIHH0p4JbBp4BJxjilC8nBpARkcjjFRvuQ4HAqwRgc1FPxjvQBGxO3npTMcccCnYyKax9D7UwDg/hTTjBHOKcucmmkHNAADgfhTQcH1pwBJ5FIyFhjn60AKqjHXHpSkZHFJtIUA54pRn86AFB5xTtvORwaQRk85py56EcUAOwSO3vTsDYfanKvJNG0qOtICErgcnrQBkbQcU91zjnmmBc5zmmAm3B4oYcc07ABIFMABz14oAjwO55pCATjrS5x9KB0PH0oAaBilA7ChmwQOCaikckgqeh5oAmI4woxSY6+tQeY3OCDThIe55oAeeMg8UY65pmck9zQuRnJyKQgRck9QKfgfwj8abnGfSlDYB9KAFb5hjp70LHgnBzQBzUi/dOaAGFR2/GmlPQdanTaO31pQARwKAK4XHWk2n/wCtU7R85JGaFTBJ4oArhSM8UhXjpVhsA9uKYDkGgCEcL0pFw3UU7ILHsKQ8Nx0FACFe46CmsOMinZ7UnbAOaAGkHr2pvWnEnv0pp4IHQGgBwwRz1pA35UgzmmMCenFAC+cCxUKc0BzyNppCFU54zRvzmgBHBC5x9cVDIxK5PAPSrIYEd6Y6g8UAUn3ZzTWLHOCauGMFTk1XaM4yv40ARxOwDAnNI0pwRipQh4Kjn1qKVWC7mXHNMBpJPG7FIpYKVJJoCnHfmkZWB68UASJjcTTwRnp1qGNWzwKcCSSO49KALCEkkY+UUrDv0qJc7QMkU9V3EjrQA7zMnIoyWGQODS7BjHTFKq4HTHNBIzy1AJUc1EYyOTVllIOR0oUFhyMCmBTJAA479amhbbnKjmpCgzyMCmsqhuhNCAVvmJxxSbOx6Uuep6U3dkY70AI6jsajZSB1pyMAD6+9MdyAeeKYDUPvkipASQRVZieTyPpSLI2cCkBYyNuMGnLyaiVsDn1qUAYzmmA5cYwetOGVGc01CDn0p4+YetAAGwcHnNOGScUm3pT1AzxQAgUE+lBTJxmnkdMdaaQxPBFAGgYTuOc49aYZCrbQRxVxgeoOag8oMfmUgZpFjY2BBZuacpy3AwKPs4HJYhR2p+0dj+lJgIVGeOaTGGzz9Kk4PUYoyAM0AOiy5LMAo9BT88fLTEJJ5707bznpQBNExYc9alAIAA7VVTIblsVYLejAUgHA4PXikLAH1puzcMlqcigDrmgBSRjnkVG6ByDUnA6/hTHYdBQBAQQMAfjTMEZHFTuCRkGogKYApHQUEc/WhB94t0pxAIoAao554pw6dTSDI6CnDlcUANPPPalUc560BGxnilQkZ3Yx7UASBQenWnqowc00cU5sA9c0gFAGO1NY4JNCsOQCCaA67iCfwNACHJGaZncDipiAehx7UzywuRnrQBAARSsRnB607O04NRsM5yaYCNgA8VCWOPlXJqRmG3GM00HA460AV/m5J4z60wBhnJGKsSEsMYpnlDbzQBGFDHIIP0pcHPXmpVCpjgD6Cl+XB9qAIwMGnMtOxkfypFJHDUAMHydAaUtuAA60dWOc80oXDZoAfGMDnvSr1IFMBOOTSh9vTkUATKvXcc0IRuwagL7s80u7C+lAFgAYyDnmonBBPXFROxADDOB6UGU4wOlADmPXvTBIBkAHmjdlc4pp5PXFADtuclT0oIOOfSnLkJ7005HWkIaSeeOKQcE560854xzSMu7tQBGeDikIOOlSIAo56+9KQGBoAjHIJpgUlutS8LnGaDgjJzigCJlyD0xSRDcRkcVIqqwODipBGqqAKAGbMg7cU0R5XrUwBHahgAMU7AVnTnFJtUDirRUNyajePqBSAqvweBxTGj3Dk8VZaMDGTTMYzimgKTIVzzx0ApB831qzIhIximRxgHPrQBHsII7UoQDOSM1MR1xTMgHDcUARFjnHagMQM55zUmATgCo5xjgdByaLCYeYdw70qzMMZIwaQJhM+tIIj1I+lMViyDjGO9PJ98Co13A8/lUgx6ikAjkFc0wdac3CnNJtOMmgBAc8GkK857D0pWGBwfzprZGRmmBG5+XCrULA45AxUuDk89aY3Ax3pgR8nIxSEKE461KMDHaneWMHaOvekBEqbhnqakCgHBPJ96VdqKR0NC4LZI5FMB4wvHY1IFA5Bpi/NjIwRUqbcYNBLAkYxTuowMfWlB9BxSbcDjNAB0HJpDx0oIyMUpOTQNG2qjljzTWGSMYx3p7AjOOKgZhuwpyPXrUmg9h2FNzgkHGaF+7nj86QKS2TQAoIwSelIMY46U7nBxwaaUzwSR9KAH54wBSkcDmmhcDGfpmn5OO1ACp17Ypcjn+tIuOvNKcYyT14oAVHxye/pT/M44FM288inxqCSM8UgAPu+9xSEkKWIye1OYKoyDUbNuU4OD7UANZwuCevtSg9CveoVUKDnk1JEwAIY0BYV8lcAUAcDmpMcVFkBuDmgdhTnnmmpyMigsAQKQOFTG3FAJDhjp2pT6GmCTdwDTsEDOc0xjlYjjtT3YFcDvUStlTxS44680hBwg4POe1DHdjPJ9RTggPBFNYENgYApiHByDtA/GhpMnHekb8KbtOfrSAazkjjio8kn5mwPQVLIpIwtR7D1zk0DsICCMjkfSnY5pwwFpOlAWGMDyKQc5yenpTye2KYevHSgLCMO4pAc9elGaaWAByevegViToTg8UDp2qu0iqpOc+1VjdyYJ+zuABxyKYWLrtktjtTc8e9QwTq77ehPY9asrtx/WgdhgY5pHJOQM809hhC2c1GuckjrQKw5UCpk05QCODUauChB6UwzIAfmH0oAmJBX7wFCFQuMhs9/WqizoSVbJ9gM1KHTGcYH0oAkHIIpNpBPeoWuEVcL81PSYmMbsD1oAlGSKR5URPmI/xqNJHnDeUMRYxu7n6UiRqD7dyeTQAgulIO2ORh6hak8wtgbGGfWpB8uRngdqaT3AzQA5SCOeMUnc80NhxwOaEG3ljg0hDXDMeuBSFNy4OTipgQRwc0wKRk9c0AIo2DIIp6nPTimlSDQMqmaEBICQCOtM5JzilU5PFBc5+WqGAGRx1pOmfShjhuemKY7E1IgccEjFQLnPNPO7aR60wKeOeaaAU8gd6YwHNPXqQaXAbp2oAhCkg4zQyD+LpUhJDfN09qCQzcc4oAZwMKB+NKyK6n34zU0Yzkdak2gLkAUAZ2CG2g5AqYZBAxxUrIobIAFJgngYGaAI9ucmgKBxinFWUHJzSLuIFAmA5B9RSZ+Ug9aUHacbSc0jnknbzQIQgYqJxnOPxqbtluKYcbSB3pgVmwB71FnPfmpeDkCowPUUwAH07cU9TlevIppAOMClCEZIxSAUfM2T2p55xg81Eg5xmpQV6E800BIgAOc807kEkCmISTkdKkA3cdKCbC5yOODSjI96NoA/SnDHT8KBiYByRTcc5zk088dKT6UIEbKng7m3HFRxQgIBgYzUlxHuTCHDdjTII2ijG5ictznmpNBHhOcA8UzaVUgnLVYn3bl2kAdx6imBGbJ7+tADVzty3Bpy5ZSSAKTaQeeRU4xt4oAiIOQeop5yVxjml6DJxilGAwIoAYoIBz3pxGcAjODUxxg4FAXAzgUAMAwCaOQcDqacrFgc0pzj6UgGtgjnk0wIOfXFDrhTnOetQbm3ZAOKBodjJPGMUm4NwBjFODkjJH4U9U3L8y7aBjCTt4pgbBPBzTwGDYwSBTsoTyooAYjBnwevpT5VDZyOnpUbON3yqR7012JYbc88UAKyqpAUYqQFc4JqN9+08DPbmkVGLfN3FAE+Bjg0pK9hzSRqNho5B56UAPUHHJpQq5ycUwsc8YxTj82MUANbbg4600cfx1JgEY4IphXFACHIY+lRSMQwwOtWGXiq7oS+PTmgBMnn270h5wacwwODx700cqDmgBhYgnPSkHApsjjd1oJAGWNACbtoyahw0r7nO1R0HrUilSpdyCOwqMTAoWZWAJOOKYh+0KeMYPrUckgHHUjtVee5QqxBwB/Ee1YsepzfJGoUyytuBYcKg70DLuoysse8MqOOFx1qW3u3eMLKwDDGQK525uVTU0E8uUHJb1HtT73V4N4NqpIXjcT1osB1a3DYLPnavI9qrm8M07rBjbjBJrk7jW7iQsWbYMYKr0xVJNamAKpIQvpjr9TRYDvF+ZwruVVRnHQfjUVzeW0TBfOjXnqSK4aOeW5J82csrHgFsDFaUa22xfMkiVT1IxmiwHQR6jb4ISZfUkHqKfDq0Ux8m0UMQfmdgcD2Fc+dQsY1Cw4I6FsdqvWerWUcJVQ6rnJKp1piNCecAHM6bT3VcfzplkI7mcxiaQxJzIwbqT0X+prO1XVbNbUNFIs0rfdUHnPbNXrBrW3tokEsQYjc2GH3j1zSCxr7GXiGQgA9CP0qaN+Qsij8KrW80ATmZTz1DA1fVF2tjDL6igQ/5CAMA0gC5wBTEGB83A7VLgk8dKAEC8Z4prKBk9c088cAE0uRnpQBEE4HFOA4x3p5x1NRu4RSQCTQAEcZzzT0QbcGmx5IywqUuFA4pCIWAUED9Kb06ZqRiucjmjAzkincCMqcnPSmMuRkHFStgjjpTUUDNICIcZBGaawLMMHipWB3egprKSAKAI8YPHJoCHdnoKccAgc808DHc49aaAibDAggCmKoUYx170/azEkYKjoaCjdx+NACoc528VIOuc5qLG3O0ZYjGKcoxznmgB2zimkEYxin5yOOtNboc4zQBGTzxQhJBxil2gLShGHIHSgTGlSCAfzpwUHgjBp5wBk0mM9uaBEbKcEcGoGQg46VaI9e9RupPAxTArlABlhn2FQyIOozVt4j1z9RURRscjigCsuMkHilPHAp7Rlm96Gj6dzTsBGByT0HpTxtxxS7P/AK9OCqegoAdEuAR1qRQcfd4phwFwtOWQjjGPegB44520KpPIpFORz+lO3eg5oACNuc8k00cA0uSTg/WggY96YG9jPoeaevHBHenBSCelIDzWZYjIpHzDOO9ROpwSp/KrL8Lk8VGqg/MDnNAEI27SDnNOXbnOeKlYBScjA9abtHagBrLxQi5yTTiMc0N0A7UAA4XAoXK4BHWgqR05pxIOOeaB2EbAJoGRwaQE7skdacWXGSCaAEZSwZTUEgKoVUbm/Kpi3G7Jz2FKT8uQOaARAsZ2rmg5LgAkAdcCpfmb+GnqNucigZGQVXg5z3oVRknINOyS3AOPpTJQFUkfeoGMLJzgY9qjZN2CrYB7VIF+TOOf50IdxJYYoAYFZlOCCPSm7GQkk7j6VNGGUkY4NS7OenPY0ARICBk9x0p6KrAhicipAvOCTkUFQMdjQA3ysAgCkIKpjv6VIMkU1l7nrQAxe+c0hBI45FOcYBNKoCqP1oAYz4JFQoGbex6E8Gn3LFUyB8xOM1Q1jUo9N04yPzI3yxoOrNQBYmdEUhyN3YVn/bWklZbdcov33bhVPp7mues5Z9SuvOvJGgtgDznkn0FXbi/t7fMEIEcIGcseo9aYjT81IF3klyeWY1Xa7Ev3TtU9z1Nc3PrSzvu5KL8qqOhHrWde6yUK/MFbGcA5osFzrp9Ts7eJ1ZyXxwPeudvfEcgJSFtqj7uT+tcxfalJcvnO0eorOaY8/MSfXNOwrnTT6vOYinm5VvvD1rOm1GTcWR2DEYzWN5jnvTgW2lugHanYC8Ll95YnPGMmg3JUHDYJqiZiDjtSLIpfJGaBF5ZzIjqSWyPzqJXYggYHrTIJCJuQACMVC0uGYE8ZoAuocKCGNLJIWXhmwKz/ADsEYyR6U9bgkkYzQBoQuNhPmEEjjjNWYJguFcuyHrzisiOYqcsuM1YEzBTjvQBrQS2g1SIiNTCoJO4e1dFp6afcFmRYlAPzI4GT+NcKJiHJOCfatCyvfJGcqO+D3pDPQ00+wk2qsSZYcbRjH5VLDaPafLaTOEzko3zCuNsNejDZl+QA4AHJrqbDWLe4VgZ03f0pDL0N82/ZcqQc8MOhq9DcIxO0gVW/dOF2FW+lV2iZX3oxGO3agk1TLwcc+9Jv3EnFQW0ivHjGGqVflGB3oAkDccg0bxk56U3OM+tMI4PNAE+4c88YozkZFQZHvUiN1xmgB5IPUUp4GaYXA7c0Zz0NIQDBHNN+hxTyBzzigqFHqaAEU5HPWgLkcnNSBQB0zmnbcDigCAxg80oUBPWpSMg0hGFx60AMUArwOlMkLA4C5JpxBBOOlMBIzzQAgQg5NKUGBxxSb89O9ODgjBoAYv0p2QOMc0EhRzxmgEHnOaYDSo69KAcsR2FO7c0ACgBvTJpCSVOAKcSvQ0wgKeCaBMQkkc8Ud+TS9TmkHc0CAjj1prAbvajJAOCKjJpoBrKd/sKQ4z0/GlYY70ZxTAQKCD6U0x9cdafu4AApc+oFAEUZ4IIFOYHB9aXauc9KeVBAoArq2CRmpx8ozimBBkHPNOGR170CYDPXNKc7hjH40vQcEU0AHqcUCudKMqcE5B70q8mpCvPPSmnABIHT0qDUVl3DHbrTNgHI4PtTlIbofwozg80DQ3ryelM6k7elPbn6UikKSKB2EVPXrQydCKefu8VGrbkbJwc9qAsKvTFCgKpJ6+tNBC5+YHNRljg579KAJThjR2GBxTA2QQaQSYwM0BYlwh5xmgEhsHoaUYCnH6U37zD1oAkZhtOKYP8AepsmBwTzTFBB68UDJWIDConGSacwzihgAOeaAGbsgjFKgBpB91uOTT1yoOBQAq5OOKeD2IOajDEdutOB45zQA7+I4owCBSZFN6c5oAVsgfKaZls5NOyD0pqsxODxQAO21Bk9SKcdvOOaqzkoFLf3hS3U6wW0srMqqiFyT7UAUde1KGwtHnmb5V+VVB5Jrz59VfULp7i5yzgbYkB4QetU9c1W41K5VnJMZPyp6Z7mo0kisXJf5gBk49apIk031NrRFAVSRyqt2rBu9Qe4ndp3JBPIFV766e6naQ4XPAVegFVjtQHKgnrmmBZa4Z2+TcqDgVXDrlt3X19aiM5YHHFQs2RzkmgQ+V+TtGB2qEEc96UEetNzu4Cn8KYEqgDn8qa5Zjy34UKjFeM496cIWIP8NADdvGTyKeqpnjml8jkAmlCqp70gFDDcD0NRkAu2B3p5ZM5x0pDMoJzQBHvVWwV4+lOMygfKv6UGVO2CajaXnBAwaYDy245Ip5mUDpk+lMVgewpCob2pAOMhcHHy0mGGTuBoMe0cc03OBgjFMB678fManhd0I2uVx3zVYnBoDMD7UgNyx1m9tXVlld1XjazcV0+m+KEnUR3LBG7kjP61wcU+1CMgn3p0bgHIYg0WA9ZsLqOZh5cikH7oB61qxo7D5mwR2FeS6dqU1ueCCM5Bziuo0/xIUZd7lt2AwpWA7bYRyzcU10wOOarW17HcIGSRXPoDVjzAeAfzpAKqkipQAAT3FMHyrwaPMyMUANDBnOBzS9DTAwjz6nvTQd78cigCdX9acCD6VCo60nQkUAWScdeaXzPUc1Eh4607B7UhEh5HFKFOPeogWB96lRyeD1oAhclW2nNMcY6datsPUZIqCYKGAHU0AVwMEgUuCT7UpQ5JHIoTPTmmgQioSxLZ+lOx196XPXJpOo9qAFwCOc0jMEXGOaU9MU1lBGc80ANLDsOaac4ORTsEd6MsBgjNAAvT0FGBj3owSuCAKGyOnSmSRNnOP1o24HFObGOOopuSP6UANIPNITg89qeDkc03r9aAG7iOWpjOTnAwfcVIBn600/K2etMCRRleeTTGGOM8CnjpnPFBwc9aAIhyTijGSCe1Lt5yDSbSRQJjgQcgU09xmgHaeetKQCc5wKEKx1RJAzSFuPumnnpx0oPC81BqNjxyQMUowaZwpOD1pAcZOaBodjsaZxnH604EbcnB+lI5XGOmfSgY1nAGBUXAJIbr60jlV461ES27IFADyo6mnAdetMyzewp24gdfpQMMksR2pwC8DFNUndyaeFzzkYoAccgfKBinKQfY1EckjJ47U7dg8CgBWx6ZNJj5RTlBJ56mnleOlAEBYqmfU05AWUbsZp5Hy5K5FMDDeSOBigB4QEAYppVg5JzipVCnbzzjNKwBoAjUc5wacQOmKeikD5vypjA7sD9KAIz1460rcCgAAmmTHkAnHegBrMVwcDBoHXdnAqBZBI4ZjgDPBpWuELbR2oAbdtujKLwR3riPH2ryx20emx8O53SMD/D2FbetaylkGLHL9Ao615rql895dSzvksxzzzimgIo32kZOWHU1HNMZCwxjPWoy+05qHzNwbH51QrCkqg+9yKryMWJ20hYD3pBIvNAiVUCD5j+FRNjJwfwpXlB6CmrKnYDNAWECj+7zUqgKO1QliW4IFSRgZ5OaYWB39DUT3DH7pAqV1UjvTRAgBJGaB2IRI7dGOKVd54JNSqMcBKRs0DGohLcml2Lg5pPzpCpI4oFYeVTbgUwIm7LEnHamuCq9D9aYjc/NQIeZFzgA5ppncEgrRkA5p67T3ANADVl+oqVZM+9NYIw5xmm+SQMg4oETZU9aUjg9xUIJA+Y/SpInJBBFAEb8YIpRIQKkZ1x04qM85K0AThztyGx7VJHdOgANUt3cnJp24dSaQGzZarLC2Vcg57V0dh4ln2sswDHqGB5rhBKoHXmpkmwAVbmiwHpVr4lkzh4dyHrggEVtW+qW86bkJUY5DV5RDdyKPlPHetTTL7DncTt6nmlYLnpDzqygqwP0qaNwRgDFc3psllMrNFclG/iDNjH4GtBL1uUthvXOPOz8o/xpAa4bbyadnJyaq2qDaGZ2dj1J/wAKmVsknmgCYeo4p3PQdaiDN25qRCQMmgABYcd6kU5ANNHQ0gI28kAUAWVYE4J60FeQB+dVjKN+1SOKmifKndSEOCcn0pNqjIAodgpJpjSAHihARyL3FMjC5JJ4p7SA9ahYgng4HpTuBK4A+YfpQp74qNXOMcGnowxQBJgH2qNhh8Dpilz6Ug4+8aAEIyOvNNYnHNPCg85NDAYOTQBEw4yKaQcDFSleDio8HHXimKwoXtnmmsBnign0NR5YtjNAg55yaUcZHrQRxTSNy4J/KgBCcEZIpQPemYxx1qQZwcUwEPT3pobjHNKSoyMmm5xnHpQAYHPenA8HNMJJ4IpuR05oA7NCpyMZFIwPzfpSjuQKQg56cVBpYi2MSSetIqgkhulTMQO9R8DJ9+tAxBGFHBOKrsrBs7ufSppGOM1EBubLA8UDG9M9/emhlPGOakZN3C9KQIAcDigBgVnIUH5RUqxADipFUAHtQeuegoAiJwTuFAOARinEgZz+lOKg80ARqR1IphyxY5wBU4j5B5oCAEg9DQAkbbgeac2WA2mhYwudvNIoxQA1euCc0jphXIPank4HvTJQVQtgkYoCw6L2P1p28E8cgVDwgYk4DHrUuFVTtH40BYeZCMEDijzU5zxULEBOvPvVaacRqWcHHTIFA0izcTIibicVAXDlcn5m5A9qzrydBAwlPyMOp7H1rNu9Yjji3K7H5Cob/aphYjm1N5tRkggyIVJRmIxz7Vc3rb5Zm2k8YJrj4blo7XzJ2YNjcWPVjms+68RS7jg7uO/rRYm5F4jvHutQuGLHarFUPtWMGK/e5A6Uya6LA7skmq0k+V5NUCHSyZ781CZsjHaoS5Y5pVGRzTGK2T909+gpY42c4ORT4nRDwuTUpkGM5xQSRG355fil+zpncXNEjjGN5ANRnbjG8/jQNEqxxD+I09VjU/KeapFsE7WpplYdcGkM0NygetNaQLnmqQlO3ufxpPMbcMmmBdEnHLCmyEbc7qhBb0zQuS3ORQAvnKoPrSCXceTgD0pzRKRnGaakZ3ZCnFADGu+cKvHqab5479KVgh3AJSBYwuX/ACoFYBIrA4NJuGCBimuqHoNtIqgdGoGO3KuTilS4YcHpUTJycEUBG9aCSybhTn5SDSF+MjvVfaVzxwKejDAzQIkX5uaeMj7pqAvtPA/OnCbPQUATdeTwaFZC3zdKasueooJVh6GgB8wTdmLlfekjid9xGFA9TUYQ5JU0oz3PSgC2jGMbXwSfQ1PDMVBI4FUVU9cEmrVusoIyuVJ5zSA1rG5jZkLgFlPfoa9B0aSKaONWCKSuR2BrzKRRuBTC/SrNnf3FuyguxUHjJpCPWAoQZTgegpyy44xXM6J4hSVVjusFsYDDv9a6ZTFOoeJhjHNIZMmSeBSnPINJH8i0u7LYxQAEnOOlRSE/dzUjA9RmgLnOc0ARxjackVMnXnvTFU5bPNSAZOMcCgCR2BHvUZIKnPelySRkYFAHJpCIsAfWm7lHpUrMg4OKjwASQDQAw5ycCnKxKk46HFISdpxT1IC4AzQAK5xx1p55+9TVGCS1KctypoAUk+vFL1BB70i4xg07IUdcCmAmMHrxTG71JTW4U96AITkcdqRR7U/BPWhR7UxMAhYEimmIjPPNSg4PrQGB74oEVwhGd1KBkelSYJHIpGGRg9KYys6kMaa2cZ/CrBAxwKjkAC8jj0FAiEHk9+KCMe9JlRz0pwOcEHkdRQB1yudpAP40sbM2QT0pjKR9wULlWyR9ag1JJBk5pH5XHekznNNXJBoAazDBBGaZt4O3NOUZ5PWnKAOO5oGRLvAAI4pwGck9qlIph54zigBisMEDOacqkKSxz3pVRQpxkmlAwMAcUDGhQcmn8Cg4JwBzS4+XkdKBDR1/pUmR2FIowMn86M88UADZ74qMgYPtTznHJpvA6UDQAdDimy/LA4HWnYw3tSSAFCM0DIEO9Mt604OTuycAGmxkbWx600sBnjIHWgVgc5U81XnYsrKgBNE8hiGQCyH0qv8AaEOdrBjnHB6Uxmdey5hYOvBBH0ri9dkIt2RSVJOQfau01OQIXUITxk47VweuNvLqCSVXn2poTKyXJe0cPyVAX8KxZXUlu/vUt9coCojUr8oVsd6q7dsYZiMnnrTJZC7bSRUDbiM0kr75Ce1BfepHTFMBoOcYPNSGREHPJquCEOc8VGGaQttGFoAsmYY4wDQJQR0yfWo4rcsMNUoQJj2oCwgkXuKVdjZpkhGSB1p8cLngjFBVhfJU9DS/ZiD8ufxqWONk+4Cx96mCvwWKj2pAVjBkc9aa0GAcVe2hsdjTXhYA7CD9aYyipZe4qaOQsPmXmkkjYDPFQZZSeaBFsEdAMGpNh25zn6VSWbbwxpY7vY3B4oAlcZ3Hb0qrIB1FWlu1Oc9DSlI5lO04YUAUmJx2pm7atSSIEc56VE7qTigLDA3vT1lKjtUZ20uABntQIlEuVJNN3c8c0zPHXimq2OR0NAE28FTmmq47UhUOOOtN2kcmgknDVOpQ43VUByMVJGR07igRaGByvSgOmOoB+lRBtwxTljDHrQBL520YVhTllUjJLnHoahERHKrzS4bHzKeKAJVm2uShx9auwTo4HmfmKzBgnBHNKvGTzigVjagaPJVZCHHPFdHpOtz2zKrneo6N3rjLVo9252IIqV5iH/dyHb1HPSkB69Yaol3GpJVc9RnpVxnA6MM15boupsk4WV8A8Z7V3VjcjcCZAwPekM3ecU9ckcVGj5ABIp4PXHQUgHoODk0qjr2NEeMcih8dBQA44xwPxpjHnHajfgHjtTc8mkIYwHX9aj3lWHcVIeBx2prKM80APUrznp3pRtxlSCKiHLH0FKg6jP4U0A8MGHqfSlCkHg4oVQoJPWhG3E88UDFHtgmjJPUcUbhz0xSMVYEZAoEKQM0h4HsKAefvZpW5FAERJz0oUEsBjilxg80E8YoAcR6c0hU/WgE49KUMehpkhk9OeKQkFuh4p4IzyaQgGhDIsck0yQZ6g/WpSD2/nSEZyKYFNo04Yr8y9D6UwKCeMk1PMpweuaYpAzkcigR1inoOlPfO01DuI56nvUykEe+OlQbESncuBjNPHAxnmmspUDbgNmpEQc5PPegBmcHGBTtuOf1oZQOlOBG31oAjbJHH50iqDyOtPcgYycUD0oAQHr2prA9SxqQDAOelHJzQBGqHcDn61Lt4oCgDFLkbeaAGcDtxRxnvScY/wpAPxzQCA8nHamkcgAUrjHbigADkUDQrfdwahYsgPGR2qXqPXFMchgQaBlLd+9KHjPNOKk596bcR/Or9D0zUWW3fKetMAmdkXGzeB39KwPEs5tDFfJFhPuSbeMn1NbksgwVLZJHSsbW4zc2jwuDtYdj3oAge4S9tne2kDsUxkdelcTqp8uF2ZsOygAH9auabetpN41vc7th4I/un1FYmqM0kpyxZQTgmmIyyhZ8nqabcAMfpxUjy4Bx1qqXIB560xEFxheF9agVucHvUs67hlaWBQiAsOTTFYBb7+SflqSOMuNqKAvrT4t0smxB8vc+lLd3CW42qM8dfegpISaRIgEX73c1Cis+Ac9abBFJcOHA981qxJHboHYjce9AyC3tg+S4IPqasFVTg80xr+JchWy1UDeySMeirQBpbwqk4x7mqsl5Gh+ZgT2xVC4lkZSNxOaqgHqePegDSe/G0lBmoheTFspVWJ40zu5J7VFJdPuIUAD2oA10n3rh2CvUExG7nnHcVkh5Hbk4qzCzdAcn3oAnMsaHofypvnRluAamii805OAKmFtAow2PzoApecCcKMZpyTSISME1bMdug4UZ9aZJLEFypyB7UANWRnHzLlaSW23sWjOOOlN+2L/Ap/GkF2dx7UCI2hK+x96a6dsmpzIrj5sZ9aiKMCTwaAI9hHO7gU5QO7A0krMOq8VC2CeOKALaMB06U4sG4JBqmrsODyKcrDd3FBBZ2EdBkUmQmM0izEcZJFGVkPI/GgRIpJzgU4NsJBBBpGUqu6N1OO1N86QsC4DGgC1BKd4GavspVAQeTWUjozHIwc9qtxu7KfLJ49TSAsiBGTLgA1KLaNeAS2ar2928YZZYg4YYBPUe9Pt13Jugc56lTTGV7m3EeSOKgU4HetZbiGZPLnjw3TJqvdWQUgwnKmgCvExB7/jXWeGb/AGyCGR8bvuk+tcgowSD2qxBI0ZXB6cjFIlo9i06UsdsnBHAz3rTT0rzzw5qrTIsEshJXhSTyK7qwmJUpIckDikM0Fx04prAZPekByOKcCO9ICMqQcmnY9OtPBGOKQjJxSEQkckEGmdD0qZyFXjk1CScdDmgAC4ySaVGx0pMjOD1pqqwY8jFAEpwxPPFQlSpOCKergtg0sgGBiquMZH6frTuCCKa33TtHNKFIXmkIccbcDjFIpOKFXOaVTyRQAoAIoOO1B9O1AHFAAwyMAUAYXvS44PrSZOeaYmOx/kUFsDgZFIGGcCjPNIQBsZ9aAwPBppPBxSKe5pgNmUkZHFRlOORkVJKGIJBz7VGGKjmgDqhCGXIP1p3lhVz+tSIm05yeadKNsZ4qEaooux3Fs9BinWith2bqxoKgcEfePWmuzAFYxnHXNMZM1IWCocc0yN9y7WGGHUU4Mq7lPBH60ACHzADjAFSLz6fhUO9FQkNuPYUsLuTnbwep9KBkwwR7UgXrxUbsVfaozn9KlQ8dcUCF6DHWo1YdMdafwxI9DSHk4oGQS4XqTzShgF6cUsi8+pFJtzgt2oGDEFaaWLYA605lGRSN8oyByKAAgop5zUBf5utPZsnmoZyBjI60ARXLb42VCNymqomXeFYgEjP0qSR8liAQw7etZ0jCNhMPuM3PtTAsuuFZWwO4bNc/ql2yxyBcBADmQngYrY1IpeRiNGAUEMT71594o1Np3+zRPiKM4ZCOrDvTQGPqF011dGUk4Pc1TuJ9zdelI25xgcVUnyFIJpiEeUE461EzAjFRqRuz+FSScDimA0crg80mxmYDPFJExL4PWrSDAz37UDSFQiGPagGTTI7SOWUNMSR6UABid1RO7K4CnikOxenvYLX5I15A6DtWTPePKxJPHpSXPzStnJ5qEsnQCgVhAOpNAbbnP5UO+MgDFRg8UwHmUgYH61CzEjrzTjg9Kae5IoAaSfWkVdzdaUYI5qSNM9elADoYi5P90d6c0iJ9wZIpZXwmxOM9agIye+KQE6SySNwSo9qR5f4c5PrmmM+E2pxmoxjmmBMruxAzUiYzh1qKJtqk09AX+bNAA8WCSp4NJtI5ODViMjAUjIqUQRyZAbaT2oAqJscYBw1O2OnQ5qSWxYHKcj1FRI8kRxIKQhS+BjGfegbHHSplCv8Adxn0pjRbehwaYDPKXJI4qNxtPAp5LL1FOVweCKBWIVOeDSjAHWpHiVs7e9RNGVPTNArE8IDEgn8M0+SMoee/SqqPtPC4PrUpuXYYk5FBI+NSzVOqOoJRyKrxvls9MVYWcjkAfjQA83MjoEfHHfHNOhlMLqzAgfzoS6hdSJE2v6irdsLe6QQu6jPRm7UDIZpUdtwJBqa1umQBXyydqlk8P3RQtbSJMB2BwaomKeAhJopEb/aWgC/dqjDKjkjNVIzgYzmkVm3DJyKfcQFPnXkGgCa1ma3l3qea9J8NX32+0VlO2ZeozXmETb1w33hWlo99Lp9yksT8g9OxpMk9kgbzF5+8OoqbZ6msjSNQivbdLiM/N0dfQ1q+cCuV71Ix5CqvPQVCXOSRjFI2WOSMUh9qAAklue9LgdT2puOv6U5eO5NIQMAcGkbpzxS85OKa5I6CgAVQc4IqRV7Y4FVtzjoc0z7W0bYZCRQBeICjgcCmMM802wu45biJZY2IZgu2rmrNDDelLbHlgDPPQ+lAFZB3zQ6jNCupHBFLk4p3AaVycUnI604dPpSMPlyOaAIyxGcUzex78U5uBkVHjg0ALuGeRmnhhjjqaiA56UnHegknX5RnvUTSENwKZuIHA/GlA9etMCUMcZPao8hic1GWZQcUA5PNIDuc5BCjpUijKnPSo1Yjk1Ix+VsdBSNiKZFKkKOR3rPIZA2eSTWkuGBZTkEVXuEUYbbliaAK/lEqDnJJBpZo13Al8H0p6BlZssNuOKiKlpD8oLetA0OiiAyw5FPYkjavHvSK2wqu0nPpSqx3Hcu2gYsMYTJY7jUZD5YgjGakdiD8i5HekiZmdgy4HY0CsICSinuP1pGZiOODUrrnpRswuSckUDIhu75NDNgcipEOVPTcKQgspzwaAIgeaaxwMU6RV2Z3YxVSa4WNd2C6nsvWgBwmCjBB4qGdw6k8AD3rON5K7OmCgP51X8iKVmE1xKu7uW4FMCeeVo2BJ+RiADiotQkCxHbgq3XA61m6kFtIW8u9YqGAC53DP41z1zrEoY78kD0PFMC/eaqtjaSBZA+QQAOz+9cBI7SyM7tkk8n1q/rF00rtISN0hyQOlZcXzN7U0BKTsjY1mzsXYDtVy/cLhFPGMk1kySEuSDwPSmBME59KcVIGDzzUayHacnIqVGDA4IJoAWKPDZpWYggKc4pqnGSeKQ+xNTcaAsQcdqAQ0gwO9OXLDFPROTjt60rlWK1xEWJ2jrVNoSp54FaBkcD5wCKDGsikg80XCxnlCcY6UhQirjIBwOtCwk9QaLi5SoE/KjYcYq55OeAOfWpPs549aVx8jM5Y8jtUgTAHtV1bc88A03yGHIXNFw5Sk6Emo9nvV5oz/dNRtEQw680JisVCjZ6UvltVwRZNHkHrTuHKUypAxTfmA61cMPGTxUZiJzRzCsQozLzk5qRZifv5FL5R6mgxgjHencLFmG6MZ4O4ehq0piuATkA+lZWzt3p67lOUP4UXCxZmtyjZjzUbMVxvHPrViKVmQAfe7insiyISOvcGmFit8rrzyKgaIgkrkipZIzGxwT9KaknzbW60EkaMQeKeXDcNxUjRq3KcGmEdQwoAjdARxUZGODUuChPpQwDUxcpGMAdakQhlGabjtRgqRQKw7nNPDFec4NCMG4PWnSJuU45NAi/ZajNEi4f5R2rXN219GQCGOOhNcw2URAOD1NS2k7QzK4LAZ5oA05hEhKPGyuPfiliuFb906fLjg+lXhcWeoKFK7ZAPvnvVSe3FvNtHzIOjCgBuMcY4PfFIVZCOMjtU8DEvt2gr6mppRsQOAMe9BBq+F9WNjdFJ1JjkAXjsa9Ft5U8tSpyCM5ryJrt2GDt9OBXfeFtQjvIlR8ecoxjsallI6bqOPzo6fX0pEO3gmnZPWkAKOvrSrxnNGB70mRnjJoAUA7jjvSMOGzzTx1pGIzSERIAeopGUHqM0/GaQDOeaAEQKhyBgj0pUjVixxyT1PemdB1xTlLYz1oAVlCsB+tSxnIx6VGG3MNwp+MdOlACscZphJ9KXg/Wk4wSaAGsPlPpUXrUoPHI4ppwDgUwGL1waQndnjjtRg5IqQADp3oFYhAPQ5oAzzTpBkHafrUYPGDwKBAwI4GKjJIxjNSnFMbr2oA7sgBjmmOVUEMxyxwKeVzxzzVeZVaRQedpyCaRsT2wSGPy8scnOWOc0sqr1HSojIP4ucUl3JsQHn6etAEEqEyHDcfWpIk2gc5Pc0sURfcx+uKdGm7OPl9aBoYqkOWp0hB5IPFSKMKR1pduB65oGQqvYmpFHB54pwUdzzQRjoePrQBGqNu5Ix2xT8YHrUiIDyelOeP5floArOo3EjhqhLbSA5x9atmMqOcHNV7nDRsByQO3agDF1TVrS3WdnSZ44/v8AloWxWJB4w0uRGMSylR2ZDxXRxQRJbgOdynkhh1PvXLeJNH0+7jBtkjtboH5ZEG3f7Ed6YWFg1mwubrasyqj/AHCf5VT8R366SEXMjPJ90nBGK4WfzI5WDHJRivI70smozTPGbli4jG1fYU7CJbzWZZX3FFHrxxWbNds4bd8uewq7ez2k8f7uMISOcd6xLhsvkdKYyR3L9cnHrSRvsQ+5pjkhQR6U0NkAnoKYEN45BwTVIA5PbNSyNvkJoVATgYoARBwc0wfeyODUzoVBwf0qIDGaAJ1lOcHkVKoBGRUUMBJzwM1aihxjJqGy4oaEJ6CniMbTtJyatJGcKMfWrCWgJ4BAPrUORqoGZ5JPanLbOD8tbkdgSoGBzVyLT0xynNRzlqmc0lo5OQD+VTiykPbJrqI7BeMJU32MAElah1C40zmIdPfbuK9alGmHbkiukW0UKMCnC2AHSp9oaezOXewCleOCaJLE4+Vea6R7QFd3oaf9kyuR1pe0D2ZyD2pHVelMa2yo4Fda1orE5H6VXlsl6hciqVQh0zl3t8LkL+Qpggz1FdHJZ4OdvaoWss5IHNUpk+zMM2ynOBUT2uM4HWtx7Qqeh/Kk+zc/d4NHOP2Zz7WxxjHNMaAjkA10LWgAyDUUlp8pOM01Ml0zAe3xzjFRmI44HIrc+z8ciopLfrirUzN0zIQFT7iragOMrwcVI8PBz1qIJsOVPSrUiHCwYBJVxzVSeDDEj8KvMAwBxzUbDjnkVaZDRnhypwasKQycjrRLDgFlAxUaE4IoJsDKQcdqYVxUx5HrTBgjGM0xEec07jGDRt2nPalPQY6UANxuzinRPhtrGnIuaR0+b6elBBPMoYZxyKiC5GfSpYmLoN2PQ04x45HegAt5THKoHQ1p+ftciQbkI79qy5IwQCM5FWIt0keT2oA2LdVRkdBvQn8alvcMpx8q+lZ1k5zjJyOlacvlXMBQo4lHCsh7/SgVjHJI3YrY0K6a3vrZlyFZgr47D1rNuYTAVRvvHtUlo7IOfWkKx6/DISgLfNnkGp1O5eMVgeGbo3FjHGT9wYGepFbKZVtw6dMVJRYB545oI4+XtSBhwaVlycg0CEB7d6QAnOaa6OMleT6Uqb2XkbTQBIx/CmYyOtIEYnLEUEHPJpCAjCdM0K2OvFB5UelN78dKAHg85xT+SOvFQhuuTTgSQcGgBxXNNPPGeKQFgCcim7sjp+VAC8g/eFAHOc80wNg9PxozzwetNAPx7gUHIHJpgyO9O3Acnk0AKq/LTWVfzpfMJOMfjUbN6EUE2Gnv+lMABPP0p3XvSE0Ajugx8xyRgAD86iKg5IIPOeaVx5jbgTikACgs7YUcAGkbEUi87VOGPPFPzK8fCFscAHipCFQFjgZ70+KRDgKc44oGVbaOVJWaVvnP8IPAFWokCoSevWnsMyqAOe9NlByVVsHtQCGg9SCMelAYnB7VJFH+7/ebd3tQYyvA6UDGkc80KqliM4PrSleMjtT0Vdw3cZ60AIFbHY1MqZXluKcqrjpx2ppIHA7UANZI1B5qtLGCDsOT+lT43nkHFI4IB2rn8aAMe5tzhgoKsehDHH5VQntmEZVwH454rdIcsSQqgD1zVWZVIzuyfpQM8u8Q6NJbTSyKoe3lJYY42nuK5W4jt40/ds4c9VIr2bU7S3u7cxzsdncFsAV5Lr1otrrPk4DqE3ZHcZ4qkxGAoKyMewFV5q1LiNSCUG0e9ZjrwQetUAE5iOTVcyYjYVOBmB/UVUfO3BGDQBHglsVNEBwKjGcfSnxH94B2pDSJWBUfNyKRYgeQamUBgc85oEZA6cUmykhkcZ34HStO3gLBTio7SHoSOa17eJRWUpG8Ii2NluUkite301dqlgT+FLZRjaABWtEvAwK5pSOmMSvFYrjp+FWY7LjIH51ahT5+nWrsUWeg61ndmiRmi1x9KU2ue1a6wDpjrTvs4APGRSuOxkC0UDAWkNpxwK2vI55FNaHIwBSuOxiG1BUgjimC2KjA6VtGDk8VA1vhj6UXCxlmEAVC0OQcitdoeaaYRmi47GQbUEZxUbWYHUVtGEEHimGHtincVjCksxj/AOtUD2mBnrXQNDzUEkI64p8xLiYJt8HpTGg4xittoc9BULQ9cjmnzE8phSW4xgD9KqTwFQcj9K6RoePSq0tvlSAKtSJcTmZYeDxVR4cA5Ga6GeAbsVnzx4zxWkZGbgY7IVzTWGcAcGr0kee3NV2jI+lbRkYOBVZcZ7g1BJGAdy/lVx0I7HBqPZirTMnEqduelNIA5FWZIxtyBzUOCMgjmqIIjn/61KvA45FK3TNIvUelAh8Z2HI5FTSqCNwqJOmR0NSxHt2pgJbnCsO9TRtknOKiZSj/AFqSPrQIlMWVwBxTLd2U7O1XoAFbkdqhuIyQJF5A60iRYQ0c+R90nmuh0V4WkeN2KyH7hHesJ28uUMoyCAcVYYv8skAII9O1AixrCBbyNHI3hiDSX1k9qiM5yjnhqdpNnLqWpp5rgBPmYsetdJq1mbu3WFAu5DxQMXwdKWLKrfMOT9K7JDvU5zmvPfCsz2uotG67cEqwNegqpKBgeTyKljRKoyMnoKcOegyajVh65p45HFBI4ZINDHjilGe+KDjoaAGoM0jqalAGMUzoSDQAwgjHpTeckdqe2c4pFUUhDkQDOfwpjcZqXA5waaw3cUAQE+maXOAMU50wOKaq54oAaQCuQfwpqqc//XqVgAPemgYzjmmgGE8f4U3PXrTx1Oab0HI5oAQMQpzSYyOcmlPzDANIVOOuDQA1sgcfrTQSR60oOWbJ7UbeCaBWO4uG2ozkHjsKSIF1DHGOoyOlSqrm2XKgMR0PrTFjcRgjqOoFI2uQzyq0iRsPm6g1JbBW3FMcHGcVLFEWUMy8nvipih3LjGBQIbGrbgWOcUsifPljk9jU23HpTcg8YNA0CcfeoxlutKFwPvHFP2hxnbyOlAyF1PUcUqgYO7jNWVQMvPWmmKgCLB2gDOKccIQDTyNoz/Kmum8g5NADWJIJVeahZyAd3H0FSsxHOflqpcy4XG5QTxQBWkmV1ZU8wnvgGqNzIUQtwuPWp57uKDKPK7s3IVUwPzqjcrLLGzrGjbRkb8kUDMq5vGYlMWsTA8u79RXI61G7+IVZHjKyW+3f/Cea19Xu5pQsdrBHJN/GqJkD64rl9bt7tLqOSQCNmXI24+XPaqQjL1Czkt2JYoUPTac1izLtOa1b+WRgfNkZyOCTWVKS2ec+lMCAsQGGeoqpIzZwTVmb5cH14qFl+Y5oASIbsg04LjnvmhRhh6VLtyaTKSFiJyewq1Eu5gKhRQMVdtl+cZ61LNIot2kZBCnp61tWkSseaSxtxIAMDOK0oLQKQAea5ZSOuER9tFtyQeK0oEJGTUUFu4x0NaEMTdCABWTZukSQJ0xV+KPniq8KYPWr0SmsyhyR5qZU7YwKfGvFTIopDKxizyKQREfSrwT0ppXvQBnNDnORULxcnArSdcA81AV60hme0eOtRtGD2q86jOBUTLimBU8uozHirpWmsgwaAKTRgA4NRtGOc1cdO4qJx60BYotGB0qJo+tXSuM0xlBqibFB489qqyRkA4rSZcZFVpF5NMVjJmj61QmiBLDHFbEqc1SmT8qtMzaMSaLkmqzRgmteaLnmqjoCTWqZk0Zjw5yBVVoyDj0rXaPFRyW4cZA6da1jIxlEytoII/lUMkfykgZq3JEUbGDiomx3rZM52ilt6g9cUwcHmrDjBJFRkBsnFUSNjbnBHFWFG1v8KroQp5q5GQyjHWgBCA64/KntGyKGxUkJCllKjnoafzJF83GKRI6MiRAT1q6YgEAHpk1UsosZB5rUtV3kq3YUCKdzF+6RlHFTWcLPGpAOT2q4YuAMbgp6CpIYnQSGRh833VX+GgRXt5za3yYU+oeuttis8ZnjzuyAy1zN5ERaMUb54yGBra0mRpIyVYjAAbHekBDfRC18QCRTiOTDfjXawbliQEdR3rmNbjKm3lA5Ufma6fT2M+nwOx+ZkBNIZMFxk8U5RjvTYgSpyBgU/BHI5oEB5IpdwxjFIDzTto70CEALfhTTnJ4ORUqegpcZ60ARhTjkUoXBqQbjn1ppDdc5NIRExI6c4qPdkc1K69c9ajVTjA700gAnAPpQhBJ3cA1KkYWPkZPuKQY3crx7U7AR7Qe/FN2BTjOfep2RsZ4qORdqUgIsYJOaQLnoKcwGeuKVFGTyDQBHgjik2jnmp2AUHOPpUGTk4WgCHAUnA5pGJwcVLgNgEVIIAVyMn6GmI78Rkj5sA08RqDxxSS8jrj6VEC2QSxODUmpOcDpQqA8gUxmGOBk+tPjJ+YZ4NACqu4EHGaQRkcjinqmB1pQDtxxQAiKPx9qeB8pGKapHOeTSux7UDQhTDZ7elAOQc9aFfjmjOaBjR+P403qtOIO3rTSuO9AFeXbjnk9hUMpjRC7lQBySTU86MI/kALngZ7VT+wRs4kmZpHHcn5R9BQMga4e4GLWIhem9xj8RVdtOjncNdSyShf8AlmThCfUgda08AA44x2rJvrv7M8knmqiopyGPX8KAGzRpBMyJGIwBkFeBivO/F+r27ytbpiSRGwSq/L+dL4m8UXio0ELbpJV/1meVHsK5K6lB2qY2D4yxY9TVJCKOoSmWY4wq+lUScSYHSpp3IlJIqKcjqoqhoikG9Rg8ioR3zUx6VGyZJ7UhjW6CpkYbelRoOqnqaegIOKTKROi7uRV62X51x2qnCemK0LZfmB75rORpA6PTThRjr3rbtl3Lk4zWDYZIGQRW3anj29a5pHbDY1IVGOasxJkcd6rwcqKuW/A5rFmyLEEQXnrVuNMCmQjj1qwo4qAFQYPNSpUa9KcM0DJhgg801mGDimdRSMeMUrhYRyMGoCetSMQaiyDSHYYR3xULCpmqFj60AGO1IRmhTTgMjigCBxxUDrkccVdI+WoXXgmmIp7eoNRMOatMOKgcUwK8gqrKARVtx1qtJ0qkBTmAxVSVBt6VecdarOvFUjNozpFzn2qrJHycCtJ044qs68GrTM2igY/wpm3GfSrjpTPL445FaJmbRUls1ljwo5rGuYjFKUbrXURp83Sqes2fmw+agG9BmtISMJxOZdecAVEnEmGGAasnrz1qOVMjcK6EznasQSJhjU1sTnB6im53Lg9QaVMq3tTEaJVdgZR068d6JCPLBUdak09toZWGQw70sieW5H8PUUhEcLNGDxxWvYjzIQwODWaIwwxyB7VpaaOPLB5Xp70EsvWnyk71yc4zV+4tCvlscFZAdp6YNWtNsRKh8xcEd6Wb5JEt5MFFO5T9aQGbp0RmeW3lXKuh5xn8Kv2EP2S4aEj5VxzTvD8brdlcchmXPtmtTUrfbPuVeig8dyKAINTTeqJ1BNX9CLiPyX+6BxUVwNzRuBkEZ4qzp6kwZIIdXz+FIDSPy0vAPApcErmkGOtAmIVHanDjinLjHNIR+GaBCr608dc01ORinYYdDQApXglaiPXIFS/dBwetRuODyaLCIHXI3buM9KcqNkE4xQEDEdcVIP8A9VMYEkd+KaeAcHNDD5etMOTyDQAhlYD5uR6Ck3Db835UEcEgc00LnqOaAGuAVJ7e1MyE6dTUwyqkZ4PamFM9TSERjLt1OPemudp4yak+6x4PpSBcnOKAEUswwBip4iyjbxihV2jApeB35oA7gsDnr6U3rw3SkHJORTHl2sEAIyM5pGo/hcEDrUyE85qJTuUMCCKkU5XK0CJkIPQUueMetMGSuTwakUHFAIQJwCBSgZBBpwIGadt4ytBREyADjrQFJqTB5NMHNACbccdqZjI5p7+9JxnigCIZxzzTGAz2qVvlye1V9wLZzxQBBcYRCVX5v51xXiGKa+juJFjEccac7upNdtO+99i4/GuC8e65bR2stjbt5k2MFk6Z9KaGeeSSumZY/vsep5NY93PI8jySSMzk8kmtrUY5o4FaWPYCBgVzsoLORjIzVBYa7B+f4qidjg5qRmwR6VFKOeKYyFnI9hQrZOKcy5yO1IVwQaVxpC4w27FPXJPFKmG7GpVj9DipZSQ6Bc561pWg27cmqcUO7kda0rWMMPQis5GsEbOmnIweRXRWce4dMiub0/KjpxXV6cMoAK5pnbBaFqKDuOKtQxsvUVJCgOKuRxA1kzRDIcjtjtzVlRnFOSLrxUqxH0qBkeMilAqcRkdqQrSsNEWKY3Q1MVprDikNFVhjNRZwasOuAcVAyGmBGxqu5waml4FV2HOaB2HIalSokXvUy0hCgVG68Hip1BprLkGgVim4IqCQcVbYVC4BzVWHYouD2qtIMVfdaryKKoTM+QYzVdhV6VcciqxXk0ySo69aruhzxV5lBqJo8g1SM2jPZMUgXsatsmAeKiK4NWjNojCcdKmRBKhUgEHikRRU0Aw2K0Rm0cZqVo1tMysD1qsoByD9K6/xDZ+ZGkirk9DXJ7CHYHgit4s5ZorOhjbjpVm3jSRm5waXqmTg0WxVbpSeQeorQyLUKFDg9BWgYUkhD559KiKiRQVHHSrNmoa2cH7ytg0CKKoRNtHAatPSowt1tYZ5BqPaokX8qsQkR3CMp6nB+lIlneadBHlscqwqG8s1N0iqoyRjkdKsaUAbVW9+KnmyGLdx0pAc/oKOmozbmDYcjj61v3kQLRt3JIqjpdssdxIwyXfk+1bEqB0QnOVOaGBl26b7fb3UkDP1q/aQlI2B4JqG1jKSOvX5ya0FHynjmkAyPIUqT0pcHkDpS4IbNSAEgkCgTIQCODUyLleaRgQAB3qaFfl/xpiEiiXk44p5jB6ipEQYPOKf5fB70gKkiBMkdKYoyDkfnVllI4PSo/XHBpoCuUCkgdqTJI6VIcBsdc00tgUwIyOec80BQAc0udxweTQc9MdKAAr1ximFSOOmacCABnrS5BGT2oAi5HXGKjY/NxUrEEGo/pmkIToDmmqfm9qcwJA65ojHY9TQA9RkEjrSMQOKkx6cU0gdeKAO2jTA5JNIY1bO4fL6UI2QQBxTwRzk/jSNiJosRhV+UDpT7YMFIOM9BUgGO9OCY5FBNhwHGW9aeAQDzTCw6UoyR3oKHDjkUquM4PWkHTGaQ4AHrQA7JYnHakxgcimklBux+FKGDqSBQA0nANR8saeMDt9aa4+bpQBGTgdaqlSzkDgVJc3FvCrGWdE+tZ51e28vMEV1cf8AXOEnP0zQMqa6ZvJ+z2km2ac7N390dSR+FYc/hC0/syYRoWnKlt7tk561oXurymZJI9C1WQoT/wAs1H9aqz+ILiNC8+hakkR9QvT35pjRwHi+X/R41YjfhelcjcRmI/MCGIzg10evzteyG5SGRIHY7FZcAVz9/J5h3Ocv3qkBQU8H1zTh0J70xCd2KnAGD0oGhkUW5CzfhUTKcnvirzKVhAHBNRiIjtnNSykiO3Qtk4NXbe1aTgA5ptqueMcA9K2tKiYSjI4NZylY1hG5UtrBzkelX4bUJjIOf511sGlJNCHUYJ/Opl0h0OCMjsaxdQ3jCxgWsRHIGK3rE4C561J/ZzL/AAkGpUhKdeKybubRNK35Ax0rRgGc1lW3DDJwK04DxnNZs0RbQdhUqKO9RxsvapVbNIY8AU0pz7Uqt70oYHIoAhdRUZXirLcCojz0pWHcrstQOnpV1lytQutFhlCZQBVYrirswzmqrDtQVcbGKlXBpijFPTg4oETqBimuvWpIxxSsMgiiwig4xVduSatyryarsOaYyuy5FQuvFWitQyDANMllKReKrMozVyTNVWIzzTJIWQZ4qN14qZiKidx0qkiGQuPl6VAVznipyw9aawz0q0ZsrAY69KlQcihlzn1pEOCPWrRkyy8fnW7qOoGa4vV4PKvG29M129uxDHnGR0rm/ElsRP5h/iOQBWsGYzRzhOCy/lSqOUb0PNKyEPuWpHUtESByBmt0c7Rp2Mm/Ix8vWrMRVZ3QA4cZFZWmSlGA7E4NbDghonXG0ZGaCRqR/OQfrVu1jWQkMMHNQRqTcbgeOpq3acXLKfrmkB2WgNutysnRDgVozKpcNnjtWboAIB6lW5re8lWU/wAR9KQFOxgG6VgMAt1+lSkHey9AP1q7bwFF24wKikUbzjnmkIqW8YErEjmrOMZJFOCjzM461IVIXOPpQAzYHHHUUmCOFPNSRKwP3T71I6Y570CK7L271LHkKfahFxyRmn8HtTJHx4KnmpF6GmKowMdKevUjtikA1gc8VAYwWJI61a6CmSfd5piKToFPy9TUDj5s4NWSuGODQqckk5pjK2SpzjNOBDdaUoWzk5pQm3rigCI9+OPpTOq9c1M3LYHIpqxgsc5zQBC3HNJk8GpWHODQEXBApCIsgn3pFIBJpxjO70FJs6/nQAMSRTcleTyKkVTgbhS4HagDsLdiUGfTrUyYZiCOlIqkj0FORcOTnPHakbDgwGAFyTUq++PwpI0OOaGAHegBQBySetLjBpoI9aa0gBxnmgB4BJzzS5POAKYXP4UhegBHJYe1IvGMHin56AimnAPNAwA5bBB5qORA2d5JHoelPUYLHtTWbI5oAhVERRtjUc+lKWI5HH0pGkOCFFRCTdwDlvSgBs0j8jPWsPVfMnjkeRyEHyIo7+taruwU5Qk+3asPWZJILfzCpChSRkc0FHBeJkaREiiG1Yx0HrXEXZBlYeneuq1jVI1hEUUhedh85znbnt9a5GXJZverQFRQfMP1qzbpvk2HpnNQKPm5qaNwsuQcGgETvmSYqOinFThAOc1FEPn3etWyMhVHfFZs0ihkUckDxyMuY2OD7V2Ol2isiSqMt3FVreyVrUJIu5GHT0rb0SN7VAkwBjz8rY5HtXPN3OuEeU2bHhAtaCAOOe1Z6kI2c+/sana6iiXc7YFYmhcKgryBVC7dYcl8Ads96qXernGIAR/tEVlzyvMd0jFz79qaQXsXDqSnOBipItWxwuTj17VkOAoyfwqLfsBOefSmohzHWw6qhA559KvwXXmDqa4VNQKKAVBNaFrr2OCkSY6qKXICkdpG5zyTUqkDvzXLReIU5BRf++uatW+vQMAc7ccEHsanlKUjfdqarYzVKLUYZ+jj8DVlHDDKsCKmxakTDpUcnenqx24NRucg4NFhplKXnNV2BqxOcMaiNIpMh6GnRn5jSP601D82aYF2L7uae/3aihYbaJH6+lIRXk6mqzkVNK45qrK3FMLjS2TmoXPpSGTGajaUY60xNkUxxmqTtg1PNICM5qhPNtzzxTSM2xWmx9KrySg55qGa7jK8nBqhPcqxIVxWqiZuRZmnIzzUQvjH97JFUWlfOFG6ozNkHcCpp2M3I3Le6SU/eGTU7Lxkc4rm95JHP5Vo2N+0Y2zfOvqKtIm5rQtkgiqXiBC8Ac9u9XlZAy7SMP6VFqi5smFXEh6nGTLiQ4/GiIckGnTZCqTzg4NSFQu1tvGK1RztFazJZmA4INdAWVLIv94qRkVgWat58ntzW1C4S0lVxncM1RBJbuTeBQPlIzV+Bdt22eVArPtvlmjf0WrenhpL0hicFqQjvtCUeQAMjgGtqMjcQoFYNm6xuFjbgjPNalmp813J4680hWLtwV27Mkk9KI4uPm6mo0yXZzirCtkZFICBo8N+NShGYjdwopdu5gRUpB8s0AMb5fpQwDAUo+5zSqCQO1AhmOo/Wm4A4NPOMkZpMetBIc446UvTqacVBUYPSmOMGgB3BGRzTce1Gdq5poc9OtNAIVBJGMVFIhAwD1qx2qOQkrTArkYGCwpg3EHNSE5HQGmAkqR6GgBoXj3pCVxwRmn846VBt2k59aAByMYHJp0Q5+lIRuJ20+MEADvQAjLk+hphXaeRUpHzZJqNupyeaQhDknikx/exSke9I31oA6lZmWRI1YAHrnuK0YVGSw61jWUiPcK0inHVeOtbC7eq45pGxIOpPamNhQc80hfaCM0wgscnp9aAGqQelBxnJAzTc4PSnDB5FAxDnuaUYAz6UpXOMUpUhTigBQ360MQQQaQDI96QjJ5PH1oAbuwMU15B17UrEDgHIqIhW5xxQAoGQWGKhlgWTnJRx0Ze1T7cdDTCOxJxQUVGkePIlAI/vr3/AArjfFt4Llkiik3qnzHy2/Q12ksbO2P4B1rmfEdnaorzRoRJg5KnGT2pgjx+9UmeRiu3J6VTlHy1s6xCI5uuSfvfWsdiXfA6CqGVitMTlxxU7LyajHyvmkxovWwBLZ4wBVyMbp1AxgEVSh+47fQCr9mN0m7NZy2NKa1O10aISqEYZBXrW7BEu1oyASnBB7isrw4mSproZI/myAMmuO53dDLmi8nO1jjsD1rPYuSQOc1uzRNICQmQKZDYyLKG2I6GmhGUttOU3+UxTu3WlNozgnyzj1FdnaWaxgBuFPapZNPiVyYwAD1WncTOESxl2lliMq+nekNtbsmAzwyAfdYZBrt/sUaLiPp6Gs+602JiWCDPWnzAkcPPE0TYkj3L7c1EYk5YKRXVy2KBDt5Hoe1Z81iFyVBB9PWjmQuVmBsDHrzTMuhOCfwq5cWrRv8AKpxUWz5Sf8iqBIWO6cLs6Hsa2NL1ny1CS5z61gzIdmc9KYCeCTUFI7yHUy67lPy1KbvcM4xXJWVxJFhCfkNaizFuhqOUtGs8u85pA2c1QSQlTk9O9WI2GypLQ+Q8YqLeRQ7HmoC+D170AX4ZMpj0pZXwh5qlHIATzSSykjNABLN1NVJJRyCRmq91PtDHPNY8s7gk7iKaQm7GlcXYjHTJrKudVRGOCGNZ9zdyMWAdqy3JDEck+prWMTGUmzRuNVZlOBtJqhNeysCWORVfYSckU4RO/wAojJ98VehkRm5bcflJHYmnLKG4q3Bp0r43DArSh0cBAM/iadws2YobHQmkZm5wpI+ldPFpSKmNo+p61OumRAYVfxqOYORnIgsCflI+opVkaPlVP0rqX06POFQE+pqBtOfJCbQfpVpktNGdp90fMBcdDmtu9xJp5kjGVI/WsxrKRJMBNzf7IrR09WEM0M6nBU4z0zWiIOPlABYH1q1bxeZaSgDlfmz7VDeK0byD0PX1q3o0pXcnZwRz2q0YyM60wNRcHO0jiry5eOYKeSMCooowb2R+oC9PepbBt4lz1xVmbLVoQzKhHzdM1saTb7L1jsLetZmnDZdxuQflOcV2WiW5kcSYxuJJpEmjHGA6njcAO1aS7hHt28GmBI1ljbsOD9atqVbJI6dKQwjyF5wKmBz8qdTyTUGM5AzUkbbOlIknACdTx60b1YZU5FQk71JJ/CnKQFGBQA4sAOcgUmXkbjhRQvzHLflUg56UkJDWXuKBxmn7c89qa688UxMVTxnNDLu6jihVwvWlGfwoERkYzxSFgCARU0mMY71BICCKaAUkYOTUbc8L1ob5j7U0EKMZ5pgR+W6q3zD8KYoYbvWp93BzSHH1FAEBLYxjmmgOFOec1PgbsikHHpQBXIKn3pwPXcalbGeRxTWAAzj8KQEeQRnNMxyakwM5oI4JoERkjBB4puQRxUgGaaOPrQB1kOHjVzGEcDGPSnI7LnnpT1ORmldR5bMOtI2ELD6GlVj3qARmRVJBGDnrUmGA6UADHOaVSaTkj0oUHHX60DHZ5xmhS+TzxTcDOR1oR2ycc0ATHAqPjdjrQWY5LLwKcB1J4oAayDkdBTQgVeGyKkALHj9adxtxigaIDkfdGTTSuQMkVI5xwBUUgyMn9KBle6kMcfyKWPtXOalHJdybH/dxINzA9Sa6NwScKDXN+KLmO0sZWkBMj8KndqBo8y8TMnnOi4HPH+Nc/Cm5iRwBV/VZWmmd3++T09BUNlA+HOO2fwqhlS4AEmB6VEAOpqaQ75SfTimEfOAKkaJox8uK09NjJye1ZuQBj2re0KHfATWc9Ea01qdp4ajPljjtzXS+XlaxfDakRgEYrpFQgDNcjOwghibJGM1owxLgKVpsSZAyKsqAB6UIByABSrDp0ocDkigMNvNRSSKM5I+tArEUpA+tUpiMkg8+lSy3MecAlyOyiqcrynlYGIPckCkWkVbgZUgDBqhNjaT3qxObgZxGo+pqhM0oHzKAKZZHIQc5AqlLGhJ24AqWSR+QQKgZ8dRii4WKz2wORyRUHkEZIzitBTk5HSlVcnmnzE8hTjAyAQa0LYnAHcUJCG7CrMMBU9KLhYlTAXGeasxD5AKZDDlh8pq8kBxyOKhlFSQccVTmzk81qTQgA5NZ8y8k4oArK5HfIpJ5js4prVXnPH0oAp3jkg88msqYlmwMkDvV2c5JOKpyEdD1rREMpTL0x19KZ5JPVeatKF3cD8aVc07k8pBHa7m+Y8VfgtwKbDFI5+VcD1NW4rb++5+gpXGok0KgDAxVlAOtQpCoX+I/nU6RqT905/GkNIkAFPwT0PFJGg9TUyx5JxzigTQxkJ4/WmpHg9M5qxtIGCKfGuOlWnYhoZHaGbcPugd6qvCIypx8oPPvWtbkqTn7tVb6McgdOvFaRZjKJwfiKIJfTKnCtyBVOz/dBfXrWz4qjzPA6AAFcH86xmysgAraJzSQ6MYklZgBk8UunjBmx60+FTIc9/anW68zNjAVsfWrRkzTgxGsbHlmrs/Dm4KC/Ur0rkLJPMdRnnqK6/TGMUqE45GKGI2njz9M09CS2M0wB5D6LUiLgkUgJQRyO9IOSQBilEZ55p4XA5pCYo5AFPVSpA6inwRE4IyB1qUr7UCIhHlsingAfWpVTt0pvl/NyRQIjNM3c8DipXHYVGQBk5OaBMUHPFOPTjOabkhc0oOR/jQIaSec01+eQac/f2pmck4NMBOgIqEoM8HmpMsBxzQOT05NMCuzFTgjNIGbuRj0qWRNvzdajzke9ADsrj3qNmG45pc8HHWmkKRnvQAmSRgCl+8p9qanAzj8qcCTnj86Qhhxg56ilXkcYoAHOcUvGPQUANx1IFIQFyTTwRjrUbkHuTQB1ikdulG8kbWUkURhs5zwe1TMw5yuBSNxq4K8dKCCRwaXAUjHSng4HTigCJlG0nNAHvxTnQOuCcUgXsPpQA0rxwKcuAAO9KQQeRxSEdxQA4mk5amMQcU5DzxmgY9OFPNHBJIphOAcikLHPB4oBCOecU3qBjoKkPuOTTNvXAoGQseTgc1yniaylvJS6cbMnJ6AV2aBFU5rkfGsjNp0sULlJH6lTghe9Azx/UAJ70iMD5jgY79q0b+3GnwNFvxJs2kkdSe1WNE0yR45dQlBWOJwqk8A1B4mkZRBHMv+kS5lJ6kL0FMaOeK/N+FRt97gZIqfjIpBhXwe/FIaGqp+XNdj4dtsWCuQPmJxXKYwuSOlehaLbeVo9rkclNx/Gsqj0N6K1Oj0SLEKnvXQqmcYGaytGT9yuOmBmt5Y8KMdK5TqI1XA6YprNjI9KmZT3qtMCcjpSGVLq92NsRXdvQVXCPv3Xjs7n7sMfRR71NM4jyIgPM7tTICEyVbLt1JoKJtkm3CbIR6KM1DLbkD5nY/U1Tv9esLFD5twrv8A3F61zOo+NkLHyYyVHt/DVJXFzJHQzwoScZ/76rMmUKxCtzXM3Hi65jALwSKrtuGQRn6VSPipmcuQ30xTdNjU0dJIx5JWqzY7H8KyoNeS4OwOqs3Y8VbWcuPlqbFp3LKuFPH5VNG6tmqHmZBx1p0cvPH40IZrRMcjHStewUSMM1hWzbyMGug01eBxxSZLRqQWqkHirJth68VNaf6vFThSQTioAx7q2AYk9Kyp7UnODxXRXY+U+tZhj4NIaRiS2ZFVprUhDurpREGXpWF4luRa2zY5fFWhHKahcBZCi498Vng7jmmZaQlz1NSxgY6VaESRrleepqzDGC3IJNRx85xVmAAdW/GmMsRQnODwPQVZSEAcAc1B9ohhQtJKo/GqUniWxi+7l/cUJEOSRsCMDqRSqo55rmJPFqeYQsR2+tNj8VLvJCDHenysOdHYwop71YSHeMj9K5mz8T2zMDMu33rqtJu7a7JWKRHB6KKFElzRFIhQcjcv606PDjKcitB40PHKFf71VjDiQleKdibjAPTmq96f3chHBxVwKdp9ap33EJ9TxTRLRy/iOHENszdzgVzs6ET5HTjArqvFIxa2YHua564QiVc9lzW0Wcs0ORRFKuakVdsbr3Zif1qGMb5eTmrhBQsT0HStUYNFzSSGuTGeCF712un2we3VurAZrhdFDSXDbRkivR9ETNqjMPvLmhiLUGWhyOCOKl2MMbeaWONkkOB8jGrkcQDZ4ApE3IFRmz8tSwqBwy5NTKqjLckVKqjORxmgTYwLj/AU9U65pdvenDgnmgCMoc8Hp60xkbccVMTzikXOaAISpGc0wxhzkmpjliVNMJVTtB5oIIyiim46gCnueeeTRjA6YoAhYEjAFNKlck9PapRjmmOQTzTAYBgZPemnPJHNOYqAQaaD8ppgNfkYIqMIOuc1KxBGSajbjvigAxx0FMIwSSBTWHvzSgknB5FACHAGRTGII5NP9RTHjGAaQhM46UwMTwcmnKAW4oxgmgBA3Xj2pDhuAKbu+Y46U0uB0BoA7GOMo4bdlRT2IYkU4KOPSlKgjpj3pG41ecUpPOAelIODTvvdAKAEpyrnkmkVT3zSgZbnigBWBY/KaiPHBNTDgelM24yTQAwDA9aTsPWnfe6Uqp8uSTQAzkqeaFU5GeRTmPBppb5eDQULkMCM0zJJwOadgkZNNC5JGcCgBrqSD2+lYGuWLeSzY3M428da6FgFTAbJ96rSR+e2G+6OvFA0cpPpgTSoLVFzGpBb/aOc15x4suPtesTHywpixGuP4QO1e4XuYodltEGlb5Yxjp715z4p0i3tImEsWZgWkds4LMaEUjzt1wATTAvzqc5qeQHkNwRSpHhcmgaQ0KSSvc8CvV7S2xY2ygcBFH6V5fAjNdxBOrMB+te029riGNSOVAFc1VnVRRe0qDbbrxzWqq/KKq2alUx0Iq8o4rA2GFflNU7nCqa0MZzUMiZBG3NA0cjfXv2cSSg5Va4rVtRvrtxDBkK5xwa9A1Xw+t0GdSoJ/h3VgtoyRSFY1ZgvVj/DTiaDNH8AXE1oJ5pQ8r8nLcCs2bRZ7dbmJkRZomw8eOdv97/drtNF1ifRkEd6jTWp53oOU+tRePo11LT11HSpx9qts5VeCR3BrWMjmmnc4HV41/sqYX12hngb5FY/w+lcPduklxKYEKrnha2pF80kynLnrnqKrLZIZgSScHNXziUGPtbKH7GzTBvP3AhfatyO0KWMUyOfmOCKqQoM7O7VtXFzEljHAi52ZGRWVzoimjNjlKHDirnl74/MiOVqkgSSTDnaDU9uwtpkCvuyclaRojQ047plU12trFhF47Vhrp+y6SZBxXQQNlAKyYGjZdOatEjGBVS34Wp84UmkFireEAEVngirN42eap7ueDSKsWolyua4rxyTuVVHGa7a2OUrmPGNo0sPmovC9cVUdyGcGnpUgODQE5NPRdoJ6mtEIJp1t03PjJHSmQtcXj7Y+AehNZ7BpmZpUcnPcVtaTqHkPGZYSoA2kAfepiI/E+k/YoYVaVmZxuJH3TVd/sDaEHeSNJon4jVfmZfrXUeJ7601bSB9mHlywnIz94/3q8/kUMGAGPXNXF2MJxbM2aQTXcjxRlELYArSgtIxbsXP7w/dFQRW6I2QOauQI7SLGnMjnAFXcz5Wdb4T8Jx6nZ+fP80I9DzUmreE5dJsmubG5lFwJAAmOAn1rrNGu9N8P6DFDJcrJcEZKp81Z954tXDrZ2Kln4EkzZCe+O9TzMaTORtPEt7DMsWoOXxx83WuvsdSiu0XBw57VzFnocupTO+AzMcs8nrWlaaTeafMgAEkannHUUyjpo49y5PpWXfqdyJ1ratk/cgHOT2rOvIwLpMioA5vxcPktgei9K56fllXuRXTeKkLGPIPbFYVzEC6EnkDpW0TGojPiz5mF65xVo4SyY7wWztqGFP37FTx1qO8ZY1SMHliWNao5mjZ8HLuvHB7qc16ZpqEQKgGAowPpXl/gmcJrscbA/vFIzXqdu+ZdoGMU2SaCLtX5cU4KSvamZ+XgU9GITJpGbHxoANvpUo54/Ko4xyWJPNKwycjrQA4qSeTQeB1pF5HPWkc0ALkYz3FIT3FJwelA9KBCOwwTwD61X2HJY8mpmXcpFR/MOMZoEwUHHPFP6DJpqHk5oY4HrQIjf3PFMfBBweak4GQRkVGVQ5b9KEBEx4+amnGOOtOlX5eKjXge9MBAMD1pjueOKdu5xUbtgmmAkjcEio0kJYAfjQWHPoaCV3DAoAeflyc5phY7cHpRyR1pNxGc0ANLc8ZxTZGIpQSemMUxgS3XIpCEBIPrS/pTcHBI6UZI9xQB26s27J+lKWJJpq/NnGMU8A9qRshAMY9zTicdKarbQRQTnvxQMVWGaeFyc0mBjpSK+GA9TQA71AzxTU5Un3p/VjxmkUBQR+NAAO4NNc5+6KNwyc8igfLz3oAYUO3n60hHFTBcnJzz2prJhuO9A0MQ7TzyKARk+tKykL60wg5ywxQMM4J/rSKdxwOKVgQMjBHelGD0FBRDPKqZOcH1rjdfgm1BplwfIi+eSRj95iOFHsB/OuyZFKksoIrHvYcQtGiYEjZYfT1pDR4zqlsI7qVFBBAGM9xVZFyuM4rstdsCYL+9CndGehHAHA4rnpbB49Hi1CTAikl8tfypFxQzRofN1W2Tqd4PHbFe3WsYMYJGK8f8LRbtaiwM7TzXs8AAQY9K5qu51UloTxKAeBU4qFe5qQE4yTisTYf2PrUZ9O9GckkGg8EUDSAKCeRxUMttCyssiK0bfw5qyAMcU1uAaYzCvNNlbzGikjjg/hiVeaxp7KWOQrLDj/rnXXTMcEVn3DPkkEU7gkcDeadpcmJC0iSHqcc1ny6bYq5CGUn61211bK7AmNf++ax7i2Cs5Uc0cxSRzwt4I3yiHPrTxGuTnpV9ouTUYgZuAlFxkMcERYbhuq/bQRK4dQC9JHbbDyK0tHsTNcgMG2DrSuM27a2LQiSQc1Yji5GKtLHtTYowtKq8dKgQRArT3OFJpVG0D3pJD8pxQUjMvGyCBVFTzjvU9ySS2T+FVMjNMuxo2uSuMVFqUPmQSIR1qeyJx9asTJuU5Apoze55bqVkba5YA7s1XAGK7/U9Hju0O0gSetcdqGnS2hIdau5JSUKDytPCRkZAFMAxwakVeaBkyRR9gahnsbVuWjO41ajDdxzVhAMDIouFjAksLUMcQsPxNOit4UkDJGysO9dIsaHGVH5VYSGIqcqB9KXOLlRh2lm9y5WIHPvWtp+gyzODMCig49a1LUKjptrVt2btTjIzkrGtpmm2kFqA6jPoP4aWe2gySEx/u063kHkjnmlcgj1NXcwM94trkCsfUImMoYjpXQyJk8VUubYuhAGTSA4/XYPOijkzytc5dIRMrD+7XeTWuYwH6Vy99ZMJCPKbI4XI7VrEiepz1um1nLVm6gytdHbnCAA59a3b9FthtC7XxnBFcrG7M7sQTlieRWyOZo6fQI/supabNcKVjlbqOpBr1q2hEcuQ25Mda8/FpHHbaUCJDIIg2cYA9q9A0sEwxyGQFHXGMUyJaF4bCeDxS4UUgVV4x15okHpQQx6tzjoKcc8nNQEn60sRKj5jQSSKQTnNIz5BXFITzTXxgsTigB6naMmjfnPHFQh9y5pTnb2AoAmyMcGombaCaQOvIAyaVypAytAhm7PQ4NL2+8ahd/pQsnBzQIkb2OaYTjIzTQ2T15NNPU5496BDnYMvFRFcj3pVGc4PNMBxuzmgBj8HAqP1yKkOetMcYOfamBGenHak3dDigHI5pDTAN3HsaTjHTrSgfLzwKa7YPFACbcDqTRkDkkc0gycilIPcZpCEbao4OajYk8rT2G09KRCrZzxQB2q8YUGlIODzz7UqEFee1PXYEPekbkMYBHB3YqUCmhME46HtQvAwetADx97rQAM/SmL8p6mnghjxQA8ZGM0jn5iaRjwdw/Gmxg4J5wKChdg+8eKVcck80vbFNzg5HQ0AOLjHSoyWHKjJNPHI7daOBkjrQAhBA+tR4IJJJ4p5Y5470j+gPPWgYxeR/Q0PnJ2nFKp6ZOT7Uj4Rsg8ntQNEUm8n5hlRUMqoVZm7rtFTkFjmoZU5x1NSUjIv9OjeymijRSJF6N0NcX4tsWsfBdrC6AeTMm36knNelBV24IPpWL4402Kbw/KZ03Rq8e3nG0hqhuxvTVzgfBKK+sJuGcCvW4fuYPWvLvBShNfWPGSpPX0r1NOOawnqdMVZD16Yp49DTVx3qQDPGKzLQnbpTlHQEU4LS7aBjBwaRjnqaeaikpMCCQHBFVJEyOatucCqrkkHPFBSKUsBOapS2ivkGtORuDVVh1NSMzWso1J2D86iNsufkNaQiLHpU8Vr5mM9BQBnWuntcSgAcV0cNusKbUHFS20WxdqgVYCkCgCusdGyrBXrUbYGaBkTcVXmPBxVh+BVKdsDFBSRm3IByaqKPmxVm4I5xVRetM1NWyPYVodsisqzPvWpAx2AdatHPIikj6kCs2/sUuIiXTce+2t4puHApDCNpyMGixFzy+/sGgd9p3KveqirkHFdzq1n+8faFXd975a5q9sxCx8sUNlplKPHerMYBHvUCjseDUqMelSNFlBmrMK1XjIAwatRt6UAW4FwwNaNv27VmwNV6FulBEkaULEd81ZU54NUomq3EeatMwaHFc5puPUU9RuJFP2cc1aIM2aDDHjNZ0toGlJYHPauikjypIqu0OH346CqRLPJvFsbJqDA/fIz16Vh2WmtLJGnIMh4IHUV1HjCMnVGL8lsmt6+00RaRotxGFBCCN8DHNaXJjC7sZsO9NbtITMWjMaqVz8qnBrtNJt/K3RPkBTxg9azbnQGuYYyhCyph1bpz1raszvjRnx5mMNjpnvVo5au5fA444qMnqCc0pbFRSAjJziqMyKQuo+XjtTd7bRuYZow+/J5GKa2dwHT1oAm3YyMk1HncfmyRTwoIJxmmMhJwOBQSSByTgDpSSE8Z6H0puSimgMGAJzQA5QOgpSx29OlMY7W4pSVznJzQIjY5OKYemM0443c+tGTzxQAzoRk0p+/nGaOASacv5CgTAD1NRyH34qTIB5qNhlcr+tAhu7Oc1E2DnmpD90ioyuAelMBgwFpv3h1xSkfIfWm449DTAME9+KQDigN+XtS55xQAgUDnNKTxgUhYZ7U3dk0ASnnPSotoA9R0p2cnApM7T14NAHaKgZnA6CnKCV2dqIc4YnrTwvFSbAAFGPSmEdT6U5ztbA60i8qQDzQA2NSecdalRcduaRRgDJ6U8HBGKBibRjmkHy554odn3jBAUjNQmRiT3HpQBMMc4pjDtShht6jFLw3SgaGoPmJ7UuASRQ54AB5pMkfSgBGXAPA4poPBqQZPr0pB1INAxoAA5qJ+W4qVuhpoXavPU0mNEbcZwaamWkyakwMCoyDnigocEy2M4Gc1S8YosmieX0VmDn3wavQg7zkEAU3Xrc3GmDaCSB0rmqbnXh1oeZ6KvkeKYCMDfxXpijjFcA8Aj1O3kkXa6OOa9AiOcehrNm5Ii8CplHXimqORUoGKQ0AAxTT60/FIRSAj7GoWPWp24B4qu/Q0ikVpGxmqcjHmrMpyTVOQ4NIpEbMe54poFKFyfapEj56UhhFHnBOavQoAowKjiXvVpBjpQIenHWpQMCmqPapO1ADTgA1C/Gakkbiq7tQCIZSc4qlOeuatsO9U7jPNBrEzpyOgqqTVq471UPOaZZYt5Du4rYtJCeGrChJ3Vp2r4AqkYzRtxHK1K4BGDVa3kBWrowVBqkc7MPU4v4jXO3SAscCuq1TiMnArm5+uKC4sxZ4cFjjioBxxitSVAQapvGAalo0QxCasxHAqsBipUPWkMuxGr0LjArMjb0q1E3vQS0asTkDirsLE1l2zc1pW3rVRMpKxoQrkVZWJccjk0y0QFauxpwCa1MSv5QAxg1XuU2ROepA4rTK4+tVLofu3HrTTE0eT+J49+ptweCMmujkJl8Ipk5EcyEZ+uKxNdYNqEu0ck81sxxkeEwCcl51H1psqEbanSoP9GhPdkBqCKIRO5GcMc/jU03yw2644EY/ChcFcntxWsNjgq/EwAbcCDx70P831o3beNpNBA49asykLGrBcuBn2qKQKTnGdtSHgYBzTGHy8daCRcgLwMCmhl53DrQOp7U7qBjpQAyTGQAOKY4zgdMdqlxzmhgMdKAK5xnk04YPTrTzHx2poX5e1ADWXJzTVOBgjj1qbK9MZJpknGMCgRDxkntSMSfumnKoyc9KQoedvSgQEggZ60iKGTFGzHXijO3vQIY6+nbrTScipDyKYQFB5poBmBj/Go3XjipRg1HJwcCmBEMAkZoLBR60pxg5ppx0AzQAg6ZxSA+1IPlJB6UgbJPYUASZGDjrTQQev6UA5OD+FKvHWgR3apjgdaVeMk08L3OKAOpNSbjR1PApoUKSak25zjvRs5wM0DGDJHPNAHPU1KFwOetNAoACQVPGTUaoAeKkA5Pak2kA85oGIUB6HmkAC96cmaTcAeR9RQAjY5PFCHj1oPI4HGaQKQxwePSgaAgkcZpjK2ScdOlOd8HHf0pAx2cUAMDMTyKQkqSSKXBGGFSbc8mpKIgu4Ek4poU5BGcU9xjKinJ02jqKQDkAJwO9WIiBmNxlG4NV1IEgqcMARXPU3O2h8Jha9pETI0qr935uO1W7QloEb1UVoXqhrZgOmKz7biIDsKzNi4vSng1CrZxipAcUAPBpppQabmkMDVaUdasE8VDIOpoGilKKqOMk5q64yKrunU96lmiK4FTRjrTQM5p6DFIZNGOasp1qshxU8bYNAmiyvNBpin3psr4XjqaBEU8nJUVDgk0pHXNSxQlu2BRYaIWWqs6HJ47VsCAY5GTUUtuMHjGKdilI5uZODx0qky1t3kQXd61mOnOMUWLuQR5HTrV+2zjmoIoyW6VoQwPtzjg1SRnNkkD7G56VrW0qyR8dqydpXg0sM5icjsaZi1cNXfgrWBLyOea0tWm5PPUVjmXI9qZUUMkxjmqsgyalLln68VG55NJlohK0oNOIyKRRzUjHocGrURqsi5NWoEJHHWgRdts54rYsxwPUVlWqEtiti0TaauKMps1rMfLk1cGMDoKqW5CrjtVjP4VZgSOeOKo33ETEZyKsk8mql6CYSqYJY45poR5slldahrEoSMtl8D3rr9VtUhTTdNTgqfMcDsa37Wzgs03QqqNj5n71h28i3utPOc+Wg2gnvTLUrIs3B+faucKAKjUgdjT52BbjuaZvG3ntW0dEedN3kx7OD0GaaW45qPcd2RQSCeuKsgeMClIB59aRemfWmF8E0EWHYyOlB74HFM809B1pckj1oAUY655pVBGcmmoOufypS3PSgBT0NNIAHNKDnoKbJyeBQIb0yetHVRntTSvPJ/Ck3AcYNAmNLZ7UoyvsKdtUnkUuAcgCgQ1lyBnGaay+oqXbyMdKUgUAV9h49KjcYNW8AdBUboMnNNAV8ACmSLnnHSpyOfamMuQaYFUqMHmm9B0qw4Gw45qBsYxxQAxwGHHFRHI5qT2pp4yaAFDcc9acCMc1GrZOD0qQce9AHoagMhJ5FNbnCgcd6lP3cDpTF5znrUmyAYAAFGPTrTHbaCTnj0GaerZ5/nQAwZJPtSjJB3CnHBPHBpm45YZPFA0Ko2ilxnk4poPGCetPH+12oGJ2yKZ1yCOaczZJHQUxeME0AKVAHFIMc8808jIqLbgnPSgaI2jBOTmlXABHP41IOlMCMckUAK3QD9KQscYX9KVlwOOabuC4Hf1qSgcZGeaM7eR6UhOScGkzxz1FAwHLZNEz7cUuMsMnioNROI+Dg1hVR14ZXLrNvtW9CKy4yUZl9KtWcu+3Kn0qpj9+axOhqxPayMwO7pnirAOKrwLsBHbrUwPvQIlz6UmaZnjrTQ3PNA0S9RTCM5BoBzS0FFZ15wKgdeKusoqJk44qWikykIwuSO9OA4qYr60xhg1JQ1eKkBFRGgGgC0rcUY3dKjjOTirMQ7mmgsIkIBBPNTAYoJA600yDGKpEMlBwKjlYYqMygCq88xAPNMLFS+ILHFZjAZJq3cy5zVTcCeKLGqZJAnzCusto0EC5xyK5WEita2um2gFgAKa0MampbvLFXUshwRWG8TK5yOK3YrtcfMwwamMEFwDkrk07XITtucNrJMaL3U1kB8nFdh4j04fYZjGM7RkYrgUduxqTWJcZ/zoB4qBXycVKlIoco4pVHJpyDIqWNc9qQgjTmr1vEOKiiStG3TA6c00iWyxbwgfdrRhjGRmoYFAFXUAB9q0ijCTJ4uODUwaol4oLACrMyQmoyQ08asM85xS5AzmoRIiyO7n5UHWgEVPEN35cZiV9pPHFVdJjEVs8nc9TXO6xqjXGoOR/qg2BXQaa4fTcLwc0R3LqR5YEp5BxzTfc0pJjj+bGaiL54HBNbpHmMRnX+D5jnHWpAVVeag4UHihpBtHXFUImMnp0pobnvUG7J56UqsT2oEPB3e3pUuTtwKIzuUetOI9qCWIh25zQWGaeVG3jHNIBz9KAGhuvJp/3gc0ny88U4YHIoAgfduDKKfxnHcUHgkfrSYy3XpQSwCktk9R2FOAwSc8Ug469aDQIQfXpQGyeDxSgAggHrSBFQnJxTAHyTz0qJ25PPNPfGDySajCDrTAjBJGehFJn3zTmUDim7cDOaAGPg5qBlAHvUrDGcmmsQBQBARnJ6YppHBHrT8EDg9aj4HegBAMH3p/VqQAbuuacfagD0PkcmkIIU7cbj607OenIHWm5546GpNx0efL+c5PtRgfjSDBA7CgDBznigQo4NIyg0ZHI5FKCMUDQwfewBikc4B70/saYSQegNAxpbahLZpgO7DNnHUVITnpimKcklhgUDELncFXgUgYliO3SnHZn5etRyLkjLYx1oAlJG4DFPHK8VGGVFOGyT0oBbHBoBDmGM+lRSYz8o59KkAODnpTBlwf0pFEanPNJnLe4p6RheDknrmmt96kMSMncQeRUeoDcgxUirg5qVUEgIwM+9ZVFdHXhWkZtqSuRSniUZq79kOc1HdQ7dh6c1z2OliJj8acDTcYx6UnfNMlD88U3OCR2pcd6UglqChVPrUgHFRqO1TKOKQBjimFR0xUoHFBpDKrrjJxUDLVxxkGqz98VLLiV246U3NPYGkxzmkUOiyKrajf/ZYi2eRVsDisTXonfGOlNAjDv/GEqyFIYCcdSTVJPHl1DKBcWoEeeobmrH9kqx3EZFWofC0c2fMC4960VhtI39I1q11a2820fcO4PUVLPJweai07SbbTottugX3xSXI4PUUjMqzy8EioVfP1qK4J3Y7UQAsefzpjuX4WzSXup2lhHuu7iOLjIDNyfoKZE67woGcd6wPGvhhtS23lnkuq4cZ4IoRDHyeN7FpSsEcrj+90BrX0nxCl0VOWX0zXnMOlSRMMqQRXQaTERMi88VQ1FHoU915lpKCcjYefwrzUffYe9dfcsxsGQcFhj8K5VYiGxioKjoOjHFWIxUcaEVYjHPNIoljXirMSU2JQT71cgTnFCIY6GLBNX7VPlyRzUUMeW9qvxJjoOKpGUmSxCrKnjg1Co46VIOorRGbJM44zTXJx1oP6UED8aoljy3ykt6Vz95eloZlzhTW5MdsLk9lJriL3zXJ3ZAPOKBwWplum6c7ema7nR4wmkAkDfuArl9PsXmlXaCTkcV3EtqLLToYSf3jfMTRFalV3aBRcIRyevaoZ8KMLy3YU9tqjLZ5qLIY8/wA66DyxDnbzjIqF2JGPSpiOp7VHtPPBoERqCfyqwhAGGGMUW6jBJ69qf3GRQIfGoGTmgZfkdBTVbJOOlPXoaCWLnaMenShT/FTwBzkUcDtxQAAAikPy9Oad2PrTOcZHWgBHwe3Sm5ABOOaGbHDdTxSNkr60EsUYIJNKT27UinjGcYoPHvQIkHyDgZNRsN3J4xSg+tNbAzimA3PPH5U3GAfelXGRk051DdM0wIs8HNRsSR8o5qRhximjk4NAFdiT1602piPmI7CoiMdTQBE/cUzoTUjjjIpu3gcUAIq5bNPZc8YpUXAoKkE80AegbFXIXuaZtO8joKkU4UE07cvNSbkeNoJOTSK+RyMU6Tg+tM2nkk0CH7sMPQ0EjnNIDgYpGwRjGPSgdwJ2rgVGHyxFOKEcjkUxVIJyDQMj2tu3DtU0WGjz396NvPem52EhR0oGhx2ry1QM4JYgcdqk+ZuTSMuP92gBkac7ieKkXPOenao41KA4yVp4yR6UAKF6kc0fdHBxSuwRM55po/eLmkUNJBUkVDI4BJyKlJ+QjrVdwNoLDjNMZLnPenhipyvXrTFwAAvApGJ6FuKhq5UJuLuS/bUA+fII7YqlfXymPAIBzxUjQiTh1yKgayhXJEQz6kVi4HUqyZMp3KD6ilIPGKSAZjA7ipVHFZtGiYL92ngUijFOApFJgBTgO1AHtS0h3HA0mRmgd6COaRRGw6mqzc5q0w4qJh3qWNFXHNLgY4qUjFMI5zSLGkcVBOu4c81OaY3Oc0hmaLVVB29KtW6MCOeBTivWnIPTpVXAeRVW6wI2JFWmOBms6+kAXGaLisZM3MhweKUFmAG44qGZv3mBViIZAp3CxNCuDWmsmLcgHtWclTBiV4JppktGfNCrSMSFpIIlXOwfNU7plzSxrtOaoLjtuY8EcVnXlmvLIMVq+1IyBhgipEmYXlFeo5p8adc1oTW49Kg8ojjFFiriwL3q9Cnr0NRxRdBirsMfK+gpohsmjUgDircSjHHWooxhiTVuMADiqRk2OC+tLtyakApAAM4q0QRgHPHSlxyaftIyRShcmqJK12cQEevFUZ9NiljwjqWxUniAuYlWJdzE9AcVk263hb5xsX/e5p2uCkom5pNtDZJ5kgBftTb2dppMkn0HtVeIlRy2T70pO4jJP4VcVY56tTm0Q1huUZIAFN24B2gUS8dBSc44rQ5yFgx6cDtT1HAyeaVnBOME+9ITgEnrQIcp2AZHFNdsqQKUNuQioz16EUCHJwcGpFbaxB7VCBzwTUgYgHPegCwjgigsM9qjjPymlLdv50EjieaYWGRSMw/GmFsHBI5oAcwBPPNNJKjGSKTdk8ikJAYADJ60CJQ2BnNIxOM4qInB9/SlDgNz0oJJNxIo64HemryflPFOyCRxzQAqADtSMeCBSsf0pq8npk1QDcEZpChxnFTEUjHAxigCk4JY010x0FWtoOePxpjKxJA6UAVMcYyKXaffFTlB260jjaMfzoAYFwp61FyT8wqRm7Co+ASWzQB6EFG0bufalBU546Ux+QRtO0+9OTATA47CpNhGB3ZGKaOSQR0oZsEAde9MJKjjOaBjkPUkU89eaahwOeTTmJ7GgBm45wMUpY4560gUjJXG6o/mJyetAIR3OcKevWnKueppdmck9aFAB4oGKxxwB0qLazA7jge1SkjBOKhZvQ0DQ0HYw5JFP3ANjtTVXcOSPrSt3wOaAGMNzc9KcDgcdB2pCNnzUiEuD1A7UDFZgFyFGTUL/NHkipiisvOR9KjcnZ04zipGCDKDpimsvze3bFTQLui54+tNbG7A6CqBDM/L19qVgQM5Jo6dRQ6knjpUNFIjQYZge/NSqMe9MPDCpBWElY66croKVehopyjGazNkKvTmloHpSikAmKMUv0pKRSGnqaiY81K3Q1C5xSKQxqjY0M+Bmo2bP1qSkIzDFR7wc8Ujk1ExIOaCiXdzSj2qNT3PWndelAglb5TmsK9kwx55Heti5YiJjjOK5q6fcxplJELPznvWlbHcnJrGL4NaenvkYPSgLF7GKev3aaeeRSIeDihEsbJ980mccGgnJJFR7uTVkE+4Zp6kGqwbHNTROCcjFAiYoCDUJiwTxxVpDn3p2wn8aBXIYUBznpVuJcdKSNOcYqwiYzTRLYgGDxVuMcdKhKkgY61ZjyQM1SIHjkd6COMUtNcZHXHNWQx2PTFCjnNIvA605eA3oBTJZi6w5NxtXPAqpGS0gyas7t8rvjg9KjAUN71pE5ZSbJjjnmhhjpTE5Yk9KkPFWjNkROOKizzx1qVlyO1MccYFMQnTrimllJIp6cg5piDLtmgQ5RkcmlyNh4poPXK0yQsFG04GaBChsjpinowJ/CoQMcmpFYDNAEq9OnNKRkUgbHYUZydvFAiMjnHQUzG0rj5vepGyD6VE+QeDQIcxP8PSheGBI5NJn5aQOPyoEPYcknmmD7ppu7JPNKpAJGaZJIrgcDg04EjmosDOeM0Fmzx0FAFhWGDk0A8fLVbPqTUgY4GOtCAlJx96lByDj9ai3buvWkZu3tTAk42nNM3En/GnAgqaZxtzmgBHwv1qLcS3Wlb79JxnNADWXILAc0wMBTweoxTcA9ABQB3YLblXHHU0rgbxgGmIzFWxg88U5QTnNSbDSDnNKTksSPlFI25VyvOP1oBLKQRzQA7IHJpzdNw6EUxlBABOPXFPG1lwT7UDGKSyDb3pwBUc9e1CYVMDoPSk3ZOaAEUkkjFIeuBx3p3YkYqIcZJNAxSVxgGotoLHIPNKHDMCpBHrS4bBLCgEMXqSARjijcQDwSfWnooyOaUrjmgZGFLn5u3NSY9OuOKEBJpwABIB5oGiNjtwD1qBnXzCpzn0qwR680iBdx+UbvU0hiqRtPHPSofnErkoAgA2tnqe9TjCKckFjUJZzgSbc98GkA0A5+YGpAMjIoHPJ6UBsD5RQMYyn0pV6CnKDnJpFxlh71lNG9F9Bw5HFKBQOaXGBWDOlAOOtFFApFCikA60tGRg0DTGkgdaqyck4qw4qnK2WIHSkUiGViSQKYRk/SpCAKQKOcVLKRGQfSo3561ZI+lRsMZJoKRAOlOU+pxUNzdQwKTIwB9BWNc6q7kiIFRTsUomzcshjZdwJrnbiFgGbFRfaZeSGNNa6l24OCKfKWkQMGU9Kt2DkA/WoPOz1X86X7Qqg7QBSsFjajlyOafHkq3rXPm/fACGnR6hIvU1SiQ0bvTjFRkY5qG01GKQbZAVb17Vd8tW5BBHsaZm0ViM8jNSQrgZqfyx06inFcNjHBoIY6Js8d6nTlOahQbafG2cg9KEQy3GowGNWUXgVXiOV9Ksg/pTEOGM1IgwDUe7jPanqRxk9RVIlkimkPHJprEgZFISSOKpEMUZJIzim3TlIDjqRipQMHFVb1+Qo4ApxIm7IzwQBwOKiDBmbIwPU09wTyM0xkK5961RykiIB8ue9OlbAwKhIYHrigngjqfWrJYY554NDgbQetIG+QMee1DHcMelAhoBHfrSkAD9KXPQU11LH2oEITxwaTkYz0p2MA9CKjbGRmgQ4jHNKi4BNA64zkU8cKaAAMSPxoIAzk1EDxjvQ4ODnrQSKMtyTxTSc5HTFJu+UY60gJIJIoAM4Jz0pCQvuT2pzr8mR1qInIyaBEjDaOaFAY5x0qMsehqRTxj0piY4YzjFLwOBzTMnnGOadHwDx9aBCKMZpAxzxilYnJBHFJgg5zTQEmQcZoYYGc04BVUbjyaV1XkZ5oAjDYGMdaQNTQCMim5ycHpQAuRzjmmEFSeTj0pcYzgUh/OgBmdqk0BgetOwMcdKQquTQB3C4Vjj6mpAQVz69qjCk5ZqNwDDHSpNh4ByPQdqczAk4qEOdx2iiSQAgBRzQBKWAzgZJqMPtHzLkE0b/wCEZz7U7aAoBHI55oGSjGCQKQjihSNoFNDcHGMZoAD8oqFtzHBxipd2etNbHbpQMZwMDHA9Kkz0xUT/ACjB4FSZG3I5FAIa/HI60m7jrS5yOOlGxR0zmgYKSG5NORFXOASTSBsfdFKDzwSKBiOBz1zSRL8xJNPZflyTmmwANyaADy8jI6imNHuP0qUOArH0NOX5iTwBigBnlqsZJ/KokBCncPpVheW65xSugIzmpGVTwxX16VGOJDnjNWSF98+tQzgbcj61MldGkHZig0+okbIp4PGa5mdcWAPBB60A84o9ab7mpNB5opAaRjQBE7Ek84qm+QTkcVal6EdqqSkDr1pFoQ00tjuAagnlKgnOKzbrUBEp2ncxosWkas9zHCpLsBXPXmtMzP5ZIXtWXe37yuS7VQNxx2qrGsYl1p2diznJpPM9KznuT1Wq8t7Lj5Y2/AUykjY3ccmo3lx0rGN/cf8APFsUxdRkIO+FgaAsbW/5Ac96aZB83sKxo9VBXmJhz3FKNRX5i3Vv0osFjQV898U9CPWsoX8RYk5P4Uo1GIHo/wCVNIlo2Q5C4B5qza3s1u4Ktx/drDjvEYctip45VYDmqsZs7Kx1CO5Ufwv6VdDA8VxVtKY3yG4rdtdQ4GTlsVFjNm30VvWmx9R9arwzeYoNWowGAPpSM2i7GCBmphkg8VFGMjNTqMVSJGRsxDKRx2qWPIAyc4opwAHPeqJJAuRz0pQvJOKReKkHNMlhxgk8VmSHfIxJzk1du2IjKjvVIqCMdOK0gjnqy6ERUspxxSFdq9c08rsQ4OTUZUsck9PyrRGJGuGy2ODQ2wA8EGnbcIRx7VGy/Lz+FMkSPBUgjAzxQAc4PSkQkZx0p3VaBDCMvx0pEdckcilIbGMYpjKQRtH1oEPGCSMcGmkYPtTlBXOaaxbPHNACKpPIFPJwCOtKOBgcUjjg4/GgCFsB8+1GM8kml25ODTScyEA4xTEIEy3y5NSqvBBoXhsY4PegEduaQhFLZII47U0gD+tSketRugzk9KAIQh3tk8dqnXG0jHOOtNCBgR0oI2+ppolhs75NLnA56UobIxg03gkj+dAhqsGLY5NKORnPfpUdy6wRGVmVQoySeKZFMJVVoyCrcgjmmBJN+9O1xlR0FPB+UA546VEcjp3p5GCMcUAPU5+gpBgMaQsccdaAvQ96ABgc01h8p6H0p+3ceuKCp6ZoArgkcDvShv1pcbWJximHOCRQB3jMSpC9aYqcAsOKhLs2COKFZi2ASSe/apNide4Xp601l7gjing/3SKRlJyM8UDCNOjA/XNOLrz0OO9RMxChBhn/ALoNIsZAXcME9utAWJ9u5MMfy4pu3am1Tx9KVmxhcHPqKVSccDigYAZHH60BQvNOUk9cEUmDnnAFADXCsp3DP1pAuRgjCinNxz1pEkBzheaBoaucHigNg4AzmpBjZ1waYD2PSgAXj2p2Tg0wNnkcijIY8Z4oAcCVyG5zTQwXkdPSmSPgEA5NLG2Rk8ntQA8KMdBThj8KaxwRnihDk9OKAJVCjPUU4kEYWo9w9gaXO3HPJoGhjn5sDPFRkGn5IzzQ/A571JSKqHDMv5U8cfWopyVkUinE965pqzOum7olDdRSds5pmeKAeKzNkOB6+tDcCkycUhPWkMimYBTluapOhJLDvVwqGJyMmkMZ7UFIx7mFyMAfSue1HTLkEPNLhT2XtXcGEd+vrVa5thNkED6mmjSJwselA9AWFTR6STjCEk9jXTyRBDtA6UhOGHHTgVpc1TOaOmsoOY9uPaoDagsRgcV1TOOjjJNZnlobi5AOAQCD75osaJmE9ryc9DUMtoApwozW5GqpcIGwynK/pVWaEFWINIq5j/2eNgOASaj+woTjAGa35YI1hiwSSUyc+tVdgzTJMxLJA5BWpFs0LcLV7ywvTqa1orSFdDuZQ4aXfGRx055FUiJMw49LV5E2qCX6DFQy6PIdwTI25zXXukItrV4iqlXDHHB6c0TYkEgXgs4J9xTuYtnnrw3aHah5rV03zUdRIh+tdSthCcFlHHTiplslx8qD8qlshsqQk7Qehq/avwMnmm/Z9h6GlSMjGOKzIZqREYFTrj8aowMQozVxGyKaIsSqOKcBz1NMz6GnA+9VcgfnBFPzwTUS5Pfim3Mm1cDqapGcnZXIpX3ng1EWB4xQCBkk0qkMeD+lbRRyt3GleDUJRsdBipSWDckEUxizZyCKsgiIG3GKiJOcDkVPnqDUbDa5bPFAiNc56U7GActSBspkfhTVXgN3oAkCj600qCDg9KcHGPSmgjGKBDOQvc0/jbkZpGxTVGQDzQAvfjFGQwxmk4HUgmmOcA4wDQAm9Q3BpI87jkYpuMYPanlh1/WmIcTztPHvSD5SRmk9ckH0oxnBFIRIoyp6GmFMHANABpd4zjOMUANHXAzTl74FA4U+tIflGDQiWBOOQOajZtoLN2GakU8e9Vr5bhoGFqELHghu470xGdGw1OOZJRjbJtAz1FaFrarbQrFHkhfWo7OxW3O4BUJO5gO5q2zYJOeTTAhhmDSFWBGDjkVNKVwSTgCoipMoYEAHqPeo7qFrho13MI1OWUHrQBJDIjllVgSO1SgEHFJHAkWdgwfU1IFOd2eooAQrjnpTRk84qQZx7VGxAGKAGvg545xUJUk96lPT6VETgEDrQB3IAVSFx+NG7nAFNL/3u4qNpm3AIKk2RKMYJPrSD5umc0hySMnil3AHaDQMdEiouVXk9akHIzUKs2fb1qQHapz0oGP5z1x+FN5DHsPSmrMMjcMZpW3E8EYoAcpAz2FGRj3zTAcNjtS45zzQA5zkVDGAWyARzTyvJIyT9aaGYSbcYXGfxoAcQQTTULZOV+U96CGYckYNG07Np6UDGq+4tjgCkDDcT1qXaoUgDimbRu3cUAI43KWPFNiOVJyMdsVLjgg45FRxKFLYHAoAm4ZR7UKAM8UiHFPVeWPvQAgUfWlcenWnFsKRUYHzbs0AEgIXgAnrURLsuGx+FT44/rULoCwPYe9SUQzKGhIbqKhibK4PUVMz53KQwB9aq/dfI7VhUR0UWT9KTOKVcMBSEY6VidKAE+tKMng00YoBpDRIoGPejHPSmg0FvSgtAenNQsQMmnMxz1qB3yCCaCkV5R1Y9TVRwQDg1ZlcdBVSVxiqTsaJla4dgKprIUZ8HDEYqa4l25FZ0s+CemKdzRMcXIOWPQ01pAFJzVKa5xniqrXDNnrTvcfMjTeUFVGegqPcpOAazmm4609JCe2aLi5kXCSW61ZtiyoVy21u1Uo5Pm5FXIXyB2NO9iGy9CuQQxOKu24UYPc+tU4WAGB+dXYTxSuZtlyMDpVhQAKrxn1qZWyKm5mxWHBqEpzxU/UUmKCRkfTBq1GQF5qJQBzUgHFCJJVPelzzxTQeKUcGqRmyTdtFQEgkkmlZsnaDzRwOe9axRz1JdCJl+bJ708IOxpRhhyKXaAD1rZGDIm71EEwx+Y/TNSk446GoxknpTEMdRs4wKikXC4zxU033cetMK5HrmgQxQFU4UUgAx9KeOOo5ppwQeDmgBuR6U1SOR1NKMAfMcUbAAcdKBDW+/gnApMgA46VHIDuz/D65pQhHfigBCSST2p3G35hTJGKHhSxPHHamjdg859qYExUEe1IVBBHamJuJyT9BQdxYjOKBCBOOaevyjHNLjjjNKAeQBSEJvHIwc9zQgVQT+tBXapI5NMBI4PQ0CHksOgGDSkbh8woU5T6UgbAxQhBkjJB4oBOKAQOtBOenSmIax5ximNjO00/GOgpjA7i3P0pgIw5GORUgGOmKh3bUJCk47VLEcr0x7elAEijjng+9DHgU0MQ2DyKUt7YoAOcHHNMI7nmn8hhjvSFcnrzQBFKMLwfwqFhx1qaTpx0qLA560Adm2WVQo570xQ24ZwPWp0UBT/SkIAzzzUmwu5fw6U0Om7JHA6UoOR82MU0jP1oGTDGRjilI+TtTATjIzmje2KAHL64zRn5jTRnJIFOwzfSgYpGD1pe3vSZ2ryaRHz0zQApzx0o2hm3E8AU1iDnOaRTgcCgaEwA2cU4nHGKTlgegpcY5NACrx3FMZhnJPftS7u3ajORxQAmxVJPIzT1wAfU0Yxk5z7UnbIzQA9SBwMZoDHcMg4Hemc8YGfWli3n7w9zQA8KSDj8qRg+eMYFKPlGQc0bsKQfrQMa+7kLioArKpBPepGbAyM5NIO+TzUjGlQe/Paqkq7XINWN2DUE3MlZ1Njak9QifHH5VJ1FV8EcjtUsbZXNcp1g1NPHNObpmmkZGDQNDfM60hekIqM8UFIVn6881A7ZFOcZqNlOORQUV5mIBxVKeRhnAq7Kp5qhOCODSGmZ88rNn1qhMWIPFX5xjPeqUgPOBTKuUZAT1phGKtNC3oQKYYz3HNO4FUrUkfSniGRjwpqRbaQHlSM07gCdKnjY9McVGsLjnFTxqehHNAmXLcggZrRhbgetZ9uOtXYs4pEsuxNxUytgdarRcmplzQSToSR1qROTzUSD1qdFJNBDZIqinY60oGOtLimiGxoHFDNtBNDHANRS/cwe9XFGcnYBuBLE8H0p7ZA45qK2JLEfwjpUkhBBya6Ejlk7scoOM9DSMeuKZvOeKdu/lVkMaRls02Tj2NKH+bpTGY5I4x70CDG5cimsMKD0pyqc/KRQ5HSgRHt5J5pjLz1/GpDnPpTWYY+lAEJU5Ib86XA2jac/1pd4JINIqYGV6+lAiJVy2T0FI3B+UACpmzg8VGxBXOKAG7c5poTb25pw4HUikBO7igBVJyQVHHvTwM84oHPOKFbBOaCQJCjHQ0m7rzn6UrAEYqPODwKAFzuyD+dIy7fQ0qnk54+tNY468igQo6ZzQRim9sijdx1pkjh05FAbnGMU0nOcHmnADGDQAEggAdQeaaM85pxwvPemk56GgCJ4i0ituIVeqjoalGFGc0xVbcefypSpKe4pgKDnnOKRyw96XaTjjFNIwOe1AD1JwQaGYDpyTTS4AFMZsZ5/WgBZW+UgHmozwBjmmlwe9GRjmgDuR8rMRk/Wkb5ucc0EjGBSLu3NUmwg5HNPFI+COvNMJwvGeaBkgal44pijIIzilx/CvNAClucdDTk56U3bk805cAEUDEkXdgdqUAHgdBQfvZz2peQB7mgBhHPpS4JBIH0oY80E44zmgA5xjvTSGwQaVskFlzkdqSLcyZfIPpQMPuge/Gad90e3rTD1xTwcjGODQA4H5RzkUZJ7jFJgdqFA5zmgCTHPJ49KXIGaiZ2LKoAVQM59adzgmgaDP8uKhBbuMGpScDJqNnJB9qQw3elM3Z+tKH+XnrTGOGGMf40AJx3zmo5cEg45NPPU5NRyMCeKyqbGtL4gC8YxUJzG3HSrEfK80SR7lPHFcp2DFPGaOoqFGKMVapQaBi4phUfjUgp20UDRWKAHmk2Z7VZKZpAvFIaZSkhY1Sntsg8VtMvFRlAe1IpHPrpry9QUWrUemxxJwgJ961yoA4GKY/pQNGRNbJs2lQKx5LdVlIxxXRXAGOKyJ1/esaCkVUQL0GKdgE9M0/AFJmgB0aAnOOamFokgOVGaIPvDNaEKDcKpESKAtdgIqSOLHatCSJSOnFRhBzimRcjij46VOifnUkacVMkQoE2RRxnNWUXA96FTB5p/AzzQSJTWbFIzAZqJTk1ViSWIGRsdqZfR/MAKuW0YVc1WnIZ2xyQa0gjGo9CvEvlqcdTR078mnB13EEdKXAPzA1ujlGquOppwxx1NBYHjB+tIuQD9aolgOcimuoOOvFKvGc+tODde9AECOPmA604c1IFUjO3BPakZcBqBEbfdPBzUO72qYnAxxzUIXk5BoAawLA+oNKh4PY0rAnikYYBIGTigBuWydx4pDyvWmqD0bvTlbkgdqBAAMdabsAzg4p52j71IcE96AAdMZphGT7U8gdeaaQMcdaCRMjpxSAEelHAHWgbW6mgBCQO9IMkYPSmNj19qXtQAnQ46044xuzTcAjPelC57fhTAUDB9/Sn49xTCcNn1p2RtJIoIFJHI601VyTRnP40dCDnFACIOePWpCMdOlAKnkDml3DoetMBmAB1OKY3KmnnhuOhpoyoI/nQBA4IOM03ORyKkcZJ70xjgYoAiKjmgHn+VOK579aCuM85oA7QKQ2d1LkkHB56ZFC9P5Uq9wCKk2GghcKOvqaVd3XtSlRy3fFKpJHpQAM4UcDJ6ULxyTj6UMAMcDNKDmgY9Wz6UowqsT2qEAlzk4APansu/IOcGgEP3B++BSsQDgdaTaMDkY7Uv+FAxNpPU844pnTg8+9SA9MdKYPmbrxQNApO3kZo5KntSMOcikOAQM0AGP0oJA5FHSkCj5h60APBBXNKOTTGwEIFOGCnoBQAuQWP5Uv1NIOHz1Bpj5Bbk5zQNCs2flBJyaaM4ORij7oyR0pjynOMYzSQxN3B54pMhiaQZOOBjvS4UdKAQx8ng1GAV+9zUmRkUjHnmsqmxpT+IdH6dqlC4+lQIce9WIzuFcbO5Fe6jJBIHPrVVXxw3WtNgDwao3UODkdqEMBIM81Oh3d6zGYq3oanin5waAL+MUcU1G3JzQWxQMCM0g5JpobNLuA5NFhiHiq0pHripmcYNU7h+OKQyCduDiqEoJJzViU5zVeU80FIrkcnNNAPQVI3XimZApgSRHFadsc1mRDnLYArQgwM46U0RJlzcMY71HjBIFR7+TzTlbLZFUQy1EMAVYVcCooT8o4qUnANAgNRSPgYFLJIBx3qjLNlsA8UCJGcjPNS2qFmyelVo/nOSa1LNMLntVITLI+WMjPasgtiRhz1rVY4Un0rKdlYkAj3raBzVBgQhiR+tPHToMU3fyKXdnjtWqMAxyc0fMeBxQSM4oJCj3qibCc55p/AWo/M6Y5p4cEcnFAhGzgmmZYjlqc3IwOlIBgYoEN25UnvTQPlpzHacryKYNz5oARxgDB5pgHXkmnuMdeSKaqnjHWgBcZB45puMdBSvleh60inPU0CEcAkbhzScA4GaVvvDGKOQOpoARj75NIFOeRmlpyrx3oJGlVbtjFMKDBHan9Aaay8ZB5oAj2lQe9IDuGCKfnPYYpMden50ARAbSRk/WnKCDTgvHrR0ODTARVyeKcw7c0/gL6UF+OBQQNVQBjFJgZo56k8UY4JoAUALmkBAzx+NL2PFIfmAxTATuKGOQRmg7h703gUAR7sjPNRuM9OalYAdOlMYc+uaAIwO/YU7qSOM04YAIximrgMT1oA7RjnvimqCAec56AUoAZuRQAAcLwBUmw0qeh704MNp7GmsxzjB60q5LDjigY773JyaFPJyKRic45pCSMEdKAHjcXOcBcYFPPB6mhfmWjGCcUDFJIAAo52Y6k0L1waCfmoAZyBgdqFODk013+bijOBQBJkVGRjJJNOBAFMd88DpQMVeARzSAncQTSb8HFMcdTjmgCb73Q0m4d6jDY4H3jTw4UDjmgB27rjmkySeaQnjIprtlTntQNDwQWOaYylj6UwMR0zmlySpLGpGLnDHpTWYseKb34J605cAnjmgaEYYA6A4qJ3A2juTSvKsaszmqUUhmnLk49qxqSsrG9KDbuX0qxEarxnIqcHFcjOpEp5FRSAMCCOakU8Ujr3pDM24g4JFUiGjbmthxkc1UmiUg0JlWI7a5C/K3SrpO7oayZI2UnA4p0NyyfKxzirEaGcUhfr0qv9pDDqKgmnwrbD83agCy8uBVV3HOarC6YJh8b/aoXnJzzRYaY6VsZqs8nXimTXAGec1Uknz0osUWC/HFML+tVfOyDnrSiUetOwjQjfNW45AFxmshJh0NWFmBHFCJZqB8ipI2z0rOjlJI5q3A+D1oRJpxNgdc0SThQQTmqhm2jg1Ezs54NMRLLNuJwetQgZPNBGBzSxZdiAOKALNuoc46VrxDaoAxx6VQtl2gYrQQ8cVSIkLNxGx9qxTndxWvOf3TfSssHHWtoHPMXBA6A00sQ3t60M2ep6UnueRWqMRpz1zQpL55pTn061EGCsQTyOtUSSHI4GKcM4OeppgIbmgHGaCWSHsBQ3A461HuPbpTkOF+bnmgQ3J3UrHGQOTTS+OlNQjB659aAA5NKqsGJPTtTlwOetOxkc0CGlfUUxlx09af16GkY/Ljr2oATb0zjimN97A708AAEmkxyTQJiBcYzSq2FbsBTS2c5pNwAx2oEBPNIzY+tIckZ7UgJPBoAB0IxmgLuHFGQOOlCsOevNAhQuAf60wAlqkyDwCM0w8dOopgxX569KQjHTr0oHTNNYkjP9aCRu7HvTkO4EmoScH3pVY9qYEpbB9c0bgB6GolYDORzTlyVyaAHFvlxQoyOR9KTIAOATTlOR0OKAI27imgMOAKkI5OPzpM8HHWgCLk/exntUZ6nP6VNLhRwOTUQGeTQI7NW3OzEY9MUjNtBOKAMcE80MMfMxyPSpOgRh3pw4GSTTRksew9KGbIOM0AOyGHpSBeOGJPvSdhRuGMZoAk3cY704Nx1GagLYPFO3AcHvQBKWyccZpMZNRt1znigHgnPNAx+cgg0wuBk/lSM3c0wEYJ70AOVhjJ60BuOe9Rd84oyeOaBkrcjPpSbj9eKiaQ5x2pELH09KBkwIByTg0gbB+Y596jk5H0phB454oAnD7QeaaHy/J61XclVznikD5bI/PFAywXw2BSluPaoGIUF3O1cck8Vn3WsWcBCNOrOTgIoyaVguaysAOopvmKm5nfCgVzPiDxA1pp4exT/SJWEabv4Se9GnLcJaIl3cPcTDlnfjn29qyqS5DWnDnNO5na4kJAIQdBU1sD6YqvCvQ1ci6muSUmztUVFWRcj9qsVXhqdelQMcPanZpAOtIDQNDXXdVdh1zVk9KiPQ5xU3KKTqDkmqcsQAJFaDLnoahkXBIIqhmawI6E1VldlBwTWlKowRVJ4+eetVcVjMknKnnJqBrvg+lXLiAHPy1QlgHpg07hYikuM81EZ6SaPHWqxB9aoZYM2O9L5oI61TYHv0pAvHWgReEo65qSO4OcLmqUYHc1Zh2joOaANK3kdsVdSTGTms6DJIA4FaNumTSJLEQLnJqyq7RzTYk2LUmMnnpRcmwzBbrU0S88dqj6nGKniBFMRctgccirS+x4qGD0qz7CqRDIrjmJx7ViJMV+VvwNbcvKNjuMVgXMYBJ5qlKxDjcnMgYjpj2pJGwBis8SGPg8rVhZVkbg8Y9a2jK5zzi4knmsMYBpfmkPzcYpEJzyOtKzDdgDB9atGY8fL0zinZyuBUa7lxuIpGfqR2qiWOJIAJOKRTnqaj8wnrSg7u/FBI/rk5pAeDzzTM7acnQ8A0AKGz0I4qRm5x0pgwATjFNZsfhQIkDYzTDzn2pSeOvJppbBxzQAobqDzTWODxSM23GOaUEEHjnvQAc5prYwcDGKd/KmFuuelAgBOMHpQDgY4zTX46UgPB9KBDyMjtmmgHJ54pM5GTmgN78UCEJK4xipCdwJqPAJ+anZwvHamJi8Hj+VISB7+1ID14pDgmgRGWU9OKVfu9aYw5IGKVOhB60wFVSxPX609csMHikVsDFHIB5HNADlGDk9acWGAM5+lR8ik6ckUASAgcUEAAg0wHmnenPSkIaVHU81CxYA8DFTtznHpURGB0zQB1wwAeOaCWOQQAKaG25zSBs5JoNxM7SaXPv1qNX3lsfdHH1p4I9OlAD8qRg9aQYxkCmfx8kUMxA6cUDFzg+9CMWTLDkU0dSTSc8/NzQNErHA56d6aH4IHbrURO4YJpmSuTQBYJ/KmPIQcdKjEnBIxTGYsNxP4UAOlkwuB940gY7QO9QM42kuQAD1qpPqltBkvMDj+6M0WC5pcA5PX3pCxBBHWsy01qxvGZYZhuBxtYbTmrolHT0osO5KJCWOSKXcB1OBVdjknHPtVa6v7a2G2edVYcY6k/hQkK5ZeXarF2G0HHNYmrarJF+7g+UtwCKpalevdzRCE7YEbdk8bj9K5/WtQZnNnbfNPNhF/wBnPVvbjNaRh3FcvnUJWgeeeZnVCyJuY4Zs8tj27VmafPvnZ9zMwPOafrWyCyjtY/uRqFBPfHesjSJtjNznPFVaw0b9/K095pkQY4MucD2rsYE3DrXn/nY1iwz1yWHNeh2fzYNefiPiPQoL3S5CuF5qxCPWoo+F5qWPjFcrNi1GMKalSo4sYNSDg0gHrRuA68Uvao2UNUDHZqOTmnZxwajb1oRSIWbBpGwwwaRxyaZuANUMieM9qrsoXjFXHIx1qJlFFwM2WPPI61RuE45FbEiBgcVQuI2XJPIp3GY08KtntmqMkOM4bmtiZVJwRzVKaPH0pphYypA2cZNMw3rVuWPk1GI+aq4WGwhgauwjuKijTnkZq7AmBgdaVxWLNpH0rUgXFU7eMrgmtCIgACi4micDApC2e9NLHHFNLE+lBNiUDmrMK5yQaqx5Jq9bjFNEsuRDgc1P64qvH+lTA1RA1+hrHuVGWHWthhkVmXXDMBTEZEyYPTNUriNJY3jkXcjcEZrUlXg+tUJlwD6inewWvucTrmnajprtdaNfXSx4+aIyE7fpmpvDfjS6a6W01Vg4b5Q7LhgfetzVHH2duQMivOtSg/eB04ZTkEdq6Kc76M5qtOyuj2a3lDHduBQjinkhgQM1wvhnVJLjTVEjEOh2sc9a1G1ee2uFSRg6t9wnjd7fWuhR6nLc6U9OlLjjPNU7LUYLwKInw+MshPzCre4446UrCuO5IGeB704kdR0phbpmgEEHFIB6nOc0owT71GSQfY0qkHNAD+nsKY53MQOlI59DTVU5oATfj5f1pSwVTg/jTWUg4ozwemaBDlkO3GetKOnzY5qEEYI7ing5WkIU4Cn1pOfWkPTPWg8UAOUZI5/CnYC5xxUaMfrinM2etAgxk5pvIBpenIpw5xn9aaExF+7zQRkmlPB6UZ7CgRDIpzlaYoweOtSuDjOOBUZPJ5pgSx9DSDknPWhGAXmgnGdvegBRkdTQxGCDTVIyQaU/XgUAJkY460mDu9qRhyQKMlc8HFAD85yBTD9cmkEnHvSbsA980hHV8AeoqPfg+1IzbV29TUYyRjNBuSqwxgDBpPmHaouc9acH5+lACtjd7mmMwGBQTljiopGVFJbIGO9OwE4cYLUhfI96zJNRtbaP95OoPvUUesWJYAXSFicAZ6miw7mru9aaZNwwaiSUsM44xUb3CRAtIyqBySTjFFhFlQACBVO8vxbnag3uR+AqvJqcRVhFIrN6jtWHc3El9c/ZrZxGiLuml/iAPRR71pCnfcVxuq6uURheuC7NtWKIZJJ9qyp/tEkRYW8gX3IH6VpQRW9sx8mPcx6u3zMfxqzONtqzYzxmtLIVzi5maORZEdkkTkDOCDV6DxbqMTAPLGyDuy81Xvrc3CsRwRmuauneK4VXHGMfWpsNM7VfFV5cqyQy7WI67QMVXe8eNVkkzISQGbqa5vT2In3LnAGK2rYXUwkRAsMR4DOMsffFNILmjeaiqzQW9s4aaXk/7K92NU7GNV1rKgkxqWZmOSTjFPs7aOCcOvzS4w8rdW9vYUlmpQzSZ5ZiDVWAfrWWjYnk4rnoJNkgxW7fSCRSB61zdySkpxwQaiRcTUilD6rbEdF4Br1LTWzGpPpXkNpMBqERwMV6rosoeBMkZI6V5lfc9Gl8JtKePenr2qFDkk1Yj5bGK5jUtxA7frUwGaiiHAFSAe9IY/pSZ45py9KaakYhAPNQS5UcdKnyMVDLyvtQUisWBqNjmnEYJqFiR0ouNIdwKaxprMAtNDAjrSuOwjnA4qCUbhg1KW6io5DxxQBRmiXBOKqTRKQcg1fc1FIvBqrjRlvbqfXFMEC+lXHXGcVGF5IouMjSIDoKniQgdKF6ipVbHSnckmiGOtTKxBqBDUwPHPSmiSXdzTl5qJSCealU4zjrTE0WYRn2NXLdSfYVQiXc1akH3cDpTiZssKBjAp4wKb2pT0q0ZsQ+1Z14Mtn0rQPeqVyMtTQkZshrPuiFU8Vpz9/asLV7gRxv9KENGBrdyApVGxXJ3JBzV+/uGZm54rLkbmtYbkS2NPw05CTrjJyCK174CSzILYcMCh/usOlYvh9tvnY65BrVvsC2yeCDuFehHY82fxEUF4+Fu4m2S7trgfwsOo+hruNK1AXtosnyhsYYA9DXmglWJzM4LW8mFlA6qezfhXT+HZGCTQgqWAOCp9RwabVxHXgkqc1IgGM9+tctpuv7oo1mILEHkdCQcGt20vYZ0JRxnuDWTjYLlzJYHdgY9KQMAp4/OkDbhx0ppJBGemamw7kiMTwRmgtzkCmb/QcCk56jpQA8kkDg5qE9evepgwxnoKiPqDQIG6E45NOUfKDUZbaDzk0buOaAHkgDk0hYZpvUHOOKhnkESljwPWgROZljBBIpyndzVZVWRFbnaeealV8Z9KAJ+c4xxR8uenSmI4JPpTxgEnNAmBYA+9Nbk0p746UwDkEngUCJOwz6VFIuBxiphgjHpUR+9zTQDEJwQRSg4pMHJ7CkBI4NADx940h4PNIOCaCSV45oAM9etIx4PrSFjtwaQcg5oAUglc00jAGTSscKfSmsc8jpQB0ZlBPtQCD04+tUTqFqiF2mj2g8ncDiqGr6/HaQCSF4zn+JjwP8atRZrc2p5liTdKyhfU1kXmuiMssETMQOGY4BrGudVutUVfsUYCkczSqQufZe9QtpQVc3NxLMxHzHO0GrVMVya512d4ZRPNFCSMKFODWOL5nAzPPMV5wSxq8traxt8sChumSMmnSlFGAAM+gpqKQXM24u5WQr5L7T/E2BWVJKFZllBQHoT61sT8scVm6jjbtYZFNoLlWPVb6AhY7uYJnoG6+1WLS4uJ5JZbp3YYG0MxPXPOKzorfzHwrsuTjjtWpbaVFDuZnkZjjcdx5pKIXLGjzy25lifdIWYbD357AVuy/6NAy8CR8M59+w/Cq+k2kVqj3AHzkcMxyaq6jcF2yGxz+daCLNqzN1IyTVvU3MdoCCeuKoWBDbfrVjXWIsuMZJ70wMsYwdvNYes2ysd7AY7cVvWoBiye1VtTRXgbHJqGhoxNMkWGQnjI6ZrUjusyZLZzxWE6EMSO1T2k2JME4x60kB0cLBSSwBzSRr+6lHHLscVBDICv3hntirWR5kqr1wGx3qxmUT+8ZTWVepi4JPStS6Gwk5rMu8thuvaspFwKyPtuVYeua9L8MXXmQIW+9jFeWO+2cegrufCFyQCpbjtXnV1qd9F6Ho1vyvzVai4aqVtIu0Ek9KuRnINcZ0FpTyKmAJGarx5A56VOh7GkBKOlNYUoHBxR61JRGRxUbVORmonX1plFOX5Saqu3Jq1P14qm9SNETNj3oDjBpjNjNR55NUMnLcHmonODSBzTc5PNIBj9/Wom5qRjwcGoW4+tMCGReT6UwjrUjtUeeKB3ExipE4pnFAOBQInBz0p+4etQpmnDuKBWJQTkc1PCSTyeKrqaswDIOelUmSy9BjOMVowKFSqdquRV9RtzxWkTKTHZ9aUc9KiJ5IpyN1FUjNjm6VVmORVlm+U1Ul5BqiTOun25yOK4fxHek7kB4NdPrtwIY25xkV53qdwZZWI6dqaQzPmkySATVR++KklPJ9agdiRxWqM2zZ8MqH88nooB/WtHVmxYsc4rM8IsDdyK/3WUqf8a0dS5QxN24ruhsefPcyNKZWd4pRujZcFT3qTTL59JvxGzEBCRG/XK9gaigXyJc9xTJlFzPKrAElRjjpiqJLV7qsU0ziKIxMpLBlOFOevFLZanPGpZJCD3JFc9uOCGO0jgn1q/BKpRQFJHsKAO30XVrmdY13qxA+bPBNby6giyBJgyM3IbGVNedWF4kLqrM0XIw3YV3Em240qEsyurMMMGz2ocbiuaiyq65Ug1KH+XGc1x900ttMUDMpAByDSwa1cRYDOsig87hg/pUOAXOtbnAzmk3gHGOKxYdfjPyyIVA7g5zVqHUbacMVmVWHZuKjlY7miACTTBkMaiMylVww/A1IH3dsmlYLjz8uStNLbshgMD1pgbBOelIWyDilYLk4bPp+FMY4JpqHA6UE/N9KBXJEwcA9qlB61AvXjipWyCMdKYh25hxTWJB5H5Uozimbt3NAD1bHBPSkk6E4qMHLUsjYBGOaYDuSMj9aQ5x1BpIjlWJoJxnFAC44NA6YoDg8UhfJwOlAASAOab0H16UMuO/FNZuRjpSAMDv1pCRjBGKU5HemnGMjrQBiQafdqjCaaFOeFjXOPzqWLTLcSrLOWuHHQSHIX6DpU5ckEk0jNgHnAxXWkO5YWRmmXoF6ADgCn3RIjPOazzMFZQDgAitBSrDaeh9aAuZtwQoDGqM8+WJBFT6vIIyyAnjp71gvclmI7ipGaiuGYYqrqwCxrjq1Fi+4fMeRTdXJMII7UwKFlw5yeQeK3oOVXcM57Vg6Wcytnmt+DGVHcUxl2/cRWoxx2GKwHmzyea09cl22oIwSDXOJLubkkmkB0mjt82MH1qTX5M2wA7NUGjvluPSnayQUUHuaYEED5h6YwO1QuN6nmm2pOG5zTLl1ER7H60MEZTA/NuAOD1qgWKy5B61oSEfZGcdzgVncsecUrDNzTnVto7Y61qDi8Zi33owoyPQ1hWRKx8cn1rcaRRNbtuGSCu000MzdRyNwAz71lSsWXHpW7qUfVh361gyHB+tZzLgULn5ZAcDpzXR+GJ9kyEtweK5+9HAZe3WruiybZVbPGa4qyudtKR7BpsoaJc1sQ4xXL6JMGjXuMZ+ldLAQRxXBI6UW1PBxUqmq8bc81Mp4zWZZYXkUpzjOKiVuOKkzkUgGk0x81IaY9MoqSAdxVGccknitCXkHtVK4GQc1I0UZe9QFvXtUz9DzVZzTuMk3A9DSk1Ap5p+aYCnFRMCc81KOaRhihsCB1qMgip3/AJVGOeoqREQGT7UtP296NtUMB05pwHrRt4oUfNQhD1FXLcZFU161bteoHvxTQmatqD74q70HWq9sCFwRzUjNxWsUYMQsNxp8fTvVfcM8VKjVRIsjcGqsjAKSe1Syms++nCwt05GOaZNjlPE1x8hBPBzXCXLjccGuh8RXPmSkAk4rmJj941cQZA5z71A7Y4p7HrmomwRx3rVGTNXw65SV3zx0FbWoZZVlUjOMEVz2jgmNjnGGrf4ltGX+JWyK7YbHBPcyL0lV5HJpmjENqcQbkNxUmqgKV9CKbo6f6YGUHI5ytamZV1CJVvZlUDaGxUlsm3JHSnXab72dgOC/HtRGAuQevSlYRq6TFFM7JMqspGDn3q3ldHMVlcs5gWQywN/C3H3T6EVQ0tys3JwDWh4iZbm0VXGQTkEdVPrQMz9N1B5NQnudSLFHJbZ1CjsBVWS9innlaAMsQbC5HWqJMyAqx3Dp05pkICgrhjkk0mI2UuE8stuAx1BPNX/LxbJcRMGiY7cjs3oa5+NdqncDzVz7UBpT2sbAEuGII460kgNRLiWHncyg9CDV+31aZQATnHr3rnoru4js2gTYys24FuSPpT4rxVUB0Yyg546EelOwHX22sRSsVkDI2PTIq/DMjjKMD7Vx8rFLD7aP9UTtKk/Mv+NMgv2iVZX3BD0apcAO3U55z+FOTpmuattXGSI51Yn+Fjmrg1douGhDA8kqeR+FQ4AbWQOBmnKxOeayotZsnO15fLb0cYH51dhnikGYpY3H+ywNKwy2GyetIT1IqEMAMEinBv73IpWAehwOaD60wsG+7S/jQA9GAFGePxpowB70m71PFADzjqBzTQeelGV5x1pOcGgBxwR7U1gNvp6UgOc0khGMfnQApYAetI2GxzSDpxSKASecUAZYBAySSBUckhbgfhSyShYyBjIqi0hUCuwCWZwB0yevFa1s/mRKwwcjrXPzSlgQAR6mtfT3xZxrxuA5pAUPESHCuuR61yzy4ctmu01NfNtHQ/UVw92NrMB0qbDL1rL84wSM+lW79hJDtU9Bk1h2khEmMkgcir0FwXdg2MUALpbDzW/vGt63bMoH6VztsfKveAApFblqwwXPBPT6UFFfxJPtjVT0JxisGKbkgHJ7GrXiK4EkgUtwBWZbYLigR12hyYTJxuIqbVCzKoxzVDRmHPqKvaiflBPJpjKEMwQMCDmobxlYD1pkshBPY44qJmzHuYnNIZNNCTp4yvPXisu0iJmweldHEpe1U8FSvFZrKIpG2DJ6YoAeqqsZXpmtAAG3hkIyVYH3xWLKX8wBiOvStmMhrMgD5mXCn0NUhMdf4aJjn2NcxOGDEHpXUy4kt1ZcEFcn3rnL5AJSB0xWU0XFlOQbkI45FFi209e9JjqO9QW7HJHWuWotDqpbnpXhi4BRcg8DGa7O2lDKCDXm/hi425XHBFdvZS/KAO1efNanejdRsnk1Orj1rNikBAwTVmN/esmUXlIzTs+lVlb3qVWx1qRk+6kaoS2OlAfjkUXGI49KpXHQg1dyCDVS4HPtSGjLkADYGarOcng1amGCfWqbfeOaZSG/jmpFORzUIp6nmgRMtKaYrelKpzxnmkIay5PFNK81LjrShaAIwtPC/SnKuTUojwaAK+z2ppUrnirZUelQuOp9KYESjnJq3aDnJ5xVRupq7ZgnAPOauO5MtjYhOVGeuOtK5pI/lTmoJ5MA8ZPatTIQsAxpyuMdelUWk5PJqPzvlwOp6mncixbmlCkmsDXLnbGeTWjK/fNcl4iuSrMAfamhHNanNvkfHbismVjk5yatXDEnOetUZcnitUSyJzn61C5x061I3p6VFKOOK0RkzY0lP3GeOTWpC2wEkVR05QtvF6ECrkjbeBXbDY4Z7lHVAGkUr064qHT5StwuDjHc1PfN8oI6iqtguZGLH5QOlaGZJC+by8Vs/fJGatxwCUFM7WP3T71l2Rze3OCSA3GTWrbN8yt3oEV7SQrLtbhlOGHoRWuzrNAVJzgcVla2PKu47lRtWVdrYH8QqxZyg8A9qBFJ12uwPUGmqMNkCprgjzCw9elRg8ZqRkgYEU0hWGSoPrTQSDTgR0oQDPLjByqkH1FO2tjKsQe2eaXoeDTu3b0poQy8u5ZbNbeYCMqwJ2/dcevsaVryQpEgKGJB8uOmfekkwVIYAj0qJIIip+UDPpTAk+1MFYMqlmOcgYIq1DqRWMqwJP8ACaomHAwrED3pvluvo31pCLtxcxyEtnBxyDUMdwA3HDdiODVOYHocjntTPmZlI5UelFgudFa6xdRKF892A6BuanOtXrEkSYX+6OK5+L/XCQngDGK0FXcgaTIB6AcU1ELm7putzeaonQsh445I/OumRwwypyPWvPolG4eWxQk9c9K3tN1GS0mWC9OY5MCOXsT6Gk6aYXOmBHXNIdv1pMDaGHQ+lNDcHFYuNikxwOMjIx6UBvQ01eASaCO/akMcpwTgcU489cVHkYHNLnnOaQCNkA449KROee/tQeO3FNIwMcj3oA5+dslscmoWJI57VIyEruIw31qNuBz1rtGirPJzycVr6VMGthggkHBrBvn284q74ckL27ZPRiT7UhmvPgq2T1rkdSi2Mw7Zrq5SAOvWue1tMu5UcgZpNCMGJiHPYVat22sT7VTB29e9SRPnjH40gLJfNzFt7nmt9XAjPpXOQNmcMOgrX8wbM84xmkMwtWk33ByTwelQ2h+bP50y8bMznJzuIotGw2DzmmFjqNGJ3E47Vb1BiT04FVNGB25/CrV997HtQBmHne57DgGqkrEqQTn2qzKQIyPSqDt867fXpQNHSxYW0RV4AAqhHCWlZiTxWjEA0SsT2FQj/XMB0ppAZs6ZuOOgIzWxCqi2+UfdHXNU5Fw2SOtXLYjYVz1FOwDrYl7PDKQw+Ug+nauf1FCJGB7V0UK4mlGcBgCOayNTj/esQDnHNTJaFR3MZ02gsDzVYgibBGM81ZlDbhu9KSVdyqw6qMVy1FodVN6m5osxSVeOK7OwuDgkH6V5/YNtdSTxXV6dPlcDke9edNanfHY6mxmcqxfAO7jHpWjFIDj1rCs5c8H/APXWhHJ2GK55GiRrJIMZqRZTis9JDjrUofipHYvLJmlDj8KpCTGcGl3nHWkOxcLACq8r8H0qPzDt65qNnJHaiwytcd/eqL96uy1Sk5/OmAz27U3cKa/So2OAaLAWFcd6lRsmqAbmrED+poAude9PQZqJDkD0qzEPSkIciU8LzQo44qYDjmgCAj1qu/erUg61UmfH40wIepyelXrDG4ZNZ/APPNWrVtpLHpVRFLY2XkCjmqFxMGJOcCmySjbVC6lyOnFa3MrCyT88HiovObd7VUeY9hUfm4J607isX5JQYyAcnFcR4gkJmI6+tdUJMqa5HxCrCZm/h9aqJLRhytkn0qq54+WrDDJNRMoGea1RkysQeuBUZ564qdhkkDpTYELToMZ+YVrDcxm7I3LdAIY14+UCpmII56ikTG7A7UP046V2x2OGWrKF2S3y5qSxtZDBLPtJRDhiKZMo3ZpsNy8FtcBSxVlIZc8H3qyStp533sxxgMePfFa0YI7YxWHpLk3RHP1rolA6jmgkZqcZuNMdQMsuGH1rN06U4IPBHGK3Y03ROD0IrnHBhnbbwSaTAuSkZOaYvT2oc7hnqcUimkMTOW71OvQfzquSN1Tryo5poQ4qOvamZOTmpAAR9Ka3PTrTAaQD2pmMfSngdcnpSMCegoAAQQaUnAxiowPmwakwCODQBG2GHOKi8kbvlGCT2qTB5FSwLuIpkktvbhcMTuI5welOnlOcVO2FQ4rMupcDHvTQFyAZ56V0mkQw6jbSWk4yD0J6g9iK5eywIwc9a3tBm8u+QZwGOPxpiZp6Fczo0mnXbAz252g+q9jU5v4VlKlwOdv41V8WRm2ljvoiwdQY5AhwSvYj1xXI29wZLqNkm8yAHIz1B7gj1qWrgmeixSBwSpzTxyCTXFnWj/aBFu3lwqACCOp9fpW9p+rRzu0e4FgMgjv9O9ZOBaZpk9hTgQP8KgRgwDA8U5GJJ9qztYdx55Bz26UxmwhJPNSZwORx61BMw4IoGYitleOT61XkY7gSc9qUMVDLkZ9agdjzk5rsApajypBx1zTvDLgeeuRknJqtfk7ST3pNBl8uaUYBzjNJAdTuDNg5z2rP1WIEZJ5IIArQtG3ZOOar6qMuhK9BwaAOOu12EKOvemR4Ck+1Wb8fvGJHeqg+6SeBUtDJoHHmcda0g2IGIzwpINY0D/vMgVoSyt9nODgYoAxpG3OwPc1Jan5ueo6Yqs5JbdnjNWbL5pBgcg0FHWaRnYvGMjNS3jZY1FppOM9B0p14DuPOc0wM+4AMZHqaz3YJMAx7jrWhdfu1ww6DOayZCHfJ6ZoBHW2zf6MpxxioSSsuehNPtCvkoM9AKlaIFwx6AVSAYVDY5602E7JlJwQDVllAUY646VUCnJJ7c0CLSjbKGz14BqrqERxnHXnPrVmEma3Zg2WXoMUt2oktl2nPepauhpnMTqA5J6UkUasrIDyRnNWbiMFz79ahhG0k4PWsJo1hKw6EFSQetb2nPlAOc1jbNz5HetzT4yFByK8yqrM9KlK6ub1pIQoz+dX4WPQZFZltu2cjpWhCTgYrnkdKL0TnHWp0YY61UTrnoasxe4qLDJAacAe9IKepI9qQxv0JqJ3YcVORVebIbGDQBE7FuvWoJBwT3qV+pJ6ioHJI6DFAyIjIz3qJxkHNTEfLwaifnIoGQElTzUkL4J9Khfp+NIjAH2oA1YW6Vchbpms63fOOcVoR4K5pEFuNQeaeT2HWo4RkDFSYyDQCIpD1NUJ/mq9IMA1RlB3H07U0BXwR1xU0bEcHpUOMMacDz1Iq4iZMx4+btVOfJY+tWCcgionAIq7k2KD5FQtnNXJAAD61VZTjnvTuTYjLsPXFZuqRCeMgda0GHY1G6ZGKpMlo4y4gKuykd6rlDjHJrqruzWQnI/KsyWzZCQMYrRSM2jFaMgHNSWEYN0pI+6Mmr7wAjpRDCFDk/ePFdFHVnPV0RORhiaY/CkVImCuKZIcEbq7Tz2VWG4n24pFVRC6soIIOfentgFutKjf6OWJ429SaoRhWDFLgEA4zjmungOYhySa5aBcPkNkZ4NdPY/NCucUEl63OYzjiudulKzsG65ro7Un5gO1YmsoUuCy9zQBX37UXnmlVuMd/rUDnhc9qWNtxHpSGPBxJ7VcUjbVN+c1PDygOcU0IlQDqDS4yDjmkRgSR2p45JABoAjGeaTnJzyKl2jHTim7euOhoEQSKQQRyKfHgg4FKw25xyMVEpKnjvTAkC5Yfzq5aoNx46d6jiAkHIq3GAuB3xQhEc457cVg3h+diSetblxyT7VgXZHmNnsaANKxIKe3WtWwcrNG2cciseyceWM961LX/AFqbfWrEzqvEYD6cpBGTjrXD3EOHMsf7uYc5HQ/Wu61ZVk06JcAggA/lXHzjazDsDSAzk8wEkhck5OKu6fNGLuNwwWZDnaTjI9qiIB5GB7Uwxhuo5HQ1AzXtdQkn1GWWaWSKIHOzoABWjba7HNclFUBM4D56/hXMqHjB+YsCMEGn28iRFTIhXByCOaTVwO589XBCvkgcio2Ykc89wK5uC6ma4E0UhdAQCAeg+lbLzr8oz85Gdo6kVLplXMpmwTg49qqysQCc0shJz2qvOWCkg8DrWxSKt0+VbJzmodJfbNJt6nAqO4fOec0/R/8AXPgZFCGdfZbjGrZxgc1X1Jz5g5ycVcteIAMduaz79suGxwOKYjF1JOc+vBrLlYBCOPpWzfqP4jxWBct+9IHSp6jFh4YetT30mI1VTlu4zVeD73JqO4bdJk9BUgQ7h+FaWmIpfOD61mgZOR09617AbVGO9MZ0NmflGOafcn5vaorTgYzwakuT05zVgUNRJMPPXtWJg5HHFauoyE4HHNZjrhSc81KEdLZ48tTjI4q/kEcZqnpoDW8ZI4AAq4NuducCqQwBO0561FJgDp261PDySOozUd19whaBEOkSsTKmQRuyBip4l2+YmT+7J/WqNm/lXRGcFua0gq+aW6bhtbPegEZVwgLHA5rPZdrkVtTR4dtx/Ks64jG8Ece9ZyiaJkS5YZyQQa6PSSHhByK55QVx0zWxocgVyjEZPSvPxMLanfh56WOit02gj1q+ijGQMCqsOPlHY1cTrx0rz2diJYzxgVOvIOKrpjnFTR8AHrUstMmXOOaeD6VGD6cCnDgVI7js8ZNRP3z1p3PrxUbMMEUDIpMYNQGpnzk4qFxmmkMhbA4qJxwSKsMMDioyMZpiKci9STUPTA7VZnXjiq4GDzihoC3bvyF7VpQNgYHSsqEkYGa0LYgcDp3pAakLACpVPHNVUbIHNSg/KakQSYOec1SlGCc/hVlz1NVJSWBz26U0BXbIYgUwMc/jT26Z70wgg8VaESKcEk01j1JpoJprFgOtUIjk681EwyBUrDPU00jg0xFV1BNR7easuoqEjrimQyu6gg8VRuI8HkVoEfnVO5zk1aMzLlX5jgVE4wFAHOasyKGbFQvjdha7sPHqcdeXQbkKcDjNMf72CeKc2VBJFQk9T3rrOMimAUEDnNQ3kgisSrDORjb61JJlmVRkfSotXUSRRgY+8APUUyDMjUDDDgHtXR6YMwAnnisW5XYFUDGa3tLULFj2FAi3b4Vm9CM1mamvnRmQD5lOMfjWlC2JSCODWVKwW4kQnhiQBQBkucrz2ogPzcHvS3ibJCoOQKihOG4PakBcOMNinQtx1pkYJzmg/K3TAqkBaU4NTrk+tVUPc1NG4B4oQEwGc8UgXinLkn2p5UY4FVYRWZTyMflTPLOc4qy4Axng0n5/WpEFoMZHerZBx9KqoAGGKupgjnoaaQFOXvXO35/esMYFdI4AJAFc3fDdcMB2NAFuykAUDGcCtyzGShHXI4rnrNgcAD8a6HTuSjDnkUxM6+4G7TlGeQO9cffKQ7HFdfMQNOBOelcbfy/viOoPNMRTydx+lOR+cVXdyG/rTgxJyKQ0y7vU8HntUsMSMcEE/SqiHjB61fsk3HOMChILkL27RkvASrjoQOasQ3MbXgkuCY7jjJB4OM/lUrqwlwnIGDTr+0FxZyuoBnRc4x96nYRnBiO+aguHIVgO/WlVwB7DrVe4cFWPcdPeg2KMp+Y1b0RgZXIByDWfNkcg/hWj4cTdJIT1zx9KEM6+3JW3B7ms+7yZPUdavR5EIz1x3rPnyXYgigky75wA2fTpXPzNmQkVs6pIACeCaw1yWJPc9qllE0bEAmq7knOeTmpn+VSOgqA8k8ikNEka5IPTnFa9quFA/OsqAZ2jPOa2rReF3cVSEalsRuFS3/CqRUcAAZcVPdJlRTEYl9ncpI5qpIMqQe44q5fqRyfWqjnCYApDOi0v5rWNj3A4q3OCF3d6qaSNtrHznAq7MA0JBpoYsDDaPTrSTqGDc81FaEltuOBV11Ug9c0EmFeMYbmEkZCkAj271sDEiKwJI7Vj6pGzqcckVa0a4M1qoLH5ev1poC1KCy7iBk9aoTrkHbjHWtNAMMrHIPI4qoVOGUgAipauUig65j461JbSNDKkgwQGAIpCOueDSxAHKt0Nc9WHNGx0U58rOysXWSIOD1FX1PtmuT0S8Mchhdhx29a6eJwyAg8GvInGzsenGV1ctAZHYVKpwuKhQ59amBA4NZs0JlORjtS4zn0qINjgUu8jioGPY81C2OSKXdyTnk01n64wRQkO5GTjJ60wnOeKcDn+lJ0GKB3Gke9RnKjpUjD164phBIpgQOODVcoCeOvWrRGemMVCyHORTBDV64B6VchOF561VVeRj61YjPTPSoGXomIHvU+cDqc1VjlyMAipTJgdM0WEOkcEbe9V3yTgUpbkmm7snNNAREYyO9MGSM9qfIQxGOtNUY79KYhgJyRikYHuOKlA6nuaYw4PeqQiPio26cVJgNn0FIV64qiSuxyMVEeKndcAnvUMnTPemiGQSHANUJyS2c1cuGyAO1UXbdkc1pFXZEnZFOb5QSevaqyHJYk1NfOVIXvnrVWvUpxtGx5dSXNJiytkgDp0NRNwxNS4IGQKryMBG2c5I7VqYiWwLTMSMVHGPO1BsHKIMH/eqRmEdhLKGwVGRnimaKoEBcglnYsSfemIZqMeJAwHT2rTsWJjBA5Apl3CHhYgcrzSWLEDBPIoAuRhi5OOaw799t8w/iBrehOSa5u/YtqDkdAeaAEvVzGrDr0NU48g56VpSKHi56VmtkMaQF2LOPWnycAcGordugzzU0i7hQhDkbIxxU0bDIyKpqcHHBqaM89KaAv7sKKkQlvrUGcKSOaltzkcVZI91UjB60iKNpHYVNgEdKaQAfagCMqAcjpViI5GAajJAGCKdCOTjjigCOZcE4zXL3x/0psdM11L53HriuSvyReSAnGGI4piJ7MkZBPU102mLnyx171ylmfm5OTXXaOCGjz2pCOmvGK6cDxnbxXD37/vmI5rs9Xbbp+O+K4W9YFyffHNAFffknrgdKsRHjjkiqcfLn61ciwAfSkBahG9gCOSa1LVDCCD6ZqlYxhyCM57ZrRvj9ntSzEA7SQT600gKr6rDbTFWR3Y9lqS51VEABQxggEFjwfasPRo5Lq8MxYsQSTxnNb+q2IvLVnAw4XPA4yAefrV2JbObE3OB3ptwxCkjj+tV1fMuM9RkU64c7azudNio7Eg5PJre8Nr8hJ4Jx71gSEFgBiuj0FdqJ6k96YM6KRgkWD6d6y5SAHPXJq9d8RHJ5rLnYCFyegFBJg6rIGc47VRh+lPuJPMkJxyTQOFJ9KkaI5Dk4FMAweT1oYnPfmlXngelBZPbjMg9BW1bg4ANZVkCTk1r2y7h15pokvWx5GcVecfKee1U4VGAOmO5q3jMZPbFMRiXvzg57GqxXOTyatXABZh05qKJRlhnmkM0dEYFSuScdM1pnJQ55z0rC0uTy7sqeARx9a6IAMmOxFUgZXi/dShscE4q2X6kd+lV5FOMipFIKgdxSEVLyMGNhnDYzWVokxivZYiOv61r3bY3d81z5Bg1ISgnAPI+tMDqZMHaw4CZ/HNQyttIPY05X3xKw6EfnSPmSEjAypxx6U+gyvcRgjI64qoNwb3FXUwysAenHWqkvDnGaxki0xZD5UizR8FvvH0IrqNLvVkhXJwfc1zKgSxGMnDEZH1p2l3DQyBWzxxXnV6dnc76FS6sd7GSQMGpw4IGeaybS58xQVOQRV+N9ozjd71xNHYiyTtPHWk3Z+tQl85NJuwevFIokY5zTc8H0ppbv2pjHI4qRko5Yf0pGPB9u9MD/8A1qVSRwTkGkNDCxPNBzt5pxHz9eKQ9cY4oGRsCM4wKiIIOT/OrDYI6GoyCev1oAiQc5zipV4qNBjINSBTmgCWLGeelSFsHCmoFPPHBHapQQRSGOHHXk0E0EgdqaWHbtQAEDPpSBQDg0objijOefemSBximEEEmnsMHNMwDmqJGnAOKRl4zmnY4yO1Nb5h1qkSQSnJx1qtK3Hb8KsyAgEjmqkvIJqkQypLyCOfrVRgFOccCrMowCDVG+lWKFmOTxwB3rpoQuzmry5UZ17LumI464FMUcdMmo4gXJZjz1qYEA8HH1r0UrHnNiOQE54qqRvYheg6mpblsjAxgdahRtqZGMn19KskramxxDBu3Kw59uav2AEcSqMnHfFYzMJ7sMMnAI+tbVuMKOMn0pkl1TnIPIPrVVAI5sDpVph+73AYNMXkYON1OwE0Jzn6VzN4cXkh65NdQo2xtjGQK5XUBicnvmpAtQEtEPWqdypWQ4AA65q1bHK1Hepg7iOvFSMr27HpnnNaIBC+1ZcZK9MitOI5TrwBTQEL4HUE/SpI2yBnIIokXI3AHmmpxzTEWo2+Qg9T6VPanqCPeqseD0qzHkcjr7VaJLi845xQcemaahJGaeeFyRQMawBHI+lPiOENMUEk45p33VIpiuLHy+PWuR1ZdmpXAGMbq62H75OK5TWv+QpcE8nNICK0PzjOM5rtNJBMiD2Bri9PXfcoDzzmu30rHnqeeKBGtr5xYD1xxXC3jAyYHXOa7bxDJi0QHpya4O4YPK316UgEjXLdce9XoVGME1XtxyOBVyJQWyB7UxGppMYLHHUdKp+K7jbF5Z6A4I9a19NiAAIHPc1ymtjz9dlUksoIyO1NCNjRIBb2kLocDGWz6GtOSbyraUMwIIJP05rN02RYwxzgFNhQng+496q6tORCY0bkkA464phY5+N8uDjgVLK27HXpVaI9MVO/3Ce+KzOgrrlpQB2NdXoijYpI6AVykAJlXoOc12GiAHOeuBj6VSEXL5hznGO1ZGoyFbcjHatG/I3gVh6vJj5SeMUAYpGXIOATTpQBHtBPPemxZySwzzRI3XGRUgiLOMdTUkeCQMUwHoOc1Zto8ncRk0IZftI8J0ORzWja4yaqwqNg7VdgADDI5qwuW4QSSKuqA0ZUdDVOPdkkVbhJJweuKQjFvECzsOagUYfj9KuanGROSDnPNUojhuaBokUGO5VuoyK6OBiUBzkYrniQSMYGK27GQmEAkYxTEyZsNkDjFRKxDVORxjj8KhMZUk54oERzYYHHpXPagQZwSMEV0DEAc9KxNYjAkVl5B60DubOlPvtgM5+napGAilO7PzcZzxmsvw9OVcxE8E1r3a5XAPfPIp9AKyttn8sA465qOdOSQakDhwSD8wOKAMgj04qGhpkCny2Dg8im3K+XKJk+6/p2NEikA8/gaLYeZE0ROW6r9a56sLo6KM7M09LvTGAC3U10Nrchh14rhYJCrEHI5wRW/p12AACxz715co2Z6UZXR0ZkwMjn2pwYMPQ1Rhl3DJOCasA5APHNZs0ROrdaC2CKiLYFKpBqRknBo5A65qPPWgZ6nmpKJUPBzzSnkfjTFOKkHI9qQxpIwcNUSjJOafKRg1ErYzyelADgcjBz9aepwtRg4709ckYzSsMdkZHNOVsdKi4709GGKLCuSA96aSCaQMPbimgE8mmFxeexp8YyDmogSCTipVcbcjvTJHLz1pG7gUiuAPrRnJ6UxCYwMZqMjGTT8jODUUhB71ZFyCXJzjjFVnHHNWX4BHrVSXOGFXEhsqTMDyTjFc/qs5kmCIRgVparMEj2jO71/pWFGC8mepPrXo0IcqPOrz5mXI0AjA7mmsADjJqQjAAI5H51A7DceK6Uc5A4+fA71Wu5REhIPzdAKsA5LHHAOBis2/UNdBTxjrTEx2nx8hiBya2YAcDk8VQhVVC9iMVqW65IweKpElnBMPJxUQXng8ip3GARyRVdev40CJXJERIrmr8bpMj1zXRXTbYDXPXB3Nz0pDJbMAKB/FUt2u6IjHNQ2pAq4y5jJHPekBjLkMc/lVy2b5cEjJqCdcFs9aLc46nHpSGaGDyDjFQPkEgYqeMggc89KYwBbIpiHwHtViMkCq0ZIPIGKm3YGfWqRLLUb5PpU4+Yc96qRtkZ71YjOV5poCUdMelMYZOacBxnrSMBjrTEPtDmQgjINcn4g+XWboDgBh/IV1tpxKCOwrkfEJH9tXmB/ED+gpDGaUCbpCD35967TShmYZ+lcdoWGuWODgDP412uijLgnr1oESeKWxAik54rijgue5rqPF8n7xVB6LXLRAs3rg0AXLcYAPXNXoBz7GqkIHStKwjyxJ+6KBM1UkS2sZZXJAUZFcdbuZpZbgj5pGJA9BWr4husWwgQ4L8EA9qy7YBIhgEDHamgLDXBVdpwcHgjtUK7pHyec85pkwGMgdetT2oyQB6UAjHiPOD071M2NhA6VBDk5OetSODzznvUo3GWozMAexrstHACbhyBxmuOtTicHtXY6SR9i3dsmqEMuiGkYg1zuosWnwDnHWt6dhlj2wa5uc5kY9eeKQETAqpJHH1qAnJJNSyElfaoVOTxUjHR5ZunStCBTlQOB/Oq0C5JHU1qWy46jk00hEqAgjB61ZjIUgUxF28tTuAeaaEX4SMZAq5EON1Z1s2CADx71pwEEYpgZuo5MgOOKz5FwQe1aWqrsYEEkHtWe7AoR0NIYKQfpmtKzIEQwcYrKhJDjPStWzAKEelMRoL91eabIMZI6U0HBwSc+tSOcx0AVJ87ecCsrUMke471rTEeWx74rIuRkHJz6UAQae/l3UbD1wRXVkZhDFcgiuQQlXVgehzXXWbG4sVGcgd6ECM1gYZX4wpPHuKcp2kgnqc5FSahGGUuVIKjAGarRykoo6sMAk0DJJRg49feqPmGG6yOMVfzvUEdfWs++jLMzgdPes5IqLJbtVDLIgOG6/WnWsw6HjB70y0cT27I55xx7GoVJVufvDrXBWhbU76NS6szpLS7yME9K04pcjHrzxXKQylRxwa17W4yqnJ+lcckdaZsK2cVIhwTVBJcnINWlk6dKgssBsjjoKUvjGR1qFHyac2WHpUlEynJ5pQx7dKjB+XGRmkXOetICSQ5FNU8Uh6/zpCM4wcCkMcDk807j8KiPU0o5AJoAk680inBPoKauGPHSj+I8flQBKoxkmlJxim7+OBSctzQIceTg80dR6U1unvSKcGmA8cjnrS/pTS3rxSO2QQBTRDAk896ic0pbCkdajY8GrJYjHtVO4faCxPSpS3BzWPrdzhBGO46d63ow5mYVZ2RkX8xlmfDZBNJbpjJ7+tQ43N6mrEXAPX616cVZHmyY+RuDjuKqTNhCO5qdjkHmqxJYk4HBI+tWQRzMY0GzkkdKzI90s5LE5zVvUZMRxhgQ31qtaDLkj170CZoRL0zyc1r2qkcY6VnW42kdz1rWt+RyKoRJJwvSq0Y+YEdDU9w2IyAKgh+8Ae9AiPUOIuPWsRuTj0rZ1M5QBWrHQZJpDHQAA81fj+6celUkAzz1q3btwfU0gK1xGCSxAqiBg4962J1ypGOSKzHXDEAd+tAFiEgKMGlI5x2qGMgDByDU8fPU54oAUA9qkB4AIpAOPegg5+lMRLGcYxVmE/LVJWINWIW6/pVIRdHTGKa3J4HFNjYnqaeRnkdKYkLZnMxGO1cn4iONbvB3BH8q6+zO27XGDmuN8QH/ifX+em/H6CkMsaAnLseo6V2ei4yPT+tcjoOBCxPc12OjgLGSRwRmgRh+KpQ96QM4AxWLbjDHmruuuDeufU1WtACcmgEXIccDvmtKIiFCScDrzVK3Ubvb1qPUbgJHtHU/pTEylcyfaNRb+6KADuA6DOKisF3SuSeccGrCIBI2TnHNADGBL47Crduu0E9zUEI3EnPU1ZAOP50AYMAAH41OVypH61DajPHcdauCPKdfekkbFKH5bjPrXZWJCaUrEYJBNcax2SMOhBrrihi0+FD1CgEUMRRuZCInI71hynbnnrWzesPKZT3HWsC4bkKOaBoZJk96amcjAzTip79PSp7aPkdzSQFm1jIQNjk81pwLlQcc5qGKM4BHT0q0nCkelMQ5wTyKRVyOe1OGMAU7gAkgUwFg+97VqWxJIx0xWShw3ArSsyQCDnk0AO1OEPGCOcdawnBG7HY10coBiO7PFc/dKQ7Y4yc0ARRnDAjnPatmzICAg5zWJGxA561rWLDyxkZ5pAXGHzE9j71LC+9cYHHFQOAVOPrUcTeW/XANMCe4Tg8YFY0+PmByPStu5y8YKHjFY9yCVII6UAUF5GMV02hSE2pHoa5mI4Y8Zrf0FsiQHgHmgC7cou4seWxwPWsWVHimZ94wx4A7Vu3C4GRxzWVdQgJIw5c/NgdqYxqSYYAAAYqSVA6EHGSKoxSbgAQQcdO5q7GcAEgVDGjMQG2nOBxnJ5qzcoJEEq8euKdeQlgXXg96jspQcxucZ4xWM43RtCVmJG4A65q3bucjDY7iqU8bRSlCMc5qSF+cd682UbOx3wldG5DLk474q9A+RzWDbyZOfStG3nJ9qyaNkzWVsDPanByWI7VUifLYJ4qdT+FQWmTggEUu4deahJyM+lOUnJHapGTb+eelIemQajzgc07+HJ6Uhjs8ZJpevTpTNw44pW4BAoAlBAFKrDniolbIIPWlGAM0CJM5HHWlDDHNR5wOOtJu55oAeeAaQnvSK4xgjmlxkdqBCFhxSBse9DYBwBTWx61ZLBmGTmomICn3pZOeh5qJiAuT0qkrmbK9w+xGYnGK5m9nMjkk59K1dauAsHlrgknJx2rCTlwG/SvSoQ5YnDWnd2LFuh8vOBzTyAE9zxT+APlH5VC5ya6rHKyCYEAgHk03cFh+b6UrkvIQOg6VWv32QgYyScUyTPuiWmYFty9jU1oMYGOtQbAoBORVu1XJB6imgNCLj6ZFatsDsy2RWdbDccdhWpFkL14oQiG54BAPJpIs4A9qWYZIpUUAZzxmmJGdqTYbA6Ac1nJndWhqf32PtxVOHr7AVLGh2ME1NCcEY6mmSdcAURthhjrSGXygZazLiPZJitSIkrzUVzHuIOPxoEZUwKEHBqSBgQCOtS3iExjjpVOElXI6e1AGioyM0EDFNhfKnJpW5Bx0oQDC2Kkibnk1GQMHjmhGyAaok0YMYyDzUrHA4NQW2DjB5FTnuapMQWxxdJyetcd4gO7Xr8/7f64FdfA2LqI9cGuN13P9tX+OSZTQM2dH4tUJAGRk11mnDZbM2e2PpXL6cuIk54I6V0ZkMWntg9qliOY1QBronrmmQAA8dqS7cPKSfpSxHAzxxQMtowA6HNZuoMWccirjOAhNZ0jF5AMcZpolli3ULDvHXHNPiyYiWABPApkqbYQM+gAzUjAjy17dcUwJ4IyAMY96mPp3oiUjp0Pr2qaCPe+SM/1oA5m0GZRnOTzWo42oSemOKo6Yu4gnnFXL1+Aide5oNTLfMtyoUZywH612d84AVMcAAVzOnQh9RgUKTlsn0wOa375v3nPQCkBlao+0Ek8YxisLIdyT+VamqOD15NZMQy/HQmgC0V3leM1fhhwqnHNQRxEEYP4VpRoSBtoSAmiTKg54xUqqAOB1pkbcYA5qRjgACgBuDzg1IFz2waYvUZ6VLkEYB6UARKSCcGr9s+Dgjiqka5OTjFWYRjqeKYF9gCDnuKx7+MEkjI9a10wVyT9BVG+XIYCgDDBwfetaxwUwRg1nSx4OQefpVnT5MnBoGa/ATkdqrFQSc8VMrZQgdBULDnnoKBEkJIUrmqt0hA5qZnKcnFMuG3x5oAyWxu44atnRjiRcdMYNZDjcxI7VoaTkSAg80DsdBcj5BkVm4AdgercfWtaQZQ5NZF7lHWRSMrnHvTEZk8JjuHYkgscgYwAPap0kwo7+wqW8jae1E7bRwDhT2qjG2cAHtwKljL3G3BqheRGNw8YGAecdatxv2IAp0gDAg9xUNFogz58PmHBYDiq6MSc9KWFvIdhzt9KdOiqQynIIzx2rjrU+qOulPoyaGTac9qtwOM8kgVmqQB/hViN8bT2rkaOpM24ZMEZOatJIfqKyreQEc8Yq2r5GM8dqzaLTL4figSZPpVZH681KDiosXcsq3Ge1Pz8oxzVYHinKTUFImBwetLzioc57808PkEHrQFxynByc5NKWPPPFMo3DBoESBjjOOKNx/CmK5C4o5NADixyRTkc4OajPenoRjFWTcd068+9Ru3X3pXPHA4qFjnk9KaJY4kAHBqrcTCKJixGB61LIcViavOciMnkc8d66aFPmZhVnZFC7lEsrMScVCq4INESl5M9qlcAEY4r0Yq2x50ncdvIGBULNhS3rxzS9Dgjj+VQuS0nH3cdu9aIgImKBzgEYIGaz5T5kpOckVaupAsbIAdzcVCE8uM5HOMk0xFKdsNir1mPkGe9Zsp3SHB4rVsVyg780IDTtYiSD0rQAwp9qr2gAABGasy4CfWmJlViC5qSMZHNROBvwOtTqAF47UCRk6n99v0qpCoyvrVrUzl6hgByMdKljRMyjGTimKPTg1KB8tRkADOaEMswEDjJyKtYyMYzVG3kAOTzmryMGUEdTTSEVbqIFSB9axJgY5Bz0710VzwCR2FY15GAc9zSsA63Ybee/NTrgg1TtTwRVhHwCDnNIB2Mbsmog2AcU5iSfrUWeTz1qkSX7NsY681oYyuBWXatgjOOK0o2JXJNMBkAIulz2Irj9aH/ABPr0DkmXp+Arr0O2dSTzmuT1fjxHdn/AKaf0FMDc08EBB2rW1GbZYNgAjgVmadj5Tmn6zNi3254NSBis25yfzqzFyAOapRHqTnFX4+FG2kBFMecVFEm58Y6VI4zJxUkabAcdetUiWC/NOoODipFIa56cDio4wdzN0PtUsKnJOOc80wLyAOcD8K0rK3ONw6Dg1W0+HcRgc9a05m+zpgYGQOlAHH6dCI7dcgEgCoro/MMetXYkxEB2AxWZeNiTj6kCg0NPQl3XxcHIVD+dWrt8ykEHGOtVvDJyLp+wAAPvUszgkg8kGkMxdSI3hSTzmoLZAZAOcU68cPKT6E1Y06MM2T27UCLmwblANXYVHIqtOAhXGM9qsREYyDyOtMZJEuC3sKGB3Y71LFj8xRjDEtQA3pgY5p6AAc/jUbnEmBnFLnINIBUILEjp6Vbi5T3qhkqfTNW7Qnkk5BpgXYWA69qjuQCpPr2qRcBOKGQFCaLAY8gJDdiOMVDbny36kAmrVwp3kggDpiqoBLc4xQBqwNkAZwPapWQEDPWqcEgAA71bV8jnigCrKAcqTyKjAO0qTkdqslAylj1yaok4Y8+1A0Quux/erOmsFmwe4quVAJJ5p9qQsgPf1oQ2dagDRgn0rK1dFEfBIGcjFXrNiYACc8dap6mu6PBP5UCMbSZAJmtpHYDBZS3I+lSXETJIuxcgck9B+NZYkMd/knjOK37hPNR1GQpGODQIrgZbdng9h2p6nGen481Ch2yGEHJAyQDzmnx/eORikUmQzqSxOD9MYp9owZdhIIPBHYUlzkMD2AxyarqxBJX8u1ZyVy07ElyvlyY/hPekViOg4qyCJoQHxkjqO1VmQxnAOfrXFVp2d0dlOd1YtxS/KBVqCbGeTisuNtpqWJznk1zNHQmbKSHHbpViOTI5H41lROexOe5q0jnGTWdi0zRjYc89alBAU4NUoXyMHFSqRn2qLFXLCkAZJozk57Coc89eKcpB/GlYZKGNKDzxUeQfqKUNzzQBMz/AEoB7ZqMeppcg5piHbxnB69qAcDg9KrSRBpVkLEY7A9amDAKRmmSSBs5BpkjYpueM1HK/DEnCgZzVxjd2JbtqQXtyIoCxIB6AGuaZjLIzMevYVPqdyZpyB90DHB4NRQoCu49O1enRhyo86rNtj0O0DJHHemM5357enYihsg/Xv61GWGcdADyPSugwGSNuyckZPA9KQsY0Oc4zSKMsWJyByPeopJtjE5BDcY9zVEjIR507HnCHH1p922FIA49als4PJhGc7u59arXzgVLEZnVj9a2tPI8sZrFQky8nrW7p6gIBTQzWtwCARU8pG3JpkGCvAoucBKaEyBW3Oc49qnBAjOe1V4/vZ7VNL/qWx3FAkZF8dz+tRxD5RzTpslj0pYRng9qQxwBxgmkcADrzT8Y+maY/PAzSQDY+BmtG3wYwQcYFZ8Yx1q3bHtniqQi1Ko8sk+lZt1FuTOOnNaeMx5P4VVYFsjvSsCMWFtshHT1FWwB1BwaguVCTkkfWpkIK89qVhiOcEegqLqzEdOtSOM89qaBjJ9KaEOhk+bHFbETApnocdK5+MkS8c5NbVvzHn170xDm55z0NcxrSBfEM5PJO05+orppeFxiud13B1okYOUT+VAGta/KgI9M1S1SYuQo6DrT0fbAOcnHWs6Vi7EgnGaQx8IJ4OMVcyFTHt2qtbr0JHbpVpVOCKEIRFDGp2TaoBOPrRFFg5xxVtofMTkAgDpVITM9BkEgVatIi20DqahRByoJPHFa1jCscIkY4AHPpQxGjb+XbWxLEB+lZF9dPNIyqcjHXNRXt608pwQAOAB6f41VLhFJJyfSgdhYDug6gVlXyYlI9au6c4+ypznNQ3ih2YjqB0oLNDQxs02V/wC82B+FRSvneccjsKt6eoTREPdiSKz5cgMc0AZsmGkPB5rU0yMBCQMdKzZFy4I6GtmzUiIAdqQCXQxIB2AqS3GUJAwe9R3mQ44P4VYtRjvjjpTBDhkHuM1Kd5AwKa7HIOAeKlB+QADJx1oQytI2G68+9OQAjPU0mwEnJ5BpQCBxQISc84HaprE4UAnkdarTZx0xU9kSBg80AaK52Gnggx4zTEBKYB4FOQHBxzigChdKQcj05zVIYx75rTu1JUkggissg7iBjFAyWJsPk9AK0UGU4P4mslWIJySAav20hKgZyehoAlIAByc+lUpeCSfrV/AyTVe5UYORz60AUtwdsA8CpIQob5v/ANdQMQsoAzjNSrwVPFAHQ6ewMeB1AqG+GEYGl0lx0P3j3p98vBJxzT6DOO1DAnJ9DmtrS52e0C5BBI56nisnU1/eHgA+tP0OYo5QnKnse1AWNO9Qx4kRMnPJHX606OQSAlTz6CrjoghIIJ3dB79qyEzaKxmYgE4B7n6VIhbxgYyCAD9apwy5O1ic9KtXQypIGCazWBWXnn60ikaykggcf0qzIqyoByGHQ1QikDKMHOO/ar0TAqM8+g9azlBNWZpGVmVeVJBHI9aXJBxip50DgZOGHeq7ZDYI5rhqU+VnXCaaJFkIOBxirccuQATz61RUZBOKcpIPWsLGyZrQyDpnOKnR2BGTkVlQy4IBFXI5g3Q4xUNFpmgGAJHanqeOOaprICevNWEYYzmosWmSqxBqRWBzxUKnPSlUgUCJgxPHagHmmBsjqKA3IoFcex4AoA6HtTTycmmlselMVxzHAwaydYuyieXGeT27Vcu5hEhckDHT61zc83mSuzEtk9PT6V24enfVnLVqWVhkXzEg5POT7VbPyqOce9QwAIhJye/0p5YnnIP9a70jjbGtk5x+VQtg5BJBPAIqRmABwDjPT0qHcqZZu5wKogR2EeAchR147VDpyfa7lpQuI1JwT3ply5kxHCwOTz7ZrWsYVt7cIABgcmmIJFCgjPHasTUWG4jNbFw52kiucuX3OeT16VLEJChduOMV0GngKgBOTisG2P7zjoeK3LUngdxTA2bfAQ9abdcgDNLCMjJOeKZcHj3piI4Rk45xTrhtkRxSQHGSaZqBAQDnJ9KBozJCCcZqWAYU56moCcnJFWYR0xSAfwQRjiomAGcdalJwcVG5BznikAzcMEdRVq0wWx61VQDPXirFsRkAVSEaDAbccYqswwxOKlJOMVC5JIINAFHUoSYw47dRVaEjbzitSVS8bKecjvWJGGSQq+etIZYfGCAaaenFKRnimucYzSAhzhuOtbFkxMQHXiscDL8YrZshiOmIlm4XPpXN6vg6uhAGdgz+tdBO5wQM1zt+S2p57hQDQBPIxEYAqq4JOf5VM5BIUn86aUwRg8UgLNsmEBPUirUSHA9KigUlRjt2q9EhC5IqkJjG+QZPA7VftkDxEnIIUnPvWXdyEYBweelb1igFmScbHAFWSZvlMSAUAzjGKNTmVYlgiJGOSQf0q3dSrbxliQSeErBm3MSckk85pDIpJAPu01CXOSTTJBg9OKlg+7zjmkCF0og2yjHIp0qgkkdRUWlE/Z+Bx2qww3exPBoLZqEAafEgwMIOPrWROcZB5FbN4oSBQDyFA/SsOU8kDHFAFXaTKMdM9K27MnZjFYsWTIMnqa3LMHvQNEF6CZQAQOKmh5A5pt4AMMO1FtggADvmgRaYcUKSc4HFNbPIyakjOFINADGIzwOTxT9oC59KaTzmnZBjwDyRQBWlJwR71LYNg4I471FIcqQetPtDgg8igDVTlSRUiEAHFQRtwfQ9qkU0AMu2LKcDn0rIZDvOcjPStiUZHArOmGH+p/KgEQEFccE0+zkIcgn8KJeQM1CjYk4/GgZswDeT0yKguh1B6ip7bBQHJPaoLwYOaQGdIPnBA4FSwgEgEc1HOQqjPUmhSVKnNMDYsVw67WIwRmrl8CYyQOlZdo3zKQTjvWvK2Yc+op9AOQ1UEOcgCs+0kMM4IOBmtnV4yCSR78VgykBsg/hSGmdzasJbdCQCQMis3UIhLDvdcEHv7Unh+6yACcjGK1rqAOQ2AF5JFNAzn7eQSKVbK49epqCaMsScACrE8DrNvixsPX2pXxJGMYGDgnqTSaJTKcWVOD0zV2Buc54Peq7qVJ7j1NSWzAkDHfr2FSy7l6M4IB5PbNLND5vzLgMO/rQAD9PX1p6k57e59BWcoqSsy4yaZSIZGIbrSDrxmrc6KwDdCenvVTBVjkYI7VwVKbizshNNEiNjrwakifDZPNQcdB+dPTIPvWNjW5fimBParKsABk1lo46DrVhHO0gn6VLRaZoRuB1NO3+vBqmj9Pp1qQN0Oc4qbDLYbgYOfrUitx71URuMk81LG3NFgLHQUxmxznA70wvgZJ4rO1K6KoUiILnjHtW1Om5OxjOaSKur3Jlk8tD8oOTjvVCNTuz2HepcbTkAkfypQRg9vcV6MI2VjhlK7uKxIA9D3pm4kkgZ46etNduCOh9PWmByg+UZB6eoNaozuSYDAYOOetVr+dFc8AADDD3p1xJ5aEZwW6kdqr2Nq1zeASfNEeSfpVElvSbQBmmcZDYIyOgq9I2RgDFSzNsHy4x0AqDGTntQNFbUGMdsSuASOprnnySe561ratN/ADmskffGeT7UmIs2i5dWPAratO+DWRbckH0ratV6Ed6EI04TiPk5NQSuS2RwKnQYj461XcDdjpViHxgmq98cfKTzVpAccEg4qpqWDIgHYc1LGUDgDmrVucAH1HFVTxgkZANXbfaUGOv0pADnnioJASasSAAnI96hkAIBFICMcfSrdpgnOM1SyTkDrmrloSMADNUgLkgzkYxVcggkZ4qycd/Sq7cE89aBDFyTisq/Qpc5AOK1l4Jz+tU9VjJh39MUAVlbcMk0yXkHHemRN8oFOLGkMhj++O2DW1aYKDtWRFjecZ5ODWta8DjGMUxDrogLkDmueucnUGOM8AE1vXTYU81zrMxvZMnjP50gJ5Bk4NKqkgDqPWm9X54FWIl7D1oQFy3A2gDsKtliEwDzio4EAA46DrTpThTx2piMy4YtdIoPUiulluBa2kJcExkbTx0PrXJw5e/DAE7CTWjq16QiQAjAAPXJBqhWI7iYSy8EhAMAelJvURncetUFnCg88jtTTMSQR0PrSuCJJWBbA4Aqa36c9hUCIWBPrVqCI8cYoGQaWf8AR1AINXMb3AyQCQOPrWdpzFYxjoK1LfmVOhG4ZH400UaepFQpB6Y7Vz84GSBgVt6kSRkEDsRWIwBYjPegCGNcOD3zW3bJ8oIPXrWMozKoPXOBW3bjAGDwKBkV6BtwM9aZbkocDvU12AwJ9KrWxBPJPFIRfbBGTnJoi5NIMkCnxDDHNMAZDknIFNUERknGRUjYpjE4IA6igCuwJGQaLdyjEEZzSZIwOtSRDLHOAetIC8jcYA4FTBxnBAFVkbHFTKARk00BI2OTntWaykuTyeeM1e7E9RVUZDnnjOeaQFeQ9RnkdagOM4796nucZyO/FUyx3EEgHtQM27NgVAU8CnXi/ISR05qtYcEHOM1eulynHPFAGFeEBRj161HC+449OlP1AFccdKghOeemKANSzYgg9ia3IQGhwe1c7Ztggk4wa6C0k3KQCCOooAx9WiwjZPJrl7lCG9a7DVlyCeMVy14MMQBxjvQMl0iby5AoJHP512tpIJoucdK89tZNko+tdfo1x+7AyST1poLFq9i2KQiZB4yB0FYcwFq4QZIxncRxmutkUPBnvjrWLdw4GXHOadiDNliDAlSSD3NRIChGM/0qQu8chDgY7GnbQ43ghs98cCpaKTJopAUwTznqasqDjAGfas9SV5XkA8kj+VTJKQM5wD370iifJVyCQT6ntSTxeZyn3h+tKcOuQNo9+pqMsRyMgD0rKcVJalxm07lfnp0OcU8ZyCO1TXEQ2eaikgkZI7VXJxXBKDTsdkZ3VyQcHNOQkd6iDYxnpTwcjjpWViydZCcc8VIJM8VUzgcdaQSEZ5pWGmaccgyATTvPAUkdqyxMRyainvtg+TkmqjBt2QpTsrs05rvYDgAkjgVnE5JLHJ/WqccjyMS7ZI6D1qUOSeScCu+nTUUck5uRIz9Tn8RUbyY4GA2O/Q0wydRkEjv6ioGYHOSSvr6VsjIsKQy5/T0p0Z2kkkZPQetRQAEsP4gMk+oqG5nA5HIHAwasgW4zM5iUgv2Het2zt0s7RIwPmA+Y+pqhosGR9rkADMMLx29a0pG+Uk9aBFeRsgjtURbAJI4xUgORzmqN7LsjJBwaAMy+lEkpwMgcVXjAJFI5JJPNSQgk9M5qRF2zQbs44rYtQMY7ZrNthx0+laVsDn+dUkBfBwgHPPeqzHDHI5qx0QVB/Gc80xEsYJTOaz7xiZMjkVoqPkPpWdMBknr6UmNFV8k8HvV22IxjByBVIDDcCrdvySaLASS9SM1Wkyc+lWJeDkVEeRzQMrLgPyeKvW3DZ/GqEygMck9au2II6nmgRalOPYVVZsOATmprphtwevtWdLJg++aAsX3JwCKjmXfEwIyCOBUkJ3Rg56ikzzg80AjAXKuQQQc1Ke/NLqEeyZiOATkVBGxPekBPApLjvzWtbA7elZds2GJFakBOOtMTI78ED29B3rnYsm4cnk5Nb2oMQhxWDbE+ax7HJoAsoCZADzmr0KDI4Oe1UofmlzWnCpBGcnFFgLMKkA5OTUVySUKg9RVntxUEgBilY9lJ/ShCMrTsiZ5AOhIxjtVG6lD3UjgEAnp6VcimSCwdicStwg6VmorMeDyabYD1+fgZzVyG3Y43AgYqWztABluTWgsZIwBgUICCKNUGBz9anRSB6ZqzDbFMFxn1JptwQmQnU9/SgDA07GwY7VrWozIh9xxWPpWCMk8DpW3acXMRz8uefWmUTaiSHOBnHSsWYnd05rb1A5kJPAx0rDkBLHJxz1oAdbsTIOBWzAcqMjBPWsm1TD5JBIrXhAKjB5PpSGRXBJ3CqluSJiAeP51PdkjO7t2qGzGZc4wMUCNE8HHekBIOeoFP2+h/OmkEZ9KYEpbIyR16U2Q4UEDrUsPKeuBUdwQQMUAVwBnpk1JGo3AntTTjHTmnRZ5z3oAmUDJPpVheVHNVo88k1OhIUE4oQBJkLwCfXFV3BPTr6VZ4xULcg45oAp3OMDPas9mQuNvHPetSdchs46cfWsicbJgBxjnIoGatoxUg9cHpWo5JXGeD1NY1q5AHP/161VYFACKQGZqYyvAP1FUIeMjqfStXUFBUgdTWSg2yEDPFA0X7cAPitnTmAPBGDwaxIycA1o2jlMEck0IRc1KNTGWxkd65PUEG5uo712t2paE8DGK5PU1AyAORxg0AYfKkEjitrRrgq5Uc+2elZE3AxT7KTZKCCevUUDPQ7CbzEIYdR3ourdZB1PHNZOm3BIUZOMVtA5Tg9qpO5LOfvLYOSpGB78VSRzHJ5e3KKce1dFeRb0bsccHFY1yqogGcseOexptCTI3w2NvT6YFBG056kDg+lIoKBsgkikByc54qLDuTK2GGeT6VYAL5Jx9Kqx8Pk5PoBVuEAk4yPapKH7CQcgEHgjoB9azplMU7JngHj3HrWyEDLtI471nauu0xsBjAwf6Vz1YXV0bU520ZV35OKUHvVXedwI7U7zAF4rk5TqUi0H4OKa0oA5FVGuFAqlcXmSQvI6fShU2xOaRPc3YBYKeagjdjyxJP86q8sR2PUmp04AOc1104JI55SbLSY6kkjHHtUokB69f51VVwoyTzTlb5TgZNaozJnbj5aArMMgDPHBPWmZAAPWn7gmc5yfTtVoljrmQxxsEzuIwRUGnw/abjBH7sDnPrUUrF51hDEk8Z9K39PgEEahR0HJ9aZJciVY4gi4AHGPSoJnLNjoBUrNtB9DVZMFiKAFICqcnGO9YV/LudgpJrVv5lji5yT2HrXPSuS5z3pCGpkkjtVu3B6frVeJCW7gVegABI/KkBbgTBB9O1aVsBnJNZ9sMvjPWtKFACcVYEztgAAdaiTJJJ4NSuMAGo4ySwzyO1MRLIxVMDGCKzn5zV+c8dKoORzjIFICDHzj0qxDhQQelQDB5B5FSIwIPJzSKJiQcjrTGB69fagNnPHWlz160AVJQS3PSrVuMIBnn1qOYZIIHAp0J+Xp3oAllII68isyc4YjHArRYggnAqhd8HPtQIu2BLJyeBU0g2nPHNUdNlIUAnjNXnBIyOaAM7U490QfrjisuI4ODzW7Ou+FgRkY7Vg5CSEcjmkBetgS5wOMVpwLhOeKz7U5UYOPpV9AduSaYipqjkQse+KxrPGOetamqn9ywz24rNtAdmQMDHemFixbjEnHTOK1YMjHNZ9ou7qMAmtaFQoBHPGKQhz525qrqUvl2TFThmIX8O9WnPb8KytelAlSCM5IGT9TTGZbEzyBVyVHAHvWjZ2oRckZPYU2yhEagkcn2rQiQAZPA+tAh8KFzgDgVeSNYVyxBqp9qiiUgnJHYdaqTXbzYGCMHgUgLs94CSI/yqmZGZiSSfampHkZJpyxlQc9e1UgRj6TxjniugsfmuYwBnnn6VzulkBfmJzkACuh07H2lMDjFJFD9SHLAHPOKxXGSQR0ravyMnIrHkI59c0wH25ww7DvWtEwAGDxjisu2HzHNaUajGDyMUhle9Ytnue2afYcrnBz0NVLw4fAPH8qvaf/qucdaaEWs+hOab04PNOweOO9Iw+bj1poCaHkEYqORcgjkDOafC5BOOlOcZU4P407BcqkEEc57U7OCMdKeqY75NI459BQFxytgAjmpUGV549qixhRjBB71KmADjmgY7ORjuKixh+TkVMR8hxioWBAAJGc0hEMwPI7VlXSgSAE9Oc1qzkhCDWddIDyOtSwJbVuAByK1YGzHxjIxWRbHCj1NaNuSD1yOnFAwuk3ZI64xisqQYkPtWzNgDJFZMiBpTgZI70CJEP7rAGTnkk1atpMkcHiqyghemaljYBwMfShAdEcvbA4Gcda5vV4iDnHJya3rVg8BXvjOKytWQnPqBQM5eYYOMnPvUSEqRirFwg3HnJqqRxkUDOi0m6G0DOCOOa6O2kJQc5FcJp8u2QL15rrbCbgAmnETRrswZcEZHvWbc22/jHOcitFORn9aa+O5xiqEYO1huDgjBPJqrIScEY2k4BNbNxGCj46ngGsiUFGSHsOfxoEOhzuwSPYVdhDAgAH6+1VHtyHilTGR1HqKt2kjMuWGCOvepsBdTheefTiq12nnABhkZ6etPVySVJ71Y2jGcAmoaKTMG7svKgLhxnIAGOg+tZbxz7T8p+ldLesBEScZJAAPf2qpJjnPTFYumtzRTa0OWlkcMAfWol+8cnGe1T6mvlXZwDtIyDVVeTznNOMUth81yyvXFSrweKqqcVMpAAz+pppCuTKSSfSpkGQBn6EVDGNx4zx+lTqAUIIwRz161aRDY5PkILHAB6etRXMxDnA57e5qJpyykY5zwMVZtLV3ffMAT1APaqET6ZbnaZZATI/OTW1GpVDyelQQrgDPXGMelThgE69KEAydwQOabEmFyaYTlwQMjPaluXMVs7Y4AoAxtUlzNgdB3rOPzHkc064lMkhbPPpTYslvSpBFmEDAI4Aq3GQG6E1FAm1Rk9asIACTwTTQMt2y8gitK3BHJ6ms+2I7HH4VpRDIHSqExJG4AHrRAgzyc0kmBk1JbqMEn0piQy4IxgVSkHJxVm6O0kHNUSSe/BqWxiqOSKeoAGMU0ccdBUnHSkmAnb2owegpASDggUmeTTGBPY01GCnB79OKX7w6GmFQDQA+RwAcVSnyTn1FWCOarynJPoKBDLR9khHUGtuIhk59Olc+jASZxzWzZsCmR1oAJSRkAHH0rAu12zt0IzW/MCGPpWPqYIkyBjtmiwElkRyDjj9a0k+4ay9PGe4JrT5EZxQBlaox8vGcc1DagiLjGKXVCeAepNSWybYxznNAFi1UP1OK0ol+Tn1qraIOhAzVtiFU4FArEZcAknoOTisMkSXUspwQWyPp2qzqNwEjdQfmPGAazFYnp/OmBom42jgggelRvcO54JAqCGMtwelX4YApG7gUAxkMLPyQTnuatJCE68mpADj5QAKmjjPVs80CIthIzg47U4Kc4GTVxIwAMDmmybcnHBAoQHH6SQFGT16V0el/8fOewU/nXLaScEAnjtXU6QQJSxyRjH40IokugGJyeB0rLnAyMCtO9yCT68is5+T70ALbjDdetaCYKg+1Z8CkuPY1dcEqcHFAFO5GZAAQa0dPXAx2xWaykygYOa0rViuBjJApoC24xnmoWYAH0qVwSPeqz+meR1poTJ4yBwDUpztOcVFEN4BHUdakAIPIyKoBhODgUhBIINPcA5wMHNRsQT+NADwCB9O1SIDg5FMXBPXmpVB29eaQ0xVPAFRM2DyOakUnkZ5qKQ54PbpSAhm+YEd8VRlHtV+QZBxVGTkkDtxUgMgBBJJ/Cr8BwmB1qnGBx1zV2ADHWgB8pygHcVUkPzEgc56ircjHaQBVRucAdc0AIpJNIvXrz0pcYHTJqPofehDN/SzgAEc45NQ6tHlSQccfnUOmSEOAD3q9foChORjvQBxt2gEhqiT65rW1BAHYAfnWVKpQkde9IaGRna4Occ10ukzgqMnGOMGuYYYPA61oaXPtlAY0XA7q2kO3rkVMeV6ZzWPY3BIweg71qiQlBwKpMTIpk+U4IrCvo2EqvnIzzW7IcryMVnTgc5GSDTuTYyyzIcpkn0J4q62JESWIFCeSoNUrtHhkynKYzmpLeQyRgxckZyDQFjTt50c5wRg45qyW5GMYrHSVZoyUypRsEe9Sw3ZJIdcD1PakCLF/yiEDOGyfx4qjPnaQeBirUuZI3BJIAyPwqC5IeEevXNQ0Ujn9Qy2Mjp61m4+fPYVp6ghwSeo6VmZIJrMpEsfv0FTAgDpxVeM44GamjIyR1qgJowSwIYgY4FE0hVQCDk9CD0qMSDPAO4HpU9pbtK4eUHAOcVaJJdPtiMSOPm7GtaFSGBJ7VFGABjAAFWI0LDgEUAToCc4H40S8Lz1NLENgOT1qOZjkY/CgAiQ8dqz9auCuI1PHU81phhHEXbsMmuTvZjPM7kYBJxzSuBDkE571YgADc5qsMkDsfWrlup2AmkIuooIJBz9afGOTx0pqDgDHFSoB700MuWoABB71eU4HAwTVW2Ax71cQgDHWqRI2XJzxVi3+7gDpVV3JOSMCrcJwgI6mhgU7xiCw9ao56+lWbx8sR396rIQSelSxir780/wDi74poOeOKcpJGMHjvQkApx600cmnZpp6k4pjAd6HwAMDrThjvScHIBoFchcgiq83QY/GrLjHA61XlGMCkBUPHatPTJR069qzH79hU1i+1wAetNAbU6/ITzWPfqWUccdSa2XbdECD2rMvOVIAoBFGx4Y4PfrWt1j6nOOtZFoCsmPfpWmTiMk5Bx1oAx9QYmZR15zmrcAGwD2qheEmcYrQtsbQKEBft1IIOee9SSnAJFNhGATVbUJCkbEHJAoAxtRmJmOCOOtLZQvJnaM+/apLWwM8hkkJCk5A9a1lVYVIjUADtTAjiiWJQWALD+dKWBOSP1oJZiTikAxkkZ96BMmRgMYODnvVhZlUckE1SzycClUgHJ60CLRuxyFJz2qB5WccnHvURIJGB19qkUE5GKBnI6e/5jrXXaO2A/bgGuLsmIfAOMnrXY6KxMcmR0wM+tJDLFz8xOeoqhIMEk9enFXZ+CTkVSIyRzx15qrCuPtxjJJ5NT5wMntUC4XPr7U4MSD7UhjFBaTdk+wrQt/lwD1JqknBBPWrcBLYI5INNAX5MAAe1VWAzyDn1qyOQM9ahlIRGOMmqEFtgqSO3FTDnocGo7AAxMcd6nUdcc0ANwe55pkijvU3oKjkHPqKYDABwcc1IoPAzSIMZ4xjpT1A6g80hoGBBGTj3qOQ4IAGalblRnrUZGc4xUgQNwCMVTK9ccE1amJB4POKiVck560gIkAVST1qzGSFyKhZBjPcU9CQuKAJgwOfUVC4BPAwc06M8NTAQSQRzQArAFD7d6gzls4qxnIIqvgByO1CGWLNsyAZxz1remQNBz1xXOwnEw54rokYG1GOmKYHManDgkjqDWLMDuJ6muj1AEsTjArAuACx9qljRUb07U6JyjD3phAzzSDPbvSQzp9MmyAAewBrftmyuOo965DS5BnBOCOldPYyjZ1yT3qkybF6VMrkVnSxnJz2rV3ZBx+NU5EDZx1pgVJrdHjIHU8YPSqiWZgZ2QnJGMVeBxkEcijIYgnrQIwV3wSu2MEnJB7+9XLfyZ4XVmKygDBBq/c2iPAxYAHqCK57L+fKyAjZgEHjIFCYNGskjRuEJyCuB70IPNjbHBXgiq6yCaR0GAcDBHY0K8tuHQjJYYJz1yKkDM1chAAvJNYbZLEE9DW9LbMId8hBcDkDvisabGSBxzUNWKQiEKAeetTb8kBQcmoUGT/hVuEKM+ooAfb2+GLHJ5rUhAC8VVix+Jq3D0qkBaiUHByMCrCsAQM/jVeHABqQckEUxE5549aYAWYcZxS5AGT1xRB3bnB9aAK2sTCGzdAAS/Fcxkknmr2tXn2icqhOxDgc8H3rOUZJPcVN7gTRjOM1owgBRkZFUYBg55NXomxyQfpQgLCsOmKkXgDHFRA4ANSRnB5piL9uPlHOAatjaFBHXFVbYEqM1YIwO+KYyNmyTnpVuFhsOPwqmeHwOcmrKEKhpsVijdEkkkVXTkkmprpgSR0JqCPgY7UhkgPUilU8ZNN6Hpmg84GfwoAfkdqQkY5NN5BPA+tHUcdKAFz79KXcB7GoxyT1FPGNvOciglkTHJJqJwSM9xUhX5sU1u4H50AUpicHNMhcq47nOKdOCGI7Gq/II5oQzo4G3RjJqtdqRk9BRpz7kxU1wM8dTQFjKhAE4yetaDfcI9RVMIFnyRyT1qeRsRkZ5oYGRcEC5wOcVp2nQY71lPzc4PrWnbcKADSQF4kjgd6zrxvMnWM9+PrV2R9qZB6CqMI8y7zjgc596oC/GgRAo4AFNI/8A105zx14qJpAO/PtRYQ/IAxxUZPWo2kz06Uo4yT0oEBfaMnAqN7mNc5bJ9qgum3HAPHtUUcO4ZwcZoAsm8+b5FJx3NI11MR8p259OakhtuQCOasiFRwVoA4q1IEoFdhoL7rSQj1AJ9646A/vR7muv0MY09ypx8354FJFFmfKqe4qr2znBqxNIwUDHJFQn3GKoVhgJB45qRSTnFRDAYjPNSJgDGetIY/OQCcVbtmUYGME1UVSSQD09anj600BqoBt471SvDtUgj8auxHMYzVG6JMhU4IBp3FYnsgVtwcEE84qcEk+lJHgRYHYUkYJIBGB2xTHYmGACT1qFiMjPUmp+uarSr83fFIBcgZB70EcAg80EkEA4NO69DTFcTJ6Z6VCxw2AeDUrDg96gxgnOTUjEcDPvUecZ+tSMM8nrjio2xnHegBhbOQOlLn06CkPOfakHcD8aQEid/Sm9GJNAOAe5ppPPpntSGKxwAetRA/MT3qbGQM1C4AcjoetMBI3IlGRwD3rpbE77XpXLoct9DXR6Wxa3wPrQBSvlEm7PGM81zd2hDMD19RXV3iZDgYziudvU4JIx7UMDGfqaZnAqWcDgAYPtUBJHHepKLto+1wSeDXQ6bKc5B46YrlVcgDI6VsabNwMnHpQmKx2cbAoSCKrzMQCF6njNQWEwK7TVt1wCQM0xGdJuViSM96fGRgE4znnFFxkg9c59KZD1IPQ+tMC46hkIB6iuf1m3lEodAQRzkdK3AcYxRcENHgjk9M0gOWjvArAsACThiOn1q/av5oO4ZHTJPWo7rS/MnLKwQE9AKmkYRwhAACO/encko6lMAHSPIIPXHFYhBJPp1NX7liHIJPNVsEDioepSI4xggAcVOiDBOOTTV681MgycikMmhyuB1q9FwBgVVhXPOM1djGME9RVCJUJIGBjFTR4ySe1MTPccUsh2qT60wEkffJgHgdRUOp3X2WzIBAdxgD27mliGXBzjByTisTWZ/tF0cH5FG0DPGPWpAoFgTnnFSxjr3zUK4zjFWoE4zQNFmADvVpQMZFV4gRzirCfdPrTSEyRcjvxT4jlhnJqNQT1qaFeRjqKaEaUGOOtSyEgHBxUMAwM96dISR3oQxgJznPNWASFzVVTlhn1qw+dmB+NMRQuSC5x3pnPGKfcKM56Cmx4Iweo70ASdgc0AZOOKMjmgEYzmkMU8A5FR5IOR0NSEgjiouxB7UALu7d6XcSMYzTBk8DrUhGF5oFYjJINMbGOeKe/QGojyDzzSArXOCmB1HP1qm3T0xVqfls5zVSQ4J7g0Aamlycc9BV+QZBIOfSsfT3HTNaq5KkUxlaQZfp+NNmyV+lSSk7sAA471XuJQqHI5AyaAMvObogHvWmpwAATgVkxN+9ZuuSatpKTnkcUkIu3EoWI81BYMFUsSSSePpVWeQswUZJ6cVfsoQqgnn61SAk2tLychakSNVGcZPqaeSMYHFNK5zk0EleV8E44FV5JWII5q7tUfwgg0h2gkhQDinYCjbxNI3JIHqavRxhRgHOKZu5zSjPfNCQFlSOMYzQWIPUYquGySP1p/cAc8UgOJhyZAehBzXZ6KP+Jep7Ek8d64uMnzceprttMG3TYCB2yfrmpRZJMQGAAHtUDA7jjn2qST5jk5yDQ64AI4PeqEV8fNz3qWNCASc1WOfOIB564qwjtjGKAJUwBnnFSW65bJ6nvTISCNp61MMAA4GelAF+LiPOc8VVwDIATg5qypwhwMcVAikz5IIA/WqQFtQFXk0IQByOvSkJBxkcU/auOlFwFzxnnNRyHpwc1IxAAxjjpURyevNIBGwSOKMHg0jgDHvT1A8vPXFO4JDCCeppjA8kHIqQn5eRjFRFj+FIBOScH/APVUcgGTk4PbinqwOfUUyRhuHIoAYwAU+/FMU4PJFSyDK+/aqoYFiCeQaQEocAnI75oJDc9hTTjoetNXg/SgZMrKeM8jtUc4y+RxxRwGY00sTz6DrQBA52tn866LSmHkqCeSKwFAIzjk+9bekk7AcDAGMUILE1yvJ549axL6MkgAjjk10FyVAII9yax7nG8kdDTGc7cRFSfrVQj16iti9j3KRnk9PrWPIMZA6g1FgQgbAzVmzkIbjgdiapgg8H9KlXIOQT7c0irHV2EuduDz3raifeOa5LTZyCDXTWcquvHGapMlodcKwOQBiqLkq5J6VpXGSvI4Hes+YDdgHr1FMRJFKNpzj2qXerqMj6ZqivfHFTRnkZ6UAOlUEfWqd3EQuSCeKuyjABycZ4qCdsg5PGKQHNXoIPQj3qqOckZrT1ADJOc1mgAk56CoGOjByAOlWIl981BGwPA6mrcPQH8KBMsxpggCrMY6DNRRKMcckVYQc88YqwJcY69KjnPIAqbovNQMMnpk+1AFfUJhbWTlTh3+Vfx71zbHnkk1o61NvuVjXBVBg/XvWYc54xUNjSHJjOOcVah4wKrRgdT16cVbiwSPSgdi2uCOTxUsY/Oo1AIwOD2qZFJU46irQh5wMVLACXBB61BtI9zVm2x1Pb9KBF6IgLyRmiRzg1GCTkY+mKJOnGaAGocuOO9TOSAOeKhQkDIxmpHJKEmgCpK2SRQgwKa5O88cGlDEjjvTEP5AyelLwR1poOFOQaUDCgipAd2xmmnrj160uCMn1phJGOOaAFBwc80rnjgcU31zSA8YI4oAazdah3ZzT3GQR71CfbgUgI5CMZNU3XOSfwqzMQeAcYqo5J7kUASWshWQY5rdt2DL7965+3wJM9+tbVq2RTGPnA5rOvDiMkdehrSlU4JznIrJviQpBx060wM1SV6VPC+4EDOapO56dM1p6fEAAxAJ7UhFiztcvvfvWkAFHHT0pkQBTOKkyMY9aoBme54pM5B5NKeh7UwDg470xCsR0NNx1NGDnk0q/MSB2oAixRgnAxxU4TIwc8UpUAcDJoEQgY+lPQYNOZOM0mDj2pDR/9k=
4	DEBBIE	VILA MARTINEZ	42300841	URB. BANCO DE LA NACION MZ E 10	9	dvila	1234	t	\N	DVM	data:image/png;base64,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
2	DENIS JACK	OCHOA BERROCAL	43724871	SIN DIRECCION	996730790	jochoa	1234	t	\N	DJOB	\N
3	GENARO	PALOMINO	28213485	LAS AMERICAS MZ Z LT 4	966	ventanilla2	1234	t	\N	GP	\N
5	NORMA	VILCATOMA JAYO	42960180	JRON MANCO CAPAC 538	966004689	ventanilla4	1234	t	\N	NVJ	\N
6	MARIA AURELIA	HUAMAN QUISPE	41983040	CARMEN ALTO MZ D 1 LT	999037294	mhuaman	1234	t	1455284179084  	MAHQ	\N
7	KATIA	LOAYZA GUILLEN	41961983	Urb Mariscal Caceres Mz K LT 4	999656509	kloayza	1234	t	1455637519088  	KLG	\N
8	HERLINDA	QUISPE ROCA	44695382	ASOC. JOSE MARIA ARQUEDAS MZ Ñ 1 LT 18	952234209	hroca	1234	t	1455637801716  	HQR	\N
9	MARLENY	NARARRO GONZALES	42213810	AV EL EJERCITO 825	966812114	mnavarro	1234	t	1455644210288  	MNG	\N
10	VILMA	CARDENAS CHAMORRO	43975511	JOSE OLAYA 317	996116658	vcardenas	1234	t	1455653447349  	VCC	\N
11	RIHIIVILINDA	HILARIO LUCANA	42839808	CIUDAD MAGISTERIAL C 13	999046181	rhilario	1234	t	1455653680773  	RHL	\N
12	YIERSNEIT	QUISPE GUTIERREZ	31183431	A	966642390	yquispe	1234	t	1455890867711  	YQG	\N
13	ROSA LUZ	CCOPA ZAVALA	25848411	JR MICAELA BASTIDAS 525	966057020	rccopa	1234	t	1455891432466  	RLCZ	\N
14	Marilu	Berrocal Crisostomo	70416632	Av. cusco cuadra 10 1026	951984748	yram	1234	t	1456235150496  	MBC	\N
15	Carlos Alberto	Rojas Huarcaya	10606185	Av Abancay 289	988966166	crojas	1234	t	1456235427414  	CARH	\N
18	GUIDO BENJAMIN	JERI GODOY	55555555	Jr.	966	gjeri	1234	t	1456930469375  	GBJG	\N
16	MAGALLY INDIRA	SOLIER CÓRDOVA	40659184	Jr. Arequipa 296	966963207	msolier	1234	t	1456842143070  	MISC	\N
17	MIRTHA	CHAVEZ FUENTES	88888888	SIN DIRECCION	966	mchavez	1234	t	1456929907085  	MCF	\N
19	LUIS ALBERTO	QUICAÑO ESCALANTE	28266804	Jr.	66311723	lquicaño	1234	t	1457043726500  	LAQE	\N
20	MAGDALENA DALILA	HUAMANI ANAYHUAMAN	21461586	Jr.	966	mhuamani	1234	t	1457047653657  	MDHA	\N
21	ARTURO	DUEÑAS VALLEJO	99999999	Jr.	966	adueñas	1234	t	1457048257709  	ADV	\N
22	BERTHA	YARANGA ZAGA	28218966	ASOCIACION MUNICIPALES MZ C1 LOTE 12	999848438	byaranga	1234	t	1457098443394  	BYZ	\N
23	SIDIA DAYSI	SOLIS NAVARRO	71849487	Jr. España Nº 118 SJB	985318601	ssolis	1234	t	1457101482483  	SDSN	\N
24	Rosa Maria	Cardenas Mendoza	28223351	Jron Arequipa 386	944555180	rcardenas	1234	t	1457102118531  	RMCM	\N
25	Basiliza	Chavez Fuentes	70154686	Jr Mariano Melgar N 519	951583211	bchavez	1234	t	1457124923929  	BCF	\N
27	SONIA	SAAVEDRA MORALES	7296345	Jr. Carlos F Vivanco N° 265	990660750	ssaavedra	1234	t	1457125914629  	SSM	\N
71	YURI	HINOSTROZA FERNANDEZ	44816747	ASD	966	yhinostroza	1234	t	001476883283774	\N	\N
28	VICENTE	ROCHA ANDIA	40092564	Jr. Wari N° 205 SJB	966564241	vrocha	1234	t	1457126297534  	VRA	\N
29	ISABEL	AUJAPUCLLA MOROTE	28303329	Jron la Mar 256	930954056	imorote	1234	t	1457130882532  	IAM	\N
30	Cesar Augusto	Mendoza Pantoja	28226562	SN	#809997	cmendoza	1234	t	1457131218964  	CAMP	\N
31	NELLY ADELIA	FLORES HUAMAN	40661746	Jr. Constitución Nº 505	990889968	nflores	1234	t	1457357810015  	NAFH	\N
32	MARÍA LUZ	MIRANDA VILLA	41946803	Urb Jose Ortis Vergara Mz H lote 7	948186170	mmiranda	1234	t	1457357988824  	MLMV	\N
33	GILMER	GARCÍA GOMEZ	28212241	jr	311830	ggarcia	1234	t	1457360370961  	GGG	\N
34	VANESA	PERLACIOS AVILES	10429209	AV MARAVILLAS 145	950903212	vperlacios	1234	t	1457361483249  	VPA	\N
26	Cesar de la Torre Ugarte 	Coronado	2879322	S/N	950892361	cugarte	1234	t	1457125190207  	CDC	\N
36	CELMIRA	CORNEJO ZAGA	28308342	PLAZOLETA PAMPACRUZ 157	966887501	ccornejo	1234	t	1457364007269  	CCZ	\N
37	KELLY ANGELA	CARDENAS CISNEROS	40586777	JR	966	kcardenas	1234	t	1457445602485  	KACC	\N
38	LISBETH	LOPE CANCHARI	44956846	ASC. LAS FLORES MZ Ñ LT 6	999868712	llope	1234	t	1457448288730  	LLC	\N
39	JOHN ALEX	PÉREZ CONTRERAS	25745679	Jr.	966	jperez	1234	t	1457545107081  	JAPC	\N
40	LEXME MILKA	OLIVERA TORRES	28295816	JR SAN MARTIN 154	966612425	lolivera	1234	t	1457545369054  	LMOT	\N
41	VICTOR PAVEL	CORDOVA CHUCHON	45763723	BARRIOS ALTOS S/N	966	vcordova	1234	t	1457644814542  	VPCC	\N
42	LIDYA	HUICHO ORIUNDO	28227527	Jr. Lima N° 126	966	lhuicho	1234	t	1457645060883  	LHO	\N
43	MIRIAM	PALOMINO PRADO	40366790	URB LOS LICENCIADOS MZ T LT9A	990598833	mpalomino	1234	t	1457705338328  	MPP	\N
44	ANA MARIA	VILCA AYALA	42303645	URB los licenciados MZVLT 22	954900321	avilca	1234	t	1457706667598  	AMVA	\N
45	MIRIAMM	PALOMINO PRAD	4036679	URB LOS LICENCIADOS MZ T LT9A	99059883	mpalomino2	1234	t	1457707946058  	MPP	\N
46	ANA MARIA	VILCA AYALA	4230364	URB los licenciados MZVLT 22	954900321	avilca2	1234	t	1457708229481  	AMVA	\N
47	MARIA LUISA	CAMPOS GUTIERREZ	28265488	AV. NUEVA GENERACION MZ D LTE 4	983978140	mcampos	1234	t	1457732718833  	MLCG	\N
48	PAULETTE JHISENIA	OBREGON CARDENAS	46184999	AV. ARENALES N° 1153	989046680	pobregon	1234	t	1457732844539  	PJOC	\N
49	MIRELLY	MENDOZA SUXE	44619560	ASOC. 11 DE JUNIO MZ B LT 8	990301256	mmendoza	1234	t	1457965714633  	MMS	\N
50	MABY	GAMBOA GARIBAY	46634827	ASOC. 11 DE JUNIO PAMPA DEL ARCO MZ. E S/N	979592311	mgamboa	1234	t	1457966058616  	MGG	\N
51	LIBBY	FARFAN CISNEROS	28220655	JR. ALFONSO UGARTE N° 217 SJB	995809099	lfarfan	1234	t	1458072861554  	LFC	\N
52	ROMULO	HUAMAN GALINDO	28286468	COOP. QUIJANO MENDIVIL MZ. D LT 3	953675751	rhuaman	1234	t	1458073106850  	RHG	\N
53	YANIRA	SOLES VILCATOMA	43068831	JR ROMA 140	94384964	ysoles	1234	t	1458222040199  	YSV	\N
54	RONALD	DOMINGUEZ PEÑA	43707614	EMADI MZ A1 LT 14 AYACUCHO	990608815	rdominguez	1234	t	1458222480808  	RDP	\N
55	MARILUZ	PARIONA PALOMINO	44842816	JR 24 DE JUNIO 411	999384084	mpariona	1234	t	1458308463306  	MPP	\N
56	ANTONIO LADISLAO	PINEDO ORTIZ	28268334	JR 9 DE OCTUBRE 205	584747	apinedo	1234	t	1458308785667  	ALPO	\N
57	Santiago	Morales Gutierrez	28228358	Jron Munive 101 San Juan Bautista	*6908754	smorales	1234	t	1458567230491  	SMG	\N
58	MONICA	DOLORIER INFANTE	28298148	AV MARISCAL CACERES 1136	949675972	mdolorier	1234	t	1458749102837  	MDI	\N
59	FERNANDO	ATAUCUSI CONGA	28261103	MZA. C LOTE. 01 URB. JOSE ORTIZ VERGARA	98102220	fataucusi	1234	t	1458749426742  	FAC	\N
60	WILVER YOHONG	ARMAS SILVA	42412550	ASOC. COVADONGA MZ. D1 LT 15	956186532	warmas	1234	t	1458751632380  	WYAS	\N
61	octavio natividad	ragas llauri	6255577	Jr. Itana N° 101	966131186	oragas	1234	t	1458751938563  	ONRL	\N
62	EVELYN	ROJAS PEREZ	72405734	URB MARIA PARADO DE BELLIDO MZ G LT 7	999202004	erojas	1234	t	1458754844240  	ERP	\N
63	BENJAMIN	HUAMAN FLORES	28296290	URB LUIS CARRANZA AYALA MZ A LT 23	966668612	bhuaman	1234	t	1458755128084  	BHF	\N
64	MARIBEL	CAJAMARCA CARDENAS	40927937	JR LIBERTAD 233	966154266	mcajamarca	1234	t	1458771005925  	MCC	\N
65	HECTOR HUGO	MONTENEGRO PORTAL	40773318	JR	990280930	hmontenegro	1234	t	1458771143034  	HHMP	\N
66	GERMAN MANUEL	GAMBOA ASTORAY	41248844	URB EMADI MZ B LTE 10	998984742	ggamboa	1234	t	1459269307682  	GMGA	\N
67	CARMEN	JURADO ALARCON	28212199	JR SOL N 582	990294953	cjurado	1234	t	1462828607547  	CJA	\N
68	CESAR WASHINGTON	BALLENA PALOMINO	28273181	JR SUCRE 180	999047922	cballena	1234	t	1462828899394  	CWBP	\N
69	Godofredo B.	Flores Huamani	7455572	asoc los municipales mz h lt 2	958752777	gflores	1234	t	1466455699630  	GBFH	\N
35	BETHSY	ESTRADA LA FUENTE	41379567	CUMANA MZ F LT 10	999012085	bestrada	1234	t	1457363692365  	BEL	\N
70	ERICK SIMON	ESCALANTE OLANO	70021899	ASD	970952134	olanaso	1234	t	001469466843699	ESEO	data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD//gA7Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcgSlBFRyB2ODApLCBxdWFsaXR5ID0gOTAK/9sAQwADAgIDAgIDAwMDBAMDBAUIBQUEBAUKBwcGCAwKDAwLCgsLDQ4SEA0OEQ4LCxAWEBETFBUVFQwPFxgWFBgSFBUU/9sAQwEDBAQFBAUJBQUJFA0LDRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU/8AAEQgCcgJyAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A/VKsvxP4p0jwVoV5rWu6jb6VpdnG0s91cuFRFAyT+Q6Dmptd1yw8MaLe6tql1HY6dZQtPcXMzbUjRRkkn6V+Df7ef7bmu/tNfEK90zSb+Sz+HmmyGDT7GElRdYJzcS/3i3YdAAOM5JAPpz9pT/gsg7SXOjfBvSiqKxT/AISHV4h8wB6xQnsRnl8HnoDXwX8SP2sPi18WL83XiTxzq14MbVt0uGjhQZ6KgOBXklFVYCa7vJ7+dprmZ55m5LyNkn8ahoopgFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAXtL1vUNEm87T72eyl674JCp/SvcvhN+3d8a/g5PF/Y3jW9vbGNw/wDZ2qubm3b1G1jwD7EV8/0UgP2i/ZV/4K0+EfineWfhv4kWf/CH+I53EUOoRfPp87HszZ3RnPqCv+0K/QGGaO4iSWJ1lidQyuhyGB6EHuK/ldBKkEHBHQiv0u/4Jj/t9X+ga/pvwm+IWrfaNEvXW20TUbxjvtpicJAz90Y8DPQkc4pNAfrtRQDnmikAUUUUALSUUUAFBoooAWkpaSgBaSiigBaKSigBaKT8KKAPzj/4LFftFXHg74faP8LtInkhvPEbfatSeM4/0SM8Rk/7T7T9Er8dq+rP+CnHjy98b/tfeL4bqXfDopTS7dB0RI+v4kkmvlOqQBRRRTAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAp8M0lvMksTtHKjBkdDgqRyCD60yigD+hr9gr9ogftH/s9aNrV3KX8QabjTdUDElmmRR+8Ps45+ua+i6/JT/giP43uovGHxI8Iu+6zuLC21NEP8DRyNG2Pr5wz/ALor9a6gAooooAKKKWgBKKKKAFpKKKACiiigAooooAMUUUUAfzaftbX02pftOfFG5uJGlmk8Q3hLMcn/AFrAfpxXktep/tUf8nJfEz/sYL3/ANGtXllUAUUUUwO6+Cfwa8R/H74jad4J8KQwz63fpM8KTyrEmI42kbLMQPuqa+m/+HRnx/8A+gXpX/gzg/8Aiqxf+CU3/J7vgr/r11H/ANIpq/eqpYH4X/8ADoz4/wD/AEC9K/8ABnB/8VR/w6M+P/8A0C9K/wDBnB/8VX7o0UXA/C7/AIdGfH//AKBelf8Agzg/+Ko/4dGfH/8A6Belf+DOD/4qv3QpaLgfhd/w6M+P/wD0C9K/8GcH/wAVR/w6M+P/AP0C9K/8GcH/AMVX7oUUXA/C/wD4dGfH/wD6Belf+DOD/wCKo/4dGfH/AP6Belf+DOD/AOKr90KKLgfhf/w6M+P/AP0C9K/8GcH/AMVR/wAOjPj/AP8AQL0r/wAGcH/xVfuhRRcD8L/+HRnx/wD+gXpX/gzg/wDiqP8Ah0Z8f/8AoF6V/wCDOD/4qv3RpKLgfhf/AMOjPj//ANAvSv8AwZwf/FUf8OjPj/8A9AvSv/BnB/8AFV+6FFFwPwv/AOHRnx//AOgXpX/gzg/+Ko/4dGfH/wD6Belf+DOD/wCKr90KKLgfhf8A8OjPj/8A9AvSv/BnB/8AFUf8OjPj/wD9AvSv/BnB/wDFV+6FFFwPwv8A+HRnx/8A+gXpX/gzg/8AiqP+HRnx/wD+gXpX/gzg/wDiq/dCii4H4X/8OjPj/wD9AvSv/BnB/wDFUf8ADoz4/wD/AEC9K/8ABnB/8VX7oUUXA/C//h0Z8f8A/oF6V/4M4P8A4qj/AIdGfH//AKBelf8Agzg/+Kr90KKLgfhf/wAOjPj/AP8AQL0r/wAGcH/xVH/Doz4//wDQL0r/AMGcH/xVfuhRRcD8L/8Ah0Z8f/8AoF6V/wCDOD/4qj/h0Z8f/wDoF6V/4M4P/iq/dCii4H4X/wDDoz4//wDQL0r/AMGcH/xVH/Doz4//APQL0r/wZwf/ABVfuhRRcD8L/wDh0Z8f/wDoF6V/4M4P/iqP+HRnx/8A+gXpX/gzg/8Aiq/dCii4H4X/APDoz4//APQL0r/wZwf/ABVH/Doz4/8A/QL0r/wZwf8AxVfuhRRcD8L/APh0Z8f/APoF6V/4M4P/AIqj/h0Z8f8A/oF6V/4M4P8A4qv3QoouB+F//Doz4/8A/QL0r/wZwf8AxVH/AA6M+P8A/wBAvSv/AAZwf/FV+6FFFwPwv/4dGfH/AP6Belf+DOD/AOKo/wCHRnx//wCgXpX/AIM4P/iq/dCii4H4X/8ADoz4/wD/AEC9K/8ABnB/8VR/w6M+P/8A0C9K/wDBnB/8VX7oUUXA/C//AIdGfH//AKBelf8Agzg/+Ko/4dGfH/8A6Belf+DOD/4qv3QoouB+F/8Aw6M+P/8A0C9K/wDBnB/8VR/w6M+P/wD0C9K/8GcH/wAVX7oUUXA/C/8A4dGfH/8A6Belf+DOD/4qj/h0Z8f/APoF6V/4M4P/AIqv3QoouB+F/wDw6M+P/wD0C9K/8GcH/wAVR/w6M+P/AP0C9K/8GcH/AMVX7oUUXA/C/wD4dGfH/wD6Belf+DOD/wCKo/4dGfH/AP6Belf+DOD/AOKr90KKLgfhf/w6M+P/AP0C9K/8GcH/AMVSN/wSN+P6qT/ZWlHAzganB/8AF1+6NNf7jfSi4H8tOtaTcaDrF/pl2oW6sp5LaVQQQHRircjryDVKup+Kn/JT/F//AGGLz/0e9ctTAKKKKYH3j/wRov5rb9q3VoI3xFceF7pZF9cXFsR+or9tK/EP/gjh/wAna3v/AGLN5/6Ot6/bzNSwFpKKKQC0lFFAC0lFFAC0lFFAC0goooAWk7UUUALRSZ9qKAP5rf2qP+TkviZ/2MF7/wCjWryyvU/2qP8Ak5L4mf8AYwXv/o1q8sqgCiiimB9d/wDBKb/k93wV/wBeuo/+kU1fvVX4K/8ABKb/AJPd8Ff9euo/+kU1fvXUsAoopKQBS0lLQAlFLRQAlLRRQAlLRRQAUUUUAFJS0lABRRRigAooooAKKKKACiiigApaSigAooooAKKKKACiiigApaSigAooooAKKOtFABRRRQAUUUUAFLSUUAFFFFABRRRQAUCiigAooooAKKKKACkf7jfSlpH+430oA/mE+Kn/ACU/xf8A9hi8/wDR71y1dT8VP+Sn+L/+wxef+j3rlqoAooopgfdP/BHD/k7W9/7Fm8/9HW9ft5X4h/8ABHD/AJO1vf8AsWbz/wBHW9ft5UsAooopAFFFFABRRRQAUUUUAFFFFABRRRQAtFJRQB/Nb+1R/wAnJfEz/sYL3/0a1eWV6n+1R/ycl8TP+xgvf/RrV5ZVAFFFFMD67/4JTf8AJ7vgr/r11H/0imr96q/BX/glN/ye74K/69dR/wDSKav3rqWAUlLRSASloooASloooASilooASilooASilooASilpKACiiigAooooADRRRQAUUUUAFFFFABQaKKACiiigAooooAKKKKACiiigAooooAKKKMUAFFFFAHzr8SP+CgXwL+FHj2Xwh4i8aJBrMDtHdLbWk1xFauOqyPGpAbPGOoPXFdR4R/bF+CPjgouk/FLwvJM/3YLjU4reU/8AAJCrfpX8/fx9le4+NvjiSRi8j6vclmY5JPmGuy8R/sSfHTwnZwXt38NtaltpoUnjm09FuwyMoYH90zHoenWnYD+ivTtTs9XtUurG7gvbZ+Vmt5BIjfQgkGrNfzQ+Cvi18TvgLrSzaDrmueE71WDmEl4t2OzI3UdiMV9j/B3/AILK/EPws8Fp498PWHi+wD/PdWjG0ugn/jyse/IH1osB+y/eivBf2ff23fhR+0haQr4b10WOsuuX0TVgsF2hxkjAYq3/AAFj0r3qkAUdqKO1ABRRRQAUDpRRQAUj/cb6GlpH+430NAH8wnxU/wCSn+L/APsMXn/o965aup+Kn/JT/F//AGGLz/0e9ctVAFFFFMD7p/4I4f8AJ2t7/wBizef+jrev28r8Q/8Agjh/ydre/wDYs3n/AKOt6/bypYBRRiikAUUUUAFFFFABRRRQAUCiigAooooAKKMUUAfzW/tUf8nJfEz/ALGC9/8ARrV5ZXqf7U//ACcj8TP+xgvf/RrV5ZVAFFFFMD67/wCCU3/J7vgr/r11H/0imr96q/BX/glL/wAnu+Cv+vXUf/SKav3rqWAlFLRSAKKSloAKKKKACkpaxvGPjLRfh/4bv9f8Q6lBpOj2MZluLu5baiL/AFJ6ADkngUAbFVtS1Sz0aykvNQu4LG0jGXnuJBGij3Y8Cvyo/af/AOCxFzfm50H4OaZLYwqSj+ItUVd7/wDXKEZwP9pjn/ZFfnZ8RfjF41+LepPf+MPE2o+ILlnLhr2dnCk/3QeAPYU7Af0ReIP2pvg54XUnVPij4QtGzjy31q33/wDfIfP6Vd0H9o34VeKFiOkfEnwnqRkA2rba1bOxz2wHzn2r+Z6lziiwH9UUUqTxrJG6yRsNyupyCPUGn1/NV8I/2nPib8DrlZPBvi7UNKgH3rNZS1vIM5w0Z4Nfpt+yv/wV30Dxzc6Z4Z+Kth/wjmszutumu2uDZSucAGVfvRZPcAqO+BRYD9HqKjt7mK8gSeCVJoZBuSSNgysPUEdakpAFLSUUAFFFFABRRRQAUtJR3oAKKKO9AC0lFFAC0lHrS0AJS0lFABRVXVNVstE0+e+1G7hsbKBS8txcSBI0UdSWPAr4A/aV/wCCvPgn4dz3+hfDbTpPGmuQs0R1KY+Tp8bg4OD9+THPQAHsxFAH6DTTR20LyyusUSAszucBQOpJr55+Kf8AwUB+BXwle6g1Px3YalqFudr2Oiv9tlDf3T5eQCO+SMV+Ivxw/a1+KP7Ql9LJ4v8AE91cWLElNLt3MdpHz/DGDj8favHadgP188c/8FrvB9g5i8KeBdT1U8/6RfzrCnthRkn9K8f1v/gtj8R5XkGk+BfC9shPyNd/aJGA99sqivzjop2A/aj/AIJ3/t8ePP2rvif4j8N+LdM0WztbHSG1GGTS4ZI2DrNFHtO52yCJSfwFfftfjT/wRR/5OE8Z/wDYry/+ldrX7LdqQH8y3x3/AOS0eNf+wvcf+jDX9JvgX/kSPD3/AGDrf/0UtfzZfHf/AJLR41/7C9x/6MNf0m+Bf+RI8Pf9g63/APRS0MDmviX+z98OfjBYvaeMPB2la0jAjzJIdkwz1xKmHH4Gvh347f8ABGjwfrsE1/8AC7Xrzw3f4yNM1N/tNo3srYDr+LNX6R0UgP5uPjP+zT8Uf2YtagfxXod7omJSLXVrZiYHcd45l4z9Dmvpb9kr/gqp43+Et5BofxJubnxv4TOFW6nO+/tPdZOsi+ofJ44Ir9nvE3hfSfGeh3mja7p1tq2lXkZiuLO7iEkcinsVPFfhJ/wUg+EPwj+DXxkh0b4Y30v2l4ml1bSI/nttPkJGxEkJzkjcSmMLxzzgPcD9uPhH8ZvB3xz8IWviTwZrdrrOnToC3kyAyQMeqSp1Rh6Gu2r8MP8Agk7oPjq+/af03UfDSXSeHLSKQa7OCRb+SUbaj9ixbG0dc4PbNfufSAWkoFFABRRRQAUkn3G+lLTX+430oA/mF+Kn/JT/ABf/ANhi8/8AR71y1dT8VP8Akp/i/wD7DF5/6PeuWqgCiiimB90/8EcP+Ttb3/sWbz/0db1+3lfiH/wRw/5O1vf+xZvP/R1vX7edqlgBoooxSAKKKKAFpKKKACiiigAooFFABRRiigBaKbiigD+a79qj/k5L4mf9jBe/+jWryyvU/wBqj/k5L4mf9jBe/wDo1q8sqgCiiimB9d/8Epf+T3fBX/XrqP8A6RTV+9Vfgr/wSl/5Pd8Ff9euo/8ApFNX71VLAKKWikAlFFLQAUUlLQBleKPFGleC/D2oa7rd9Dpuk2ELXFzdTsFSNFGSSa/Bb9t/9ufxL+1R4suNPs7mbS/h7ZTn+z9Kj+Tz8EhZp/7zEc4PC9hnmvqX/gsR+1A5vbH4MaFeMI1ijv8AXTE2AWY5igb6BQ5HT519K/LKmgCiiiqAKKKKACiiigD9C/8Agmz+37qfw28XWPw5+IOsG48FajiGwvrxiW06f+Ab/wDnm33SD0O0gjnP7MRSpNEkkbB0cBlZTkEHoQa/ld6V+43/AASm/aUHxj+BX/CIatdGXxP4PYWreYctNZsSYHHPO35o/YIvrUsD7fopKWkAlFLRQAlFLSUAFFFLQAlFFFABRRS0AJRRRQAteX/tC/tF+Df2afAk3ifxffCGLPl2tlEQZ7uU9EjXv6k9gCazf2n/ANqDwl+y18PLjxH4kn868kVk07SoT++vZscKvoucZY8D9K/AT4+/H/xd+0d4+u/FXi6/a4uJGZba0Vj5NpFnIjjXsB+vU0wPVP2tP29/iB+0/rlzbNey+HfBaMVtdCsZGRXXPDTtnMjn8FHYDnPzFRRTAKKKKYBRRRQB+h//AARR/wCThPGf/Yry/wDpXa1+y1fjT/wRR/5OE8Z/9ivL/wCldrX7LVLA/mW+O/8AyWjxr/2F7j/0Ya/pN8C/8iR4e/7B1v8A+i1r+bL47/8AJaPGv/YXuP8A0Ya/pN8C/wDIkeHv+wdb/wDotaGBuUUV8T/8FBf2/dN/Zw0SXwh4TuY7/wCIt/AT8nzJpkZ4Ekh6bzztXrxk4BGUBj/8FGP+CgMHwG0S78BeBL2Gf4g3sfl3F0mHGlRMOWx080g/KD0znHFflb+z18BfGH7W/wAXY9C06aWe5upDc6nrF1ukEEZOWkc9yecDuazPg98H/HH7U/xah0TRYrjV9b1W5a4v9SuXJWIMS0s80h/E88k8DJIFfvn+y7+zJ4X/AGXPhzD4c8PwJJezbZdS1IriW8mAxknrtGTgdsn1NPYDV/Z5/Z98K/s1/DbTvB/ha3IigXddX0oHn3kx+9LIR3J6DoBgCvSbm5isreW4nkSGCJS7yOcKqgZJJ7CnSSJDGzuwRFBZmY4AA6kmvyO/4KW/8FC4vGRu/hV8NNQdtHjYpretQMVF04P+oiPdByWboTjHTlAd1+0P/wAFiX8EfE650H4c+HtK8RaDp03k3Op6g0h+1MPv+TsdQoByATuzjPfFfeX7P/x08O/tE/DHSvGXhydHt7uMC4tt2XtZwBvif3U/n1r+fv4c/ss/En4q/DTxR498OeHZ73w14eiaW5ushfNCDdIIlJzIUXJIXP58V6b/AME//wBry6/ZZ+LKrqbyzeC9b22uq2oJ/dHPyTqvTchyP91mp2A/f6iqmj6vZ6/pVnqWnXMd5YXcSzwXETZSRGGVYH0Iq3SAM0j/AOrb6GlpH+430oA/mE+Kn/JT/F//AGGLz/0e9ctXU/FT/kp/i/8A7DF5/wCj3rlqoAooopgfdP8AwRw/5O1vf+xZvP8A0db1+3lfiH/wRw/5O1vf+xZvP/R1vX7eVLAKKKKQBRRRQAUUUdqACiiigAooooAP50UUUAHNFGKKAP5rf2p/+TkfiZ/2MF7/AOjWryyvU/2qP+TkviZ/2MF7/wCjWryyqAKKKKYH13/wSl/5Pd8Ff9euo/8ApFNX71V+Cv8AwSl/5Pd8Ff8AXrqP/pFNX71VLAKWiikAlLRRQAlQahex6bYXN3McRW8TSuf9lQSf5VYrg/jzrsnhn4KeOtUiO2a20W7eM4zhvKYA4+pFAH8737SHxHl+Lnx38c+LZeBqWqTPEpOdsSnZGM+yKtebU53aR2djlmOST3NNqgCiiimAUUUUAFFFFABX1t/wTA+Lj/C79q3w9aSOq2HiU/2NMrnALyMBER7h8fnXyTXdfArWG8PfGjwNqakhrPWrScEdfllU/wBKQH9NdFA6UVIC0lLSUAFFFFABRRS0AJRRRQAUUUtACVyvxT+JmhfB7wDrPi/xJdpZ6RpkJlldjgseiovqzMQAPU11VfjP/wAFa/2rv+Fj+PIfhZ4ev2k8PeHZzJqRhb5Li9AK7Tg/MIwWHpk+1AHyn+1N+0l4i/af+K2oeKtbmZLMHyNN09SfKtLdSdqqPU5JJ6kn6V49RRVAFFFFMAooooAKKKKAP0P/AOCKP/JwnjP/ALFeX/0rta/Zavxp/wCCKP8AycJ4z/7FeX/0rta/ZapYH8y3x3/5LR41/wCwvcf+jDX9JvgX/kSPD3/YOt//AEUtfzZfHf8A5LR41/7C9x/6MNftd+1H+274d/ZP+DWgW0UkWqePNQ0iBtN0gHOwGMATS/3UBB68tggdDQAv7f8A+3DY/steCzpGhPBffEHVoytnbs4IskOAZ5FHPQnaOMnnkDB/GHwL4G8eftW/F9dN04T694o1mczXF1OxIQE/NI7fwqM1X0nS/H37UvxfS3iN74q8ZeILos8sjF2JOSzMTwqKMnsABX7tfsbfsd+Gf2TfAf2Oziiv/FeoKr6trLIDJKwHESHqsanOB3JJNGwGj+yR+yb4Y/ZR+HVtoulhb/XrhFfVdZkQB7qbHzBf7sYP3V9MZJPNe6lgASTgDvRX5kf8FJv+CiKeHIbz4XfDHVt+qSK0es61ZuR9nB48iJx/EedzDpwM9aQGH/wUp/4KJP8A8Tj4SfDO/VVO6013Xbd8t6PbwsOndWb6gY618g/sU/sba9+1n4/MRMun+EtPZZdU1UrngniNM8F2wfwBrJ/ZD/ZH8U/tY/EOHT7CGa18N20qvrGtuv7u3jzllBP3pGHRRnkgnAya/ff4S/Cbwz8E/A2n+FPCemxaZpNmoAWNQGlfAzI56sxxyTT2AteA/hv4d+GvgbTvCHh/TYbLQLG3+zR2oUFWX+It/eLEkk9yTX4i/wDBSf8AZDX9m34pxa3oMDL4J8SvJLZr1FrMMF4SfT5sr7Z9K/eCvEP2yv2fbT9pL4Da94VkhR9ViX7dpcrAZjuo1bbgnpuVnX/gVID5a/4JA/tLN43+HF98LdaufM1bw4zT6a7klpbN23FeepRy34EelfopX81HwX+KHiD9mP436X4lt4pbfVNBvjFe2RODIqttmhb6gFTX9I/h3XrLxToGnazp0wuNP1C3jureZejxuoZW/EEU2BoUj/6tvpS0j/cb6GkB/MJ8VP8Akp/i/wD7DF5/6PeuWrqfip/yU/xf/wBhi8/9HvXLVQBRRRTA+6f+COH/ACdre/8AYs3n/o63r9vK/EP/AII4f8na3v8A2LN5/wCjrev28qWAZooopAFFFFABRRRQAUUUUAFFFFABmjNFFABkUUUUAfzW/tT/APJyPxM/7GC9/wDRrV5ZXqf7U/8Aycj8TP8AsYL3/wBGtXllUAUUUUwPrv8A4JS/8nu+Cv8Ar11H/wBIpq/euvwU/wCCU3/J7vgr/r11H/0imr96qlgLSUtFIBKWkpaACuR+Lugr4o+FXjDSGO37bpF3AGxnBaJgDjvg4rrqbJGssbI6hkYFSp6EHtQB/LDeWr2V3PbyDEkLtGw9wcGoa93/AG4vhI/wW/ah8deH1tWtbCW8Oo2Oc7XgnHmAqT1ALMv1QjtXhFUAUUUUwCiiigAooooAK9K/Zp0FvFH7Qfw50lUMn2zX7KEqBngzKDXmtfdn/BIb4PN47/aJn8WXVrJJpnha1M4lKfu/tL5EY3YxkYLY68UmB+3I6UtFFSAUlFLQAlFFFABS0lFABRRRQAtJRRQB49+1p8eLf9nL4EeJvGbeW+oW9uYdOhkbAlunG2Ie4DEE+wNfzh39/capez3l3M9xdTuZJZZDlnYnJJPrX6Y/8Fo/jZJfeLPC3wvspz9msbcatfqneWQssaN9FUN/wMV+Y1UgCiiimAUUUUAFFFFABRRRQB+h/wDwRR/5OF8Z/wDYry/+ldrX7LV+NP8AwRR/5OE8Z/8AYry/+ldrX7LVLA/mW+PH/JaPG3/YWuf/AEYahto/Gv7QHj7T7JGvfE/ia+ENlboSXcqihEUeihQK9V/aO/Zp+JOnftM+JvDcXg/WL6+1LVpX09raxkeO7jdztkRguCuOp7c5xiv1e/YG/YU0j9l3wkut67bQaj8RdSQNc3rAN9hjIGIIj27lmHJJxnAFAGv+w5+xDon7KXg6O6vfJ1Xx3fwj+0NRCfLDnBMMXfaDwW6tjoOlfUo6UV8G/wDBRP8A4KDWnwH0y48BeBL+K68f3cJFzdQMHGlI3AJPTzTyQvUDBPUUgML/AIKTf8FBLf4W6RqXww+H93HceMLxDBqepRSZGmRn7yLjrKw45+6Ce/T82/2Wv2XvF37XXxNOj6W7w2MTC41fW7hS6W0ZPU/3nbnC5559KyPgB8BPGf7VfxWg0HRo7m+uryY3Gp6vcFnW3QndJNNIe556nLMQOSa/fr9nX9nnwr+zX8OrPwr4Ys44wAJLy+KDzrybHLu3U98A9B0p7AaXwO+CXhj9n74c6V4O8K2gt7CyjAknYDzbmX+OWQ92Y5Pt0HArvqKKQBRRRQB+D/8AwVQ+Cz/Cv9qbV9Xt4fL0jxXEmrW+1cKshASZfqZEdv8AgQr9FP8AglR8al+KH7Men6Hcy79W8JuNNlBfcTDyYDjt8ox/wGuN/wCCyHw0h8Sfs+aX4ujszJe+HtRRWuEUkpDMQhDY/h3FevQn3r5b/wCCMvj6bQ/2iNd8MSTlbLW9EldId3DXEUkbqceoTzfzp9AP2ipJPuN9KWkf7jfSkB/MJ8VP+Sn+L/8AsMXn/o965aup+Kn/ACU/xf8A9hi8/wDR71y1UAUUUUwPun/gjh/ydre/9izef+jrev28r8Q/+COH/J2t7/2LN5/6Ot6/bypYBRQaKQBRRRQAUUUUAFFFFABRRRQAUUUUALRSUUAfzW/tUf8AJyXxM/7GC9/9GtXllep/tT/8nI/Ez/sYL3/0a1eWVQBRRRTA+u/+CUv/ACe74K/69dR/9Ipq/eqvwV/4JTf8nu+Cv+vXUf8A0imr96qlgLSUUUgFpKKKAFoopKAPg/8A4Ksfsoz/ABn+Gtv488OWZufFXhmIrLFGCXubLJZlGOpQszAf7Rr8SyCpIIwR1Br+qNlDqVYAgjBB6EV+SX/BQz/gmpdaBd6r8S/hRpklzpUjNc6p4ds4yz2xJy0sCjnZk5Kj7o5GAOGgPzIop0kbROyOpR1JDKwwQfQ02qAKKKKACiirujaLf+ItVtNM0uyuNR1G7lWG3tLWMySyyMcKqqASSSQABQA7QtDv/E2s2WlaZayXuoXkqwQW8S7mkdjgACv6Df2EP2bE/Zl+AOk6HdxIPEuosdR1iVVwfOf7sf8AwBAi/UE968J/4J5f8E6F+BU1t8Q/iBDFd+NZbfFlprruTS92MsTnBlxxn+HJ7mv0AqWAUlFLSASlopKACiiigBaSiloASilooASgnaCSeBS1i+NNYi8P+D9d1SZ/LhsrCe5dsZwEjZif0oA/nr/bo+Iv/C0f2sPiRraTedbJqbWEBzx5duqwDHsfLJ/GvB60/E2rNr3iTVtTYkte3ctySe5dy39azKoAooopgFFPiieaRY40Z5GOFVRkk+gFfpP+w3/wSyu/GbaZ44+MFjc6foRC3Fp4bl3QzXYIypm6MidDt4J+lID4/wDgn+xz8W/2greS78HeE7i602PrqF0629uT6BnI3H6ZqH42/sh/Fb9nuMXHjTwrPY6cWCrqMDrNbsSM43qePxxX7A/tM/t3/C/9jTSLLwj4fsrPWNet18qPw7pDKkdjGMf60rwmc8L948mu7+BfxQ8Pft4/szXGoa14c+yabrUdzpd9p1yBIqsMoXjY/UMrDkH3FK4H879FdN8TPCg8C/EHxF4eD+Yum30tsG9QrECuZqgP0P8A+CKP/JwnjP8A7FeX/wBK7Wv2Wr8af+CKP/JwnjP/ALFeX/0rta/ZapYDTGpYMVBYdyOadRRSA+Lf+CiP7dcH7NHhh/Cnhgi5+IOrQfunJ+TT4T1mYd2xkKOOTnPGD+IGoavdeK/EM2oa1fyzXV7OZLm8my7ksfmY+tfrv+3l/wAE0/FX7Qnxck8f+C9btFnvoI4bzT9RbaEaNQqtG3oQOQe9fMv/AA5x+NX/AD/aB/4F00B9Afstftp/ssfsu/DSy8N6Fda5PqDxq+papJpSrLdz4+ZjiQ4XOcLk4Hc9a9k/4e3/ALP/APz/AOu/+C4f/F18N/8ADnH41f8AP9oH/gXR/wAOcfjV/wA/2gf+Bf8A9agD7k/4e3/s/wD/AD/67/4Lh/8AF0f8Pb/2f/8An/13/wAFw/8Ai6+G/wDhzj8av+f7QP8AwL/+tR/w5x+NX/P9oH/gXRoB9yf8Pb/2f/8An/13/wAFw/8Ai6P+Ht/7P/8Az/67/wCC4f8AxdfDf/DnH41f8/2gf+BdH/DnH41f8/2gf+Bf/wBajQD6M/as/wCCjfwK+Nf7PfjjwZp15rMmp6ppzx2Yl09VTzx80e47+BuC818C/sAeMW8D/tg/DPUBIY0m1E2D843CeJ4cH8ZBXt3/AA5x+NX/AD/aB/4F16P+zz/wSM+IHhT4weFvEPjHWtMtdF0a/i1GRNPmZppWiYOiKRjbllXJ9M96AP1tpH+430NL2pH+430NID+YT4qf8lP8X/8AYYvP/R71y1dT8VP+Sn+L/wDsMXn/AKPeuWqgCiiimB90/wDBHD/k7W9/7Fm8/wDR1vX7eV+If/BHD/k7W9/7Fm8/9HW9ft5UsAooopAFFFFABRS0lABRRRQAUUUUAFFFFABmilooA/ms/an/AOTkfiZ/2MF7/wCjWryyvU/2p/8Ak5H4mf8AYwXv/o1q8sqgCiiimB9d/wDBKb/k93wV/wBeuo/+kU1fvVX4K/8ABKX/AJPd8Ff9euo/+kU1fvVUsAooopAFFMnnjtYJJppFhijUs8jthVA6kk9BXzB8YP8AgpJ8C/hBLNZzeLIvEmqxNsay0AG7wec5kXKDHTBbPNAH1FRX5VeMv+C28oup18K/DqPyASIpNWuixYdiQmMfSvIdT/4LJfG29kdrfTfDGnqTwsNk7Bf++3anYD9s6MZ61+GEn/BXX9oB3JXUtHjH91dLiIH5imf8Pcv2gf8AoLaR/wCCuH/4miwH6OftQf8ABNn4Z/tEyXWr2cI8HeLpdzNqmnxApO57yxZAY+4IP1r85fir/wAElPjl8P1uLnRbXSvG1ghyp0i72z7c4yY5VTn1ClqsaX/wV4+PNvqNtLeX2kXVqkimWA6bEu9c8jIAI49DX7LfB34p6N8avhp4e8aaDMk2n6vaR3IVW3GFyo3xN6MjZUj1FGwH89mr/sf/ABr0MkXfwx8SKR/zysWl/wDQM1a0b9i345a+VFn8MPEDbunnW3k/+hkV/R3RRcD8VvhP/wAEcvi14rubefxnqWj+DNNJBli883d4B3wiDZ09ZK/S39m/9ib4Y/szafA3h7R47/XwuJtev0D3Uhyc7T/AOeg/Wvbdf12x8MaJf6vqU6WthZQvcTzOcBEUZJ/IV+MnxQ/4K8/Fu5+IXiB/Bl1ptj4VF5ImmQz6fHJJ5AOEZmYEksBuP1o3A/auivws/wCHuX7QP/QW0j/wVw//ABNKP+Cuf7QIIJ1XSCPT+y4f/iaLAfujS1+I2mf8FjvjhZOpuLPw3qAHVZrFlz/3w61674P/AOC3F4oiHin4cwSngO2k3TRj3IEm6iwH6uUV8qfCn/gpn8Bvii0Vu3iyPwtqDkL9n8QL9lXJ9JW+T9a+odN1Oz1mwhvrC6hvrKdd8VxbyCSORfVWGQR7ikBZpaKSgBaKKKACiiigArzj9o68Nh8BPiBODjbol0PzjI/rXo9cX8atDbxJ8IPGmlxqGkutHuo0UnALeU2P1xQB/MbRTnQxuysMMpwR6Gm1YBXSfD34c+JPir4rsfDfhXSbjWdZvH2xW1smT0yWY9FUAEkn0r0f9mH9k3xv+1P4sGmeGbNoNLgcLfazOh+z2o68noWxyFzk1+zvwz+CnwX/AOCePwovNcubmCwaGFf7Q8Rao4N1eScDZGO25ukaD0znGaVwPL/2Lv8AgnD4Y/Zw0uPxr8R5LDWvGcai4DyH/Q9KUDJ2lsBm9XIGMcep8m/be/4KrR2P9reA/g7J5tz89pd+KT92Mg4YWoB5PBG8/gDwa+e/2u/+Cgnjv9rDxHH4K8CRXuj+EJ5fIg0yxBN1qbk4UyEfNjGMIMD1zX01+xD/AMErNO8MQ6b43+Mdp9u1kFbm08NO2ILY9VNwB99hwdmcDowPIpAfPP7HP/BN/wAZftH6vB44+Iz3OieDJpPPLXRP23VCTk7FPKoe7tjrwDzj9Av2jP2kfhp+wT8FD4X8Mw2sOu29o1vonhyyYbkkYHbNL6KGO9ieW7da8t/bd/4KaaJ8EoZPBHwpnsNZ8VIhjn1CALLaaYAMBVA+V39uQuORzx+PXjHxnrvxB8SX2v8AiTVbnWdZvpTNcXl2+53Yn9B6AYAHAAFG4FLWtXudf1e91K8kaa7u5nnldjkszEkn9apUUVQH27/wSh+Mngr4LfG3xTqvjjxFZ+G9OuvD0ltDc3pIR5Tc27BBgHnCsfwNfqZ/w3v+z5/0VbQP+/j/APxNfzrUUrAf0Uf8N7/s+f8ARVtA/wC/j/8AxNH/AA3v+z5/0VbQP+/j/wDxNfzr0UWA/oo/4b3/AGfP+iraB/38f/4mj/hvf9nz/oq2gf8Afx//AImv516KLAf0Uf8ADe/7Pn/RVtA/7+P/APE0f8N7fs+f9FW0D/v4/wD8TX869FFgP6KP+G9/2fP+iraB/wB/H/8AiaP+G9v2fP8Aoq2gf9/H/wDia/nXoosB/RXF+3l+z9PKkafFXQGdiFUea/JP/Aa94ikSaJJI2DI4DKw6EHvX8s+kWR1HVbK0AyZ5kix9WA/rX9S8CLHDGiqFVVACgYAGKQElJRRSAKST7jfSlpH+430oA/mE+Kn/ACU/xf8A9hi8/wDR71y1dT8VP+Sn+L/+wxef+j3rlqoAooopgfdP/BHD/k7W9/7Fm8/9HW9ft7X4hf8ABHD/AJO1vf8AsWbz/wBHW9ft5UsAooopAFFFFAC0lLSUAFLRSUAFFLSUAFFLSUALRRRQB/NZ+1P/AMnI/Ez/ALGC9/8ARrV5ZXqf7U//ACcj8TP+xgvf/RrV5ZVAFFFFMD67/wCCU3/J7vgr/r11H/0imr96q/BX/glN/wAnu+Cv+vXUf/SKav3qqWAV5D+0v+1B4M/Zb8DHxB4rume4n3R2Gl22GuLyQDOFBIAA4yx4GfUgHuPib8Q9I+E/w/1/xhrsvk6To1nJeTkfeYKuQq+rMcKB6kV/O1+03+0X4k/aZ+KGoeKtfupGt97R6dY5/dWdvn5UUfzPUnrQB237Uf7d/wAR/wBp6/ubXUr46L4TMm630GxYiIAdDIert3yfXivm+iimAUUUUwCiiigAr9Ff+CSX7WC+APHB+E3iG5ZdE8QzFtLlkf5Le8wTsOegkxgY/iI9c1+dVWtL1O70TU7TULGd7W9tJUngnjOGjkUhlYe4IBpAf1N0tfOv7C37TsH7UHwRstZuJYh4m00iy1eCMY2ygZWTHYOAfxVq9C/aJ+NWl/s+fB3xL451Royum2rNbW7tj7RcN8sMQ/3nKg47ZPapA+Ev+Cvv7Vi6BoVn8HPD11m/1FRd65JGf9VAP9VD9XOWI7BV9a/I6um+JXxD1r4reOdY8V+ILt73VtTnaeaWQ+vRR6ADAAHpXM1QBRRRTAKKKKACvcf2df2yPiZ+zLfZ8J6yZNIkkElxo17mS1mPTO3PBx3HtXh1FID99P2Ov+Chngr9qaKDRLmL/hF/HSx5k0i4kDR3JAyzQScbhwTtIBHv1r6yr+Wrw74i1PwjrthrWjX02m6rYTLcW13bvtkikU5DA1+8f/BPT9scftU/DS4t9ckgi8c6D5cWoxRYQXEbA7J1XPGSrA44BHuBSaA+sqSlpKQBS0UUAJVXV7L+0dKvbTp58DxZ/wB5SP61booA/mC+Knhe48E/E3xZ4fuozFcaZqt1Zuh7FJWX+lfXX7Ev/BNLxN8e72z8U+OIZvDfgBfnVXyt3f8AoI0x8qZ6s2PYGvv2z/4JseB9X/aZ8XfFfxdL/btvqN+l5p2glNtvE3lR73mPWQmQOQvAxjOc1wv7bf8AwU00L4JWd94K+GD2eseMo/8AR5b1AHtNN6hgADhpB0A6A9QcYpget/Gj9o34Q/8ABPz4aaf4dsrGFLqOEnTvDGlBVml7GSQ9FBI5dsk9gcV+UGv+Ifjb/wAFJfjGkNrZzaifMPk2sRZdP0mEnq7nhQB1PVj0BJxW7+zX+yH8TP28/HV34t8Tare23h95/wDT/Et6pdpW6mKAHAJGeg4XI45r9T9U1H4M/wDBN/4IL5UUWmWqKEhhLh7/AFa4x3PViepIG1RnAA4oA579l39jD4c/sR+D7jxVr9/Z3fiVLfff+Ir7Cx2ygZZIcjKr156tgcdq+H/24P8AgqLqXxZh1XwP8MGuNH8IyM1vc6w/7u51CMZDBAD8kbe/JXqBkivAP2t/24PHP7VfiFlv7j+xvCVsStloVmSsYH9+U5zI59+BjgDnPzjRYBWYuxZiSxOST3pKKKoAooooAKKKKACiiigAooooAKKKKACiiigD0j9m3wu3jX9oH4caGE8xb7xBYwOOwRp0DE+wGa/pdAwB7Cvwn/4JP/DIePf2rNN1Sdd1n4ctpNRcYz+8xiLnthsH8K/dipYBRRRSAKR/uN9DS0j/AHG+lAH8wnxU/wCSn+L/APsMXn/o965aup+Kn/JT/F//AGGLz/0e9ctVAFFFFMD7p/4I4f8AJ2t7/wBizef+jrev28r8Q/8Agjh/ydre/wDYs3n/AKOt6/b2pYCUGiikAUUUtACUUUUAFFLSUAAooooAKKKKADFFLRQB/NZ+1R/ycl8TP+xgvf8A0a1eWV6n+1P/AMnI/Ez/ALGC9/8ARrV5ZVAFFFFMD67/AOCU3/J7vgr/AK9dR/8ASKav3qr8Ff8AglL/AMnu+Cv+vXUf/SKav3qqWB+ZP/BZn49jS/C2gfCnTrn9/qbrqOqRqDxEhzEpPuwDY9q/JCvpz/gpH8QX+IP7YXj6QSbrbSrpdJhTsn2dFif83Rj+NfMdNAFFFFMAooooAKKKKACiiigD6W/YE/aek/Zk+OVnqF7O6eFtZ2WOsRKTtCZ+SXA6lCT+DNXp/wDwVH/a5tfjv8SofB3he/F54O8OOR9oiP7u7usYd1PdV5UHvjI618NUvWkAlFFFMAooooAKKKKACiiigAr2/wDYy+OU/wCz7+0J4Y8UCRk095hZagignfbSEBhj2IB/CvEKdHI0Uiuh2spDA+hpAf1P21zFeW0VxBIssMqCRHU5DKRkEfhUteO/seeMJ/Hn7Lnwv1q6bfdTaBaRTP8A33jjEbN9SUJ/GvYGZUUsxCqOSSelSA6sDxj498N/D3SzqXibXbDQbEHAnv7hYlY+gyeT7CviL9sv/gqX4d+DgvvC3w1az8UeMYy0M17Jl7KxccHO0jzGB7AgA9c9K/JL4s/Hbx38cdbfVfGviS91u4Jyscr7Yox6LGMKOvpTsB+9UP7e/wAALjUhYJ8TdK+07tuGinVM/wC+Y9v616xd/E7wnY+C5fF03iLTR4Zih89tUW4VoNmM5DAnJ9hzX8wFdBF478SHwufCw1+/Tw9LOkzaa1ywt96ghWK5xwGP50WA++P23f8AgqBqvxVubvwN8I5L3TPDT/uLjV1BjutQJ4KxqPmRO3qe4Fan7D//AASu1HxbJpvjf4wWbabonE9r4blOJ7odVMwH3EPXafmPQgZr6D/YA/4J5eDvhX4e0b4jeIby18ZeKb+BLuykiw9lZIwBXyxj539WPHYAYyfPP+CgP/BTPUfBOq6z8MfhlE+n6zazPaapr1whDwFThkt16A5BG8546DJyAD3L9rL9vf4f/sfaEng3wvZ2ur+Lbe2EdroengJbaeuCE80qML/uD5sDkDIz+Knxa+L/AIr+N/jK88T+MNWm1bVblid0jHZEueEReiqOgA4GK5jV9Xvtf1O51HUrua/v7mQyzXNw5eSRj1JJ5JqnTsAUUUUwCiiigAooooAKKKKACiiigAooooAKKKKACiiu1+DHww1L4zfFDw54N0qMvd6rdrDkfwJ1dj6YUE0AfrP/AMEbvgu3hL4J6v8AEC9t1S88UXbRWkhX5/ssDFOvoZFk/IV+hVcx8Mvh/pnwq+H3h/wjo8fl6do9nHaRccttHzOfdmyx9ya6aoAKWkooAWmyfcb6GlpH+430NAH8wnxU/wCSn+L/APsMXn/o965aup+Kn/JT/F//AGGLz/0e9ctVAFFFFMD7p/4I4f8AJ2t7/wBizef+jrev28r8Q/8Agjh/ydre/wDYs3n/AKOt6/bypYC0lFFIAooooAKKKKACiiigApaSigAooooAWikzRQB/Nb+1P/ycj8TP+xgvf/RrV5ZXqf7U/wDycj8TP+xgvf8A0a1eWVQBRRRTA+u/+CU3/J7vgr/r11H/ANIpq/eiVtkbt6AmvwX/AOCUv/J7vgr/AK9dR/8ASKav3muv+Pab/cP8qlgfzNfHzVW1346/EbUnYu154j1G4LHqd1zI39a4Ouk+JUnnfEbxVJ/f1W7b85mrm6YBRRXuX7FfwP0P9or9onw54E8R3N7aaRqEdy80unuqTDy4XkAUsrAZK46GgDw2iv2v/wCHMXwP/wCg540/8GFt/wDI9fjz8UfDFr4K+I3iTQbF5ZLPTr+a1hacguVViBuIABP4UXA5aiiimAUUUUAFFFFABRRRQAUUUUAFFaPhyyj1PxDpdnNnybi6iifacHazgH9DX7eaJ/wSe+Ad3o1hPLp2tNLLbxu7fbxySoJ/gpAfhlRX0R+3t8FfDX7P/wC0hrPg7wnHcRaLbWltNGl1IJHDPGGbkAcZ9q+d6YBRRRQB+5v7F3x58HfBP/gnr8O/E3jvXrfR7CGC9jjEhLzTlL24VUjjXLO2AOAOO+BzXwX+2P8A8FMvGH7QMlx4d8HyXXhHwRuZWjhkMd1fL0Hmsp4Xr8gOOeegr45vvE2ranpGn6Vd6jc3Gm6eGW0tJJCYoAzFm2r0GWJJ+tZlKwBRRRTAKKKfDC9xKkUSNJI5CqijJJPYUAft/wD8Egvide+Of2XptFv5Glfwxq02nwO7ZJgZEmUfg0rj6AV5H/wV+/ZSbVNKtPjJ4a07fc2e2019LdAC0ROI7hgOThiEJ5PzDsOPoX/gmB8BtR+Bn7M9sdbRoNZ8S3z6zNbuuGgRkSONDnvtjD/8Dx2r6r8QaBp/irQ77R9WtY77Tb2FoLi3mGVkRhgg1AH8tNFfVf7fv7Gt7+yz8TJJ9LSa78CawTPpt2y/6hifnt3PTKnGDxkEV8qVQBRRRTAKKKKACiiigAooooAKKKKACiiigAooooAK/Yj/AIJHfsmT+AfDF78WPFGmG31rW4Bb6PHcoN8NoTueUA8qZCEAPBwp7Nz8df8ABPD9im8/aV+IVrr+vW8sHw/0W4Wa7kK8X0ikMLdT6HgMR0Ge9fu3Y2NvpllBaWkKW9rAgjiijGFRQMAAemKlgT0tJRSAKWkooAKR/uN9KdTZPuN9KAP5hPip/wAlP8X/APYYvP8A0e9ctXU/FT/kp/i//sMXn/o965aqAKKKKYH3T/wRw/5O1vf+xZvP/R1vX7eV+If/AARw/wCTtb3/ALFm8/8AR1vX7eVLAKKKKQBS0lFAC0UlFAC0lLSUAFFFFABRRRQAUUtFAH81n7U//JyPxM/7GC9/9GtXllep/tT/APJyPxM/7GC9/wDRrV5ZVAFFFFMD67/4JTf8nu+Cv+vXUf8A0imr95br/j1m/wBw/wAq/Br/AIJS/wDJ7vgr/r11H/0imr95br/j1m/3D/KpYH8wHxD/AOR/8Tf9hO6/9GtXPV0PxD/5H/xN/wBhO6/9GtXPUwCvrb/gld/yez4J/wCuF/8A+kktfJNfW3/BK7/k9nwT/wBcL/8A9JJaGB+99fzNftA/8lv8c/8AYXuf/Rhr+mav5mf2gf8Akt/jn/sL3P8A6MNJAef0UUVQBRRRQAUUUUAFFFFABRRRQBs+DP8AkcNC/wCv+D/0Ytf0+eHP+Rd0v/r1i/8AQBX8wfgz/kcNC/6/4P8A0Ytf09+HP+Re0v8A69Yv/QBUsD8MP+Csf/J53iL/ALB9j/6JFfHVfYv/AAVj/wCTzvEX/YPsf/RIr46pgFFFFMAooooAKKK+sf2SP+Cd3j79pq8h1S7U+FPBSMPN1a8iLPMO6wx5BY+5IAz3pAfOnw8+Gnij4seJ7Xw94R0S817V7lgqW9nEXIyfvMeiqO7HAHc1+wf7GP8AwS18PfBu4sPF/wAR1g8S+MISJLewOJLKybsduMSOPU5A6jnmvqr9n/8AZq8C/s1+Ek0PwbpSWxbDXV/Lhri6f+87/wAgOBXqVK4AAAAAMAUUUUgOO+LXwk8LfG7wPqHhPxfpUOq6ReLgpIPmibHEiN1Vx2I5r8F/2xv2LvFf7J/jCSO6hm1PwfdysNN1xU/duvURyEcLIB1BxnBIyK/oZrm/iH8OfDvxW8JX3hrxVpcGr6Nertltp1yODkMD2IIBBFAH8v1FfoB+2V/wSw8TfCWW88VfDTzvFXhJmaSTTFQm+sR6YGRKnuMEenevgKaCS2leKaNopUO1kcEMp9CD0qgGUUUUwCiiigAooooAKKKKACiip7OyuNRuo7a1gkubiQhUiiUszH0AHWgCCvqL9if9hvxN+1b4pW6nhn0jwJYyL9v1h02iU9fJhz95yOuMhQRnGRn3b9jb/glFr/j2503xb8WQ/h/w2rCaPw/g/bLxRyBIekSH8WI4wM5H67+FPCWjeB9BtNF0DTbbSNKtV2Q2lpGEjQewFTcCh8N/hz4e+E3grSvCnhbTYdK0TTYRDBbwqBnHVmP8TMckseSSSa6WiikAUUUUAFFFFAC01/uN9DS0j/cb6UAfzCfFT/kp/i//ALDF5/6PeuWrqfip/wAlP8X/APYYvP8A0e9ctVAFFFFMD7p/4I4f8na3v/Ys3n/o63r9vK/EP/gjh/ydre/9izef+jrev28qWAtJRRSAKKKKACiiigAooooAKKKKAFpKKKAFooooA/ms/an/AOTkfiZ/2MF7/wCjWryyvU/2p/8Ak5H4mf8AYwXv/o1q8sqgCiiimB9d/wDBKb/k93wV/wBeuo/+kU1fvLdf8es3+4f5V+DX/BKb/k93wV/166j/AOkU1fvLdf8AHrN/uN/KpYH8wHxD/wCR/wDE3/YTuv8A0a1c9XQ/EP8A5H/xN/2E7r/0a1c9TAK+tv8Agld/yez4J/64X/8A6SS18k19bf8ABK7/AJPZ8E/9cL//ANJJaGB+99fzM/H85+Nvjn/sL3P/AKMNf0zV/Mz8fv8Aktvjj/sL3P8A6MNJAcBRRRVAFFFFABRRRQAUUUUAFFFFAGz4M/5HDQv+v+D/ANGLX9Pnhz/kXtL/AOvWL/0AV/MH4M/5HDQv+v8Ag/8ARi1/T34c/wCRd0v/AK9Yv/QBUsD8MP8AgrICP2zvEWf+gfY/+iRXx1X6Bf8ABZzwxPp37RPh/W2gZLfUtFSJJtvyu0TkEZ9RvH51+ftNAFFFFMArb8GeCde+IfiK00Lw1pN5rer3TbYrOxhaWRvfCgnA7ntXvn7KP7BXxD/ak1KG6s4F8PeEUcfaNd1BCFK9xCg5kbHToPVhX7U/s3fsn+AP2X/DpsPCemL/AGjPGiXur3ADXN0V9T2GSTtHFK4HyF+x5/wSa0TwdFYeKvjBFHruuqUnh8Pq+bS2I5Amx/rTnquSvYg1+jllY2+m2kVraQRWttEoSOGFAiIB0AA4AqeipAKSlpKACiiloASlpKKACvlj9pL/AIJzfCb9oWK8v/7JTwn4qlyy6zoyiLe5OSZYh8j57kjdyea+qKKAPwZ+OX/BLz4z/CEzXel6O3jnR1LbbjQo2mnCjoWgGXHHoD0NfJWqaVe6HfzWOo2dxp97A2yW2uomjkjb0ZWAIP1r+po1xXj/AOCfgL4pwyR+LfCGj+IA6GMvf2aSOBjHDEZB9CDxTuB/MfRX7rfEL/gk18CvGY8zTdP1DwrcjOG024zEc+qN6exFeR6l/wAESPCFwT9i+JOq2fpv01Jcf+RRTuB+QtFfqkf+CHbfaCB8XB5HZjoXzfl5+P1rptE/4IjeE7SVG1P4l6pqCD7yQ6WkGfofNbFFwPyHq9o2h6l4j1GKw0nT7rU76U4jtbOFpZXPsqgk1+5/gP8A4JQfATwbKs17pGoeJpxgn+1bstF/3woA/PNfTvgf4T+DPhrarbeFfC+k+H4Qu3bp9okWR7kDJpXA/FP4Cf8ABK74wfFi7tLnxHpr+AdBfDST6vGUudvcLAcOGx/eAHrX6g/s3f8ABPz4Tfs3rDf6do/9v+J1A3a5rH76VWHeND8kf1UZ96+lqKQC0lFLQAlFFFAC0lFLQAlFFFABSSfcb6UtJJ9xvoaAP5hPip/yU/xf/wBhi8/9HvXLV1PxU/5Kf4v/AOwxef8Ao965aqAKKKKYH3T/AMEcP+Ttb3/sWbz/ANHW9ft5X4h/8EcP+Ttb3/sWbz/0db1+3lSwClpKKQBRRRQAtJS0UAJRRRQAUUUUAFLSUUALRRRQB/NZ+1P/AMnI/Ez/ALGC9/8ARrV5ZXqf7U//ACcj8TP+xgvf/RrV5ZVAFFFFMD67/wCCU3/J7vgr/r11H/0imr95bv8A49Zv9w/yr8Gv+CU3/J7vgr/r11H/ANIpq/eW6/49Zv8Acb+VSwP5gPiH/wAj/wCJv+wndf8Ao1q56uh+If8AyP8A4m/7Cd1/6NauepgFfW3/AASu/wCT2fBP/XC//wDSSWvkmvrb/gld/wAns+Cf+uF//wCkktDA/e+v5mfj9/yW3xx/2F7n/wBGGv6Zq/mY+Pv/ACWzxx/2F7n/ANGGkgOBoooqgCiiigAooooAKKKKACiiigDZ8Gf8jhoX/X/B/wCjFr+nzw5/yL2l/wDXrF/6AK/mD8Gf8jhoX/X/AAf+jFr+nzw5/wAi9pf/AF6xf+gCpYHzX/wUH/ZJk/ar+EMNtpEqW/i7QZmvdMZx8s+VxJAx7Bhgg/3lXtmvwd8ceAfEXw18RXGheKNGvNC1a3OHtb6FonxkjIDAZBwcHvX9Q9Zms+GdI8RRhNU0uz1JAMBbqBZB+oNFwP5jfBHw98S/EnXINH8LaHf69qUzBUtrC3aV+T1IUHA96/UL9j7/AIJH2unm28UfGpftdxhZLbwzbzFY0PXNw68k9PlUjvmv010rRNP0K2+z6bY29hB18q2iWNfyAq7RcCno2i6f4d0u103S7KDTtPtY1igtbaMRxxoBgKqjgACrlLSUgFpKKWgApKKWgBKKWkoAWiiigAopKKACilpKAClopKACilpKACiiigAooooAKKKWgBKKKWgBKKKKACiiloASkf7jfQ0tI/3G+hoA/mE+Kn/JT/F//YYvP/R71y1dT8VP+Sn+L/8AsMXn/o965aqAKKKKYH3T/wAEcP8Ak7W9/wCxZvP/AEdb1+3lfiH/AMEcP+Ttb3/sWbz/ANHW9ft5UsAooopAFFFFABRRRQAUUUUAFFFFABRRRQAtFJRQB/Nb+1P/AMnI/Ez/ALGC9/8ARrV5ZXqf7U//ACcj8TP+xgvf/RrV5ZVAFFFFMD67/wCCUv8Aye74K/69dR/9Ipq/eW6/49Zv9w/yr8Gv+CU3/J7vgr/r11H/ANIpq/eW7/49pv8AcP8AKpYH8wHxD/5H/wATf9hO6/8ARrVz1dD8Q/8Akf8AxN/2E7r/ANGtXPUwCvrb/gld/wAns+Cf+uF//wCkktfJNfW3/BK7/k9nwT/1wv8A/wBJJaGB++FfzL/H3/ktnjj/ALC9z/6MNf0z1/Mx8ff+S2eOP+wvc/8Aow0kBwNFFFUAUUUUAFFFFABRRRQAUUUUAbPgz/kcNC/6/wCD/wBGLX9Pnhz/AJF7S/8Ar1i/9AFfzB+DP+Rw0L/r/g/9GLX9Pnhv/kXtL/69Yv8A0AVLA0aKKKQCUtFJQAtJS0UAFJS0UAJS0UlABS0UUAJS0lLQAlFLSUAFFFLQAlFLSUAFFFFABRRS0AJRRRQAUUUtACUUUtACUUtFACUUUtACUj/cb6UtJJ9xvpQB/MJ8VP8Akp/i/wD7DF5/6PeuWrqfip/yU/xf/wBhi8/9HvXLVQBRRRTA+6f+COH/ACdre/8AYs3n/o63r9vK/EP/AII4f8na3v8A2LN5/wCjrev29qWAlFLSUgCiiigAopaSgAopaSgAopaKAEopaKAEopaKAP5rP2p/+TkfiZ/2MF7/AOjWryyvU/2p/wDk5H4mf9jBe/8Ao1q8sqgCiiimB9d/8Epv+T3fBX/XrqP/AKRTV+8t1/x6zf7h/lX4Nf8ABKb/AJPd8Ff9euo/+kU1fvLd/wDHrN/uN/KpYH8wHxD/AOR/8Tf9hO6/9GtXPV0PxD/5H/xN/wBhO6/9GtXPUwCvrb/gld/yez4J/wCuF/8A+kktfJNfW3/BK7/k9nwT/wBcL/8A9JJaGB++FfzLfHv/AJLV43/7C9x/6Ga/por+Zf49/wDJavG//YXuP/QzSQHBUUUVQBRRRQAUUUUAFFFFABRRRQBs+DP+Rw0L/r/g/wDRi1/T34b/AORe0v8A69Yv/QBX8wngz/kcNC/6/wCD/wBGLX9Pnhz/AJF7S/8Ar1i/9AFSwNGiikpALSUtFABSUtFACUtFFACUUtFABSUtFABRRRQAlFFFABS0lFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFLQAlFFLQAlFFLQAlI/3G+hpaR/uN9DQB/MJ8VP+Sn+L/wDsMXn/AKPeuWrqfip/yU/xf/2GLz/0e9ctVAFFFFMD7p/4I4f8na3v/Ys3n/o63r9vK/EP/gjh/wAna3v/AGLN5/6Ot6/b2pYCUUUUgCiiigAopaSgAopaSgAoopaAEooooAKKWigD+az9qf8A5OR+Jn/YwXv/AKNavLK9T/an/wCTkfiZ/wBjBe/+jWryyqAKKKKYH0Z/wT8+K3hr4K/tT+FvFni2+/s3QrSC9jmudhYIXtZUTgerMB+Nfrddf8FNP2ezazBfGwZthwotnyTivwFopWA2PGV/Dqvi/XL22bfb3N9PNG3qrSMQfyNY9FFMAr6I/YD+Kvhz4LftR+FvFviy9OnaFZxXaT3IUtsL28iLwP8AaYV870UgP3//AOHmv7PP/Q8L/wCAz/4V+Fvxb12z8T/E/wAU6tp8nm2V7qM08LkY3Izkg1yVFFgCiiimAUUUUAFFFFABRRRQAUUUUAaXhm8i0/xHpV1M22GC7ildvRVcE/oK/d/Qf+Cl/wCz7b6Hp0UvjURypbRq6G2fKkKARX4HUUgP3/8A+Hmv7PP/AEPC/wDgM/8AhR/w81/Z5/6Hhf8AwGf/AAr8AKKLAfv/AP8ADzX9nn/oeF/8Bn/wo/4ea/s8/wDQ7r/4DP8A4V+AFFFgP3//AOHmv7PP/Q8L/wCAz/4Uf8PNf2ef+h4X/wABn/wr8AKKLAfv/wD8PNf2ef8AoeF/8Bn/AMKP+Hmv7PP/AEPC/wDgM/8AhX4AUUWA/f8A/wCHmv7PP/Q8L/4DP/hR/wAPNf2ef+h4X/wGf/CvwAoosB+//wDw81/Z5/6Hhf8AwGf/AAo/4ea/s8/9Dwv/AIDP/hX4AUUWA/f/AP4ea/s8/wDQ8L/4DP8A4Uf8PNf2ef8AoeF/8Bn/AMK/ACiiwH7/AP8Aw81/Z5/6Hhf/AAGf/Cj/AIea/s8/9Dwv/gM/+FfgBRRYD9//APh5r+zz/wBDwv8A4DP/AIUf8PNf2ef+h4X/AMBn/wAK/ACiiwH7/wD/AA81/Z5/6Hhf/AZ/8KP+Hmv7PP8A0PC/+Az/AOFfgBRRYD9//wDh5r+zz/0PC/8AgM/+FH/DzX9nn/oeF/8AAZ/8K/ACiiwH7/8A/DzX9nn/AKHhf/AZ/wDCj/h5r+zz/wBDwv8A4DP/AIV+AFFFgP3/AP8Ah5r+zz/0PC/+Az/4Uf8ADzX9nn/oeF/8Bn/wr8AKKLAfv/8A8PNf2ef+h4X/AMBn/wAKP+Hmv7PP/Q8L/wCAz/4V+AFFFgP3/wD+Hmv7PP8A0PC/+Az/AOFH/DzX9nn/AKHhf/AZ/wDCvwAoosB+/wD/AMPNf2ef+h4X/wABn/wo/wCHmv7PP/Q8L/4DP/hX4AUUWA/f/wD4ea/s8/8AQ8L/AOAz/wCFH/DzX9nn/oeF/wDAZ/8ACvwAoosB+/8A/wAPNf2ef+h4X/wGf/Cmyf8ABTX9nry3x42Vjg4Atn5r8AqKLAb3j7U7fWvHfiPULR/MtbvUrm4if+8jSsyn8iKwaKKYBRRRQB90/wDBHD/k7W9/7Fm8/wDR1vX7e1+IX/BHD/k7W9/7Fm8/9HW9ft5UsAooopAFLSUUALSUtJQAtJRRQAUtJRQAUUUUALRRRQB/NZ+1P/ycj8TP+xgvf/RrV5ZXqf7U/wDycj8TP+xgvf8A0a1eWVQBRRRTAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACitLw34b1Txhrtjouiafc6pqt9MsFtZ2kTSSyuxwFVQCScmv1W/Zm/4I7aLFpNrrXxivri9vpow/8Awj+nzGGOAnBxJKp3MR0wpA5pAfkvRX9FOl/sF/ADR7BbSD4XaG8QULuuEeZz9Xdi2ffNeVfGD/gk/wDBD4h6dct4d0u58Dayy/urrTLmR4d3+1FIzLj/AHcH3pXA/Cuiva/2o/2TvGn7K3jZ9H8R2j3OkzEtp2uQRH7NeJ7N0DjuhORwehFeKUwCiiimAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAfdP/BHD/k7W9/7Fm8/9HW9ft5X4h/8EcP+Ttb3/sWbz/0db1+3lSwClpKKQBRRRQAUUtJQAUUd6KACiiigBaSiigBaKTPvRQB/Nb+1P/ycj8TP+xgvf/RrV5ZXqf7U/wDycj8TP+xgvf8A0a1eWVQBRRRTAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKdGnmSKg4LECgD9ev+CQn7LVjo3gU/GHXbOOfV9Vklh0bzFybeBGaN5BkcMzKwBHav0przb9mnw5a+E/2evhvpVmixwQeH7E4Xu7QIzt+LMx/GvSqgBKWikoA83/aE+Bfh/8AaI+Fus+DfEEEbR3kLfZrorl7SfB2Sr7qcH36V/N7418H6n8P/Fur+G9ag+zarpVy9pcxc/LIhwRz9K/qKr8C/wDgqLoNvoP7ZPi9bdFQXcVveSbe7yJlifemgPk6iiiqAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPun/gjh/ydre/9izef+jrev29r8Qv+COH/ACdre/8AYs3n/o63r9vKlgFFLSUgCilpKACilpKACiiloAKSiigAopaKACiiigD+a39qtGi/aU+JyOCrL4hvQQf+uzV5XX0j/wAFE/DMnhj9sP4io8PkC9vjfqMY3LKNwb8etfN1UAUUUUwCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACl6UlFAH9FX7CXxMtvir+yh8OtWhlDzWumppdyucskttmA7vciMN9GFe91+GH/BNv9tlP2bPGcnhbxVdsngDXJwZZGGRYXBwon9lwBu9hntX7iaTq9jr2m2+oabdwX9hcoJIbm2kEkcinoVYcEfSoAt0UUUABOBk8V/Ox+3d8T7L4uftS+ONd0yTztOS7NlbTAgiWOL5A4x2OMiv0+/4KNft46f8AA3wpqXgLwfqMNx8QNRtzDNJCwc6ZG643HHSQg5UHpwcdK/EQkkkk5J7mmgEoooqgCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigD7r/wCCN0bP+1pflVJCeGLwsQOg8+2H9a/bqvx3/wCCJegSXPxn8f62IyYbPQUs2kxwrTXCOB+PkH8q/YipYBRS0lIApaSigAopaSgAopaSgAooooAKKKWgBM0UtFAH5U/8FovgdfSz+FfipYQCWyjT+x9RZAS0ZJLwsf8AZ4dc+pHrX5X1/Tx8WPhjonxl+HeueDPEMTS6Tq0Bgl2YDochldSf4lYAj6V/PL+1H+zjr37MXxY1LwjrCSTWinz9O1Bk2rd2zEhHHbPBBx3BpoDyGiiiqAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACvcv2fv2zvin+zYWg8Ja839kOwaTSb1fOtifUKfuk9MivDaKQH6U6f/wW38ZwWgS8+G+j3Vxtx5qahJGM+u3Yf515R8af+Crvxj+KulTaVpT2fgnTplKS/wBkljcMD2804IHXoB1r4toosBNeXk+oXc11czPcXEzmSSWRtzOxOSSe5qGiimAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFfRf7En7JGrftV/FS008xy23hHTpUn1nUFGNsQOTEh6b3xtHpnPakB+mv/AASP+CV78Mf2fLvxLqlv9mvvF1yl3GhUhvs0asIi2R3LyH6EetfctUtF0ez8PaRZ6Xp9ulrYWcSwQQRjCoijAA+gFXakAooooAWkoooAWkoooAKWkooAWkpaSgApaSigBaKSigBa83+O37P3gr9orwZN4c8Z6THf2+1jbXIGJ7RyMb436qenscDNej0UAfhN+0n/AMEuvit8FLm4v/DWnzeP/DC5YXWkx77qJf8AppAPnJx1KBh718fappF9od49pqNlcafdp96C6iaORfqrAEV/U1jNcd4v+Dngbx9IsniLwnpGsSqu0SXVojOB1xnGadwP5i6K/o0uv2HvgLezGWb4WeHnkPU/ZyP5Gof+GEvgB/0Snw9/34b/AOKouB/OjRX9F3/DCXwA/wCiU+Hv+/Df40f8MJfAD/olXh7/AL8N/wDFUXA/nRor+i7/AIYS+AH/AESnw9/34b/4qj/hhL4Af9Eq8Pf9+G/+KouB/OjRX9F3/DCfwA/6JT4e/wC/Df8AxVJ/wwl8AP8AolXh7/vw3/xVFwP50qK/ou/4YS+AH/RKvD3/AH4b/wCKo/4YS+AH/RKvD3/fhv8A4qi4H86NFf0Xf8MJfAD/AKJT4e/78N/8VSf8MJfAD/olXh7/AL8N/wDFUXA/nSor+i7/AIYS+AH/AESrw9/34b/4qk/4YS+AH/RKvD3/AH4b/wCKouB/OlRX9Fv/AAwl8AP+iVeHv+/Df/FUv/DCXwA/6JT4e/78N/8AFUXA/nRor+i7/hhL4Af9Ep8Pf9+G/wDiqP8AhhL4Af8ARKvD3/fhv/iqLgfzo0V/Rd/wwl8AP+iU+Hv+/Df/ABVH/DCXwA/6JT4e/wC/Df8AxVFwP50aK/ou/wCGEvgB/wBEp8Pf9+G/+KrjfjN+xD8C9L+EnjK9sPhloVpfW+k3U0FxDEyvHIsTFWB3dQQKLgfgHRRRVAFFFFABRRRQAUUUUAFFFFABRRRQAUV6R+zj4VsPG/x28DaDqlst7p2oapDBPbuTiRCeQcc1+83/AAwl8AP+iU+Hv+/Df/FUrgfzo0V/Rd/wwl8AP+iU+Hv+/Df/ABVH/DCXwA/6JV4e/wC/Df8AxVK4H86NFf0Xf8MJfs//APRKvD3/AH4b/wCKpD+wh+z+evwp8P8A/fhv/iqLgfzpUV/RZ/wwf+z9/wBEp8Pf9+W/+Ko/4YP/AGfv+iU+Hv8Avy3/AMVRcD+dOiv6LP8Ahg/9n7/olPh7/vy3/wAVXEfGz9mT9mv4J/C3xH401f4VeHvsek2jz+X5TAyuB8iD5urHA/Gi4H4FUVYv7pb2+uLhLeK0SWRnEEOdkYJztXJJwOnJNffn/BK39jXQvjnqniHxx490ZNX8J6XixsrK5z5VzdEBnZsdQi7eM9ZPamB+fdFf0V/8MG/s+/8ARKPD3/flv/iqP+GDf2ff+iUeHv8Avy3/AMVSuB/OpRX9Ff8Awwb+z7/0Sjw9/wB+W/8AiqP+GDf2ff8AolHh7/vy3/xVFwP51KK/or/4YN/Z9/6JR4e/78t/8VR/wwb+z7/0Sjw9/wB+W/8AiqLgfzqUV/RX/wAMG/s+/wDRKPD3/flv/iqP+GDf2ff+iUeHv+/Lf/FUXA/nUor+iv8A4YN/Z9/6JR4e/wC/Df8AxVH/AAwb+z7/ANEo8Pf9+W/+KouB/OpV/RtB1PxHfJZaTp13ql4/3beygaaRvoqgk1/RPp/7EXwI0uTfa/C7w/E3r9nJ/ma9E8IfCfwZ4B3f8I54X0rRmYYLWlqiMR9cZouB+M/7Mv8AwSp+JnxduoNU8cWkvgDwxlW/08AXtwM8hIfvJx3cL14zX7IfCD4P+FvgZ4D07wj4Q0uLS9JskAwijfM+Pmlkbq7seSxrs6KQBRRRQAtJRRQAUUUUAFFLSUAFFFFAC0lFFAC0lFFAC0UlFABRRRQAUUUUAFFFFABRRRQAUUUUAFHWiigAooooAKKKKACiiigAooooAWkpaSgApaSloASuK+N0scHwc8byTELEujXZYnsPKbNdrXjP7ZniL/hFv2VvinqAXc6+H7uJBux8zxlAc+27P4UAfzgUUUVYBRRRQAUUUUAFFFFABRRRQAUUUUAe3fsSiJv2svhaJjiL+24dxP41/RxX81f7Lmpf2R+0T8PbzOPK1m3Of+BY/rX9KlSwCkoopAFLSUUAFFFFABX5Wf8ABaT44TRXHhP4V2N0VieAazqUSHh8uyQq3uDG5x/tCv1Tr+df9vD4h3PxM/ax+IupzzebHa6i2mQAHISO3/dAD2yjH6k00B474J8Ial8QPGGjeGtHt3utU1a7is7eJFJJd2Cjp2Gcn2Br+kb9n74PaZ8B/hF4c8F6VCkcen24E8iDmac8yOT3JPc9gPSvyQ/4JA/Bf/hOv2h5fGl2itYeErWSaMMMh7mVDEg/BXZs+qiv2zoYC0lFFIBaSiloAKKKKAEopaSgApaSloASilpKAFpKWkoAKWkooAWkopaACkoooAKKWkoAWk7UUUALSUtJQAUUUUALRSYooAKKKKACiiigAoooxQAUUYooAKKKKACiiigAooxRQAUUUUAFFFFABRRRQAtJS0lABS0lFABXxZ/wVq+Ip8Gfsp3mlQuFuvEN7FZAE4JiB3SY/QfjX2pX5C/8Fq/ikmqfELwT4Bt5iy6TYvqdyqngSTuUUH3Cwg/8DoA/NOiiirAKKKKACiiigAooooAKKKKACiiigDT8M6xN4f8AEWmanbymGezuY50kHVSrA5/Sv6cfh14rj8d/D7wx4lhKtFrOl2uooV6ETRLIMf8AfVfy91/QN/wTY+JFv8Rv2PvAhSQtd6LbHRrlG6oYGKIPxjEZ/GpYH0/RRRSAWkopaAEooooAivQxs59gJfy2wB1ziv5iPipvHxQ8YeYCJP7YvNwPXPnvmv6fa/nk/wCCgvwwuPhV+1r49sJUxbajd/2vayAYDx3A8w4+jl1+qmmgPvP/AIIkjTP+FXfEMxlf7X/teHzuu7yfJ+T8M7+n49q/SevwJ/4J1ftYw/sxfGVV1xpP+EO19RZ6iU5Nux/1c+O+1gAf9kt16V+9WjazY+IdLtdS026ivbC6jEsNxCwZHUjIIIoYF2kopaQBRRSUALRSUUALSUUUAFFFFAC0UlFAC0lFFAC0lLSUAFFFLQAlLRSUAFLRSUAFFFLQAlFLSUAFLSUUAFFLRQAlFFFAC0lLSUALSUtJQAUUUUAFFFFABRiiigAoo60UAFFFFABRRRQAUUUUAFFFLQAlFFFAGR4u8U6d4I8Lar4g1a4S103TLaS6uJXOAqIpJ/HjA9zX83n7SHxevPjt8bPFfja7dm/tK7JgUkkRwIAkajPQbVHHua/RP/grd+2HBHpj/BXwtdLLNOyTa/dRPkIqtuS2GO+4Kzem0CvyhpoAoooqgCiiigAooooAKKKKACiiigAooooAK/RT/gjz+0Ongr4maj8MdVuvK07xMTPYCR8Kt4iZwM8Aui49yFFfnXWp4X8S6h4N8S6Vr2kzm11PTLqK8tZl6pLGwZT+YFID+pKkrwr9jn9qHSP2p/hHZ+IbUx22u2oW31fTlbLW82Oo77WwSD7Edq92qQCiikoAKWkooAWvi7/gpJ+xZJ+0t4Hg8S+GLdW8eaBbuII1HzX9uCW8j/eBLFfdj619oUUAfyw3tlcabdzWl3BJbXUDmOWGZCrxsDgqwPIIPY19Mfssf8FBPiV+zAF0u0ux4j8JNIHbRNTYukXYmF/vR/QHbnnFfqb+2F/wTp8F/tPLc67p0kfhbx0U+XU4osxXLDoJ1HJ9Nw5Geh6V+THx3/YP+MX7P1xLJrnhl9U0dT8msaKTc2zDJ64AdTx/EoqgP1m+BX/BT74LfGC2t4NU12LwLrTIvmWniCRbeHeeoWcnYRnpkg4r6q0LxFpXiewS+0bU7PVrJ/u3NjOk0bfRlJBr+WxlaNyrAqynBBGCDXT+C/ij4u+HV6bvwz4j1LRLk4zJZ3DITjp/OlYD+n2kzX4K+BP+Cp/x/wDBX2VJ/EVr4kt4doZNYtRI0ijsXUqckd+tfS/w8/4LcAEQ+OPhs23jN3od+Cff91Io/wDQ6LAfqpSV8wfCH/gpD8C/jAscVv4mfw3qD4AsPEMYt5CT6MrMh/76r6V0zVbLWrOO70+8gvrWQBkmtpBIjD1BBxSAt0lLSUAFFI7iNSzEKoGSScACvhr9rv8A4Kj+C/ghFeeHvAyx+NPGW0p5sMg+w2bZwS7jJdh/dUYPdhQB9oeKPF2ieCNGn1fxDq9lomlwDMt5qFwsESfVmIFfEvxd/wCCv/wj8DtfWfhS21DxrqMLGOOW2j8q0ZgcE+Y+CV64Kg54r8lvjV+0b8Qf2gNdbU/GniG51NgT5VqGKwQA/wAKIOAK8zp2A+9/G/8AwWO+MWuanLJ4esNF8N2PSOFLYXDgerNJnJ+gArz+4/4KqftJzXazJ45t4I1OfITRLEqfqTCT+tfJFFOwH378Pf8Agsl8XPD91GvijS9G8VWhP7wtbi2lA/2THtXP1Br7o/Z8/wCCoHwg+Nj2um6pqI8C+IZiEFnrcgjhkcnACTn5MnjgkHnHNfg1SglSCDgjoRRYD+qKKVJ41kjcSRuAyspyCPUGnV+F/wCxf/wUn8W/s96jp/h3xdJceKPh9/qjblgbmwBPDxMfvAc5QkZzwRiv2n+GXxP8NfGDwbp/ijwpqcWq6PepujljPzKe6OvVWB4IP8sGpA6milpKACiiigBaKSigBaSlpKAFopKWgAooooASiiigAooooAKDRRQAUZoooAKKMUUAFFFFABRRRQAUUUUAFFFFABRRVS91nT9MYC7vra1YjOJ5lTj15NAFuiuM8S/GjwF4PtTca14y0PT4sE/vr+PccdcKDk/gK+bPij/wVa+BHw7+0Q6dquoeMr6IYEOi2vyFsdDJKUH4jNAH2NnAJNfA37en/BSXR/gzpt/4K+G+qWureO5EMc9/blZ4dMz78q0o/unOOMivib9pT/gqb8TPjjZXuiaBFH4F8MXAaN7eylMl1Mh/hebA4I6gAda+LndpHLMSzMcknqTTsBY1TVbzW9Rub/ULqa9vrlzLNcXDl5JHJyWZjySTVWiiqAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPWf2bP2k/F37MXxDt/E3ha8ZY3xHf6dJzBew5zsdfUc4YcjseTX7zfs0/tX+BP2oPCcGp+GNTiXVUhV7/AEWV8XNm/RgVPJXPRhwRiv5wK3vA/jrXvht4osPEXhrU7jSNZsZBLBdWz7WVgf1HqO9KwH9RFJX5IfAT/gs3rGjfZ9O+K3ho6zaogQ6voYVLnI7tE7BW9yGH0r7a+G3/AAUX+AnxNEcdn42i0i9fH+h6zA9s659WwU/JjUgfStFc/YfELwtqkEc1n4l0i6ikG5HhvomDD1BDVs2l/bahGZLW4huUBwWhcOM+mRQBPRRRQAtRzwR3MTRTRrLG4wyOMgj3FPooA+d/iz+wB8DPjHJc3Os+Cbex1Odi51DR5ntJQx6ttQ7Cf95TXx/8S/8AgiXYuJZ/AXxBuYDuytnrtssuR6eZHtx+K1+pFFAH4HfEv/gl98evh29xJB4YXxRZxAss2hyfaHcYzxGBuz7Yr5l8U+Ctf8D3/wBh8Q6NfaJec/uL+3aF+OvDAV/UXWfrfh7S/Etk1nq2nWup2jfegu4VlQ/VWBFO4H8tVesfBv8Aao+KfwEvln8GeMdR023yN+nyP59pIB2MMgZPxAB96/Zb4y/8EwPgf8WPPubPQv8AhDNVlYv9r0LESbj3MP3Dzz0FfnV+0f8A8Eqfil8GYJtW8MInj/w8hJZ9NBF5CvJ3PARyOP4C34U7gfWH7Ln/AAV58PeOJrXQvizaW3hbVHKxrrVtlbKQk4zIGJ8vtk5x16V99eI/iJ4Z8JeDbjxZq2uWNn4bghE76m86+RsPQhgcHOQBjrniv5gbq1msbiS3uYZLeeNirxSqVZT3BB5BrauvHviO98J2/hifW76bw7bzfaYtMedjAkuCN4ToDhiM+9KwH29+3F/wU58QfF3Ur/wh8MtQudA8EJuhm1CDMd1qXUMd3VIyOAowTznOQB8BkliSTknqTSUUwCiiimAUUUUAFFFFABX0L+yH+2b4w/ZQ8XJPpsz6l4VupAdS0KZsxzL3ZP7kgHQj2zkcV89UUgP6bPgz8aPCfx68C2PizwfqcepaZcqNyqf3kD45jkXqrDuDXc1/OF+yz+1P4s/ZW+IMfiDw9L9psJ18nUdKmY+TdxH1HZhjIPb8a/eT9m39pfwf+094Bt/Enha7xMuI77TJiBcWcvdWXuO4YcEe+QEB6zRRRSAKKKKACiiigBaKSigBaKSigAooooAKKKKACilpKACiiigAooooAKKKKACiiigAooooAKKKKACvxp/4LK63qNj+0N4dt7a/ureBtBjYxRTMqk+a/OAcV+y1fi5/wWg/5OO8Of8AYAj/APRr00B8AzTyXD7pZHkb1diTUdFFUAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAFi2v7qyObe5lgPrE5X+Vfsr/AMEXdUvNU+AXjR727nu3TxK6q08rOVH2W3OBk8Cvxir9lP8Agif/AMm/+N/+xnf/ANJLekwP0RopaSpAKKKKACiiigAoopaAEpsjpHGzuQqKCWJ6AU6vhr/gqX+1qnwS+Fi+B/D94o8YeKEeKQRk7rSyxiSQkdGYlVA7jf6UAfnZ/wAFH/jJ4M+LX7QWor4J0LTrDTtJ/wBDm1Wzj2PqM4J8yRgDtwGJUHGTtySc8c7+xF+yHf8A7XHxPk0d7ybSPDWmwm61PUoYw7KuQFiTPG9ieM5wATg4r5161+v3/BE7XNKk+GHj3SIpVGsR6lFcTQngmMoQrD1GRj/9dVsB9EeHP+Ca37PPh/w4NIk8Aw6qCMS3l/dzNcSHAGSyuu3p/CAK+Iv22P8AglP/AMK70O+8bfCR73U9Kty0174euD5s1vF1LwsACyr3DZIHOTg1+vdGARipA/lckjaGRkdSjqSrKRgg+lNr9lP2+/8AgmfZ/FSO88efCzT4NP8AFyoZL3RoiIotROSdyZ+VZe3YHA79fx31fSL7QNTudO1K0msL+2kaKa2uIykkbg4Ksp5BBqgKdFFFMAooooAKKKKACvSfgL+0H4z/AGcfHFt4n8G6ibW5QgT2koLW91HnlJUyMg+owR2Irzaut+E3w51H4t/Ejw74P0pGe+1i8jtEKjO3cwBY+gHUmkB/R38B/imPjZ8IfCvjgabLpA1uyju/scpyY9w7HuO4PcYrvazvDfh+y8J+HtL0TTYhBp+m2sVnbRL0SONQqj8ABWjUgFFFFABRS0lABRRRQAUUUUAFLRSUAFFFFAC0lFBoAKKKKACjrRRQAUUUUAFFFFABRRRQAUUUUAFfi5/wWf8A+TjvDn/YAj/9GvX7R1+Ln/BaD/k47w5/2AI//Rr00B+ftFFFUAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABX7Kf8ET/wDkgHjf/sZ3/wDSS3r8a6/ZT/gif/yQDxv/ANjO/wD6SW9JgfojRRRUgFLRSUAFLSUdqAFpKKKAMHx7420v4b+Ctc8U63OLfSdHs5b25kJAwkaliBnucYA7kiv5wP2hvjZrH7QXxa17xrrLnzb6Y+RADlbeEH5I19gK/SD/AILI/tGyaXpGkfCLRtQKPfqt9rUUJIPlhg0Ubn3ID4+lfkvTQBXrf7MX7SXib9l34n2fi7w66zx7TBfadMT5N5AxG5GweDkAg9iB2yD5JRVAf0nfs3ftKeEP2nfh/D4m8LXal0IivtOkYedZzYyUcencHuK9Xr+Zr4J/HPxh+z941t/E3g3Vp9Mvkws0aOfKuYwc+XIvR19iDX7tfsgftr+Df2r/AAtGbKePSvGFtEDqOgzNiRD3eLP3489xkjIzipA+i6+NP24/+Cd/h39pTSb3xJ4aEegfEWFPMjnVQLe/I6pMMcMR0cdDjINfZlFID+Xnx74C174ZeK9Q8N+JdOm0vWLGQxzW8y4IPqPUHqDXP1/Q3+15+xP4M/aw8OZ1CFNK8W2kTJYa5AgEi55CSnGXjzzg9MnHU1+Enxt+BnjD9n7xze+FvGWky6dfQORFMRmG6jz8ssTjhlIwfUdDggiqTA8/ooopgFFFFABX6N/8EbvgLJ4p+JWt/E6/hP8AZvh9PsNkT0kupFy3b+BCp69XFfnt4a8O3/i7xDpuiaXbvd6jqNxHa28EalmeR2CqAB7mv6Ov2V/gbY/s7fA3w34LtI0FxbQ+ffyoOZrqT5pGJ744UH0UelJgetV8Y/8ABT39qHVv2ePhHpdl4V1JdO8W65dhbeZSDJDDHgyMF98gZPHWvsuWRYY3kdgiKCzMxwAB1Nfz/f8ABRv9oGL4/wD7Sur3em3Jn8P6FEuj6eQTscRszSSAHuZHfn0AqQP1F/YW/b80L9qHQLfQ9fktNF+I1rFi4sVbZHfbRzLACc89SmSRz2r6+r+WrQNf1HwtrVlq+kXs+nanZSrNb3VtIUkicHIKsOQa/aL9gD/go1pfxzsbXwP4/vItM8ewqEtbqY7YtVUDs3QSjupxuyCMnNNoD70pKWkpALRSUtABRRRQAlFFFABS0lFABR2paQ0AFFFFABRRzRQAtJRRQAUUUUAFGaKKACiiigAr5P8A2r/+Cefhf9rHx5YeKNa8Talo1zaWS2Sw2cSOrKGLZJY9fmr6wooA/OP/AIcn/D7/AKH3Xv8AwGi/xo/4cn/D7/ofde/8Bov8a/R2igD84f8Ahyf8Pv8Aofde/wDAaL/Gj/hyf8Pv+h917/wGi/xr9HaKAPzi/wCHJ/w+/wCh917/AMBov8aP+HJ/w+/6H3Xv/AaL/Gv0epKAPzi/4cn/AA+/6H3Xv/AaL/Gl/wCHJ/w+/wCh917/AMBov8a/RyloA/OL/hyf8Pv+h917/wABov8AGj/hyf8AD7/ofde/8Bov8a/RyigD84/+HJ/w+/6H3Xv/AAGi/wAaP+HJ/wAPv+h917/wGi/xr9HaSgD84/8Ahyf8Pv8Aofde/wDAaL/Gk/4cn/D7/ofde/8AAaL/ABr9HaKAPzj/AOHJ/wAPv+h917/wGi/xo/4cn/D7/ofde/8AAaL/ABr9HKWgD84f+HJ/w+/6H3Xv/AaL/Gl/4cn/AA+/6H3Xv/AaL/Gv0dpKAPzj/wCHJ/w+/wCh917/AMBov8aT/hyf8Pv+h917/wABov8AGv0dooA/OP8A4cn/AA+/6H3Xv/AaL/Gj/hyf8Pv+h917/wABov8AGv0cooA/OL/hyf8AD7/ofde/8Bov8aX/AIcn/D7/AKH3Xv8AwGi/xr9HaSgD84/+HJ/w+/6H3Xv/AAGi/wAa+qf2Sf2UNF/ZH8E6v4b0TWbzWrfUdQOovNexqjKxjSPaAvbEYP417nRQAUUUUALRRSUAFFFLQAVW1K/h0rTrq9uHEdvbRNNI7HAVVBJJ/AVYrwH9vD4jTfC/9lTx5q9txeS2ZsoCDjDynbn8t1AH4S/tLfFu8+OXx18ZeNLyTeNR1CT7OoJIS3T93Co+kaJXmVFFWAUUUUAFdJ8O/iL4i+FHjDTfFHhbU5tJ1rT5RLBcQn81YdGUjIIPBBrm6KAP3c/YT/4KD6J+05pUfhzxJ9n0P4h2qfPbh8RagoH+siz0b1Tn1B5wPsmv5ZtH1i+8P6pa6lpl5Pp+oWsglgurWQxyROOjKwIIPuK/Yj9gj/gplYfFFdM8A/FC/h07xaVW3stZnIji1BgMBZG6LK2O+NxOOpGZsB+iNeSftJ/sx+Dv2n/Alx4d8UW3l3AUmy1WBR59nJ2ZSeoz1U9RnoeR62DkZHSikB/OT+1V+yZ4w/ZS8cHRvEEQvdJuiz6brUCEQ3aA8/7rjIyp9eprxCv6Uv2mPghoXx/+D+veFtc0+G9Z7d5rGSQYe3uVU7JEb+E54+hOa/m0v7KXTb64tJxtmt5GicA5wykg/qKpAQUUV6V+zz8Ctf8A2ivipo3gzQIJGku5VN1dKuUtIARvlc9go59+lMD7R/4JGfsp3HjDx/8A8Ld1+2I0LQg8elRypxcXjDb5gz1Eal/+BFeeK/YuuY+Gnw50P4S+BdG8JeHLRbLR9Kt1t4Ih1IA5Zj3YnknuTW1rWtWHhzSLzVNUu4bDTrOJp7i6uHCRxIoyzMT0AFQB8r/8FLP2j/8AhQP7PF/badME8TeJm/suxAODGjDM0vrwgKj3da/BCSRpZGd2LOxLMx6k+te//tsftRX37U/xkvNeDyR+HLHda6NaMMeXBu+8R/ebgn/61fP1UgCrFhf3Ol3sF5ZzyWt1A4kimiYqyMOhBHQ1XopgfsJ/wT+/4KYweP4tH+HHxSuI7bxKqra2HiB32pfYACLMD0kPTcOGOOBkmv0hBDDIOQehFfyuRyPDIskbFHUhlZTggjoQa/Vb/gnJ/wAFHzcvafDL4saz85CxaN4gvn6np5E8h/Daze4J6VLQH6nUlAYMAQQQeQRRSAWiiigBKKKKACiig0AFFFFABR3oooAKKKKACiiigAooooAKKKKACiiigAooooAWiikoAKKKKACiiigApaSigAooooAWkoooAKKWkoAKKKKACiiloASiiloASiiigAooooAKWkooAKKKKACiiigAoopaAEr43/4Ky3jWn7H2rBQT52p2sRx6EOf6V9kV87/8FAPhxN8Tv2UPHWm2q7ry0tf7QgQLnc0XOPxG6gD+eKiiirAKKKKACiiigAp8UrwSpLE7RyIQyupwVI6EGmUUAfqP+wR/wVBksF0/4efF25822G2HTfE7t80Y6CO4HcdMOOR3B6j9WLK9t9StIbq0njubaZBJHNEwZXUjIII6giv5YK9T8C/tS/Fz4aaL/ZHhn4i+ItI0sJsSzgv5PKiH+wpJCf8AAcVNgP3a/bC/ak8O/syfCrVNVvbq1uPEVxC0Wl6Q8oElxIRjOOu0dSfw71/Ovc3D3dxLPK26WVy7N6knJrY8Y+O/EnxD1dtV8U6/qfiPU2G03eq3clzLj03OSce1YYBJAAyT2pgXtC0O+8S6zZaVpltJeaheSrDBbxLuZ3Y4AAr95/8Agn3+xpZ/sufDKO91aKO48e62gm1K52/8eyHlLdD6KMbj3YnsBXhX/BLz9hKT4f2sPxY8f6SY/EV1DjRdOvYyHso25M7IejsOBkZALetfpJSbAWvzD/4K5ftef2LYH4LeGrgi+u4kuNduYn/1cTcpb9OrDDH2YV9O/t5ftg6d+yr8LmeyuLefxxrG6DSrAsGdBg77hl/uJwOeCzL15r8DPE/ibVPGfiHUdd1u+m1LVtQna4ubu4Ys8jsckk/5x0oQGXRRRVAFFFFABT4pXhkWSNijqQyspwQfWmUUAftP/wAEuf21W+MfhGD4ZeK5c+LdCt8Wd675N/ar93Of40HHuFBr7+r+YH4ZfEXWvhL490Pxd4euns9W0i6juoXU4DbWBKN6qwGCDwQSK/pH+CfxX0n43fC7w9400aVZLPVbVZiqnJifHzxn0KnIqWB3FFJiikAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUABooooAKM0UUAFFHtR3oAKKWkoAKKM0UALSUUUAFHaig0AFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFLQAUlFLQAlFFFAC0lFGKACiiigApaKSgAqG+sodSsp7S5jWW3njaKSNxkMpGCD+BqaigD+dr9t79nDUP2bPjzr+itA3/AAj99O99o9yEISS3kO4IPdCSh/3c96+f6/oq/bG/ZP0H9q74YXWi3gSz8R2iPLo+q45t5scK3rGxABHoSRg1+AHxR+F/iP4OeNtR8KeKtOl0zWLF9skUqkBl7Op7qexHBqkBylFFFMAooooAKKKKACiipba2lvLmK3gjeaeVxHHHGMs7E4AA7kmgBiI0jBVBZicAAZJNfqX/AME2/wDgnPJM2lfFj4n6cEjV1utD0G5T5iQcpcTKegyAVX6E46Vqf8E9v+CZy6VLZ/Ef4uaWXu12zaR4duQQIz186depPTah46kg8V+oaIsaKiKFRQAFUYAFS2AoAAwOAOwrzb9oD49+GP2cvhtqfjDxPcYgto2+z2UbATXk2PlijB7k4Geg6mrfxw+N3hb9n74fX/i7xbfx2Vhb/JFGWHmXMpBKxRj+Jjg8DsCe1fgP+1f+1Z4r/ap+ItzrmtXD2+iwMY9K0aM4hs4R04/ic9WY5OTjgAAIDkvjx8b/ABH+0H8SNT8Y+JbgyXl25EUAbKW8WfljT2Fee0UVYBRRRQAUUUUAFFFFABX6of8ABFv45M1z4t+FV/OSPKGs6YrHgYYJOo9zviP/AAE1+V9e8/sM/E2X4T/tTeAtaFyLa1lvhYXRcgK0MwMZBJ6DJU/hSYH9FlFLRUgJRRS0AJRRS0AJRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRS0lABR1oooAKKKKACilpKACiiigAooooAKKKKACilpKACilpKACiiigAooooAKKWkoAKKKKACiiigAooooAKKKKACiiigBaSiigAoo4ooAK+ef2x/2NvDH7WfgkWt4sWm+K7BWbS9aCfPGSOY3I5MbHGR2IBHv9DUUAfzLfGn4J+LPgF481Dwn4v01rDUbV8LIPminQ8rJG38Skc+vYgHiuDr+j39p79lDwT+1P4NfR/E1s1tqMKN9g1m1AFxaPjg8/eXPJU9ecYzmvwW/aM/Zw8XfsyeP5vDHiu1wTmSzv4gfIvIgcb0J/DI7VSYHldFFFMAoor6W/ZO/YP8fftTala3dpA2heDRLsufEFzHlAB94RLkeY3bAOBnmkB4j8OPhn4m+Lfiuz8N+EtIuNa1i6YLHBAvT/AGmY8Ko7k8V+0/7D/wDwTi0D9nC3svFPi5bTxB8QtodZVXfBpzEciIsOWHTfge3rXtf7M/7Ivw//AGWfDf2DwrYNcapOo+2a1e4e6uD6ZAAVf9lQB65617ZSuAlea/H39oPwd+zf4BvPFXjC/wDIt4lIt7OHDXF5JjiOJSRkk9yQB3IriP2uf2yfB/7KHhH7Tqc8eo+J7xG/s3Q45P3szAffcDlUBIye/QV+E/x8/aI8bftH+NbjxH4y1WS8kZz9msUJW2s4+0cSdAAO/U9SSaAOp/a1/a08UftX+Pf7Z1gtY6Nabk0zSEfdHbITyfdjgZPtXhVFFMAooopgFFFFABRRRQAUUUUAFX9Av20vXtNvVO1ra5jmB9CrA/0qhRQB/UP4A1Ntb8B+G9Rc7nvNNtrgnPUvErf1orxr4Da/qP8Awo34d/6VKf8AinNO5Jz/AMu0dFQB9B0UUUALSUUUAFFFFABRRRQAd6KKKACjNFFABRRRQAUUUUAFFFFAB0ooooAKWkooAKWkooAKWkooAKKKKAFpKWkoAWikooAWkpaSgAooooAKKKKAClpKKAFpKKKAClpKKACiiigBaSiigBaSiigAopaKAEpaSigApaSigBa8z/aD/Z88JftJfD268KeLbFZ4GPm2t2qjzrOYAhZI26g8kH1BIr0uigD+cr9qr9kzxj+yt47m0fXrZrrRpyZNN1mAZguo8nHP8LjGCpwfqCCfPfhp8JfGHxi8RwaF4N8PXuv6lMcCO0jyqcZy7nCoMd2IFf0i/Fj4QeE/jd4Pu/DPjDSYtV0y4Vlw4xJExGN8bdVYdjTPhX8GPBfwU8OQ6J4M0C00SxjUKfJTMkhAxudzyx+pp3A+CP2Sv+CRmmeFHtvEnxje21rU1ZZIfD1s/mW0X/XZsYc5/hGV46nNfpJp2nWukWFvZWNtDZ2Vugiht7dAkcaAYCqo4AA4wKsV5j8dP2kPAP7OvhqTWPGuuwaf8p8iyVg1zctg4WOMcnp16CkB6XNNHbRPLK6xRICzO5wFA6kmvzu/bO/4Kr6F8ORqHhH4TyReIfEoDwT63tzZ2bcg+Wf+Wrg9x8vua+Pf2uP+Cmnjz9oNrjQPDZbwZ4KO5Db2kjfarxT/AM9pc9MfwqF6nOeMfGJJJJJyT3p2A2PGHjHWvH3iO917xDqVxq2r3jmSe7upC7uT6k1jUUVQBRRRQAUUUUAFFFFABRRRQAUUUUAFS2sDXVzDCv3pHCD6k4qKu8+A/gyb4h/GfwV4cg+/qGrW8RO3dhd4LHHsoNAH9FHwc8Hafpfwi8D2RtVzbaFYw/N1+W3Qc/lRXd2NnHp1lb2sI2wwRrEg9FUYH6CioAnpKKKAClpKKAFpKKKACiiigAoNFFABQKKKADtRRRQAUdaKKACiiigAoopaAEooooAKKKKACiiigAooooAKKKKACiiloASiiigAooooAKWkooAKKWigBKKKKACiiigApaSigAooooAKKKKACilpKACiiigBaSiigAooooAKKKKAPkD/AIKI/tOfEv8AZw8DWt14F8JSXlneRstz4nZRLDpz5wqlASQeh3MNvIAJIOPw48c+PvEXxL8SXev+KNYvNc1e6cvLdXszSOc9gSeAOw6Cv6eNd0LTvE2j3elatZw6hp13G0M9tcIGSRCMEEGvxS/b6/4Jzal+z5c3vjbwQs2q/D+abdLb7d02lFm4ViPvR5IAbqOAfWmgPhWiiiqAKKKKACiiigAooooAKKKKACiiigAooooAK+7/APgj98H5PHH7R134uubVZdL8J6e8yyuuQt3MfLiA99nnHP8As18IqpdgqgsxOAAOSa/oD/4J3fs4f8M7fs+abBfxbPEmvBNS1PI5RmX5Iun8AJ/EmkwPqGiloqQEooooAKKMUUAFFFFABRRRigAooooAKKKKACiiigAooooAKKKKADrRRRQAUUGigAooooAKKKKACiiigApaSigBaKSloASiiigAoopaAEoopaAEooooAWkoooAWikooAKKKOlABRRRQAtJRRQAtJRRQAUUUUALRSUUALSUUUAFFFFAC1W1PTLTWdPubC/tYb2xuY2hntriMPHKjDDKynggg4INWKKAPx2/4KAf8E0b34eXF98QPhXpkt94WIabUNFtVLy2HcvGvVo+p4ztx6V+cdf1SOiyIyOoZWGCpGQRX5Vf8FC/+CaBhGsfFD4U2o8vL3ereG4Y8Y6s80GO3UlMepB7U0wPywop80L28rxSo0ciHayMMEH0NMqgCiiigAooooAKKKKACiiigAoor3/8AY+/ZA8UftZePRpumg6b4csSkmq6zLGWjgQk4RRkbnbBwM9iTSA9m/wCCYP7Hkvxw+JVv468S6ZI/gfw7cLNGZlxFfXaEMkeCPnVTtLDp2PWv3AAAAA6Vyfwq+GGgfBvwDo/hDw1aLZ6TpkCwxrj5nP8AE7HuzHJJ9TXWVIC0UmfeigBaSiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKO9FFABRRRQAUUUUAFFFFABRRRQAUUUtABRSUUAFFFFABRRRQAUtJRQAUtJRQAUtJS0AFJS0lABS0UlABRRS0AFJRRQAtJS0lABRRRQAUtJRQAUtJS0AJS0lFABRRRQAtJS0UAJQRkYIyKKKAPz5/bm/4Jh6P8XEn8ZfC6yttB8XqGe80uLEdtqPfKr0jk69MA555r8fvG/gTxD8NvEt74f8T6PeaHrFm5Sa0voGicehwwGQRyCOCCCK/qHry345/szfDz9onQpNO8aeH4L6TYUh1CNQl1bkjG5JMZBGe+R7U7gfzWUV+jfx1/4I1eN/DL3Oo/DTX7LxXp4JZdMvs2t4o7BT8yP9Sy/Svh/wAf/An4hfC2/Nn4q8H6vo04Gf39sxQj1DrlT+dMDhKKUgqSCMEdQaSmAUUVf0rQNT1yURabp13qEhO0JawNISfTCg0AUKK+rPg7/wAEzvjp8XLiCRvDaeE9Kdhuv/EEvkgDqcRqGkJx/sj6iv0h/Zm/4JYfDb4JyQ6t4pZPH/iRCrpLe24S0gYf3IiTuOT95vQcClcD89v2OP8AgnJ41/aOv7DXfEFrd+FfADEStqFzCY5b2PqBbq2Nwb++MrX7X/Cb4QeE/gh4MtPC/g7R4NH0q3HKRD55Xxy8jHl2PqTXXwQR2sEcMMaxRRqESNBhVA4AA7CpKkApKWkoAWiiigApPSiigAFFFFAC0hoooAWk9aKKADvQKKKAFpooooAXvRRRQAHpR3oooAWk9KKKAA0tFFABRRRQAgpaKKACkPSiigA70tFFABRRRQAUUUUAFJ3oooADS0UUAJS0UUAFFFFABSetFFAC0UUUAIaWiigApO9FFAC0goooAWkHSiigApaKKACiiigApO9FFABRRRQAtFFFABRRRQAUg6UUUAHrVTU9IsNatzBqFlb30B6xXMSyL+TAiiigD88f27Phb4L0fVJ5LDwjoNjI6bme20yGMk46khRzX5T+KrK3h166SOCJED8KqAAUUUAfQ37K/hTRNZv7VdQ0ewvlLDIubVJAef8AaBr9qfhJ8N/CXhjwnpcujeF9F0mVow7PY6fDCxb1JVRzwOaKKAPQqWiigApPWiigBaKKKACiiigD/9k=
\.


--
-- TOC entry 2250 (class 0 OID 139566)
-- Dependencies: 223
-- Data for Name: usuariocargo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuariocargo (idusuariocargo, idusuario, idcargo, fechaasignado, estado) FROM stdin;
1	2	216	2016-02-02 00:00:00	t
2	3	54	2016-02-12 00:00:00	t
3	4	56	2015-10-15 08:09:55.042	t
5	5	56	2016-02-12 00:00:00	t
6	6	55	2016-02-12 08:36:54.475	t
7	7	142	2016-02-16 10:45:48.994	t
8	8	148	2016-02-16 10:50:29.359	t
9	9	213	2016-02-16 00:00:00	t
10	10	36	2016-02-16 15:11:33.541	t
11	11	34	2016-02-16 15:15:14.781	t
12	12	73	2016-02-19 09:08:11.251	t
13	13	75	2016-02-19 00:00:00	t
14	14	58	2016-02-23 08:46:36.205	t
15	15	57	2016-02-23 08:50:47.554	t
16	16	52	2016-03-01 09:23:07.202	t
17	17	218	2016-03-02 09:49:19.994	t
18	18	217	2016-03-02 09:55:06.488	t
19	19	158	2016-03-03 17:23:37.074	t
20	20	127	2016-03-03 18:28:06.604	f
21	20	127	2016-03-18 00:00:00	t
22	21	97	2016-03-07 00:00:00	t
23	22	130	2016-03-04 08:34:46.825	t
24	23	232	2016-03-04 09:27:15.192	t
25	24	162	2016-03-04 09:35:39.731	t
26	20	100	2016-03-04 10:07:05.239	f
27	25	233	2016-03-04 15:57:36.109	t
28	26	208	2016-03-04 16:00:28.287	t
29	27	234	2016-03-04 16:15:56.182	t
30	28	109	2016-03-04 16:18:48.282	t
31	29	165	2016-03-04 17:35:39.082	t
32	30	163	2016-03-04 17:40:54.033	t
33	31	176	2016-03-07 08:37:17.908	t
34	32	170	2016-03-07 08:40:26.888	t
35	33	187	2016-03-07 09:19:52.52	t
36	34	189	2016-03-07 09:38:28.599	t
37	35	51	2016-03-07 10:15:26.888	t
38	36	45	2016-03-07 10:21:06.846	t
39	37	166	2016-03-08 09:00:27.492	t
40	38	235	2016-03-08 09:48:29.207	t
41	39	63	2016-03-09 12:39:06.643	t
42	40	236	2016-03-09 12:44:04.824	t
43	41	141	2016-03-10 16:20:59.845	t
44	42	131	2016-03-10 16:25:07.481	t
45	43	27	2016-03-11 09:10:41.023	t
46	43	27	2016-03-11 09:23:45.802	t
47	44	26	2016-03-11 09:32:04.522	t
48	44	28	2016-03-11 09:47:33.603	f
49	43	237	2016-03-11 09:49:29.792	f
50	45	237	2016-03-11 09:54:16.413	t
51	46	28	2016-03-11 09:57:36.641	t
52	47	149	2016-03-11 16:45:40.829	t
53	48	238	2016-03-11 16:49:02.554	t
54	49	88	2016-03-14 00:00:00	t
55	50	239	2016-03-14 00:00:00	t
56	51	44	2016-03-15 15:15:26.185	t
57	52	40	2016-03-15 15:19:07.348	t
58	53	186	2016-03-17 08:41:07.92	t
59	54	179	2016-03-17 08:48:21.509	t
60	55	103	2016-03-18 08:42:02.664	t
61	56	100	2016-03-18 08:46:48.536	t
62	57	53	2016-03-21 08:34:18.525	t
63	58	240	2016-03-23 11:06:36.157	t
64	59	60	2016-03-23 11:10:43.528	t
65	13	241	2016-03-23 11:33:50.971	t
66	60	242	2016-03-23 11:48:51.815	t
67	61	222	2016-03-23 00:00:00	t
68	62	87	2016-03-23 12:41:15.736	t
69	63	79	2016-03-23 12:45:53.465	t
70	64	178	2016-03-23 17:12:45.732	t
71	65	177	2016-03-23 17:13:08.633	t
72	44	26	2016-03-28 17:16:44.291	f
73	66	243	2016-03-29 11:37:03.232	t
74	67	119	2016-05-09 16:35:12.05	t
75	68	112	2016-05-10 08:06:39.498	t
76	69	160	2016-06-20 15:48:51.22	t
77	70	5	2016-07-25 12:14:23.726	t
78	1	1	2016-07-25 12:15:42.323	t
79	11	63	2016-08-03 08:17:04.732	t
4	1	216	2016-07-25 00:00:00	t
80	71	229	2016-10-19 08:22:00.978	t
81	1	222	2016-10-28 12:52:54.418	t
82	2	6	2016-11-14 15:17:10.561	f
\.


--
-- TOC entry 2269 (class 0 OID 388179)
-- Dependencies: 242
-- Data for Name: usuariogrupo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuariogrupo (idusuariogrupo, denominacion, idusuariocreacion, estado) FROM stdin;
\.


--
-- TOC entry 2251 (class 0 OID 139569)
-- Dependencies: 224
-- Data for Name: usuariorol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuariorol (idusuariorol, idusuario, idrol, fechaasignacion, estado) FROM stdin;
1	2	1	2015-10-14 15:17:53.756	t
2	3	1	2015-10-15 08:08:48.986	t
3	4	1	2015-10-15 08:08:57.034	t
4	1	2	2015-10-15 11:59:20.159	t
5	5	2	2015-10-21 08:16:29.728	f
6	9	3	2015-11-24 10:30:57.783	f
7	2	2	2015-11-30 16:27:05.458	t
8	3	2	2015-11-30 16:29:52.35	f
9	5	1	2016-02-11 18:39:13.28	t
10	6	1	2016-02-12 08:37:03.247	t
11	7	4	2016-02-16 10:46:54.155	t
12	8	3	2016-02-16 10:50:43.134	t
13	9	1	2016-02-16 12:37:31.66	f
14	9	2	2016-02-16 12:37:47.978	f
15	10	3	2016-02-16 15:11:48.454	t
16	11	4	2016-02-16 15:15:29.945	t
17	12	4	2016-02-19 09:08:40.876	t
18	13	3	2016-02-19 09:17:55.304	t
19	14	3	2016-02-23 08:47:01.056	t
20	15	4	2016-02-23 08:51:00.658	t
21	16	2	2016-03-01 09:25:23.251	t
22	17	3	2016-03-02 09:50:57.479	t
23	18	4	2016-03-02 09:55:30.387	t
24	19	4	2016-03-03 17:27:34.227	t
25	20	4	2016-03-03 18:31:32.448	t
26	21	4	2016-03-03 18:38:40.265	t
27	22	3	2016-03-04 08:35:07.042	t
28	23	3	2016-03-04 09:27:36.861	t
29	24	3	2016-03-04 09:35:52.289	t
30	25	3	2016-03-04 15:57:53.456	t
31	26	4	2016-03-04 16:00:47.865	t
32	27	3	2016-03-04 16:16:27.803	t
33	28	4	2016-03-04 16:19:07.002	t
34	29	3	2016-03-04 17:36:06.726	t
35	30	4	2016-03-04 17:41:51.582	t
36	31	3	2016-03-07 08:37:37.439	t
37	32	4	2016-03-07 08:40:45.639	t
38	33	4	2016-03-07 09:20:20.241	t
39	34	3	2016-03-07 09:38:46.04	t
40	35	3	2016-03-07 10:15:38.37	t
41	36	4	2016-03-07 10:21:23.413	t
42	37	4	2016-03-08 09:00:50.689	t
43	38	3	2016-03-08 09:48:45.353	t
44	39	4	2016-03-09 12:39:26.409	t
45	40	3	2016-03-09 12:44:22.327	t
46	41	3	2016-03-10 16:21:40.202	t
47	42	4	2016-03-10 16:25:28.681	t
48	0	0	2016-03-11 00:00:00	t
49	43	3	2016-03-11 09:24:11.917	t
50	44	4	2016-03-11 09:32:20.825	t
51	45	3	2016-03-11 09:54:43.635	t
52	46	4	2016-03-11 09:57:52.194	t
53	47	4	2016-03-11 16:45:55.103	t
54	48	3	2016-03-11 16:49:17.577	t
55	49	4	2016-03-14 09:29:28.516	t
56	50	3	2016-03-14 09:36:00.017	t
57	51	3	2016-03-15 15:15:40.443	t
58	52	4	2016-03-15 15:19:25.116	t
59	53	3	2016-03-17 08:41:33.676	t
60	54	4	2016-03-17 08:48:35.862	t
61	55	3	2016-03-18 08:42:43.568	t
62	56	4	2016-03-18 08:47:02.764	t
63	57	1	2016-03-21 08:34:34.328	t
64	58	3	2016-03-23 11:06:50.259	t
65	59	4	2016-03-23 11:10:56.242	t
66	60	3	2016-03-23 11:49:12.064	t
67	61	4	2016-03-23 11:52:58.983	t
68	62	3	2016-03-23 12:41:31.446	t
69	63	4	2016-03-23 12:46:05.867	t
70	64	3	2016-03-23 17:13:35.044	t
71	65	4	2016-03-23 17:13:46.729	t
73	9	4	2016-03-30 16:45:18.759	t
74	67	3	2016-05-09 16:22:19.58	t
75	68	4	2016-05-09 16:22:39.314	t
76	69	1	2016-06-20 15:49:07.319	f
77	69	3	2016-06-20 15:50:08.128	t
78	70	3	2016-07-25 12:14:39.707	t
79	9	2	2016-09-20 15:18:31.455	t
80	15	2	2016-09-27 10:41:37.187	t
72	66	2	2016-09-27 00:00:00	t
81	71	2	2016-10-19 08:21:40.735	t
82	72	2	2016-11-14 15:24:29.526	f
\.


--
-- TOC entry 2160 (class 2606 OID 139574)
-- Dependencies: 210 210
-- Name: pk_anio; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY anio
    ADD CONSTRAINT pk_anio PRIMARY KEY (idanio);


--
-- TOC entry 2192 (class 2606 OID 188621)
-- Dependencies: 226 226
-- Name: pk_archivo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY archivo
    ADD CONSTRAINT pk_archivo PRIMARY KEY (idarchivo);


--
-- TOC entry 2202 (class 2606 OID 303837)
-- Dependencies: 232 232
-- Name: pk_archivodocumento; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY archivodocumento
    ADD CONSTRAINT pk_archivodocumento PRIMARY KEY (idarchivodocumento);


--
-- TOC entry 2216 (class 2606 OID 387964)
-- Dependencies: 239 239
-- Name: pk_archivomensaje; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY archivomensaje
    ADD CONSTRAINT pk_archivomensaje PRIMARY KEY (idarchivomensaje);


--
-- TOC entry 2162 (class 2606 OID 139576)
-- Dependencies: 211 211
-- Name: pk_area; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY area
    ADD CONSTRAINT pk_area PRIMARY KEY (idarea);


--
-- TOC entry 2226 (class 2606 OID 388197)
-- Dependencies: 244 244
-- Name: pk_areagrupo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY areagrupo
    ADD CONSTRAINT pk_areagrupo PRIMARY KEY (idareagrupo);


--
-- TOC entry 2212 (class 2606 OID 379763)
-- Dependencies: 237 237
-- Name: pk_areatipodocumento; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY areatipodocumento
    ADD CONSTRAINT pk_areatipodocumento PRIMARY KEY (idareatipodocumento);


--
-- TOC entry 2230 (class 2606 OID 388928)
-- Dependencies: 247 247
-- Name: pk_bandeja; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bandeja
    ADD CONSTRAINT pk_bandeja PRIMARY KEY (idbandeja);


--
-- TOC entry 2200 (class 2606 OID 238229)
-- Dependencies: 230 230
-- Name: pk_cargo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cargo
    ADD CONSTRAINT pk_cargo PRIMARY KEY (idcargo);


--
-- TOC entry 2228 (class 2606 OID 388202)
-- Dependencies: 245 245
-- Name: pk_detalleareagrupo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY detalleareagrupo
    ADD CONSTRAINT pk_detalleareagrupo PRIMARY KEY (iddetalleareagrupo);


--
-- TOC entry 2214 (class 2606 OID 380524)
-- Dependencies: 238 238
-- Name: pk_documento; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY documento
    ADD CONSTRAINT pk_documento PRIMARY KEY (iddocumento);


--
-- TOC entry 2218 (class 2606 OID 387969)
-- Dependencies: 240 240
-- Name: pk_documentomensaje; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY documentomensaje
    ADD CONSTRAINT pk_documentomensaje PRIMARY KEY (iddocumentomensaje);


--
-- TOC entry 2198 (class 2606 OID 188764)
-- Dependencies: 229 229
-- Name: pk_envio; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY envio
    ADD CONSTRAINT pk_envio PRIMARY KEY (idenvio);


--
-- TOC entry 2220 (class 2606 OID 387982)
-- Dependencies: 241 241
-- Name: pk_estadobandeja; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY estadobandeja
    ADD CONSTRAINT pk_estadobandeja PRIMARY KEY (idestadobandeja);


--
-- TOC entry 2164 (class 2606 OID 139580)
-- Dependencies: 212 212
-- Name: pk_estadoflujo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY estadoflujo
    ADD CONSTRAINT pk_estadoflujo PRIMARY KEY (idestadoflujo);


--
-- TOC entry 2234 (class 2606 OID 415306)
-- Dependencies: 250 250
-- Name: pk_evento; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY evento
    ADD CONSTRAINT pk_evento PRIMARY KEY (idevento);


--
-- TOC entry 2232 (class 2606 OID 413473)
-- Dependencies: 248 248
-- Name: pk_expediente; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expediente
    ADD CONSTRAINT pk_expediente PRIMARY KEY (idexpediente);


--
-- TOC entry 2166 (class 2606 OID 139584)
-- Dependencies: 213 213
-- Name: pk_expedienterequisito; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expedienterequisito
    ADD CONSTRAINT pk_expedienterequisito PRIMARY KEY (idexpedienterequisito);


--
-- TOC entry 2168 (class 2606 OID 139586)
-- Dependencies: 214 214
-- Name: pk_feriado; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY feriado
    ADD CONSTRAINT pk_feriado PRIMARY KEY (idferiado);


--
-- TOC entry 2196 (class 2606 OID 188645)
-- Dependencies: 228 228
-- Name: pk_flujo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY flujo
    ADD CONSTRAINT pk_flujo PRIMARY KEY (idflujo);


--
-- TOC entry 2224 (class 2606 OID 388192)
-- Dependencies: 243 243
-- Name: pk_iddetalleusuariogrupo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY detalleusuariogrupo
    ADD CONSTRAINT pk_iddetalleusuariogrupo PRIMARY KEY (iddetalleusuariogrupo);


--
-- TOC entry 2236 (class 2606 OID 450244)
-- Dependencies: 251 251
-- Name: pk_mensaje; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mensaje
    ADD CONSTRAINT pk_mensaje PRIMARY KEY (idmensaje);


--
-- TOC entry 2170 (class 2606 OID 139590)
-- Dependencies: 215 215
-- Name: pk_modulo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY modulo
    ADD CONSTRAINT pk_modulo PRIMARY KEY (idmodulo);


--
-- TOC entry 2172 (class 2606 OID 139592)
-- Dependencies: 216 216
-- Name: pk_preexpediente; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY preexpediente
    ADD CONSTRAINT pk_preexpediente PRIMARY KEY (idpreexpediente);


--
-- TOC entry 2174 (class 2606 OID 139594)
-- Dependencies: 217 217
-- Name: pk_preexpedienterequisito; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY preexpedienterequisito
    ADD CONSTRAINT pk_preexpedienterequisito PRIMARY KEY (idpreexpedienterequisito);


--
-- TOC entry 2204 (class 2606 OID 303855)
-- Dependencies: 233 233
-- Name: pk_referencia; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY referencia
    ADD CONSTRAINT pk_referencia PRIMARY KEY (idreferencia);


--
-- TOC entry 2206 (class 2606 OID 303860)
-- Dependencies: 234 234
-- Name: pk_regla; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY regla
    ADD CONSTRAINT pk_regla PRIMARY KEY (idregla);


--
-- TOC entry 2178 (class 2606 OID 139596)
-- Dependencies: 219 219
-- Name: pk_requisitos; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY requisitos
    ADD CONSTRAINT pk_requisitos PRIMARY KEY (idrequisitos);


--
-- TOC entry 2194 (class 2606 OID 188637)
-- Dependencies: 227 227
-- Name: pk_respuesta; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY respuesta
    ADD CONSTRAINT pk_respuesta PRIMARY KEY (idrespuesta);


--
-- TOC entry 2180 (class 2606 OID 139598)
-- Dependencies: 220 220
-- Name: pk_rol; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rol
    ADD CONSTRAINT pk_rol PRIMARY KEY (idrol);


--
-- TOC entry 2182 (class 2606 OID 139600)
-- Dependencies: 221 221
-- Name: pk_rolmodulo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rolmodulo
    ADD CONSTRAINT pk_rolmodulo PRIMARY KEY (idrolmodulo);


--
-- TOC entry 2208 (class 2606 OID 303868)
-- Dependencies: 235 235
-- Name: pk_tipodocumento; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipodocumento
    ADD CONSTRAINT pk_tipodocumento PRIMARY KEY (idtipodocumento);


--
-- TOC entry 2210 (class 2606 OID 336718)
-- Dependencies: 236 236
-- Name: pk_tipoprocedimiento; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tipoprocedimiento
    ADD CONSTRAINT pk_tipoprocedimiento PRIMARY KEY (idtipoprocedimiento);


--
-- TOC entry 2184 (class 2606 OID 139602)
-- Dependencies: 222 222
-- Name: pk_usuario; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT pk_usuario PRIMARY KEY (idusuario);


--
-- TOC entry 2188 (class 2606 OID 139604)
-- Dependencies: 223 223
-- Name: pk_usuariocargo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuariocargo
    ADD CONSTRAINT pk_usuariocargo PRIMARY KEY (idusuariocargo);


--
-- TOC entry 2222 (class 2606 OID 388183)
-- Dependencies: 242 242
-- Name: pk_usuariogrupo; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuariogrupo
    ADD CONSTRAINT pk_usuariogrupo PRIMARY KEY (idusuariogrupo);


--
-- TOC entry 2190 (class 2606 OID 139606)
-- Dependencies: 224 224
-- Name: pk_usuariorol; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuariorol
    ADD CONSTRAINT pk_usuariorol PRIMARY KEY (idusuariorol);


--
-- TOC entry 2176 (class 2606 OID 139608)
-- Dependencies: 218 218
-- Name: procedimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY procedimiento
    ADD CONSTRAINT procedimiento_pkey PRIMARY KEY (idprocedimiento);


--
-- TOC entry 2186 (class 2606 OID 246430)
-- Dependencies: 222 222
-- Name: unique_user; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT unique_user UNIQUE (usuario);


--
-- TOC entry 2283 (class 0 OID 0)
-- Dependencies: 9
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2016-11-23 13:00:06

--
-- PostgreSQL database dump complete
--


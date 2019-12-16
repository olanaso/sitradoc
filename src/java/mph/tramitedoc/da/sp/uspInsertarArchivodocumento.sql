CREATE OR REPLACE FUNCTION uspInsertarArchivodocumento(
	_documento bigint,
	_codigo character varying,
	_nombre character varying,
	_url character varying,
	_estado boolean)

  RETURNS integer AS
$BODY$
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

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






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






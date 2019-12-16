CREATE OR REPLACE FUNCTION uspInsertarRegla(
	_subida boolean,
	_igual boolean,
	_bajada boolean,
	_estado boolean)

  RETURNS integer AS
$BODY$
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

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






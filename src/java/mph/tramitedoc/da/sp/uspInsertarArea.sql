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






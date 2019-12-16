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






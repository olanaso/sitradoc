CREATE OR REPLACE FUNCTION uspActualizarRegla(
	_idregla integer,
	_subida boolean,
	_igual boolean,
	_bajada boolean,
	_estado boolean)

  RETURNS integer AS
$BODY$
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

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






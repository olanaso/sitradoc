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






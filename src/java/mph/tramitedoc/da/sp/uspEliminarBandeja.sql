CREATE OR REPLACE FUNCTION uspEliminarBandeja(
	_idbandeja bigint
)

  RETURNS integer AS
$BODY$
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

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






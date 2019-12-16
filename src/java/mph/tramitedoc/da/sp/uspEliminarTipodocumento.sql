CREATE OR REPLACE FUNCTION uspEliminarTipodocumento(
	_idtipodocumento integer
)

  RETURNS integer AS
$BODY$
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

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;






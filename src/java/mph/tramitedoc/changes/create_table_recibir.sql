
-- Table: recepcion

-- DROP TABLE recepcion;

CREATE TABLE recepcion
(
  idrecepcion bigint,
  idexpediente bigint,
  idarea integer,
  idusuariorecepciona integer,
  bindentregado boolean,
  fecharecepcion timestamp without time zone,
  bindderivado boolean,
  bindprimero boolean,
  fechaderivacion timestamp without time zone,
  estado boolean,
  observacion character varying(600),
  idrecepcion_proviene bigint,
  idprocedimiento integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE recepcion OWNER TO postgres;

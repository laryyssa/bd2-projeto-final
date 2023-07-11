CREATE OR REPLACE FUNCTION verificarStatusCandidatura()
  RETURNS TRIGGER AS
$$
DECLARE
    candidaturaSelected candidatura%rowtype;

BEGIN
    SELECT * INTO STRICT candidaturaSelected FROM candidatura WHERE codcandidatura = NEW.codcandidatura;

    IF candidaturaSelected.codstatuscandidatura != 1 THEN
        RAISE EXCEPTION 'Apenas pode ser associado a ser CPI, agentes politicos com a candidatura ELEITA.';
    END IF;

    return NEW;
END
$$
LANGUAGE plpgsql;

CREATE TRIGGER verificarStatusCandidaturaTrigger
BEFORE INSERT ON candidaturacpi
FOR EACH ROW
EXECUTE FUNCTION verificarStatusCandidatura();

CREATE TRIGGER verificarStatusCandidaturaTrigger2
BEFORE INSERT ON candidaturaprojetolei
FOR EACH ROW
EXECUTE FUNCTION verificarStatusCandidatura();
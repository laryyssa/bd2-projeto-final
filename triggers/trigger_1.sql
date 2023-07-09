CREATE OR REPLACE FUNCTION verificarStatusCandidatura()
  RETURNS TRIGGER AS
$$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM AgentePolitico ap
    LEFT JOIN Candidatura c ON ap.CPF = c.CPF
    WHERE c.codStatusCandidatura != 1
      AND (NEW.codCPI IS NOT NULL OR NEW.numeroProjetoLei IS NOT NULL)
      AND ap.CPF = NEW.CPF
  ) THEN
    RAISE EXCEPTION 'Apenas agentes políticos com status de candidato eleito podem criar uma CPI ou um projeto de lei.';
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER verificarStatusCandidaturaTrigger
BEFORE INSERT ON CPI
FOR EACH ROW
EXECUTE FUNCTION verificarStatusCandidatura();

CREATE TRIGGER verificarStatusCandidaturaTrigger2
BEFORE INSERT ON ProjetoLei
FOR EACH ROW
EXECUTE FUNCTION verificarStatusCandidatura();

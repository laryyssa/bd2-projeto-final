CREATE OR REPLACE FUNCTION verificarTipoPessoa()
  RETURNS TRIGGER AS
$$
BEGIN
  IF NOT (
    (EXISTS (SELECT 1 FROM AgentePolitico WHERE CPF = NEW.CPF)) OR
    (EXISTS (SELECT 1 FROM ServidorPublico WHERE CPF = NEW.CPF))
  ) THEN
    RAISE EXCEPTION 'Apenas agentes políticos ou servidores públicos podem ser inseridos como pessoa.';
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER verificarTipoPessoaTrigger
BEFORE INSERT ON Pessoa
FOR EACH ROW
EXECUTE FUNCTION verificarTipoPessoa();
  
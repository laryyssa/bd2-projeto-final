CREATE INDEX idx_cargo_politico_nome ON CargoPolitico USING hash (nome);
CREATE INDEX idx_candidatura_ano ON Candidatura USING btree (ano);
CREATE INDEX idx_orcamento_anual_secretaria ON OrcamentoAnual USING btree (valorSecretaria);
CREATE INDEX idx_orcamento_anual_ministerio ON OrcamentoAnual USING btree (valorMinisterio);
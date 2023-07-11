  CREATE TABLE CPI (
      codCPI SERIAL PRIMARY KEY,
      nomeCPI VARCHAR(100) NOT NULL
  );

  CREATE TABLE Estado (
      UF VARCHAR(2) PRIMARY KEY,
      nome VARCHAR(20) NOT NULL,
      regiao VARCHAR(20)
  );

  CREATE TABLE Ministerio (
      codMinisterio SERIAL PRIMARY KEY,
      nomeMinisterio VARCHAR(100),
      statusMinisterio BOOLEAN DEFAULT TRUE NOT NULL
  );

  CREATE TABLE Municipio (
      codMunicipio SERIAL PRIMARY KEY,
      nome VARCHAR(100) NOT NULL,
      UF VARCHAR(2) NOT NULL,
      CONSTRAINT Municipio_Estado_codEstado_fk
          FOREIGN KEY (UF) REFERENCES Estado (UF)
  );

  CREATE TABLE Partido (
      codPartido SERIAL PRIMARY KEY,
      nome VARCHAR(100) NOT NULL
  );

  CREATE TABLE Pessoa (
      CPF VARCHAR(11) PRIMARY KEY,
      nome VARCHAR(100)
  );

  CREATE TABLE Poder (
      codPoder SERIAL PRIMARY KEY,
      nome VARCHAR(20)
  );

  CREATE TABLE CargoPolitico (
      codCargoPolitico SERIAL PRIMARY KEY,
      UF VARCHAR(2),
      salario FLOAT,
      nome VARCHAR(100),
      codPoder INT NOT NULL,
      codMunicipio INT,
      CONSTRAINT CargoPolitico_Estado_UF_fk
          FOREIGN KEY (UF) REFERENCES Estado (UF),
      CONSTRAINT CargoPolitico_Municipio_codM_fk
          FOREIGN KEY (codMunicipio) REFERENCES Municipio (codMunicipio),
      CONSTRAINT CargoPolitico_Poder_codPoder_fk
          FOREIGN KEY (codPoder) REFERENCES Poder (codPoder)
  );

  CREATE TABLE Governo (
      codGoverno SERIAL PRIMARY KEY,
      tipoGoverno VARCHAR(10) NOT NULL,
      dataFimGoverno TIMESTAMP,
      dataInicioGoverno TIMESTAMP NOT NULL,
      codPoder INT,
      CONSTRAINT Governo_Poder_codPoder_fk
          FOREIGN KEY (codPoder) REFERENCES Poder (codPoder)
  );

  CREATE TABLE GovernoMinisterio (
      codGoverno INT NOT NULL,
      codMinisterio INT NOT NULL,
      PRIMARY KEY (codGoverno, codMinisterio),
      CONSTRAINT GovernoMinisterio_Governo_codGoverno_fk
          FOREIGN KEY (codGoverno) REFERENCES Governo (codGoverno),
      CONSTRAINT GovernoMinisterio_Ministerio_codMinisterio_fk
          FOREIGN KEY (codMinisterio) REFERENCES Ministerio (codMinisterio)
  );

  CREATE TABLE ProjetoLei (
      numeroProjetoLei SERIAL PRIMARY KEY,
      ano TIMESTAMP NOT NULL
  );

  CREATE TABLE Secretaria (
      codSecretaria SERIAL PRIMARY KEY,
      nomeSecretaria VARCHAR(100),
      codMinisterio INT,
      CONSTRAINT Secretaria_Ministerio_codMinisterio_fk
          FOREIGN KEY (codMinisterio) REFERENCES Ministerio (codMinisterio)
  );

  CREATE TABLE AgentePolitico (
      CPF VARCHAR(11) PRIMARY KEY,
      codPartido INT,
      codMinisterio INT,
      codSecretaria INT,
      codGoverno INT,
      codCargoPolitico INT,
      funcaoMinisterio VARCHAR(100),
      funcaoSecretaria VARCHAR(100),
      CONSTRAINT AgentePolitico_CargoPolitico_codGoverno_fk
          FOREIGN KEY (codCargoPolitico) REFERENCES CargoPolitico (codCargoPolitico),
      CONSTRAINT AgentePolitico_Governo_codGoverno_fk
          FOREIGN KEY (codGoverno) REFERENCES Governo (codGoverno),
      CONSTRAINT AgentePolitico_Ministerio_codMinisterio_fk
          FOREIGN KEY (codMinisterio) REFERENCES Ministerio (codMinisterio),
      CONSTRAINT AgentePolitico_Partido_codPartido_fk
          FOREIGN KEY (codPartido) REFERENCES Partido (codPartido),
      CONSTRAINT AgentePolitico_Secretaria_codSecretaria_fk
          FOREIGN KEY (codSecretaria) REFERENCES Secretaria (codSecretaria)
  );

  CREATE TABLE GovernoSecretaria (
      codGoverno INT NOT NULL,
      codSecretaria INT NOT NULL,
      PRIMARY KEY (codSecretaria, codGoverno),
      CONSTRAINT GovernoSecretaria_Governo_codGoverno_fk
          FOREIGN KEY (codGoverno) REFERENCES Governo (codGoverno),
      CONSTRAINT GovernoSecretaria_codSecretaria_fk
          FOREIGN KEY (codSecretaria) REFERENCES Secretaria (codSecretaria)
  );

  CREATE TABLE OrcamentoAnual (
      codOrcamentoAnual SERIAL PRIMARY KEY,
      ano TIMESTAMP NOT NULL,
      nome VARCHAR(100),
      codMinisterio INT,
      codSecretaria INT,
      valorMinisterio FLOAT,
      valorSecretaria FLOAT,
      CONSTRAINT OrcamentoAnual_Ministerio_codMinisterio_fk
          FOREIGN KEY (codMinisterio) REFERENCES Ministerio (codMinisterio),
      CONSTRAINT OrcamentoAnual_Secretaria_codSecretaria_fk
          FOREIGN KEY (codSecretaria) REFERENCES Secretaria (codSecretaria)
  );

  CREATE TABLE GovernoOrcamentoAnual (
      codGoverno INT NOT NULL,
      codOrcamentoAnual INT NOT NULL,
      PRIMARY KEY (codGoverno, codOrcamentoAnual),
      CONSTRAINT GovernoOrcamentoAnual_Governo_codGoverno_fk
          FOREIGN KEY (codGoverno) REFERENCES Governo (codGoverno),
      CONSTRAINT GovernoOrcamentoAnual_OrcamentoAnual_codOrcamentoAnual_fk
          FOREIGN KEY (codOrcamentoAnual) REFERENCES OrcamentoAnual (codOrcamentoAnual)
  );

  CREATE TABLE ServidorPublico (
      CPF VARCHAR(11) PRIMARY KEY,
      salario FLOAT,
      codMinisterio INT,
      codSecretaria INT,
      funcaoSecretaria VARCHAR(100),
      funcaoMinisterio VARCHAR(100),
      CONSTRAINT ServidorPublico_Ministerio_codMinisterio_fk
          FOREIGN KEY (codMinisterio) REFERENCES Ministerio (codMinisterio),
      CONSTRAINT ServidorPublico_Secretaria_codSecretaria_fk
          FOREIGN KEY (codSecretaria) REFERENCES Secretaria (codSecretaria)
  );

  CREATE TABLE StatusCandidatura (
      codStatusCandidatura SERIAL PRIMARY KEY,
      titulo VARCHAR(100) NOT NULL
  );

  CREATE TABLE Candidatura (
      codCandidatura SERIAL PRIMARY KEY,
      codCargoPolitico INT NOT NULL,
      numeroCandidato VARCHAR(10) NOT NULL,
      CPF VARCHAR(11) NOT NULL,
      ano TIMESTAMP,
      codStatusCandidatura INT,
      CONSTRAINT Candidatura_AgentePolitico_CPF_fk
          FOREIGN KEY (CPF) REFERENCES AgentePolitico (CPF),
      CONSTRAINT Candidatura_CargoPolitico_codCargoPolitico_fk
          FOREIGN KEY (codCargoPolitico) REFERENCES CargoPolitico (codCargoPolitico),
      CONSTRAINT Candidatura_StatusCandidatura_codStatusCandidatura_fk
          FOREIGN KEY (codStatusCandidatura) REFERENCES StatusCandidatura (codStatusCandidatura)
  );

  CREATE TABLE CandidaturaCPI (
      codCandidatura INT NOT NULL,
      codCPI INT NOT NULL,
      PRIMARY KEY (codCandidatura, codCPI),
      CONSTRAINT CandidaturaCPI_CPI_codCPI_fk
          FOREIGN KEY (codCPI) REFERENCES CPI (codCPI),
      CONSTRAINT CandidaturaCPI_Candidatura_codCandidatura_fk
          FOREIGN KEY (codCandidatura) REFERENCES Candidatura (codCandidatura)
  );

  CREATE TABLE CandidaturaProjetoLei (
      codCandidatura INT NOT NULL,
      numeroProjetoLei SERIAL NOT NULL,
      PRIMARY KEY (codCandidatura, numeroProjetoLei),
      CONSTRAINT CandidaturaProjetoLei_Candidatura_codCandidatura_fk
          FOREIGN KEY (codCandidatura) REFERENCES Candidatura (codCandidatura),
      CONSTRAINT CandidaturaProjetoLei_ProjetoLei_numeroProjetoLei_fk
          FOREIGN KEY (numeroProjetoLei) REFERENCES ProjetoLei (numeroProjetoLei)
  );
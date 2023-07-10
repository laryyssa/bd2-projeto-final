CREATE VIEW agentesCandidaturas AS
SELECT partido.nome as nome_partido,
       partido.codpartido as cod_partido,
       candidatura.numerocandidato,
       extract('YEAR' from candidatura.ano) as ano_candidatura,
       statuscandidatura.titulo as nome_status_candidatura,
       quantidade_projeto_lei
       quantidade_cpi
from (SELECT pessoa.cpf,
             pessoa.nome,
             count(*) as quantidade_cpi
      FROM AgentePolitico
               INNER JOIN Candidatura on AgentePolitico.cpf = Candidatura.cpf
               INNER JOIN pessoa on pessoa.cpf = agentepolitico.cpf
               INNER JOIN CandidaturaCPI on Candidatura.codCandidatura = CandidaturaCPI.codCandidatura
      group by pessoa.cpf) as tabela_codCPI,
     (SELECT pessoa.cpf,
             pessoa.nome,
             count(*) as quantidade_projeto_lei
      FROM AgentePolitico
               INNER JOIN Candidatura on AgentePolitico.cpf = Candidatura.cpf
               INNER JOIN pessoa on pessoa.cpf = agentepolitico.cpf
             INNER JOIN candidaturaprojetolei c on candidatura.codcandidatura = c.codcandidatura
      group by pessoa.cpf) as tabela_projeto_lei,
    agentepolitico, partido, candidatura, pessoa, statuscandidatura
    WHERE tabela_codCPI.cpf = tabela_projeto_lei.cpf
      and tabela_codCPI.cpf = agentepolitico.cpf
      and agentepolitico.codpartido = partido.codpartido
      and candidatura.cpf = agentepolitico.cpf
      and agentepolitico.cpf = pessoa.cpf
      and statuscandidatura.codstatuscandidatura = candidatura.codstatuscandidatura;
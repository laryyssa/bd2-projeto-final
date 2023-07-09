CREATE VIEW agentesCandidaturas AS
SELECT 
    Partido.nome as nome_partido,
    Partido.codPartido,
    Candidatura.numeroCandidato,
    Candidatura.ano as ano_da_candidatura,
    StatusCandidatura.titulo as nome_status_candidatura,
    COUNT(DISTINCT ProjetoLei.numeroProjetoLei) as quantidade_projeto_lei,
    COUNT(DISTINCT CPI.codCPI) as quantidade_cpi
FROM 
    AgentePolitico
    INNER JOIN Candidatura on AgentePolitico.cpf = Candidatura.cpf
    INNER JOIN Partido on AgentePolitico.codPartido = Partido.codPartido
    INNER JOIN statusCandidadtura on Candidatura.codStatusCandidatura = statusCandidadtura.codStatusCandidatura
    INNER JOIN CandidaturaProjetoLei on Candidatura.codCandidatura = CandidaturaProjetoLei.codCandidatura
    INNER JOIN ProjetoLei on CandidaturaProjetoLei.numeroProjetoLei = ProjetoLei.numeroProjetoLei
    INNER JOIN CandidaturaCPI on Candidatura.codCandidatura = CandidaturaCPI.codCandidatura
    INNER JOIN CPI on CandidaturaCPI.codCPI = CPI.codCPI




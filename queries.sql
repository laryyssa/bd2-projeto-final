-- 1. Nome e partido de todos governadores do rio na última década em ordem alfabética 
SELECT Pessoa.nome, Partido.nome AS partido
FROM AgentePolitico
         JOIN CargoPolitico ON AgentePolitico.codcargopolitico = CargoPolitico.codCargoPolitico
         JOIN Governo ON AgentePolitico.codgoverno = Governo.codGoverno
         JOIN Pessoa ON AgentePolitico.CPF = Pessoa.cpf
         JOIN Partido ON AgentePolitico.codPartido = Partido.codPartido
WHERE CargoPolitico.nome = 'Governador'
  AND Governo.dataInicioGoverno >= '2012-01-01'
ORDER BY Pessoa.nome ASC;



-- 2. Soma dos orçamentos por ministério de todos os governos
SELECT Ministerio.nomeMinisterio AS nome_ministerio,
       COALESCE(SUM(OrcamentoAnual.ValorMinisterio), 0) AS valor_total
FROM OrcamentoAnual
         RIGHT OUTER JOIN Ministerio ON Ministerio.codMinisterio = OrcamentoAnual.codMinisterio
GROUP BY Ministerio.codMinisterio;




-- 3. Nome dos presidentes que tiveram mais ministérios em seu mandato
SELECT P.CPF, P.nome, COUNT(*) AS quantidade_ministerios
FROM AgentePolitico
         INNER JOIN CargoPolitico CP ON AgentePolitico.codCargoPolitico = CP.codCargoPolitico
         INNER JOIN Governo G ON AgentePolitico.codGoverno = G.codGoverno
         INNER JOIN Pessoa P ON AgentePolitico.CPF = P.CPF
         INNER JOIN GovernoMinisterio GM ON G.codGoverno = GM.codGoverno
WHERE CP.nome = 'Presidente'
GROUP BY P.CPF;



-- 4. Média do orçamento anual da saúde dos últimos 2 governos (Usando AVG)
SELECT AVG(OrcamentoAnual.valorMinisterio) AS média_orçamento_federal_saúde
FROM GovernoOrcamentoAnual
         JOIN (SELECT *
               FROM Governo
               WHERE tipogoverno = 'Federal'
               ORDER BY datainiciogoverno DESC, datafimgoverno DESC
               LIMIT 2) AS t
              ON t.codGoverno = GovernoOrcamentoAnual.codGoverno
         JOIN OrcamentoAnual ON OrcamentoAnual.codOrcamentoAnual = GovernoOrcamentoAnual.codOrcamentoAnual
WHERE OrcamentoAnual.nome = 'Saúde';


-- 5. Quantidade de projetos de lei criadas agrupada pelos partidos (COUNT)
SELECT Partido.nome, COUNT(*) AS quantidade_de_projetos_de_lei
FROM ProjetoLei
         JOIN CandidaturaProjetoLei ON CandidaturaProjetoLei.numeroProjetoLei = ProjetoLei.numeroProjetoLei
         JOIN Candidatura ON Candidatura.codCandidatura = CandidaturaProjetoLei.codCandidatura
         JOIN AgentePolitico ON AgentePolitico.CPF = Candidatura.cpf
         JOIN Partido ON AgentePolitico.codpartido = Partido.codPartido
GROUP BY Partido.nome;


-- 6. Média do salário dos cargos político por região (AVG)
SELECT e.regiao, AVG(CargoPolitico.salario) AS média_salario_dos_cargos
FROM CargoPolitico
         INNER JOIN Estado e ON e.UF = CargoPolitico.UF
GROUP BY e.regiao;



-- 7. Agrupar por partido o nome dos presidentes nos últimos 20 anos
SELECT Partido.nome AS partido,
STRING_AGG(Pessoa.nome, ',') AS nomes_presidentes
FROM AgentePolitico
JOIN
Pessoa ON Pessoa.CPF = AgentePolitico.CPF
JOIN
CargoPolitico ON CargoPolitico.codCargoPolitico = AgentePolitico.codCargoPolitico
JOIN
Governo ON Governo.codGoverno = AgentePolitico.codGoverno
JOIN
Partido ON Partido.codPartido = AgentePolitico.codPartido
WHERE CargoPolitico.nome = 'Presidente'
AND Governo.dataInicioGoverno >= (NOW() - INTERVAL '20 years')
GROUP BY Partido.nome;




-- 8. Agrupar, por partido, todos os candidatos à deputado estadual no Rio de Janeiro do ano de 2014
SELECT Partido.nome, Pessoa.nome, Pessoa.CPF
FROM AgentePolitico
      JOIN Pessoa ON Pessoa.CPF = AgentePolitico.CPF
	JOIN CargoPolitico ON CargoPolitico.codCargoPolitico = AgentePolitico.codCargoPolitico
	JOIN Governo on Governo.codGoverno = AgentePolitico.codGoverno
	JOIN Partido ON Partido.codPartido = AgentePolitico.codPartido
      JOIN Candidatura ON Candidatura.CPF = Pessoa.CPF
WHERE CargoPolitico.nome = 'Deputado Estadual'
AND Candidatura.ano = '2014-01-01 00:00:00'



-- 9. CPF dos candidatos eleitos na região Nordeste que aprovaram mais de uma lei
SELECT Candidatura.CPF,
Estado.regiao,
COUNT(Candidatura.CPF) AS quantidade_de_aprovacoes_leis
FROM AgentePolitico
JOIN
Candidatura ON AgentePolitico.CPF = Candidatura.CPF
JOIN
CargoPolitico ON AgentePolitico.codCargoPolitico = CargoPolitico.codCargoPolitico
JOIN
Estado ON CargoPolitico.UF = Estado.UF
JOIN
CandidaturaProjetoLei ON CandidaturaProjetoLei.codCandidatura = Candidatura.codCandidatura
WHERE Candidatura.codStatusCandidatura = 1
AND Estado.regiao = 'Nordeste'
GROUP BY Candidatura.CPF, Estado.regiao
HAVING COUNT(Candidatura.CPF) >= 1;




-- 10.Média dos salários dos servidores que participaram de secretarias que receberam um orçamento maior ou igual a R$100.000,00.
SELECT ROUND(CAST(AVG(salario) AS numeric), 2) AS salario
FROM ServidorPublico
WHERE codSecretaria IN (SELECT codSecretaria
FROM OrcamentoAnual
WHERE codSecretaria IS NOT NULL
AND OrcamentoAnual.valorSecretaria > 1000000);



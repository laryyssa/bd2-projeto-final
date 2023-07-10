CREATE VIEW ListaServidores AS
SELECT
    CONCAT('***.***.***-', SUBSTRING(CPF, 10, 3)) AS cpf_ofuscado,
    ServidorPublico.salario,
    '' as nome_ministerio,
    Secretaria.nomeSecretaria as nome_secretaria,
    ServidorPublico.funcaoSecretaria,
    ServidorPublico.funcaoMinisterio
FROM servidorpublico
JOIN Secretaria ON servidorpublico.codSecretaria = secretaria.codSecretaria
UNION
SELECT
    CONCAT('***.***.***-', SUBSTRING(CPF, 10, 3)) AS cpf_ofuscado,
    ServidorPublico.salario,
    ministerio.nomeministerio as nome_ministerio,
    '' as nome_secretaria,
    ServidorPublico.funcaoSecretaria,
    ServidorPublico.funcaoMinisterio
FROM servidorpublico
JOIN ministerio ON servidorpublico.codministerio = ministerio.codministerio
CREATE VIEW ListaServidores AS
SELECT 
    CONCAT('***.***.***-', SUBSTRING(CPF, 10, 3)) AS cpf_ofuscado,
    ServidorPublico.salario,
    Ministerio.nomeMinisterio,
    Secretaria.nomeSecretaria,
    ServidorPublico.funcaoSecretaria,
    ServidorPublico.funcaoMinisterio
FROM servidorpublico
JOIN Ministerio ON servidorpublico.codMinisterio = ministerio.codMinisterio
JOIN Secretaria ON servidorepublico.codSecretaria = secretaria.codSecretaria

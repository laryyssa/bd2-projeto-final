-- Ao se trocar um governo, é possível que todos os servidores que estarão atuando nos ministérios e secretarias que o governo possui, ele poderá receber um ajuste de X% no salário. O ajuste pode ser incremental ou decremental. Propúnhamos uma função que entra com um governo e atualiza o salário de todos os funcionários de todos os ministérios e secretários que estão presentes no governo.

CREATE OR REPLACE FUNCTION AjusteSalario(governoId governo.codGoverno%TYPE, ajuste float) RETURNS bool as
'
    DECLARE
        codMinisterios ministerio.codministerio%TYPE;
        codSecretarias secretaria.codsecretaria%TYPE;

    BEGIN

        SELECT codministerio
                INTO codMinisterios
               FROM GovernoMinisterio
               WHERE codGoverno = governoId;

        SELECT codsecretaria
               INTO codSecretarias
               FROM GovernoSecretaria
               WHERE codGoverno = governoId;

        UPDATE servidorpublico set salario = (salario * ajuste ) where codministerio in (codMinisterios);
        UPDATE servidorpublico set salario = (salario * ajuste ) where codSecretaria in (codSecretaria);

        return TRUE;
    END;
' language plpgsql;

SELECT AjusteSalario(1, 1.1);
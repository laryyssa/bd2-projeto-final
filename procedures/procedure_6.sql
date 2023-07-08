-- Função para formatar o CPF

CREATE OR REPLACE FUNCTION formataCpf(cpf varchar) RETURNS varchar as
$$
    DECLARE
    BEGIN

    cpf := regexp_replace(cpf, '[^0-9]', '', 'g');

    IF length(cpf) != 11 THEN
        raise exception 'CPF INVALIDO!';
    END IF;

    cpf := substring(cpf, 1, 3) || '.' || substring(cpf, 4, 3) || '.' || substring(cpf, 7, 3) || '-' || substring(cpf, 10, 2);

    RETURN cpf;


    END
$$ language plpgsql;


select formataCpf('95408771997')
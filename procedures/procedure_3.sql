CREATE OR REPLACE FUNCTION CassarCandidatura(f_nomepartido varchar(100)) 
    RETURNS BOOL AS 
$$
BEGIN
    UPDATE candidatura
    SET codStatusCandidatura = 3
    FROM agentepolitico
    INNER JOIN partido ON partido.codpartido = agentepolitico.codpartido
    WHERE agentepolitico.cpf = candidatura.cpf
        AND partido.nome = f_nomepartido;

    RETURN TRUE;
END;
$$
LANGUAGE plpgsql;

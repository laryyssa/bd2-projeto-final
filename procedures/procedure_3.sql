
CREATE OR REPLACE FUNCTION CassarCandidatura(f_nomepartido varchar(100)) 
    RETURNS BOOL AS 
$$
BEGIN
    UPDATE statusCandidadtura
    SET codStatusCandidatura = 3
    FROM candidatura
    INNER JOIN agentepolitico ON agentepolitico.cpf = candidatura.cpf
    INNER JOIN partido ON partido.codpartido = agentepolitico.codpartido
    WHERE partido.nome = f_nomepartido;

    RETURN TRUE;
END;
$$
LANGUAGE plpgsql;



    
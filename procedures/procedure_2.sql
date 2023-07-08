--Função para realizar o desligamento de um ministério e ministérios, realizando a exoneração de todos os servidores públicos que trabalham naquela instituição. A exoneração é definida com a exclusão do registro do servidor público, retornando quantos servidores foram exonerados. 

CREATE OR REPLACE FUNCTION DesligamentoMinisterioSecretaria(identificador INTEGER, type varchar) RETURNS bool as
$$
    DECLARE
    BEGIN

        IF type != 'SECRETARIA' AND type != 'MINISTERIO' THEN
             raise exception 'Defina se você quer exonerar servidor de SECRETARIA ou para MINISTERIO';
        END IF;

        IF type = 'SECRETARIA' THEN
            DELETE FROM servidorpublico where codSecretaria = identificador;
        END IF;
        iF type = 'MINISTERIO' THEN
            DELETE FROM servidorpublico where codMinisterio = identificador;
        END IF;

        RETURN TRUE;

    END
$$ language plpgsql;

SELECT DesligamentoMinisterioSecretaria(1, 'MINISTERIO');
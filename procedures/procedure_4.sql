-- CREATE TYPE record AS (
--     nomepessoa VARCHAR(100),
--     salario FLOAT,
--     nomeministerio VARCHAR(100),
--     nomesecretaria VARCHAR(100),
--     funcaoministerio VARCHAR(100),
--     funcaosecretaria VARCHAR(100),
--     nomecargopolitico VARCHAR(100),
--     ufatuacao VARCHAR(2),
--     nomepartido VARCHAR(100)
-- );

create or replace function analisarDadosPessoa(f_cpf varchar)
returns record as
$$
declare 
	f_nomepessoa varchar(100);
	f_salario float;
	f_nomeministerio varchar(100);
	f_nomesecretaria varchar(100);
	f_funcaoministerio varchar(100);
	f_funcaosecretaria varchar(100);
	f_nomecargopolitico varchar(100);
	f_ufatuacao varchar(2);
	f_nomepartido varchar(100);
	resultado record;
begin
	
	select
		nome into f_nomepessoa
	from pessoa
	where pessoa.cpf = f_cpf;
	
	SELECT
    	servidorpublico.salario INTO f_salario
	FROM servidorpublico
	WHERE servidorpublico.cpf = f_cpf;
	
	if(f_salario is not NULL) then  -- é um servidor público
		SELECT
			ministerio.nomeministerio,
			secretaria.nomesecretaria,
			servidorpublico.funcaoministerio,
			servidorpublico.funcaosecretaria
		INTO
			f_nomeministerio,
			f_nomesecretaria,
			f_funcaoministerio,
			f_funcaosecretaria
		FROM servidorpublico
		inner join ministerio on ministerio.codministerio = servidorpublico.codministerio
		inner join secretaria on secretaria.codsecretaria = servidorpublico.codsecretaria
		WHERE
			servidorpublico.cpf = f_cpf;
		
		f_nomecargopolitico := NULL;  
		f_nomepartido := NULL; 
		f_ufatuacao := NULL;
	
	else -- é um agente político
		SELECT
			cargopolitico.salario,
			cargopolitico.nome,
			cargopolitico.uf,
			partido.nome
		INTO
			f_salario,
			f_nomecargopolitico,
			f_ufatuacao,
			f_nomepartido
		FROM agentepolitico
		INNER JOIN cargopolitico ON cargopolitico.codcargopolitico = agentepolitico.codcargopolitico
		INNER JOIN partido ON partido.codpartido = agentepolitico.codpartido
		WHERE agentepolitico.cpf = f_cpf;

        f_nomeministerio := NULL;
        f_nomesecretaria := NULL;
        f_funcaoministerio := NULL;
        f_funcaosecretaria := NULL;
		
		
	end if;
	
	resultado := row(f_nomepessoa, f_salario, f_nomeministerio, f_nomesecretaria, f_funcaoministerio, f_funcaosecretaria, f_nomecargopolitico, f_ufatuacao, f_nomepartido);
    RETURN resultado;
	
END
$$
LANGUAGE plpgsql;
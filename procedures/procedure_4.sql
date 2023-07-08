

-- CREATE TYPE record AS (
--     f_nomepessoa VARCHAR(100),
--     f_salario FLOAT,
--     f_nomeministerio VARCHAR(100),
--     f_nomesecretaria VARCHAR(100),
--     f_funcaoministerio VARCHAR(100),
--     f_funcaosecretaria VARCHAR(100),
--     f_nomecargopolitico VARCHAR(100),
--     f_ufatuacao VARCHAR(2),
--     f_nomepartido VARCHAR(100)
-- );

-- DROP FUNCTION IF EXISTS analisarDadosPessoa;

create or replace function analisarDadosPessoa(f_cpf varchar)
returns record as
$$
declare
	f_cpf varchar(11);
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
    	servidorpublico.salario 
	INTO 
		f_salario
	FROM servidorpublico
	WHERE servidorpublico.cpf = f_cpf;
	
	if(f_salario is not NULL) then
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

		
		if (f_funcaoministerio is not null) then
			resultado := row(f_nomepessoa, f_nomeministerio, f_funcaoministerio, f_salario);
			return resultado;
		
		else 			
			resultado := row(f_nomepessoa, f_nomeministerio, f_nomesecretaria, f_funcaosecretaria, f_salario);			
			return resultado;
			
		end if;
	
	else 
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

		
		resultado := row(f_nomepessoa, f_nomecargopolitico, f_nomepartido, f_ufatuacao, f_salario);
		return resultado;
		
	end if;
	
END
$$
LANGUAGE plpgsql;

select analisarDadosPessoa('08356724333')

-- select * from agentepolitico
-- select * from candidatura
-- select * from servidorpublico
-- select * from ministerio
-- select * from secretaria
-- select * from cargopolitico
-- select * from partido
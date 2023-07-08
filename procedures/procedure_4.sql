-- Função analise Pessoa 
-- entra CPF; 
-- Se for Agente político: retorna salário, cargo
-- Se for Servidor público: retorna salário, nome Secretaria

create or replace function analisarDadosPessoa(f_cpf varchar)
returns record as
$$
declare
	f_cpf varchar,
	f_codcargopolitico int,
	f_funcaosecretaria varchar,
	f_salario float,
	f_nome varchar,
	f_codpartidopolitico int,
	resultado record;
begin
	
	select 
		salario into f_salario,
	from servidorpublico 
	where servidorpublico.cpf = f_cpf
	
	select
		nome into f_nome
	from pessoa ps
	where pessoa.cpf = f_cpf
	
	
	if(f_salario is not NULL)
		select
			codministerio into f_codminiterio,
			codsecretaria into f_codsecretaria,
			funcaoministerio into f_funcaoministerio,
			funcaosecretaria into f_funcaosecretaria;
		from servidorpublico 
		where servidorpublico.cpf = f_cpf
		
		if (f_codministerio is not null)
			select 
				nomeministerio into f_nomeministerio
			from ministerio 
			where ministerio.codministerio = f_codministerio;
			
			resultado := row(f_nome, f_nomeministerio, f_funcaoministerio, f_salario)
			return resultado;
		else 		
			select 
				nomesecretaria into f_nomesecretaria
				nomeministerio into f_nomeministerio
			from secretaria 
			inner join ministerio as ministerio.codministerio = secretaria.codministerio
			where secretaria.codsecretaria = f_codsecretaria
			
			resultado := row(f_nome, f_nomeministerio, f_nomesecretaria, f_funcaosecretaria, f_salario)			
			return resultado		
		end if
	
	else 
		select 
			cargopolitico.salario into f_salario,
			cargopolitico.nome into f_nomecargopolitico,
			cargopolitico.uf into f_ufatuacao
		from agentepolitico
		inner join cargopolitico as cargopolitico.codcargopolitico = agentepolitico.codcargopolitico
		where agentepolitico.cpf = f_cpf;
		
		
		
		
		select
			salario into f_salario
		from cargopolitico 
		inner join agentepolitico as agentepolitico.codcargopolitico = cargopolitico.codcargopolitico
		where 
			ap.cpf = f_cpf
		
		
	end if;
	
end

select * from agentepolitico
select * from candidatura
select * from servidorpublico
select * from ministerio
select * from secretaria
select * from cargopolitico

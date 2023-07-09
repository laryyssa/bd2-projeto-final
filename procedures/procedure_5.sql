-- entra nome do agente politico
-- cria se uma cpi no nome dele

-- retorna True: criou-se uma tupla em candidaturacpi
-- retorna False: tupla não criada

create or replace function criaCPI(f_nomepessoa varchar(100), f_nomecpi varchar(100))
returns boolean as
$$
declare
	f_codcandidatura int;
	f_codcpi int;
	max_cod int;
begin
	select 
		candidaturacpi.codcandidatura,
		candidaturacpi.codcpi
		into
		f_codcandidatura,
		f_codcpi
	from candidaturacpi
	inner join candidatura on candidatura.codcandidatura = candidaturacpi.codcandidatura
	inner join cpi on cpi.codcpi = candidaturacpi.codcpi
	inner join pessoa on pessoa.cpf = candidatura.cpf
	where
		pessoa.nome = f_nomepessoa and
		cpi.nomecpi = f_nomecpi;
		
	IF (f_codcandidatura IS NOT NULL) AND (f_codcpi IS NOT NULL) THEN
		RETURN False;
	
	else 
		SELECT MAX(codcpi) into max_cod
		FROM candidaturacpi;

		max_cod := max_cod + 1;
		
		select codcandidatura into f_codcandidatura
		from candidatura
		inner join pessoa on pessoa.cpf = candidatura.cpf
		where pessoa.nome = f_nomepessoa;
		
		if (f_codcandidatura is not null) then
			INSERT INTO candidaturacpi (codcandidatura, codcpi)
			VALUES (f_codcandidatura, max_cod);
			
			return True;
		else
			return False;
		end if;
		
	END IF;

end
$$ 
LANGUAGE plpgsql;
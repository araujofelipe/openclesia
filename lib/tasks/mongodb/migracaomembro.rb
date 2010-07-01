module MongodbTasks

	class MigraMembro < MigracaoBase

		def initialize
   
	    @sql_recupera_membros = 
					"select cod_membro, nom_membro, nom_carteirinha_membro, dig_sexo, d.dta_nascimento from sis_tb_membros m  
	        inner join sis_tb_dados_pessoais d on m.cod_dado_pessoal = d.cod_dado_pessoal 
	        order by cod_membro "
    
		end

		#migra os dados de membros para pessoa
		def exec(conn)
			puts 'migrando dados de membros'
			rs = conn.exec(@sql_recupera_membros)
    	erros = []
	  	quantidade_acertos = 0
			rs.each do |row|
      	begin

					pessoa = Pessoa.new do |p|
						p.nome = row['nom_membro']
	        	p.nome_curto = row['nom_carteirinha_membro']
	        	p.data_nascimento = row['dta_nascimento']
	        	p.sexo = masculino?(row['dig_sexo'])
					end
        	
					pessoa.save

        	puts "#{pessoa.nome} importada"
					quantidade_acertos = quantidade_acertos + 1
      	rescue => err
        	erros[erros.size] = {:cod_membro => pessoa.id, :nome => pessoa.nome, :err => err}
        	puts "erro na importacao: #{pessoa.nome}"         
      	end
			end	

	  	puts 'migracao finalizada com sucesso' if erros.size == 0
    	puts "migracao finalizada com #{erros.size} erros" if erros.size > 0
			puts "#{quantidade_acertos} pessoas criadas" if quantidade_acertos > 0
			puts "relatorio de gerado em tmp/membros_com_erro.txt"
  
    	gera_log_de_erro(erros, 'Pessoa')
    
		end
		
		#Diz se o sexo passado como paramentro do do genero masculino (true)
		def masculino?(sexoliteral)
		  masculino = true
		  masculino = false if sexoliteral == "F"
		  return masculino
		end	

	end

end

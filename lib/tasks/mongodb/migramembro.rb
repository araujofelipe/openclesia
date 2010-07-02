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
			Pessoa.delete_all
			rs = conn.exec(@sql_recupera_membros)
    	erros = []
	  	quantidade_acertos = 0
			rs.each do |row|
      	begin

					membro = Membro.new do |m|
						m.id_sys = row['cod_membro']
						m.nome = row['nom_membro']
	        	m.nome_curto = row['nom_carteirinha_membro']
	        	m.data_nascimento = row['dta_nascimento']
	        	m.sexo = masculino?(row['dig_sexo'])
					end
        	
					membro.save

        	puts "#{membro.nome} importada"
					quantidade_acertos = quantidade_acertos + 1
      	rescue => err
        	erros[erros.size] = {:cod_membro => membro.id, :nome => membro.nome, :err => err}
        	puts "erro na importacao: #{membro.nome}"         
      	end
			end	

	  	puts 'migracao de Membro finalizada com sucesso' if erros.size == 0
    	puts "migracao de Membro finalizada com #{erros.size} erros" if erros.size > 0
			puts "#{quantidade_acertos} membros criados" if quantidade_acertos > 0
			puts "relatorio de gerado em tmp/membros_com_erro.txt"
  
    	gera_log_de_erro erros, 'Membro', 'tmp/membros_com_erro.txt'
    
		end
		
		#Diz se o sexo passado como paramentro do do genero masculino (true)
		def masculino?(sexoliteral)
		  masculino = true
		  masculino = false if sexoliteral == "F"
		  return masculino
		end	

	end

end

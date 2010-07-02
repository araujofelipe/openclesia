module MongodbTasks
	
	class MigraCongregacao < MigracaoBase

		def initialize
		
			@sql_recupera_congregacoes = "select cod_congregacao, cod_endereco, nom_congregacao from sis_tb_congregacoes"

		end

		def exec(conn)
			puts 'migrando dados das congregacoes'
			Congregacao.delete_all
			rs = conn.exec(@sql_recupera_congregacoes)
    	erros = []
	  	quantidade_acertos = 0
			rs.each do |row|
      	begin
					congregacao = Congregacao.new do |c|
						c.id_sys = row['cod_congregacao']
						c.nome = row['nom_congregacao']
					end
					congregacao.save
				rescue => err
        	erros[erros.size] = {:cod_congregacao => congregacao.id_sys, :nome => congregacao.nome, :err => err}
        	puts "erro na importacao: #{congregacao.nome}"         
      	end
			end

	  	puts 'migracao de Congregacao finalizada com sucesso' if erros.size == 0
    	puts "migracao de Congregacao finalizada com #{erros.size} erros" if erros.size > 0
			puts "#{quantidade_acertos} congregacoes criadas" if quantidade_acertos > 0
			puts "relatorio de erro gerado em tmp/congregacoes_com_erro.txt"
  
    	gera_log_de_erro erros, 'Congregacao', 'tmp/congregacoes_com_erro.txt'

		end

	end

end

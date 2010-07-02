module MongodbTasks
	
	class MigracaoBase

		def gera_log_de_erro(erros, nome_entidade, path_file)
		  puts 'gerado relatorio' if erros.size > 0
		  File.open(path_file, 'w') do |f|
		    erros.each do |erro|
		      f.write "#{nome_entidade} nao exportado(a)\n"
		      f.write "Nome: #{erro[:nome]}\n"
		      f.write "Codigo: #{erro[:cod_membro]}\n" 
		      f.write "motivo: \n#{erro[:err]}\n\n"
		    end
		  end
		end

	end

end

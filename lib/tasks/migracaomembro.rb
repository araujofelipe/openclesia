class MigracaoMembro

	def initialize
   
    @sql_recupera_membros = "select cod_membro, nom_membro, nom_carteirinha_membro, dig_sexo, d.dta_nascimento from sis_tb_membros m  
        inner join sis_tb_dados_pessoais d on m.cod_dado_pessoal = d.cod_dado_pessoal 
        order by cod_membro "
    
	end

	#migra os dados de membros para pessoa
	def load_membros_by_membro_legado(conn)
		puts 'migrando dados de membros'
		rs = conn.exec(@sql_recupera_membros)
    erros = []
	  quantidade_acertos = 0
		rs.each do |row|
      begin
        membro = cria_ou_recupera_membro(row['cod_membro'])
        membro.nome = row['nom_membro']
        membro.nome_curto = row['nom_carteirinha_membro']
        membro.data_nascimento = row['dta_nascimento']
        membro.sexo = masculino?(row['dig_sexo'])
        membro.save
        puts "#{membro.nome} importada"
				quantidade_acertos = quantidade_acertos + 1
      rescue => err
        erros[erros.size] = {:cod_membro => membro.id, :nome => membro.nome, :err => err}
        puts "erro na importacao: #{membro.nome}"         
      end
		end	

	  puts 'migracao finalizada com sucesso' if erros.size == 0
    puts "migracao finalizada com #{erros.size} erros" if erros.size > 0
		puts "#{quantidade_acertos} pessoas criadas" if quantidade_acertos > 0
		puts "relatorio de gerado em tmp/membros_com_erro.txt"
  
    gera_log_de_erro erros    
    
  end

  def gera_log_de_erro(erros)
    puts 'gerado relatorio' if erros.size > 0
    File.open('tmp/membros_com_erro.txt', 'w') do |f|
      erros.each do |erro|
        f.write "Membro nao exportado\n"
        f.write "Nome: #{erro[:nome]}\n"
        f.write "Codigo: #{erro[:cod_membro]}\n" 
        f.write "motivo: \n#{erro[:err]}\n\n"
      end
    end
  end

  #Cria ou recupera um membro pelo id do sistema legado
  def cria_ou_recupera_membro(id_membro_legado)
    membro = Membro.find_by_id_membro_legado(id_membro_legado)
    if(membro == nil) 
      membro = Membro.new
      membro.id_membro_legado = id_membro_legado
    end
    return membro    
  end
  
  #Diz se o sexo passado como paramentro do do genero masculino (true)
  def masculino?(sexoliteral)
    masculino = true
    masculino = false if sexoliteral == "F"
    return masculino
  end

end

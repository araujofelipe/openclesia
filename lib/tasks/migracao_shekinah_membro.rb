#Classe responsavel pela migracao dos dados dos membros
class MigracaoMembro

	def initialize
   
    @sql_recupera_membros = "select cod_membro, nom_membro, nom_carteirinha_membro, dig_sexo, d.dta_nascimento from sis_tb_membros m  
        inner join sis_tb_dados_pessoais d on m.cod_dado_pessoal = d.cod_dado_pessoal 
        order by cod_membro "
    
	end

	#migra os dados de membros para pessoa
	def load_pessoas_by_membro_legado(conn)
		puts 'migrando dados de membro para pessoa'
		rs = conn.exec(@sql_recupera_membros)
    erros = []
		rs.each do |row|
      begin
        pessoa = cria_ou_recupera_pessoa(row['cod_membro'])
        pessoa.nome = row['nom_membro']
        pessoa.nome_curto = row['nom_carteirinha_membro']
        pessoa.data_nascimento = row['dta_nascimento']
        pessoa.sexo = masculino?(row['dig_sexo'])
        pessoa.save
        puts "#{pessoa.nome} importada"
      rescue => err
        erros[erros.size] = {:cod_membro => pessoa.id, :nome => pessoa.nome, :err => err}
        puts "erro na importacao: #{pessoa.nome}"         
      end
		end	

	  puts 'migração finalizada com sucesso' if erros.size == 0
    puts 'migração finalizada com #{erros.size} erros' if erros.size > 0
  
    gera_log_de_erro erros    
    
  end

  def gera_log_de_erro(erros)
    puts 'gerado relatório' if erros.size > 0
    File.open('membros_com_erro.txt', 'w') do |f|
      erros.each do |erro|
        f.write "Membro não exportado\n"
        f.write "Nome: #{erro[:nome]}\n"
        f.write "Codigo: #{erro[:cod_membro]}\n" 
        f.write "motivo: \n#{erro[:err]}\n\n"
      end
    end
  end

  #Cria ou recupera um pessoa pelo id do sistema legado
  def cria_ou_recupera_pessoa(id_membro_legado)
    pessoa = Pessoa.find_by_id_membro_legado(id_membro_legado)
    if(pessoa == nil) 
      pessoa = Pessoa.new
      pessoa.id_membro_legado = id_membro_legado
    end
    return pessoa    
  end
  
  #Diz se o sexo passado como paramentro do do genero masculino (true)
  def masculino?(sexoliteral)
    masculino = true
    masculino = false if sexoliteral == "F"
    return masculino
  end

end
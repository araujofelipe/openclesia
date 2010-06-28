require ::File.expand_path('../../../config/environment',  __FILE__)
require ::File.expand_path('../../../lib/tasks/migracaomembro',  __FILE__)

namespace :shekinah do

	desc 'cria as pessoas do sistema baseado na base legada'
	
	task :createpessoas do
		conn = PGconn.connect("localhost", 5432, '', '', "shekinah", "postgres", "caiozinho@133")
		migracao_membro = MigracaoMembro.new
		migracao_membro.load_membros_by_membro_legado(conn)
	end

end

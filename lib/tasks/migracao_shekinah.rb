=begin
require 'lib/tasks/migracao_shekinah'
migracao = MigracaoShekinah.new
migracao.migrate
=end

require 'lib/tasks/migracao_shekinah_membro'

class MigracaoShekinah

	def initialize
		@conn = PGconn.connect("localhost", 5432, '', '', "shekinah", "postgres", "caiozinho@133")
	end
	
	def migrate
		migracao_membro = MigracaoMembro.new
		migracao_membro.load_pessoas_by_membro_legado(@conn)
	end

end

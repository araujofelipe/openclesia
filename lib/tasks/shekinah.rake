require ::File.expand_path('../../../config/environment',  __FILE__)
require ::File.expand_path('../../../lib/tasks/mongodb/base',  __FILE__)
require ::File.expand_path('../../../lib/tasks/mongodb/migracaomembro',  __FILE__)

namespace :shekinah do

	desc 'cria as pessoas no mongodb'
	task :createpessoasinmongodb do
		conn = PGconn.connect("localhost", 5432, '', '', "shekinah", "postgres", "caiozinho@133")
		migracao_mongodb = MongodbTasks::MigraMembro.new
		migracao_mongodb.exec(conn)		
	end

end

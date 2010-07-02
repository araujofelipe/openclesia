require ::File.expand_path('../../../config/environment',  __FILE__)
require ::File.expand_path('../../../lib/tasks/mongodb/base',  __FILE__)
require ::File.expand_path('../../../lib/tasks/mongodb/migramembro',  __FILE__)
require ::File.expand_path('../../../lib/tasks/mongodb/migracongregacao',  __FILE__)

namespace :shekinah do

	desc 'cria as pessoas no mongodb'
	task :migra do

		conn = PGconn.connect("localhost", 5432, '', '', "shekinah", "postgres", "caiozinho@133")

		migracongregacao = MongodbTasks::MigraCongregacao.new
		migracongregacao.exec(conn)		

		migramembro = MongodbTasks::MigraMembro.new
		migramembro.exec(conn)		

	end

end

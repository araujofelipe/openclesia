ActiveRecord::Base.logger = Logger.new(STDOUT)

class Teste

  def initialize
    logger.info 'teste info'
    logger.error 'teste info'
    logger.fatal 'teste fatal'
  end
  
end
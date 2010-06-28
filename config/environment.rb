# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Openclesia::Application.initialize!

#Inflections
ActiveSupport::Inflector.inflections do |inflect|
 inflect.irregular 'congregacao', 'congregacoes'
end

class Pessoa

	include Mongoid::Document

	field :nome, :type => String
	field :nome_curto, :type => String
	field	:sexo,	:type => Boolean
	field :data_nascimento, :type => Date
	field :id_membro_legado, :type => Integer

end

class CreateCongregacoes < ActiveRecord::Migration
  
	def self.up
    create_table :congregacoes do |t|
			t.string :nome, limit => 100, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :congregacoes
  end
end

class CreateUsersTable < ActiveRecord::Migration
	def change
		create_table :users do |t| 
			t.string :username
			t.string :lat
			t.string :long
			t.string :password_digest
			t.timestamps
		end
	end
end

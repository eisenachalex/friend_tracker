class CreateUsersTable < ActiveRecord::Migration
	def change
		create_table :users do |t| 
			t.string :username
			t.string :lat 
			t.string :mobile
			t.string :long
			t.boolean :is_active, default: false
			t.string :password_digest
			t.timestamps
		end
	end
end

class AddIsActive< ActiveRecord::Migration
  class Product < ActiveRecord::Base
  end
 
  def change
    add_column :users, :is_active, :boolean, default: false

    Product.reset_column_information
    reversible do |dir|
      dir.up { Product.update_all flag: false }
    end
  end
end
class AddIsActive< ActiveRecord::Migration
  def change
    add_column :users, :is_active, :boolean, default: false

    Product.reset_column_information
    reversible do |dir|
      dir.up { Product.update_all flag: false }
    end
  end
end
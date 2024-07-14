class AddDataToMuseums < ActiveRecord::Migration[7.1]
  def change
    add_column :museums, :name, :string
    add_column :museums, :address, :string
  end
end

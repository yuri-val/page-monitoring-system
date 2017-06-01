class AddActiveToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :active, :boolean, default: true
  end
end

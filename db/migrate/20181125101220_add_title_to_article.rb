class AddTitleToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :title, :string
  end
end

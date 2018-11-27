class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.references :site, foreign_key: true
      t.references :status, foreign_key: true
      t.string :article_url
      t.references :current_version, foreign_key: { to_table: :versions }

      t.timestamps
    end
  end
end

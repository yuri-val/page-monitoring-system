class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.references :site, foreign_key: true
      t.string :article_url
      t.string :status_id
      t.references :current_version, foreign_key: true

      t.timestamps
    end
  end
end

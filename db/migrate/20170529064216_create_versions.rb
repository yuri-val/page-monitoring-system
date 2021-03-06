class CreateVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :versions do |t|
      t.references :article, foreign_key: true
      t.integer :version, limit: 8
      t.text :html_text
      t.text :plain_text

      t.timestamps
    end
  end
end

class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.string :site_url
      t.string :article_url_tmpl
      t.string :article_content_tag
      t.string :paginator_url_tmpl
      t.integer :pages_to_scan

      t.timestamps
    end
  end
end

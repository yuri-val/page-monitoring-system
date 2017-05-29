class SiteSerializer < ActiveModel::Serializer
  attributes :id, :site_url, :article_url_tmpl, :article_content_tag,
              :paginator_url_tmpl, :pages_to_scan, :articles
end

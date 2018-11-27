class SiteSerializer < ActiveModel::Serializer
  include SerializerHelpers
  attributes :id, :site_url, :article_url_tmpl, :article_content_tag,
             :paginator_url_tmpl, :pages_to_scan
  attribute :atricles_size do
    object.articles.size
  end
end

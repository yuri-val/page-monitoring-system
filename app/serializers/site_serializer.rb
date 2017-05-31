class SiteSerializer < ActiveModel::Serializer
  include SerializerHelpers
  attributes :id, :site_url, :article_url_tmpl, :article_content_tag,
              :paginator_url_tmpl, :pages_to_scan
  attribute :articles do arry_to_h(object.articles, %w(id article_url)) end
end

class ArticleSerializer < ActiveModel::Serializer
  include SerializerHelpers
  attribute :site do attrs(object.site, %w(id site_url)) end
  attributes :id, :article_url, :status_id
  attribute :current_version do attrs(object.current_version, %w(id version)) end
  attribute :versions do arry_to_h(object.versions, %w(id version)) end

end

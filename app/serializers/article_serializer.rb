class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :site, :article_url, :status_id, :current_version, :vesrions
end

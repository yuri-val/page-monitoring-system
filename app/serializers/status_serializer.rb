class StatusSerializer < ActiveModel::Serializer
  include SerializerHelpers
  attributes :id, :name
  attribute :articles do arry_to_h(object.articles, %w(id article_url)) end
end

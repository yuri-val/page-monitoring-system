class VersionSerializer < ActiveModel::Serializer
  include SerializerHelpers
  attributes :id, :version
  attribute :article do
    attrs(object.article, %w[id article_url title site_id])
  end
  attribute :html_text do
    (object.html_text || '')[0..150] + '...'
  end
  attribute :plain_text do
    (object.plain_text || '')[0..150] + '...'
  end
end

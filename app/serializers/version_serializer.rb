class VersionSerializer < ActiveModel::Serializer
  attributes :id, :article, :version
  attribute :html_text do
    object.html_text[0..150] + "..."
  end
  attribute :plain_text do
    object.plain_text[0..150] + "..."
  end
end

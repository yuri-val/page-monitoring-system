class VersionSerializer < ActiveModel::Serializer
  attributes :id, :article, :vesrion, :html_text, :plain_text
end

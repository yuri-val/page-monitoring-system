class VersionSerializer < ActiveModel::Serializer
  attributes :id, :article, :version, :html_text, :plain_text
end

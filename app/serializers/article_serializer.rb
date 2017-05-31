class ArticleSerializer < ActiveModel::Serializer
  attribute :site do attrs(object.site, %w(id site_url)) end
  attributes :id, :article_url, :status_id
  attribute :current_version do version_to_h(object.current_version) end
  attribute :versions do versions_to_h(object.versions) end

  def versions_to_h(vers)
    data = []
    vers.each do |ver|
      data << version_to_h(ver)
    end
    data
  end

  def version_to_h(ver)
    ver.nil? ? {} : VersionSerializer.new(ver, {})
  end

  def attrs(obj, fields)
    data = {}
    return data if obj.nil?
    fields.each do |fld|
      data[fld] = obj[fld.to_sym]
    end
    data
  end

end

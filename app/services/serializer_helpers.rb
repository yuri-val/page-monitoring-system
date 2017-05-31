module SerializerHelpers
  def arry_to_h(arry, flds)
    data = []
    arry.each do |ver|
      data << attrs(ver, flds)
    end
    data
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

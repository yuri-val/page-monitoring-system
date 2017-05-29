class Article < ApplicationRecord
  belongs_to :site
  belongs_to :current_version
  has_many :versions

  def deleted!
    status = Status.find_or_create_by(name: "Deleted")
    save
  end
end

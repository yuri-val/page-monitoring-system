class Article < ApplicationRecord
  belongs_to :site
  belongs_to :current_version
  has_many :versions
end

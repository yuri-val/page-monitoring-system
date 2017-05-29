class Article < ApplicationRecord
  belongs_to :site
  belongs_to :current_version
end

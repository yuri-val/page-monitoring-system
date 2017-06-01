class Site < ApplicationRecord
  has_many :articles

  scope :active, -> { where(active: true) }
end

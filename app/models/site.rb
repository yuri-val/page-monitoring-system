class Site < ApplicationRecord
  has_many :articles, dependent: :destroy

  scope :active, -> { where(active: true) }
end

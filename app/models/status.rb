class Status < ApplicationRecord
  has_many :articles, dependent: :destroy
end

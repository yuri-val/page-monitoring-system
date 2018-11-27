class Version < ApplicationRecord
  belongs_to :article

  scope :by_params, ->(params) do
    allowed_params = %(id, article_id)
    cond = {}
    params.each_pair do |k, v|
      cond[k] = v if allowed_params.include?(k)
    end
    where(cond)
  end
end

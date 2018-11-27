class Article < ApplicationRecord
  belongs_to :site
  belongs_to :status
  belongs_to :current_version, class_name: 'Version'
  has_many :versions, dependent: :destroy

  validates :current_version, presence: true, allow_nil: true

  scope :by_params, ->(params) do
    allowed_params = %(id, site_id, status_id)
    cond = {}
    params.each_pair do |k, v|
      cond[k] = v if allowed_params.include?(k)
    end
    where(cond)
  end

  scope :changed, -> { joins(:versions).group('articles.id').having('SUM(1) > 1') }

  def deleted!
    status = Status.find_or_create_by(name: 'Deleted')
    save
  end
end

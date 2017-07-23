class JefitActivityDate < ActiveRecord::Base
  validates :active_on, presence: true, uniqueness: true
end

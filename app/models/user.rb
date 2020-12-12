class User < ActiveRecord::Base
  validates :email, uniqueness: true

  def full_name
    "#{first_name} #{last_name}".strip
  end
end

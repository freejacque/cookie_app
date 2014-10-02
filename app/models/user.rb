class User < ActiveRecord::Base
  belongs_to :favorite_recipe, class_name: "Recipe"

  validates :name, :role, :email, presence: true
  validates :email, uniqueness: true

  has_secure_password

  # here is are helpers to check user roles...
  #
  def is_admin?
     (self.role =~ /patissier/) == 0 ? true : false
  end

  def is_baker?
    self.role == 'baker'
  end
end

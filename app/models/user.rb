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

  # define a comparator method for sorting...
  #
  def <=>(other)
    if self.role != other.role # sort by role
      self.role_value <=> other.role_value
    else # sort by name
      self.name <=> other.name
    end
  end

  def role_value
    case self.role
    when 'patissiere' then 3
    when 'baker'      then 2
    when 'customer'   then 1
    else 0; end
  end
end

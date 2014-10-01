class User < ActiveRecord::Base
  belongs_to :favorite_recipe, class_name: "Recipe"
  validates :name, :role, :email, presence: true
  validates :email, uniqueness: true

  has_secure_password
end

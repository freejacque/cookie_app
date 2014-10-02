require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should belong_to(:favorite_recipe) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:role) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }

  describe "role helpers" do
    describe "#is_admin?" do
      it "is true when the user has a role of 'patissiere'" do
        user = User.create(name: "PJ", email: "pj@ga.co", role: "patissiere", password: "12345")
        expect(user.is_admin?).to eq(true)
      end
      it "is false when the user doesn't have a role of 'patissiere'" do
        user = User.create(name: "PJ", email: "pj@ga.co", role: "baker", password: "12345")
        expect(user.is_admin?).to eq(false)
      end
    end

    describe "#is_baker?" do
      it "is true when the user has a role of 'baker'" do
        user = User.create(name: "PJ", email: "pj@ga.co", role: "baker", password: "12345")
        expect(user.is_baker?).to eq(true)
      end
      it "is false when the user doesn't have a role of 'baker'" do
        user = User.create(name: "PJ", email: "pj@ga.co", role: "patissiere", password: "12345")
        expect(user.is_baker?).to eq(false)
      end
    end
  end
end

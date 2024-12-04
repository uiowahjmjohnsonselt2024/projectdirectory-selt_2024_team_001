require 'spec_helper'
require 'rails_helper'

RSpec.describe User, type: :model do
  # Factory setup
  let(:user) { build(:user) }

  # Validations
  describe "Validations" do
    context "email validations" do
      it "is valid with a valid email" do
        expect(user).to be_valid
      end

      it "is invalid without an email" do
        user.email = nil
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "is invalid with a duplicate email" do
        create(:user, email: "duplicate@example.com")
        user.email = "duplicate@example.com"
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("has already been taken")
      end

      it "is invalid with an improperly formatted email" do
        user.email = "invalid_email"
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    context "password validations" do
      it "is invalid without a password" do
        user.password = nil
        user.password_confirmation = nil
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end

      it "is invalid if password and password_confirmation do not match" do
        user.password = "Password123!"
        user.password_confirmation = "Mismatch123!"
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end

      it "is invalid with a weak password" do
        user.password = "weakpass"
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and one special character")
      end

      it "is valid with a strong password" do
        user.password = "Password123!"
        user.password_confirmation = "Password123!"
        expect(user).to be_valid
      end
    end
  end

  # Callbacks
  describe "Callbacks" do
    it "downcases the email before saving" do
      user = create(:user, email: "TEST@EXAMPLE.COM")
      expect(user.email).to eq("test@example.com")
    end
  end

  # Instance Methods
  describe "#unlocked_achievement?" do
    let(:achievement) { Achievement.create!(name: "First Login", user: user) }

    before { user.save }

    it "returns true if the user has unlocked the achievement" do
      achievement
      expect(user.unlocked_achievement?("First Login")).to be true
    end

    it "returns false if the user has not unlocked the achievement" do
      expect(user.unlocked_achievement?("Nonexistent Achievement")).to be false
    end
  end

  describe "#list_achievements" do
    let!(:achievement1) { Achievement.create!(name: "First Login", unlocked_at: 2.days.ago, user: user) }
    let!(:achievement2) { Achievement.create!(name: "First Post", unlocked_at: 1.day.ago, user: user) }

    before { user.save }

    it "returns achievements ordered by unlocked_at descending" do
      expect(user.list_achievements).to eq([achievement2, achievement1])
    end
  end

  # Class Methods
  describe ".authenticate" do
    let!(:user) { create(:user, email: "test@example.com", password: "Password123!") }

    it "returns the user with valid credentials" do
      expect(User.authenticate("test@example.com", "Password123!")).to eq(user)
    end

    it "returns false if password is wrong with invalid credentials" do
      expect(User.authenticate("test@example.com", "WrongPassword")).to be_falsey
    end

    it "returns nil if the email does not exist" do
      expect(User.authenticate("nonexistent@example.com", "Password123!")).to be_nil
    end
  end

  # Default Values
  describe "Default Values" do
    it "sets default shards to 0" do
      user = create(:user)
      expect(user.shards).to eq(0)
    end

    it "sets default money to 0.0" do
      user = create(:user)
      expect(user.money).to eq(0.0)
    end
  end

  # Password Complexity Validation
  describe "Password Complexity Validation" do
    it "is invalid if password lacks a digit" do
      user.password = "Password!"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and one special character")
    end

    it "is invalid if password lacks an uppercase letter" do
      user.password = "password123!"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and one special character")
    end

    it "is invalid if password lacks a lowercase letter" do
      user.password = "PASSWORD123!"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and one special character")
    end

    it "is invalid if password lacks a special character" do
      user.password = "Password123"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, one digit, and one special character")
    end
  end
end

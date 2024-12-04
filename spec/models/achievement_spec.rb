require 'spec_helper'
require 'rails_helper'

RSpec.describe Achievement, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "Password123!") }

  describe "validations" do
    it "is valid with a unique name and a user" do
      achievement = Achievement.new(name: "First Login", user: user)
      expect(achievement).to be_valid
    end

    it "is not valid without a name" do
      achievement = Achievement.new(name: nil, user: user)
      expect(achievement).not_to be_valid
    end

    it "is not valid with a duplicate name for the same user" do
      Achievement.create!(name: "First Login", user: user)
      duplicate_achievement = Achievement.new(name: "First Login", user: user)
      expect(duplicate_achievement).not_to be_valid
    end

    it "is valid with the same name for different users" do
      other_user = User.create!(email: "other@example.com", password: "Password123!")
      Achievement.create!(name: "First Login", user: user)
      achievement = Achievement.new(name: "First Login", user: other_user)
      expect(achievement).to be_valid
    end
  end

  describe ".unlock_for_user" do
    it "creates a new achievement if it doesn't exist for the user" do
      achievement = Achievement.unlock_for_user(user, "First Login", "Log in for the first time")
      expect(achievement).to be_persisted
      expect(achievement.name).to eq("First Login")
      expect(achievement.description).to eq("Log in for the first time")
      expect(achievement.unlocked_at).not_to be_nil
    end

    it "does not create a duplicate achievement if one already exists" do
      Achievement.create!(name: "First Login", user: user)
      expect {
        Achievement.unlock_for_user(user, "First Login", "Log in for the first time")
      }.not_to change { Achievement.count }
    end

    it "updates the description and unlocked_at if a new achievement is created" do
      achievement = Achievement.unlock_for_user(user, "New Achievement", "Initial description")
      expect(achievement.description).to eq("Initial description")
      expect(achievement.unlocked_at).not_to be_nil
    end
  end
end

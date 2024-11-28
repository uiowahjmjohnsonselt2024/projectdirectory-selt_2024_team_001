require 'spec_helper'
require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(
      username: "john@gmail.com",
      email: "test@example.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      shards: 100,
      money: 2500.75
    )
  }

  # Validations
  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it "is not valid with a duplicate email" do
      described_class.create!(
        username: "another_user",
        email: subject.email,
        password: "Password123!",
        password_confirmation: "Password123!"
      )
      expect(subject).not_to be_valid
    end

    it "is not valid with an improperly formatted email" do
      subject.email = "invalidemail"
      expect(subject).not_to be_valid
    end

    it "is not valid with a short password" do
      subject.password = "short"
      subject.password_confirmation = "short"
      expect(subject).not_to be_valid
    end

    it "is not valid without a complex password" do
      subject.password = "password"
      subject.password_confirmation = "password"
      expect(subject).not_to be_valid
    end
  end

  # Callbacks
  describe "callbacks" do
    it "downcases the email before saving" do
      subject.email = "TEST@EXAMPLE.COM"
      subject.save
      expect(subject.email).to eq("test@example.com")
    end
  end

  # Instance Methods
  describe "#unlocked_achievement?" do
    let(:achievement) { Achievement.create!(name: "First Login", user: subject) }

    before { subject.save }

    it "returns true if the user has unlocked the achievement" do
      achievement
      expect(subject.unlocked_achievement?("First Login")).to be true
    end

    it "returns false if the user has not unlocked the achievement" do
      expect(subject.unlocked_achievement?("Nonexistent Achievement")).to be false
    end
  end

  describe "#list_achievements" do
    let!(:achievement1) { Achievement.create!(name: "First Login", unlocked_at: 2.days.ago, user: subject) }
    let!(:achievement2) { Achievement.create!(name: "First Post", unlocked_at: 1.day.ago, user: subject) }

    before { subject.save }

    it "returns achievements ordered by unlocked_at descending" do
      expect(subject.list_achievements).to eq([achievement2, achievement1])
    end
  end
end

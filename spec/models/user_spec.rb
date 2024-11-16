# spec/models/user_spec.rb
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

  # Class Methods
  describe ".authenticate" do
    it "authenticates a user with correct credentials" do
      subject.save
      expect(User.authenticate(subject.email, subject.password)).to eq(subject)
    end

    it "does not authenticate with incorrect credentials" do
      subject.save
      expect(User.authenticate(subject.email, "wrongpassword")).to be_falsey
    end
  end
end

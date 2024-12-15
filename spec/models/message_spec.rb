require 'rails_helper'
require 'spec_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:server) { create(:server) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:server) }
  end

  describe 'callbacks' do
    it 'broadcasts append to server after create' do
      message = build(:message, user: user, server: server)

      # Mocking broadcast_append_to
      allow(message).to receive(:broadcast_append_to).with(server)

      message.save!
      expect(message).to have_received(:broadcast_append_to).with(server)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      message = build(:message, user: user, server: server)
      expect(message).to be_valid
    end

    it 'is invalid without a user' do
      message = build(:message, user: nil, server: server)
      expect(message).not_to be_valid
    end

    it 'is invalid without a server' do
      message = build(:message, user: user, server: nil)
      expect(message).not_to be_valid
    end
  end
end
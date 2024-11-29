require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  let(:user) { create(:user, shards: 0) }

  before do
    # Simulate a logged-in user
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    context "with valid parameters and successful payment" do
      before do
        allow(Stripe::Token).to receive(:create).and_return(OpenStruct.new(id: 'tok_visa'))
        allow(Stripe::Charge).to receive(:create).and_return(OpenStruct.new(paid: true, receipt_url: 'http://example.com/receipt'))
      end

      it "increases the user shard balance" do
        post :create, params: { amount: 10.0, card_number: '4242424242424242', month: '12', year: '2025', cvc: '123' }
        expect(user.reload.shards).to eq(13) # Assuming shard calculation is amount / 0.75
        expect(flash[:notice]).to include('Your payment for')
        expect(response).to redirect_to('main_game_screen')
      end
    end

    context "with valid parameters but failed payment" do
      before do
        allow(Stripe::Token).to receive(:create).and_return(OpenStruct.new(id: 'tok_visa'))
        allow(Stripe::Charge).to receive(:create).and_return(OpenStruct.new(paid: false))
      end

      it "does not increase the user shard balance" do
        post :create, params: { amount: 10.0, card_number: '4242424242424242', month: '12', year: '2025', cvc: '123' }
        expect(user.reload.shards).to eq(0)
        expect(flash[:alert]).to eq('We are sorry. We are unable to proceed with your request. Please try again later.')
        expect(response).to redirect_to('main_game_screen')
      end
    end

    context "when Stripe raises an exception" do
      before do
        allow(Stripe::Token).to receive(:create).and_raise(Stripe::CardError.new('Card declined', nil, nil))
      end

      it "displays an error message" do
        post :create, params: { amount: 10.0, card_number: '4242424242424242', month: '12', year: '2025', cvc: '123' }
        expect(flash[:alert]).to eq('Card declined')
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "raises an error if amount is less than or equal to zero" do
        expect {
          post :create, params: { amount: 0, card_number: '4242424242424242', month: '12', year: '2025', cvc: '123' }
        }.to raise_error(ArgumentError, 'Amount must be greater than 0')
      end
    end
  end
end

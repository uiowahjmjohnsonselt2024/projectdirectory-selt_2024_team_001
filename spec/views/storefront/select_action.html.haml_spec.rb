require 'rails_helper'

RSpec.describe "storefront/select_action.html.haml", type: :view do
  before do
    # Mock the session variable for the "Back to Game" link
    allow(view).to receive(:session).and_return({ return_to: "/game" })
    render
  end

  it "displays the store title" do
    expect(rendered).to have_selector("h1", text: "Welcome to the Store!")
  end

  it "has a 'Buy' button with the correct link" do
    expect(rendered).to have_link("Buy", href: "/storefront/store_menu")
  end

  it "has a 'Trade' button with the correct link" do
    expect(rendered).to have_link("Trade", href: "/storefront/trade")
  end

  it "has an 'API Test' button with the correct link" do
    expect(rendered).to have_link("API Test", href: "/storefront/api_test")
  end

  it "has a 'Back to Game' button with the correct link" do
    expect(rendered).to have_link("Back to Game", href: "/game")
  end
end

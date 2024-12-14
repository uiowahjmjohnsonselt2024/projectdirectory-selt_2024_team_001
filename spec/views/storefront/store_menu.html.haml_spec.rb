require 'rails_helper'

RSpec.describe "storefront/store_menu.html.haml", type: :view do
  before do
    assign(:gold, 100)
  end

  it "has a back link to select action" do
    render
    expect(rendered).to have_link("← Back", href: "/storefront/select_action")
  end

  it "displays the search form with an input and a search button" do
    render
    expect(rendered).to have_selector("form[action='/storefront/store_menu'][method='get']")
    expect(rendered).to have_selector("input[type='text'][name='search']")
    expect(rendered).to have_button("Search")
  end

  it "displays the current gold amount" do
    render
    expect(rendered).to have_selector("#gold-amount", text: "100")
  end

  it "has sections for Ships, Modules, Crew, and Consumables" do
    render
    expect(rendered).to have_link("Ships", href: "/storefront/ships")
    expect(rendered).to have_link("Modules", href: "/storefront/modules")
    expect(rendered).to have_link("Crew", href: "/storefront/crew")
    expect(rendered).to have_link("Consumables", href: "/storefront/consumables")
  end

  context "when search results are present" do
    before do
      assign(:filtered_items, [
        { title: "Laser Cannon", description: "High-powered weapon.", cost: 50 }
      ])
      params[:search] = "Laser"
    end

    it "displays filtered items" do
      render
      expect(rendered).to have_selector(".item-box")
      expect(rendered).to have_content("Laser Cannon")
      expect(rendered).to have_content("High-powered weapon.")
      expect(rendered).to have_content("Cost: 50 Gold")
    end
  end

  context "when no search results are present" do
    before do
      assign(:filtered_items, [])
      params[:search] = "NonExistentItem"
    end

    it "displays 'No results found'" do
      render
      expect(rendered).to have_content("No results found.")
    end
  end
end

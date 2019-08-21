require 'rails_helper'

RSpec.describe "As a Visitor" do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @cart = Cart.new({})
  end

  it "see all items that I have added to my cart with item info" do
    visit "/items/#{@tire.id}"

    within "#item-info" do
      click_on "Add to Cart"
      @cart.add_item(@tire.id)
    end

    visit "/items/#{@pull_toy.id}"

    within "#item-info" do
      click_on "Add to Cart"
      @cart.add_item(@pull_toy.id)
    end

    visit "/items/#{@pull_toy.id}"

    within "#item-info" do
      click_on "Add to Cart"
      @cart.add_item(@pull_toy.id)
    end

    visit "/cart"

    quantity_tire = @cart.quantity_of(@tire.id)
    quantity_pulltoy = @cart.quantity_of(@pull_toy.id)

    subtotal_tire = @tire.price * quantity_tire
    subtotal_pulltoy = @pull_toy.price * quantity_pulltoy
    grand_total = subtotal_tire + subtotal_pulltoy

    # save_and_open_page

    expect(page).to have_content(@tire.name)
    expect(page).to have_css("img[src*='#{@tire.image}']")
    expect(page).to have_content("Sold by: #{@tire.merchant.name}")
    expect(page).to have_content("Price: $#{@tire.price}")
    expect(page).to have_content("Quantity: #{quantity_tire}")
    expect(page).to have_content("Subtotal: $#{subtotal_tire}")

    expect(page).to have_content(@pull_toy.name)
    expect(page).to have_css("img[src*='#{@pull_toy.image}']")
    expect(page).to have_content("Sold by: #{@pull_toy.merchant.name}")
    expect(page).to have_content("Price: $#{@pull_toy.price}")
    expect(page).to have_content("Quantity: #{quantity_pulltoy}")
    expect(page).to have_content("Subtotal: $#{subtotal_pulltoy}")

    expect(page).to have_content("Grand Total: $#{grand_total}")
  end

end
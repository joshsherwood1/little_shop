require 'rails_helper'

RSpec.describe 'item show page', type: :feature do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @active_items = [@tire, @pull_toy]
    @inactive_items = [@dog_bone]
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @good_review = @chain.reviews.create(title: "I like this product", content: "This is a great product. I will buy it again soon.", rating: 5)
    @negative_review = @chain.reviews.create(title: "I don't like this product", content: "This is not a great product. I will not buy it again soon.", rating: 2)
  end

  it 'shows item info' do

    visit "items/#{@chain.id}"

    expect(page).to have_link(@chain.merchant.name)
    expect(page).to have_content(@chain.name)
    expect(page).to have_content(@chain.description)
    expect(page).to have_content("Price: $#{@chain.price}")
    expect(page).to have_content("Active")
    expect(page).to have_content("Inventory: #{@chain.inventory}")
    expect(page).to have_content("Sold by: #{@bike_shop.name}")
    expect(page).to have_css("img[src*='#{@chain.image}']")
  end

  it 'shows reviews for an item' do

    visit "items/#{@chain.id}"

    within "#review-#{@good_review.id}" do
      expect(page).to have_content(@good_review.title)
      expect(page).to have_content(@good_review.content)
      expect(page).to have_content(@good_review.rating)
    end
  end

  it 'shows link to add a new review for item and shows flash messages' do
    visit "/items/#{@chain.id}"
    click_link "add new review"

    expect(current_path).to eq("/items/#{@chain.id}/review/new")

    title = "So-so product"
    content = "This product was very, very average"
    rating = 3

    fill_in :title, with: title
    fill_in :content, with: content
    fill_in :rating, with: rating

    click_button "Post Review"

    expect(current_path).to eq("/items/#{@chain.id}")
    expect(page).to have_content("You have successfully posted a review")
    save_and_open_page


    within "#review-#{Review.last.id}" do
      expect(page).to have_content(title)
      expect(page).to have_content(content)
      expect(page).to have_content("Rating: #{rating}")
    end
  end

  it 'shows alert flash messages when form is not completely filled' do
    visit "/items/#{@chain.id}"
    click_link "add new review"

    expect(current_path).to eq("/items/#{@chain.id}/review/new")

    title = "So-so product"

    fill_in :title, with: title

    click_button "Post Review"

    expect(current_path).to eq("/items/#{@chain.id}/review/new")
    expect(page).to have_content("You have not completed the form. Please complete all three sections to post a review.")
    save_and_open_page
  end

  it 'shows review stats' do
    visit "/items/#{@chain.id}"

    within "#item-#{@chain.id}-review-stats" do
      expect(page).to have_content("Average Rating: #{@chain.reviews.average(:rating)}")
    end
  end
end

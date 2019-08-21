class Review < ApplicationRecord
  belongs_to :item

  validates_presence_of :title,
                        :content,
                        :rating

  def self.average_review_rating
    average(:rating)
  end

  def self.top_three_reviews
    order(:rating).reverse[0..2].pluck(:title, :rating)
  end

  def self.bottom_three_reviews
    order(:rating)[0..2].pluck(:title, :rating)
  end
end

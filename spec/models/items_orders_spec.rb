require 'rails_helper'

RSpec.describe ItemsOrder do
  describe 'relationship' do
    it {should belong_to :item}
    it {should belong_to :order}
  end
end

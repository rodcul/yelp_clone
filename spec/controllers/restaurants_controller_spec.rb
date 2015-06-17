require 'rails_helper'

describe RestaurantsController do
  describe "Test Restaurants" do
    it 'Responds 200' do
      get :index
      (expect(response.status).to eq(200))
    end
  end

end

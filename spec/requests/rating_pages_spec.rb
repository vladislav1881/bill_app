require 'spec_helper'

describe "rating pages" do
  
  subject { page }

  describe "index" do 

    let(:user) { FactoryGirl.create(:user) }
    let!(:r) { FactoryGirl.create(:rating) }

    before do
      sign_in user
      visit ratings_path 
    end

    it { should have_title "Rating" }
    it { should have_content "Rating" }
    it { should have_content(r.rate) }
  end
end

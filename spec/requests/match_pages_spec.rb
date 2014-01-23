require 'spec_helper'

describe "Match pages" do 
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do 
  	sign_in user
    visit matches_path
  end

  describe "showing all matches" do

    it { should have_content('Matches') }
    it { should have_title('Matches') }
  end  

  describe "creating new match" do
    let(:submit) { "Save" }
    
    before { click_link "Create New Match" }

    describe "opening form for filling in" do
      
      it { should have_content("Invited") }

      xit { should_not have_link "Create New Match"}
    end

    describe "creating new match with invalid data" do
      it "should not create match" do
        expect { click_button submit }.not_to change(Match, :count)
      end
    end

    describe "creating new match with valid data" do
      before do
        select "planned",     from: "Status"
        fill_in "Wins",       with: 5
        fill_in "Loses",      with: 5  
      end 

      it "should create new match" do
      	pending
        expect { click_button submit }.to change(Match, :count)
      end
    end
  end
end
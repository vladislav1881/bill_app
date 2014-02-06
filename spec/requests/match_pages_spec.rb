require 'spec_helper'

describe "Match pages" do 
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }


  before do 
  	sign_in user
    visit matches_path
    user.follow!(other_user)
  end

  describe "showing all matches" do

    it { should have_content('Matches') }
    it { should have_title('Matches') }
  end  

  describe "creating new match" do

    before { click_link "Create New Match" } 
    it { should have_title('New Match') }
    it { should have_content('New Match') }
    it { should have_select('match_status') }
    it { should have_select('match_invited_id') }
    it { should have_css('select#match_invited_id option', text: other_user.name) }
    it { should_not have_css('select#match_invited_id option', text: another_user.name) }



    let(:submit) { "Save" }

    describe "with invalid data" do
      before { select "finished",           from: "match_status" }
      it "should not create a match" do 
        expect { click_button submit }.not_to change(Match, :count)
      end
    end

    describe "with valid data" do 
       before do
        puts page.body
        select other_user.name,        from: "match_invited_id"
        select "finished",           from: "match_status"
        fill_in "match_wins",       with: 5
        fill_in "match_loses",      with: 5  
      end 

      it "should create new match" do
        expect { click_button submit }.to change(Match, :count)
      end
    end
  end
=begin
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
        expect { click_button submit }.to change(Match, :count)
      end
    end
  end
=end
end
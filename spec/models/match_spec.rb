require 'spec_helper'

describe Match do
  before { @match = Match.new(initiator_id: 1, invited_id: 2, status: "finished", wins: 5, loses: 4) }
  
  subject { @match }

  it { should respond_to(:initiator_id) }
  it { should respond_to(:invited_id) }
  it { should respond_to(:status) }
  it { should respond_to(:wins) }
  it { should respond_to(:loses) }

  # check that user is initially valid
  it { should be_valid }

  describe "when initiator_id is not present" do
    before { @match.initiator_id = " " }
    it { should_not be_valid }
  end

  describe "when invited_id is not present" do
    before { @match.invited_id = " " }
    it { should_not be_valid }
  end

  describe "when status is not present" do
    before { @match.status = " " }
    it { should_not be_valid }
  end

  # finished matches always should have wins and loses
  describe "when match is finished score is required" do
    before { @match.status = "finished" }
      describe "wins are empty" do
        before do
          @match.wins = " " 
          @match.loses = "5"
        end

        it { should_not be_valid }
      end

      describe "loses are empty" do
      	before do 
      	  @match.wins = "5" 
          @match.loses = " " 
        end

        it { should_not be_valid }
      end

      describe "wins and loses are empty" do
      	before do
      	  @match.wins = " " 
          @match.loses = " " 
        end
        it { should_not be_valid }
      end
  end

  describe "when match is not finished score is not required" do
    before do
      @match.status = "planned" 
      @match.wins = " " 
      @match.loses = " "
    end

    it { should be_valid }
  end

  describe "when wins too long" do
    before { @match.wins = "1" * 3 }
    it { should_not be_valid}
  end

  describe "when loses too long" do
    before { @match.loses = "1" * 3 }
    it { should_not be_valid}
  end

  describe "#games" do
    let!(:initiator) { FactoryGirl.create(:user) }
    let!(:invited) { FactoryGirl.create(:user) }
    let!(:match) { FactoryGirl.create(:match, initiator: initiator, invited: invited) }

    it "returns 0 if not games played" do
      expect(match.games).to eq(0)
    end
  
  end

  context "[rating]" do
    let!(:initiator) { FactoryGirl.create(:user) }
    let!(:invited) { FactoryGirl.create(:user) }
    let!(:match) { FactoryGirl.create(:match, initiator: initiator, invited: invited) }

    describe "#save" do
      it "doesn't change robustness if match is not finished" do
        match.save
        expect(match.initiator.robustness).to eq(0)
        expect(match.invited.robustness).to eq(0)
      end

      it "doesn't change robustness if match is not finished" do
        match.save
        expect(match.initiator.rating).to eq(0)
        expect(match.invited.rating).to eq(0)
      end

      it "increases robustnesses by played games after match was finished" do
        match.status = 'finished'
        match.wins = 3
        match.loses = 1
        match.save

        expect(match.initiator(true).robustness).to eq(4)
        expect(match.invited(true).robustness).to eq(4)
      end

       it "changes ratings according the Formulae after match was finished" do
        match.status = 'finished'
        match.wins = 3
        match.loses = 1
        match.save

        expect(match.initiator(true).rating).to eq(468)
        expect(match.invited(true).rating).to eq(432)
      end

      it "changes ratings according the Formulae after match was finished" do
        match.initiator.rating = 550
        match.initiator.robustness = 50

        match.invited.rating = 450
        match.invited.robustness = 30

        match.status = 'finished'
        match.wins = 3
        match.loses = 1
        match.save

        expect(match.initiator(true).rating).to eq(553)
        expect(match.invited(true).rating).to eq(444)
      end
      
    end
  end
end

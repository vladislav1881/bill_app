require 'spec_helper'

describe "clubs/edit" do
  before(:each) do
    @club = assign(:club, stub_model(Club,
      :name => "MyString",
      :address => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit club form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", club_path(@club), "post" do
      assert_select "input#club_name[name=?]", "club[name]"
      assert_select "input#club_address[name=?]", "club[address]"
      assert_select "input#club_description[name=?]", "club[description]"
    end
  end
end

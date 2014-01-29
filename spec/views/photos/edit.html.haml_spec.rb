require 'spec_helper'

describe "photos/edit" do
  before(:each) do
    @photo = assign(:photo, stub_model(Photo,
      :description => "MyText",
      :user => nil,
      :micropost => nil
    ))
  end

  it "renders the edit photo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", photo_path(@photo), "post" do
      assert_select "textarea#photo_description[name=?]", "photo[description]"
      assert_select "input#photo_user[name=?]", "photo[user]"
      assert_select "input#photo_micropost[name=?]", "photo[micropost]"
    end
  end
end

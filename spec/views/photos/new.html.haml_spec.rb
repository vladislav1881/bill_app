require 'spec_helper'

describe "photos/new" do
  before(:each) do
    assign(:photo, stub_model(Photo,
      :description => "MyText",
      :user => nil,
      :micropost => nil
    ).as_new_record)
  end

  it "renders new photo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", photos_path, "post" do
      assert_select "textarea#photo_description[name=?]", "photo[description]"
      assert_select "input#photo_user[name=?]", "photo[user]"
      assert_select "input#photo_micropost[name=?]", "photo[micropost]"
    end
  end
end

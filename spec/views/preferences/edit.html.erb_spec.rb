require 'rails_helper'

RSpec.describe "preferences/edit", type: :view do
  before(:each) do
    @preference = assign(:preference, Preference.create!(
      :setting => "MyString",
      :value => "MyString"
    ))
  end

  it "renders the edit preference form" do
    render

    assert_select "form[action=?][method=?]", preference_path(@preference), "post" do

      assert_select "input#preference_setting[name=?]", "preference[setting]"

      assert_select "input#preference_value[name=?]", "preference[value]"
    end
  end
end

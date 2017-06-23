require 'rails_helper'

RSpec.describe "preferences/new", type: :view do
  before(:each) do
    assign(:preference, Preference.new(
      :setting => "MyString",
      :value => "MyString"
    ))
  end

  it "renders new preference form" do
    render

    assert_select "form[action=?][method=?]", preferences_path, "post" do

      assert_select "input#preference_setting[name=?]", "preference[setting]"

      assert_select "input#preference_value[name=?]", "preference[value]"
    end
  end
end

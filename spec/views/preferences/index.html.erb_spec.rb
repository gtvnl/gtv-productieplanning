require 'rails_helper'

RSpec.describe "preferences/index", type: :view do
  before(:each) do
    assign(:preferences, [
      Preference.create!(
        :setting => "Setting",
        :value => "Value"
      ),
      Preference.create!(
        :setting => "Setting",
        :value => "Value"
      )
    ])
  end

  it "renders a list of preferences" do
    render
    assert_select "tr>td", :text => "Setting".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end

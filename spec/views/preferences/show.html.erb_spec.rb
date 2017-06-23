require 'rails_helper'

RSpec.describe "preferences/show", type: :view do
  before(:each) do
    @preference = assign(:preference, Preference.create!(
      :setting => "Setting",
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Setting/)
    expect(rendered).to match(/Value/)
  end
end

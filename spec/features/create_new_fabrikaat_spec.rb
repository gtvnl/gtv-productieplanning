require 'rails_helper'

feature "Fabrikaat" do

  scenario "Create new fabrikaat" do
    visit fabrikaten_path

    click_link "new"

    fill_in "Naam", with: "Legrand"

    click_button("create")

    expect(page).to have_content "Fabrikaat aangemaakt"
  end

  scenario "Create new systeem" do
    fabrikaat = create(:fabrikaat)

    visit new_fabrikaat_systeem_path(fabrikaat)

    click_link "new"

    fill_in "Naam", with: "XL3 4000"

    click_button("create")

    expect(page).to have_content "Systeem aangemaakt"

  end

end

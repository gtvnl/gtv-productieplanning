crumb :root do
  link "home", root_path
end

# Calculaties
crumb :calculaties do
  link "calculaties", calculaties_path
end

crumb :new_calculatie do
  parent :calculaties
  link 'nieuwe calculatie'
end

crumb :calculatie do |calculatie|
  if params[:calculatie_id].present?
    @calculatie = Calculatie.find(params[:calculatie_id])
  else
    @calculatie = calculatie
  end
  parent :calculaties
  link @calculatie.number, edit_calculatie_path(@calculatie)
end

crumb :posities do
  parent :calculatie
  link "posities", calculatie_posities_path
end

crumb :positie do |positie|
  if params[:calculatie_id].present?
    @calculatie = Calculatie.find(params[:calculatie_id])
  else
    @calculatie = calculatie
  end
  parent :posities
  link positie.number, edit_calculatie_positie_path(@calculatie, positie)
end

crumb :fabrikaten do
  link "alle fabrikaten", fabrikaten_path
end

crumb :new_fabrikaat do
  parent :fabrikaten
  link 'nieuw fabrikaat'
end

crumb :systemen do
  link "alle systemen", all_systemen_path
end

crumb :ip_waardes do
  link "alle IP-waardes", calculaties_path
end

crumb :kleuren do
  link "alle kleuren", calculaties_path
end

crumb :offertes do
  link "alle offertes", offertes_path
end

crumb :new_offerte do
  parent :offertes
  link "nieuwe offerte"
end


# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).

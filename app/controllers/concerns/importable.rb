require 'action_view'
include ActionView::Helpers::DateHelper


module Concerns
  module Importable
  extend ActiveSupport::Concern

  included do

    def import
      @spreadsheet = read_file(params[:file])
    end

      private
        def read_file(file)
          @spreadsheet = open_spreadsheet(file)
        end

        def open_spreadsheet(file)
          begin
            case File.extname(file.path)
              when ".csv" then open_csv(file)
              when ".xls" then open_xls(file)
              when ".xlsx" then open_xlsx(file)
              else unknown_file_type(file)
            end
          rescue
            redirect_to calculaties_url
          end
        end

        def unknown_file_type(file)
          flash[:error] = "#{File.extname(file.path)} niet ondersteund."
          redirect_to calculaties_url
        end

        def open_csv(file)
          # CSV.new(file.path, nil, :ignore)
          flash[:error] = ".csv niet ondersteund."
          redirect_to calculaties_url
        end

        def open_xls(file)
          # Roo::Excel.open(file.path, nil, :ignore)
          flash[:error] = ".xls niet ondersteund."
          redirect_to calculaties_url
        end

        def open_xlsx(file)
          calculatie = Roo::Spreadsheet.open(file.path, extension: :xlsx)
          detect_fabrikaat(calculatie)
        end

        def detect_fabrikaat(calculatie)

          # Check for Hagercad
          if calculatie.first_column  == 1                               &&
            calculatie.last_column   == 7                                &&
            calculatie.cell(1,1)     == "Projectnaam"                    &&
            calculatie.cell(2,1)     == "Omschrijving"                   &&
            calculatie.cell(3,1)     == "Ordernummer"                    &&
            calculatie.cell(4,1)     == "Projectnummer"                  &&
            calculatie.cell(5,1)     == "Locatienaam"                    &&
            calculatie.cell(6,1)     == "Plaats"                         &&
            calculatie.cell(7,1)     == "Status"                         &&
            calculatie.cell(8,1)     == "Invoerdatum"                    &&
            calculatie.cell(9,1)     == "Datum laatste wijzigingen"      &&
            calculatie.cell(10,1)    == "Commercieel verantwoordelijk"   &&
            calculatie.cell(11,1)    == "Technisch verantwoordelijk"

            import_hagercad(calculatie)

          # File format unknown
          else
            flash[:error] = "Bestandsindeling niet herkend! #{calculatie.info}"
            redirect_to calculaties_url
          end
        end

        def import_hagercad(calculatie)
          # Initialize new arrays
          errors = []
          changed = []
          posities = []
          start_pos = []
          end_pos = []
          # Find calculation
          @calculatie = Calculatie.find(params["calculatie_id"])
          # Destroy all existing positions
          @calculatie.posities.destroy_all

          # Update fields
          project_name = calculatie.cell(1,2).to_s
          project_number = calculatie.cell(4,2).to_i

          if @calculatie.name != project_name
            changed << "naam"
            @calculatie.update(name: project_name)
          end
          if @calculatie.number != project_number
            changed << "nummer"
            @calculatie.update(number: project_number)
          end

          # Iterate rows to find number of positions and start and end
          (calculatie.first_row..calculatie.last_row).each do |row|
            if calculatie.cell(row, 1) == "Aantal producten"
              start_pos << row
              posities << calculatie.cell(row - 1, 1).split(",")
            end
            if calculatie.cell(row, 1) == "Totalen"
              end_pos << row
            end
          end

          if start_pos.count == end_pos.count && start_pos.count == posities.count
            posities.each do |positie|
              @positie = Positie.new(calculatie: @calculatie)
              if positie.count == 3
                @positie.location = positie[0]
                @positie.number = positie[1].to_i
                @positie.name = positie[2]
              elsif positie.count == 2
                @positie.number = positie[0].to_i
                @positie.name = positie[1]
              else
                @positie.errors.add(:base, "Fout bij het importeren: #{positie}")
              end
              if @positie.valid?
                @positie.save
              else
                errors << [@positie.number, @positie.errors.full_messages.join(',')]
              end
            end
          else
            raise "Fout bij het importeren"
          end

        posities.count.times do |index|
          ((start_pos[index] - 1)..(end_pos[index] - 11)).each do |line|

              # [0] Aantal producten
              # [1] Artikelnummer
              # [2] Omschrijving
              # [3] Stuksprijs bruto
              # [4] Totaalprijs
              # [5] Korting artikelgroep
              # [6] Nettoprijs per stuk

              aantal = calculatie.parse[line][0].to_i
              artnr = calculatie.parse[line][1].to_s
              desc = calculatie.parse[line][2].to_s
              bruto = calculatie.parse[line][3].to_d
              korting = calculatie.parse[line][5].to_d
              netto = calculatie.parse[line][6].to_d unless calculatie.parse[line][6].nil?

              if (start_pos[index] - 1) == line
                actual_position = calculatie.parse[line - 2][0].split(",")
                actual_position.shift if actual_position.count == 3
                @act_pos = @calculatie.posities.where(number: actual_position[0].to_i, name: actual_position[1].to_s).first


                montage = calculatie.parse[end_pos[index] - 6][0]
                bedrading = calculatie.parse[end_pos[index] - 5][0]

                @montage_uren = ProductionHours.new(montage)
                @bedradings_uren = ProductionHours.new(bedrading)
                
                @total_uren = @montage_uren.to_seconds + @bedradings_uren.to_seconds

                @act_pos.update(production_time: @total_uren)

              end

              item = Item.upsert!(supplier: "Hager", number: artnr, description: desc, bruto: bruto, discount: korting, netto: netto)

                raise "item error" unless item.valid?

              positie = PositieItem.create(positie: @act_pos, item: item, quantity: aantal)

                raise "positie_item error" unless positie.valid?


          end
        end

        error = errors.blank? ? nil : "Fout in posities: #{errors.join(', ')}"
        change = changed.blank? ? nil : "De volgende velden zijn aangepast: #{changed.join(', ')}"

        if !errors.blank?
          flash[:error] = "Hagercad calculatie geïmporteerd. /!\\ #{error} /!\\"
        elsif !changed.blank?
          flash[:warning] = "Hagercad calculatie geïmporteerd. /!\\ #{change} /!\\"
        else
          flash[:success] = "Hagercad calculatie geïmporteerd."
        end


        redirect_to calculaties_url
      end

    end
  end
end

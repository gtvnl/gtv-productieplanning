module Concerns
  module PositieMethods
      extend ActiveSupport::Concern

      included do

        private
          def positie
            calculatie
            @positie ||= load_positie
          end

          def posities
            calculatie
            @locations = @calculatie.posities.collect.pluck(:location).to_set
            @posities ||= @calculatie.posities
          end

          def load_positie
            deleted_positie || blank_positie || found_positie || created_positie || nil
          end

          def blank_positie
            %w(new).include?(params[:action]) && Positie.new
          end

          def found_positie
            %w(show edit update).include?(params[:action]) && Positie.find(params[:id])
          end

          def created_positie
            %w(create).include?(params[:action]) && Positie.new(positie_params)
          end

          def deleted_positie
            %w(destroy).include?(params[:action]) && Positie.find(params[:id])
          end

          def calculatie
            @calculatie ||= Calculatie.find(params[:calculatie_id]) if params[:calculatie_id].present?
          end

          def fabrikaat
            @fabrikaat ||= Fabrikaat.find(params[:positie][:fabrikaat]) if params[:positie][:fabrikaat].present?
          end

          def systeem
            @systeem ||= Systeem.find(params[:positie][:systeem]) if params[:positie][:systeem].present?
          end

          def positie_params
            params.require(:positie).permit(:number, :name, :location)
          end
      end
  end
end

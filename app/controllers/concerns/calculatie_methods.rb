module Concerns
  module CalculatieMethods
      extend ActiveSupport::Concern

      included do

        private
          def calculatie
            @calculatie ||= load_calculatie
          end

          def calculaties
            @calculaties ||= Calculatie.all.page params[:page]
          end

          def load_calculatie
            deleted_calculatie || blank_calculatie || found_calculatie || created_calculatie || nil
          end

          def blank_calculatie
            %w(new).include?(params[:action]) && Calculatie.new
          end

          def found_calculatie
            %w(show edit update).include?(params[:action]) && Calculatie.find(params[:id])
          end

          def created_calculatie
            %w(create).include?(params[:action]) && Calculatie.new(calculatie_params)
          end

          def deleted_calculatie
            %w(destroy).include?(params[:action]) && Calculatie.find(params[:id])
          end

          def calculatie_params
            params.require(:calculatie).permit(:name, :number)
          end
      end
  end
end

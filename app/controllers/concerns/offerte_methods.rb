module Concerns
  module OfferteMethods
      extend ActiveSupport::Concern

      included do

        private
          def offerte
            @offerte ||= load_offerte
          end

          def offertes
            @offertes ||= Offerte.all.page params[:page]
          end

          def load_offerte
            deleted_offerte || blank_offerte || found_offerte || created_offerte || nil
          end

          def blank_offerte
            %w(new).include?(params[:action]) && Offerte.new
          end

          def found_offerte
            %w(show edit update).include?(params[:action]) && Offerte.find(params[:id])
          end

          def created_offerte
            %w(create).include?(params[:action]) && Offerte.new(offerte_params)
          end

          def deleted_offerte
            %w(destroy).include?(params[:action]) && Offerte.find(params[:id])
          end

          def calculatie
            Calculatie.find(params[:offerte][:calculatie]) if params[:offerte][:calculatie].present?
          end

          # Only allow a trusted parameter "white list" through.
          def offerte_params
            params.require(:offerte).permit(:number, :description)
          end
      end
  end
end

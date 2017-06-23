module Concerns
  module PositieItemMethods
      extend ActiveSupport::Concern

      included do

        private
          def positie_item
            @positie_item ||= load_positie_item
          end

          def positie_items
            positie
            @positie_items ||= Kaminari.paginate_array(@positie.positie_items).page(params[:page]).per(10)
          end

          def load_positie_item
            deleted_positie_item || blank_positie_item || found_positie_item || created_positie_item || nil
          end

          def blank_positie_item
            %w(new).include?(params[:action]) && PositieItem.new
          end

          def found_positie_item
            %w(show edit update).include?(params[:action]) && PositieItem.find(params[:id])
          end

          def created_positie_item
            %w(create).include?(params[:action]) && PositieItem.new(positie_item_params)
          end

          def deleted_positie_item
            %w(destroy).include?(params[:action]) && PositieItem.find(params[:id])
          end

          def calculatie
            @calculatie ||= Calculatie.find(params[:calculatie_id]) if params[:calculatie_id].present?
          end

          def positie
            @positie ||= Positie.find(params[:positie_id]) if params[:positie_id].present?
          end

          def positie_item_params
            params.require(:positie_item).permit(:quantity, :positie_id, :item)
          end
      end
  end
end

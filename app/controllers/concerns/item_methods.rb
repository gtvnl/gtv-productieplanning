module Concerns
  module ItemMethods
      extend ActiveSupport::Concern

      included do

        private
          def item
            @item ||= load_item
          end

          def items
            positie
            @items ||= Item.all.page params[:page]
          end

          def load_item
            deleted_item || blank_item || found_item || created_item || nil
          end

          def blank_item
            %w(new).include?(params[:action]) && Item.new
          end

          def found_item
            %w(show edit update).include?(params[:action]) && Item.find(params[:id])
          end

          def created_item
            %w(create).include?(params[:action]) && Item.new(item_params)
          end

          def deleted_item
            %w(destroy).include?(params[:action]) && Item.find(params[:id])
          end

          def calculatie
            @calculatie ||= Calculatie.find(params[:calculatie_id]) if params[:calculatie_id].present?
          end

          def positie
            @positie ||= Positie.find(params[:positie_id]) if params[:positie_id].present?
          end

          def item_params
            params.require(:item).permit(:supplier, :number, :description, :bruto, :discount, :netto)
          end
      end
  end
end

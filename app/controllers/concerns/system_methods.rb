module Concerns
  module SystemMethods
      extend ActiveSupport::Concern

      included do

        private
          def systeem
            fabrikaat

            @systeem ||= load_systeem
          end

          def systemen
            fabrikaat
            @systemen ||= @fabrikaat.systemen
          end

          def load_systeem
            deleted_systeem || blank_systeem || found_systeem || created_systeem || nil
          end

          def blank_systeem
            %w(new).include?(params[:action]) && Systeem.new
          end

          def found_systeem
            %w(show edit update).include?(params[:action]) && Systeem.find(params[:id])
          end

          def created_systeem
            valid_params = systeem_params
            valid_params.delete :color
            %w(create).include?(params[:action]) && Systeem.new(valid_params)
          end

          def deleted_systeem
            %w(destroy).include?(params[:action]) && Systeem.find(params[:id])
          end

          def fabrikaat
            @fabrikaat ||= Fabrikaat.find(params[:fabrikaat_id]) if params[:fabrikaat_id].present?
          end

          def color
            @color ||= Color.find(params[:systeem][:color]) if params[:systeem][:color].present?
          end

          def ip_value
            @ip_value ||= IpValue.find(params[:systeem][:ip_value]) if params[:systeem][:ip_value].present?
          end

          def systeem_params
            params.require(:systeem).permit(:name, :fabrikaat_id, :klass, :has_door)
          end
      end
  end
end

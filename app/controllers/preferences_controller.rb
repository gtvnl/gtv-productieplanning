class PreferencesController < ApplicationController
  before_action :set_preference, only: [:show, :edit, :update, :destroy]

  # GET /preferences
  def index
    @preferences = Preference.all
  end

  # GET /preferences/1/edit
  def edit
  end

  # PATCH/PUT /preferences/1
  def update
    old_value = @preference.value

    if @preference.update(preference_params)
      unless old_value == @preference.value
        redirect_to preferences_url, notice: "#{@preference.setting} aangepast van #{old_value} naar #{@preference.value}"
      else
        flash[:warning] = "Niets gewijzigd"
        redirect_to preferences_url
      end
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preference
      @preference = Preference.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def preference_params
      params.require(:preference).permit(:setting, :value)
    end
end

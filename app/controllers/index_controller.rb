class IndexController < ApplicationController
  def main
    @thisweek = Date.today.cweek
  end
end

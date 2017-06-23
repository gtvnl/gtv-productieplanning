module Dateable
  extend ActiveSupport::Concern

  module ClassMethods
    def late?
        Order.where(:delivery_date.lt => Date.today)
    end

    def weeks_count(year)
      last_day = Date.new(year).end_of_year
      if last_day.cweek == 1
        last_day.prev_week.cweek
      else
        last_day.cweek
      end
    end

    def group_per_week(department)
      orders_array = []
      weeks_count(Date.today.year).times do |week|
        dates = monday_this_week(week + 1)..friday_this_week(week + 1)
        orders_array << Order.where(:department => department, :delivery_date.in => dates.to_a).order_by(:delivery_date => :desc).to_a
      end
      return orders_array
    end

    def current_week
      Date.today.cweek
    end

    def monday_this_week(weeknum)
      Date.commercial(Date.today.cwyear,weeknum)
    end

    def friday_this_week(weeknum)
      monday_this_week(weeknum) + 4
    end

    def upcoming_weeks_helper
      weeks = []

      4.times do |i|
        week_number = current_week + i
        week = {"number" => current_week + i, "start" => monday_this_week(week_number), "end" => friday_this_week(week_number)}
        weeks << week
      end

      return weeks

    end

    def upcoming_weeks
      @upcoming_weeks || upcoming_weeks_helper
    end

    def deliver_this_week(week)
      Order.where(:delivery_date.in => monday_this_week(week)..friday_this_week(week))
    end

    def production_hours_this_week(week)
      Order.deliver_this_week(week).sum(:hours).round
    end

    def quantity_this_week(week)
      Order.deliver_this_week(week).sum(:quantity)
    end
  end
end

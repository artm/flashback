require "show_schedule"
require "json_list"

class Card < Sequel::Model
  extend JsonList

  def level= new_level
    super
    self.show_at = Date.today + ShowSchedule.interval(level)
  end

  def forgotten
    self.level = 0
  end

  def retained
    self.level += 1
  end
end


require "json"

class Card < Sequel::Model
  def level= new_level
    super
    self.show_at = Date.today + Card.interval(level)
  end
  def forgotten
    self.level = 0
  end
  def retained
    self.level += 1
  end
  Intervals = [1,2,4,8,16,32,64]
  def self.interval level
    level = [0,level].max
    level = [level,Intervals.count-1].min
    Intervals[level]
  end
  def self.json_list
    JSON.pretty_generate Card.all.map{|c| c.to_hash}
  end
end


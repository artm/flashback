module ShowSchedule
  Intervals = [1,2,4,8,16,32,64]

  def self.interval level
    level = [0,level].max
    level = [level,Intervals.count-1].min
    Intervals[level]
  end
end

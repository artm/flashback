require "json"
module JsonList
  def self.make enum
    JSON.pretty_generate enum.map{|c| c.to_hash}
  end

  def json_list
    JsonList.make self.all
  end
end

require "json"
module JsonList
  def json_list
    JSON.pretty_generate self.all.map{|c| c.to_hash}
  end
end

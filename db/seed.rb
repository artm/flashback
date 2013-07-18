$LOAD_PATH << File.join(File.dirname(File.dirname(__FILE__)),"lib")
require "config/db"
require "models/card"

[ ['from', 'to'],
].each do |fields|
  Card.create front: fields[0], back: fields[1]
end


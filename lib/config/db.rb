require "sequel"
root = File.dirname(File.dirname(File.dirname(__FILE__)))
DB = Sequel.connect("sqlite://#{root}/db.sqlite")


require "sequel"
require "yaml"

env = ENV["RACK_ENV"] || "development"
config = YAML.load_file("config/database.yml")[env]
DB = Sequel.connect( config )


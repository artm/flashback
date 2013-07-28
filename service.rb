#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "sprockets"
require "sass"

set :assets, Sprockets::Environment.new
%w[assets assets/js assets/js/lib assets/css].each do |path|
  settings.assets.append_path path
end

$LOAD_PATH << File.join(settings.root,"lib")
require "config/db"

require "service/api"
require "service/webapp"


#!/usr/bin/env ruby

require "rubygems"
require "sinatra"

$LOAD_PATH << File.join(settings.root,"lib")
require "config/db"

require "service/api"


#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "sinatra/reloader" if development?
require "sequel"
require "json"

DB = Sequel.connect("sqlite://db.sqlite")
#Cards = DB["cards"]
class Card < Sequel::Model

end

get "/" do
  redirect "/flashback.html"
end

get "/:file.html" do
  headers "Content-Type" => "text/html"
  File.read "src/#{params[:file]}.html"
end

get "/:file.js" do
  headers "Content-Type" => "application/javascript"
  File.read "src/#{params[:file]}.js"
end

get "/:file.css" do
  headers "Content-Type" => "text/css"
  File.read "src/#{params[:file]}.css"
end

get "/cards" do
  headers 'Content-Type' => 'application/json'
  JSON.pretty_generate Card.all.map{|c| c.to_hash}
end

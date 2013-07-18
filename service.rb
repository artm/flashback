#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "sinatra/reloader" if development?
require "json"
$LOAD_PATH << File.join(settings.root,"lib")
require "config/db"
require "models/card"

get("/") { redirect to "/app/" }
get("/app") { redirect to "/app/" }

get "/app/" do
  send_file File.join "src", "flashback.html"
end

get "/app/:file" do
  send_file File.join "src", params[:file]
end

get "/cards" do
  headers "Content-Type" => "application/json"
  JSON.pretty_generate Card.all.map{|c| c.to_hash}
end

post "/card/:id/:state" do
  state = params[:state]
  if %w(retained forgotten).include? state
    card = Card.first(params[:id])
    card.send(state)
  end
end

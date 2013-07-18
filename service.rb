#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
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
  Card.json_list
end

post "/card/:id/:state" do
  state = params[:state]
  if %w(retained forgotten).include? state
    card = Card.first(params[:id])
    card.send(state)
    card.save
  end
  ""
end

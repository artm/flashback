#!/usr/bin/env ruby

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
  200
end

get("/") { redirect to "/app/" }
get("/app") { redirect to "/app/" }
get("/app/") { send_file File.join "src", "flashback.html" }
get("/app/:file") { send_file File.join "src", params[:file] }

BEGIN {
  require "rubygems"
  require "sinatra"
  $LOAD_PATH << File.join(settings.root,"lib")
  require "config/db"
  require "models/card"
}

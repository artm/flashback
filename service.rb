#!/usr/bin/env ruby

get "/cards" do
  headers "Content-Type" => "application/json"
  Card.json_list
end

post "/card/:id/:state" do
  state = params[:state]
  if %w(retained forgotten).include? state
    card = Card.first(id: params[:id])
    card.send(state)
    card.save
  end
  200
end

post "/card/:id" do
  card = Card.first(id: params[:id])
  card.front = params[:front]
  card.back = params[:back]
  card.save
  JSON.pretty_generate card.to_hash
end

post "/card" do
  card = Card.create front: params[:front], back: params[:back]
  JSON.pretty_generate card.to_hash
end

get("/") { redirect to "/app/" }
get("/app") { redirect to "/app/" }
get("/app/") { send_file File.join settings.public_folder, "flashback.html" }
get("/app/:file") { send_file File.join settings.public_folder, params[:file] }

BEGIN {
  require "rubygems"
  require "sinatra"
  $LOAD_PATH << File.join(settings.root,"lib")
  require "config/db"
  require "models/card"

  set :public_folder, "public"
}

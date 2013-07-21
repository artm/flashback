#!/usr/bin/env ruby

get "/cards/scheduled" do
  headers "Content-Type" => "application/json"
  JsonList.make Card.where("show_at is null or show_at <= ?", Date.today).all.shuffle
end

get "/cards" do
  headers "Content-Type" => "application/json"
  JsonList.make Card.all
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
get("/app") { redirect to "/app/flashback" }
get("/app/") { redirect to "/app/flashback" }
Dir["views/*.slim"].each do |file|
  basename = File.basename file, ".slim"
  get("/app/#{basename}") { slim basename.to_sym }
end
get("/app/:file") { send_file File.join settings.public_folder, params[:file] }

BEGIN {
  require "rubygems"
  require "sinatra"
  require 'slim'
  $LOAD_PATH << File.join(settings.root,"lib")
  require "config/db"
  require "models/card"
  require "json_list"
}

require "models/card"
require "json_list"

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

delete "/card/:id" do
  Card.find(id: params[:id]).delete
end

post "/card" do
  card = Card.create front: params[:front], back: params[:back]
  JSON.pretty_generate card.to_hash
end



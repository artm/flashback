require 'slim'
require 'coffee-script'

get("/") { redirect to "/flashback/" }
get("/flashback") { redirect to "/flashback/drill" }
get("/flashback/") { redirect to "/flashback/drill" }

get "/flashback/*" do |view|
  slim view.to_sym, locals: { page: view }
end

get "/assets/*" do |file|
  file.gsub! /(-\w+)(?!.*-\w+)/, ""
  asset = settings.assets[file]
  content_type asset.content_type if asset
  asset.to_s
end

get("/flashback/:file") { send_file File.join settings.public_folder, params[:file] }

require 'slim'
require 'coffee-script'

get("/") { redirect to "/flashback/" }
get("/flashback") { redirect to "/flashback/drill" }
get("/flashback/") { redirect to "/flashback/drill" }
Dir["views/*.slim"].each do |file|
  basename = File.basename file, ".slim"
  get("/flashback/#{basename}") { slim basename.to_sym, locals: { page: basename } }
end
Dir["views/js/*.coffee"].each do |file|
  basename = File.basename file, ".coffee"
  get("/js/#{basename}.js") { coffee basename.to_sym, views: "views/js" }
end
get("/flashback/:file") { send_file File.join settings.public_folder, params[:file] }

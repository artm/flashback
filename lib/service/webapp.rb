require 'slim'

get("/") { redirect to "/flashback/" }
get("/flashback") { redirect to "/flashback/drill" }
get("/flashback/") { redirect to "/flashback/drill" }
Dir["views/*.slim"].each do |file|
  basename = File.basename file, ".slim"
  get("/flashback/#{basename}") { slim basename.to_sym, locals: { page: basename } }
end
get("/flashback/:file") { send_file File.join settings.public_folder, params[:file] }

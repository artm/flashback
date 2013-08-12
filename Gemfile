source "https://rubygems.org"
ruby "1.9.3"

gem "middleman", "~> 3.1.4"
gem "sinatra"
gem "sequel"

group :development do
  gem "middleman-livereload", "~> 3.1.0"
  # For faster file watcher updates on Windows:
  gem "wdm", "~> 0.1.0", :platforms => [:mswin, :mingw]
  gem "sqlite3"
end

group :production do
  gem "pg"
end

gem "rack-contrib"

gem "slim"
gem "bootstrap-sass", github: 'thomas-mcdonald/bootstrap-sass', :branch => '3'
gem "handlebars_assets"



require "rack"
require "rack/contrib/try_static"

use Rack::TryStatic,
  root: "tmp",
  urls: %w[/],
  try: %w[.html index.html /index.html]

# otherwise 404 NotFound
run proc { [404, {"Content-Type" => "text/html"}, ["whoops! Not Found"]]}

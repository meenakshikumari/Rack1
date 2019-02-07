# config.ru
require 'rack'
require_relative 'fetch_user'

use Rack::ETag

app = Rack::Builder.new do
  use Rack::Auth::Basic do |username, password|
    username == 'demo' && password == 'demo'
  end

  map '/' do
    run FetchUser.new
  end
end

run app

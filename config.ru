# config.ru
require_relative 'fetch_user'

use Rack::ETag

run FetchUser.new

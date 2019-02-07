# config.ru
require_relative 'fetch_user'

run FetchUser.new

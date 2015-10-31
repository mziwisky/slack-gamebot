require 'sinatra/base'
require 'chartkick'

class Web < Sinatra::Base
  get '/' do
    erb :index
  end
end

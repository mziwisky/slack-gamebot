module Api
  module Presenters
    module UserRankPresenter
      include Roar::JSON::HAL
      include Roar::Hypermedia
      include Grape::Roar::Representer
      include Api::Helpers::UrlHelpers

      property :id, type: String, desc: 'UserRank ID.'
      property :user_name, type: String, desc: 'UserRank name.'
      property :wins, type: Integer, desc: 'Number of wins.'
      property :losses, type: Integer, desc: 'Number of losses.'
      property :elo, type: Integer, desc: 'Elo.'
      property :rank, type: Integer, desc: 'Rank.'

      link :user do |opts|
        request = Grape::Request.new(opts[:env])
        "#{root_url(request)}/users/#{user_id}"
      end
    end
  end
end

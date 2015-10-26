module Api
  module Presenters
    module MatchPresenter
      include Roar::JSON::HAL
      include Roar::Hypermedia
      include Grape::Roar::Representer
      include Api::Helpers::UrlHelpers

      property :id, type: String, desc: 'Match ID.'
      property :scores, type: Array, desc: 'Match scores.'
      property :created_at, type: DateTime, desc: 'Date/time when the match was created.'

      link :challenge do |opts|
        request = Grape::Request.new(opts[:env])
        "#{root_url(request)}/challenges/#{represented.challenge.id}" if represented.challenge
      end

      link :winners do |opts|
        request = Grape::Request.new(opts[:env])
        represented.winners.map do |user|
          "#{root_url(request)}/users/#{user.id}"
        end
      end

      link :losers do |opts|
        request = Grape::Request.new(opts[:env])
        represented.losers.map do |user|
          "#{root_url(request)}/users/#{user.id}"
        end
      end

      link :self do |opts|
        request = Grape::Request.new(opts[:env])
        "#{root_url(request)}/matches/#{id}"
      end
    end
  end
end

module Api
  module Presenters
    module ChallengePresenter
      include Roar::JSON::HAL
      include Roar::Hypermedia
      include Grape::Roar::Representer
      include Api::Helpers::UrlHelpers

      property :id, type: String, desc: 'Challenge ID.'
      property :state, type: String, desc: 'Current state of the challenge.'
      property :channel, type: String, desc: 'Channel where the challenge was created.'
      property :created_at, type: DateTime, desc: 'Date/time when the challenge was created.'
      property :updated_at, type: DateTime, desc: 'Date/time when the challenge was accepted, declined or canceled.'

      link :created_by do |opts|
        request = Grape::Request.new(opts[:env])
        "#{root_url(request)}/users/#{represented.created_by.id}" if represented.created_by
      end

      link :updated_by do |opts|
        request = Grape::Request.new(opts[:env])
        "#{root_url(request)}/users/#{represented.updated_by.id}" if represented.updated_by
      end

      link :challengers do |opts|
        request = Grape::Request.new(opts[:env])
        represented.challengers.map do |challenger|
          "#{root_url(request)}/users/#{challenger.id}"
        end
      end

      link :challenged do |opts|
        request = Grape::Request.new(opts[:env])
        represented.challenged.map do |challenged|
          "#{root_url(request)}/users/#{challenged.id}"
        end
      end

      link :match do |opts|
        request = Grape::Request.new(opts[:env])
        "#{root_url(request)}/matches/#{represented.match.id}" if represented.match
      end

      link :self do |opts|
        request = Grape::Request.new(opts[:env])
        "#{root_url(request)}/challenges/#{id}"
      end
    end
  end
end

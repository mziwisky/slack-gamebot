module Api
  module Endpoints
    class RootEndpoint < Grape::API
      format :json
      prefix :api
      formatter :json, Grape::Formatter::Roar
      get do
        present self, with: Api::Presenters::RootPresenter
      end
      mount Api::Endpoints::UsersEndpoint
      mount Api::Endpoints::ChallengesEndpoint
      mount Api::Endpoints::MatchesEndpoint
      mount Api::Endpoints::SeasonsEndpoint
      add_swagger_documentation
    end
  end
end

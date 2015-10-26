module Api
  module Helpers
    module UrlHelpers
      extend ActiveSupport::Concern

      def root_url(request)
        "#{request.base_url}/api"
      end
    end
  end
end

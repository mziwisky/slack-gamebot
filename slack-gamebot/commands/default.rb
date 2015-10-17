module SlackGamebot
  module Commands
    class Default < SlackGamebot::Commands::Base
      match(/^(?<bot>\w*)$/)

      def self.call(client, data, _match)
        send_message client, data.channel, SlackGamebot::ASCII
      end
    end
  end
end

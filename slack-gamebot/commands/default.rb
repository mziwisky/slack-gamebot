module SlackGamebot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      match(/^(?<bot>[\w[:punct:]@<>]*)$/)

      def self.call(client, data, _match)
        send_message client, data.channel, "Yes, <@#{data.user}>?"
      end
    end
  end
end

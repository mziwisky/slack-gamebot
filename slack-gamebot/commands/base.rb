module SlackGamebot
  module Commands
    class Base < SlackRubyBot::Commands::Base
      def self.send_message_with_gif(client, channel, text, keywords, options = {})
        if SlackGamebot.config.disable_gifs
          send_message(client, channel, text, options)
        else
          super
        end
      end
    end
  end
end

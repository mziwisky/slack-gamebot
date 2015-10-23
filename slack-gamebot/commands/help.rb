module SlackGamebot
  module Commands
    class Help < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        commands = (SlackGamebot::Commands.constants - [:Default]).map(&:downcase).sort
        message = <<-HELP_MSG
(version #{SlackGamebot::VERSION})
I understand these commands:
```#{commands.join("\n")}```
See https://github.com/dblock/slack-gamebot for details.
        HELP_MSG
        send_message_with_gif client, data.channel, message, 'help'
        logger.info "HELP: #{data.user}"
      end
    end
  end
end

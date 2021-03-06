module SlackGamebot
  module Commands
    class Won < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        challenger = ::User.find_create_or_update_by_slack_id!(client, data.user)
        challenge = ::Challenge.find_by_user(data.channel, challenger, [ChallengeState::PROPOSED, ChallengeState::ACCEPTED])
        scores = Score.parse(match['expression']) if match.names.include?('expression')
        if challenge
          challenge.win!(challenger, scores)
          send_message_with_gif client, data.channel, "Match has been recorded! #{challenge.match}.", 'winner'
          logger.info "WON: #{challenge}"
        else
          match = ::Match.where(loser_ids: challenger.id).desc(:_id).first
          if match
            match.update_attributes!(scores: scores)
            send_message_with_gif client, data.channel, "Match scores have been updated! #{match}.", 'score'
            logger.info "SCORED: #{match}"
          else
            send_message client, data.channel, 'No challenge to win!'
            logger.info "WON: #{data.user}, N/A"
          end
        end
      end
    end
  end
end

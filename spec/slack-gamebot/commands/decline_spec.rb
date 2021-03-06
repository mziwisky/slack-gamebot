require 'spec_helper'

describe SlackGamebot::Commands::Decline, vcr: { cassette_name: 'user_info' } do
  let(:app) { SlackGamebot::App.new }
  let(:challenged) { Fabricate(:user, user_name: 'username') }
  let!(:challenge) { Fabricate(:challenge, challenged: [challenged]) }
  it 'declines a challenge' do
    expect(message: "#{SlackRubyBot.config.user} decline", user: challenged.user_id, channel: challenge.channel).to respond_with_slack_message(
      "#{challenge.challenged.map(&:user_name).join(' and ')} declined #{challenge.challengers.map(&:user_name).join(' and ')} challenge."
    )
    expect(challenge.reload.state).to eq ChallengeState::DECLINED
  end
end

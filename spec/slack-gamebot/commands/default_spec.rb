require 'spec_helper'

describe SlackGamebot::Commands::Default do
  let(:app) { SlackGamebot::App.new }
  it 'default' do
    expect(message: SlackRubyBot.config.user).to respond_with_slack_message(SlackGamebot::ASCII)
  end
  it 'upcase' do
    expect(message: SlackRubyBot.config.user.upcase).to respond_with_slack_message(SlackGamebot::ASCII)
  end
end

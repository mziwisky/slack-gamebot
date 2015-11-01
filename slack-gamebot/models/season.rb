class Season
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :created_by, class_name: 'User', inverse_of: nil, index: true
  has_many :challenges
  embeds_many :user_ranks

  after_create :archive_challenges!
  after_create :reset_users!

  validate :validate_challenges

  SORT_ORDERS = ['created_at', '-created_at']

  def initialize(attrs = {})
    super
    create_user_ranks
  end

  def to_s
    [
      "#{label}: #{winner}",
      "#{played_challenges.count} match#{played_challenges.count == 1 ? '' : 'es'}",
      "#{players.count} player#{players.count == 1 ? '' : 's'}"
    ].join(', ')
  end

  def to_chart
    # go thru all matches chronologically. calculate elo at each step. chart it.
    # format: [
    #           {name: 'z', data: {'datestring1' => 1, 'datestring2' => 2} },
    #           {name: 'nomitch', data: {'datestring1' => 2, 'datestring2' => 1} }
    #         ]
    user_histories = players.reduce({}) do |hash, player|
      surrogate = UserRank.from_user(player.user).tap {|p| p.elo = p.tau = 0}
      hash[player.user.user_id] = {player: surrogate, data: {player.user.created_at.to_s => 0}}
      hash
    end

    played_challenges.asc(:updated_at).map(&:match).each do |match|
      winners = match.winners.map { |user| user_histories[user.user_id][:player] }
      losers = match.losers.map { |user| user_histories[user.user_id][:player] }

      deltas = Elo.calculate_change(winners: winners, losers: losers)
      deltas.each do |player, delta|
        player.elo += delta[:elo]
        player.tau += delta[:tau]
        user_histories[player.user.user_id][:data][match.created_at.to_s] = player.elo
      end
    end

    user_histories.map { |user_id, hash| {name: hash[:player].user_name, data: hash[:data]} }
  end

  private

  def winner
    user_ranks.asc(:rank).first
  end

  def played_challenges
    persisted? ? challenges.played : Challenge.current.played
  end

  def label
    persisted? ? created_at.strftime('%F') : 'Current'
  end

  def players
    user_ranks.where(:rank.ne => nil)
  end

  def validate_challenges
    errors.add(:challenges, 'No matches have been recorded.') unless Challenge.current.any?
  end

  def create_user_ranks
    return if user_ranks.any?
    User.ranked.asc(:rank).each do |user|
      user_ranks << UserRank.from_user(user)
    end
  end

  def archive_challenges!
    Challenge.where(
      :state.in => [ChallengeState::PROPOSED, ChallengeState::ACCEPTED]
    ).set(
      state: ChallengeState::CANCELED,
      updated_by_id: created_by && created_by.id
    )
    Challenge.current.set(season_id: id)
  end

  def reset_users!
    User.reset_all!
  end
end

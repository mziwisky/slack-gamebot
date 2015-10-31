class Match
  include Mongoid::Document
  include Mongoid::Timestamps

  SORT_ORDERS = ['created_at', '-created_at']

  field :scores, type: Array
  belongs_to :challenge, index: true
  before_create :calculate_elo!
  validate :validate_scores

  has_and_belongs_to_many :winners, class_name: 'User', inverse_of: nil
  has_and_belongs_to_many :losers, class_name: 'User', inverse_of: nil

  def to_s
    "#{winners.map(&:user_name).join(' and ')} #{score_verb} #{losers.map(&:user_name).join(' and ')}"
  end

  private

  def validate_scores
    return unless scores
    return if Score.valid?(scores)
    errors.add(:scores, 'Loser scores must come first.')
  end

  def score_verb
    return 'defeated' unless scores
    lose, win = Score.points(scores)
    ratio = lose.to_f / win
    if ratio > 0.9
      'narrowly defeated'
    elsif ratio > 0.4
      'defeated'
    else
      'crushed'
    end
  end

  def calculate_elo!
    deltas = Elo.calculate_change(winners: winners, losers: losers)
    deltas.each do |player, delta|
      player.elo += delta[:elo]
      player.tau += delta[:tau]
      player.save!
    end
  end
end

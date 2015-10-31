module Elo
  DELTA_TAU = 0.94

  def self.team_elo(players)
    (players.sum(&:elo).to_f / players.count).round(2)
  end

  def self.adjustment_factor(winner_elo, loser_elo)
    100 - 1.0 / (1.0 + (10.0**((loser_elo - winner_elo) / 400.0))) * 100
  end

  def self.calculate_change(winners:, losers:)
    winners = Array(winners)
    losers = Array(losers)

    winners_elo = team_elo(winners)
    losers_elo = team_elo(losers)

    deltas = {}
    winners.each do |winner|
      deltas[winner] = {
        tau: 0.5,
        elo: adjustment_factor(winner.elo, losers_elo) * (DELTA_TAU**(winner.tau + 0.5))
      }
    end
    losers.each do |loser|
      deltas[loser] = {
        tau: 0.5,
        elo: - adjustment_factor(winners_elo, loser.elo) * (DELTA_TAU**(loser.tau + 0.5))
      }
    end
    deltas
  end
end

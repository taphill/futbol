require_relative '../lib/findable'
require_relative '../lib/league_statistics'

class GameManager
  include Findable
  include LeagueStatistics
  attr_reader :games, :tracker

  def initialize(path, tracker)
    @games = []
    @tracker = tracker
    create_games(path)
  end

  def create_games(path)
    games_data = CSV.read(path, headers: true)

    @games = games_data.map do |data|
      Game.new(data, self)
    end
  end

  #------------SeasonStats
  def games_of_season(season)
    @games.find_all { |game| game.season == season }
  end

  #---------------TeamStats
  def games_by_team(team_id)
    @games.select do |game|
      game.home_team_id == team_id || game.away_team_id == team_id
    end
  end

  #------------LeagueStats
  def team_stats
    tracker.initialize_team_stats_hash.each do |team_id, games_goals|
      games.each do |game|
        next unless team_id == game.away_team_id || team_id == game.home_team_id
        
        games_goals[:away_games] += 1 if team_id == game.away_team_id
        games_goals[:home_games] += 1 if team_id == game.home_team_id
        games_goals[:away_goals] += game.away_goals.to_i if team_id == game.away_team_id
        games_goals[:home_goals] += game.home_goals.to_i if team_id == game.home_team_id
      end
      games_goals[:total_games] = games_goals[:away_games] + games_goals[:home_games]
      games_goals[:total_goals] = games_goals[:away_goals] + games_goals[:home_goals]
    end
  end
end

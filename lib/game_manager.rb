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

  #-------------GameStatistics
  def highest_total_score
    result = @games.max_by do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    result.away_goals.to_i + result.home_goals.to_i
  end

  def lowest_total_score
    result = @games.min_by do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    result.away_goals.to_i + result.home_goals.to_i
  end

  def count_of_games_by_season
    games_by_season_index = {}
    games_by_season.each do |season, games|
      games_by_season_index[season] = games.length
    end
    games_by_season_index
  end

  def games_by_season
    result = {}
    games.each do |game|
      if result[game.season].nil?
        result[game.season] = [game]
      else
        result[game.season] << game
      end
    end
    result
  end

  def average_goals_per_game
    (total_goals.to_f / total_number_of_games).round(2)
  end

  def total_goals
    goal_count = 0
    games.each do |game|
      goal_count += game.home_goals.to_i
      goal_count += game.away_goals.to_i
    end
    goal_count
  end

  def total_number_of_games
    game_count = 0
    games.each do
      game_count += 1
    end
    game_count
  end

  def average_goals_by_season
    goals_by_season_average = {}
    season_information.each do |season, goals|
      goals_by_season_average[season] = (goals[:total_goals].to_f / goals[:total_games]).round(2)
    end
    goals_by_season_average
  end

  def initialize_season_information
    season_info = {}
    games.each do |game|
      season_info[game.season] = { total_goals: 0, away_goals: 0, home_goals: 0, total_games: 0 }
    end
    season_info
  end

  def season_information
    initialize_season_information.each do |season, goals|
      games.each do |game|
        next unless game.season == season

        goals[:total_games] += 1
        goals[:away_goals] += game.away_goals.to_i
        goals[:home_goals] += game.home_goals.to_i
      end
      goals[:total_goals] = goals[:away_goals] + goals[:home_goals]
    end
  end
end

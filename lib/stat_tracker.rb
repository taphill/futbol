require 'csv'

class StatTracker
  attr_reader :games, :teams, :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.from_csv(locations)
    games = CSV.read(locations[:games], headers:true)
    teams = CSV.read(locations[:teams], headers:true)
    game_teams = CSV.read(locations[:game_teams], headers:true)

    new(games, teams, game_teams)
  end

#
# #------------GameStatistics
#
#   def highest_total_score
#     result = games.max_by do |game|
#       game.away_goals.to_i + game.home_goals.to_i
#     end
#     result.away_goals.to_i + result.home_goals.to_i
#   end
#
#   def lowest_total_score
#     result = games.min_by do |game|
#       game.away_goals.to_i + game.home_goals.to_i
#     end
#     result.away_goals.to_i + result.home_goals.to_i
#   end
#
#------------LeagueStatistics
  def count_of_teams
    teams = games.flat_map do |game|
      [game['away_team_id'], game['home_team_id']]
    end

    teams.uniq.count
  end

# #------------SeasonStatistics
#
#   def winningest_coach
#     winner = coach_list_wins_losses.max_by do |key, w_l|
#       wins = w_l.count("WIN")
#       losses = w_l.count("LOSS").to_f
#       (wins) / (wins + losses)
#     end
#     winner[0]
#   end
#
#   def worst_coach
#     loser = coach_list_wins_losses.min_by do |key, w_l|
#       wins = w_l.count("WIN")
#       losses = w_l.count("LOSS").to_f
#       (wins) / (wins + losses)
#     end
#     loser[0]
#   end
#


#------------TeamStatistics
  def team_info(team_id)
    result = { }
    teams.each do |team|
      if team_id == team['team_id']
        result[:team_id] = team['team_id']
        result[:franchise_id] = team['franchiseId']
        result[:team_name] = team['teamName']
        result[:abbreviation] = team['abbreviation']
        result[:link] = team['link']
      end
    end
    result
  end

  def best_season(team_id)
    unique_game_info(team_id)
    average_of_wins_by_season(team_id).keys.max_by do |season|
      average_of_wins_by_season(team_id)[season][:average]
    end
  end

  def worst_season(team_id)
    unique_game_info(team_id)
    average_of_wins_by_season(team_id).keys.min_by do |season|
      average_of_wins_by_season(team_id)[season][:average]
    end
  end

#---------------------------
  private

  def coach_list_wins_losses
    coach_hash = Hash.new
    game_teams.each do |gt|
      (coach_hash[gt.head_coach] ||= []) << gt.result
    end
    coach_hash
  end
end

#----------TeamStatsHelpers
def average_of_wins_by_season(team_id)
  counts_by_season = { }
  unique_game_info(team_id).each do |season, games|
    counts_by_season[season] = { }
    counts_by_season[season][:total] = games.length
    counts_by_season[season][:wins] = games.select do |game|
      game['result'] == "WIN"
    end.length
    counts_by_season[season][:average] = (counts_by_season[season][:wins].to_f / counts_by_season[season][:total]).round(2)
  end
  counts_by_season
end

  def unique_game_info(team_id)
    results = game_info_by_team(team_id)
    results_by_season = { }
    team_games_by_season(games_by_team(team_id)).each do |season, games|
      results_by_season[season] = []
      games.each do |game|
        results_by_season[season] << results.find do |game_info|
          game['game_id'] == game_info['game_id']
        end
      end
    end
    results_by_season
  end

  def team_games_by_season(all_games = games)
    result = { }
    all_games.each do |game|
      if result[game['season']] == nil
        result[game['season']] = [game]
      else
        result[game['season']] << game
      end
    end
    result
  end

  def games_by_team(team_id, all_games = games)
    games.select do |game|
      game['home_team_id'] == team_id ||
      game['away_team_id'] == team_id
    end
  end

  def game_info_by_team(team_id)
    game_teams.select do |game_team|
      game_team['team_id'] == team_id
    end
  end

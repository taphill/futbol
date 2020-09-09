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
  def highest_total_score
    result = games.max_by do |game|
      game['away_goals'].to_i + game['home_goals'].to_i
    end
    result['away_goals'].to_i + result['home_goals'].to_i
  end
#
  def lowest_total_score
    result = games.min_by do |game|
      game['away_goals'].to_i + game['home_goals'].to_i
    end
    result['away_goals'].to_i + result['home_goals'].to_i
  end

  def percentage_home_wins
    average = all_home_game_wins.count / all_home_games.count.to_f
    average.round(2)
  end

  def percentage_visitor_wins
    average = all_away_game_wins.count / all_away_games.count.to_f
    average.round(2)
  end

  def percentage_ties
    average = all_tie_games.count / all_games.count.to_f
    average.round(2)
  end

  def count_of_games_by_season
    # require "pry"; binding.pry
    games_by_season_index = {}
    games_by_season.each do |season, games|
      games_by_season_index[season] = games.length
      # require "pry"; binding.pry
    end
    games_by_season_index
  end

  def games_by_season
    result = { }
    games.each do |game|
      if result[game['season']] == nil
        result[game['season']] = [game]
      else
        result[game['season']] << game
      end
    end
    result
  end

  #   def game_team_results_by_season(season)
  #     games_of_season = games.find_all do |game|
  #       game['season'] == season
  #     end
  #     game_ids_in_season = games_of_season.map do |game|
  #       game['game_id']
  #     end
  #   end
#
#------------LeagueStatistics
  def count_of_teams
    teams = games.flat_map do |game|
      [game['away_team_id'], game['home_team_id']]
    end

    teams.uniq.count
  end

  def best_offense
    best_offense = team_stats.max_by do |team, stats|
      stats[:total_goals] / stats[:total_games].to_f
    end

    find_team_by_team_id(best_offense[0])
  end

  def worst_offense
    worst_offense = team_stats.min_by do |team, stats|
      stats[:total_goals] / stats[:total_games].to_f
    end

    find_team_by_team_id(worst_offense[0])
  end

  def highest_scoring_visitor
    highest_scoring_visitor = team_stats.max_by do |team, stats|
      stats[:away_goals] / stats[:away_games].to_f
    end

    find_team_by_team_id(highest_scoring_visitor[0])
  end

  def highest_scoring_home_team
    highest_scoring_home_team = team_stats.max_by do |team, stats|
      stats[:home_goals] / stats[:home_games].to_f
    end

    find_team_by_team_id(highest_scoring_home_team[0])
  end

  def lowest_scoring_visitor
    lowest_scoring_visitor = team_stats.min_by do |team, stats|
      stats[:away_goals] / stats[:away_games].to_f
    end

    find_team_by_team_id(lowest_scoring_visitor[0])
  end

  def lowest_scoring_home_team
    lowest_scoring_home_team = team_stats.min_by do |team, stats|
      stats[:home_goals] / stats[:home_games].to_f
    end

    find_team_by_team_id(lowest_scoring_home_team[0])
  end

# #------------SeasonStatistics

  def winningest_coach(season)
    game_team_results_by_season(season)
    coaches_records_start
    add_wins_losses
    determine_winningest_coach
  end

  def worst_coach(season)
    game_team_results_by_season(season)
    coaches_records_start
    add_wins_losses
    determine_worst_coach
  end


#------------TeamStatistics

  def team_info
    result = { }
    teams.each do |team|
      (result[:team_id] ||= []) << team['team_id']
      (result[:franchiseId] ||= []) << team['franchiseId']
      (result[:teamName] ||= []) << team['teamName']
      (result[:abbreviation] ||= []) << team['abbreviation']
      (result[:link] ||= []) << team['link']
    end
    result
  end

#---------------------------
  private

  # -----------------GameStatistics

    def all_home_games
      game_teams.find_all do |game|
        game['HoA'] == "home"
      end
    end

    def all_home_game_wins
      all_home_games.find_all do |game|
        game['result'] == "WIN"
      end
    end

    def all_home_game_losses
      all_home_games.find_all do |game|
        game['result'] == "LOSS"
      end
    end

    def all_away_games
      game_teams.find_all do |game|
        game['HoA'] == "away"
      end
    end

    def all_away_game_wins
      all_away_games.find_all do |game|
        game['result'] == "WIN"
      end
    end

    def all_games
      game_teams.find_all do |game|
        game['HoA'] == "away" || game['HoA'] == "home"
      end
    end

    def all_tie_games
      all_games.find_all do |game|
        game['result'] == "TIE"
      end
    end
  # -----------------SeasonStatistics

def game_team_results_by_season(season)
    games_of_season = games.find_all do |game|
      game['season'] == season
    end
    game_ids_in_season = games_of_season.map do |game|
      game['game_id']
    end
    @games_results_per_season = game_teams.find_all do |gt|
      game_ids_in_season.include? gt['game_id']
    end
  end

  def coaches_records_start
    @coach_record_hash = {}
    @games_results_per_season.each do |gr|
      @coach_record_hash[gr['head_coach']] = {wins: 0, losses: 0, ties:0}
    end
    @coach_record_hash
  end

  def add_wins_losses
    @games_results_per_season.each do |gr|
      if gr['result'] == "WIN"
        @coach_record_hash[gr['head_coach']][:wins] += 1
      elsif gr['result'] == "LOSS"
        @coach_record_hash[gr['head_coach']][:losses] += 1
      elsif gr['result'] == "TIE"
        @coach_record_hash[gr['head_coach']][:ties] += 1
      end
    end
    @coach_record_hash
  end

  def determine_winningest_coach
    add_wins_losses.max_by do |coach, w_l|
      w_l[:wins].to_f / (w_l[:wins] + w_l[:losses] + w_l[:ties])
    end[0]
  end

  def determine_worst_coach
    add_wins_losses.min_by do |coach, w_l|
      w_l[:wins].to_f / (w_l[:wins] + w_l[:losses] + w_l[:ties])
    end[0]
  end


#------------LeagueStatistics Helper Methods
  def find_team_by_team_id(id)
    teams.find do |team|
      team['team_id'] == id
    end['teamName']
  end

  def create_team_stats_hash
    team_stats_hash = {}

    teams.each do |team|
      team_stats_hash[team['team_id']] = { total_games: 0, total_goals: 0,
                                           away_games: 0, home_games: 0,
                                           away_goals: 0, home_goals: 0 }
    end

    team_stats_hash
  end

  def team_stats
    create_team_stats_hash.each do |team_id, games_goals|
      games.each do |game|
        if team_id == game['away_team_id'] || team_id == game['home_team_id']
          games_goals[:away_games] += 1 if team_id == game['away_team_id']
          games_goals[:home_games] += 1 if team_id == game['home_team_id']
          games_goals[:away_goals] += game['away_goals'].to_i if team_id == game['away_team_id']
          games_goals[:home_goals] += game['home_goals'].to_i if team_id == game['home_team_id']
        end
      end
      games_goals[:total_games] = games_goals[:away_games] + games_goals[:home_games]
      games_goals[:total_goals] = games_goals[:away_goals] + games_goals[:home_goals]
    end
  end
end

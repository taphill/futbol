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
    games_by_season_index = {}
    games_by_season.each do |season, games|
      games_by_season_index[season] = games.length
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

  def average_goals_per_game
    (total_goals.to_f / total_number_of_games).round(2)
  end

  def total_number_of_goals
    home_goals.count + away_goals.count
  end

  def home_goals
    games.find_all do |game|
      game['away_goals'].to_i
    end
  end

  def total_goals
    goal_count = 0
    games.each do |game|
      goal_count += game['home_goals'].to_i
      goal_count += game['away_goals'].to_i
    end
    return goal_count
  end

  def total_number_of_games
    game_count = 0
    games.each do |game|
      game_count += 1
    end
    return game_count
  end

  def average_goals_by_season
    season_hash = { }
    games.each do |game|
      season_hash[game['season']] = 0
    end

    season_hash.each do |season, average_goals|
      games.each do |game|
        if game['season'] == season
          average_goals += game['away_goals'].to_i
          average_goals += game['home_goals'].to_i
        end
      end
      season_hash[season] = average_goals
    end

    season_hash.each do |season, goals|
      count_of_games_by_season.each do |season_games, games|
        if season_games == season
          average = goals.to_f / games.to_f
          season_hash[season] = (average).round(2)
        end
      end
    end
  end

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
  #   gt_results = game_team_results_by_season(season)
  #   coach_record_start = initialize_coaches_records(gt_results)
  #   total_record = add_wins_losses(gt_results, coach_record_start)
  #   determine_winningest_coach(total_record)
  end

  def worst_coach(season)
    gt_results = game_team_results_by_season(season)
    coach_record_start = initialize_coaches_records(gt_results)
    total_record = add_wins_losses(gt_results, coach_record_start)
    determine_worst_coach(total_record)
  end

  def most_accurate_team(season)
    gt_results = game_team_results_by_season(season)
    shots_goals_start = initialize_shots_and_goals_per_team(gt_results)
    total_shots_goals = add_shots_and_goals(gt_results, shots_goals_start)
    determine_team_with_best_accuracy(total_shots_goals)
  end

  def least_accurate_team(season)
    gt_results = game_team_results_by_season(season)
    shots_goals_start = initialize_shots_and_goals_per_team(gt_results)
    total_shots_goals = add_shots_and_goals(gt_results, shots_goals_start)
    determine_team_with_worst_accuracy(total_shots_goals)
  end

  def most_tackles(season)
    gt_results = game_team_results_by_season(season)
    tackles_start = initialize_tackles_per_team(gt_results)
    total_tackles = add_tackles(gt_results, tackles_start)
    determine_team_with_most_tackles(total_tackles)
  end

  def fewest_tackles(season)
    gt_results = game_team_results_by_season(season)
    tackles_start = initialize_tackles_per_team(gt_results)
    total_tackles = add_tackles(gt_results, tackles_start)
    determine_team_with_least_tackles(total_tackles)
  end

  # def game_team_results_by_season(season)
  #     games_of_season = games.find_all do |game|
  #       game['season'] == season
  #     end
  #     game_ids_in_season = games_of_season.map do |game|
  #       game['game_id']
  #     end
  #     games_results_per_season = game_teams.find_all do |team_result|
  #       game_ids_in_season.include? team_result['game_id']
  #     end
  #     games_results_per_season
  #   end

    # def initialize_coaches_records(gt_results)
    #   coach_record_hash = {}
    #   gt_results.each do |team_result|
    #     coach_record_hash[team_result['head_coach']] = {wins: 0, losses: 0, ties:0}
    #   end
    #   coach_record_hash
    # end

    # def add_wins_losses(gt_results, coach_record_start)
    #   gt_results.each do |team_result|
    #     if team_result['result'] == "WIN"
    #       coach_record_start[team_result['head_coach']][:wins] += 1
    #     elsif team_result['result'] == "LOSS"
    #       coach_record_start[team_result['head_coach']][:losses] += 1
    #     elsif team_result['result'] == "TIE"
    #       coach_record_start[team_result['head_coach']][:ties] += 1
    #     end
    #   end
    #   coach_record_start
    # end

    # def determine_winningest_coach(totaled_record)
    #   totaled_record.max_by do |coach, w_l|
    #     w_l[:wins].to_f / (w_l[:wins] + w_l[:losses] + w_l[:ties])
    #   end[0]
    # end

    # def determine_worst_coach(totaled_record)
    #   totaled_record.min_by do |coach, w_l|
    #     w_l[:wins].to_f / (w_l[:wins] + w_l[:losses] + w_l[:ties])
    #   end[0]
    # end

    def initialize_shots_and_goals_per_team(gt_results)
      total_shots_goals = {}
      gt_results.each do |team_result|
        total_shots_goals[team_result['team_id']] = {shots: 0, goals: 0}
      end
      total_shots_goals
    end

    def add_shots_and_goals(gt_results, shots_goals_start)
      gt_results.each do |team_result|
        shots_goals_start[team_result['team_id']][:shots] += team_result['shots'].to_i
        shots_goals_start[team_result['team_id']][:goals] += team_result['goals'].to_i
      end
      shots_goals_start
    end

    def determine_team_with_best_accuracy(total_shots_goals)
      result_id = total_shots_goals.max_by do |id, s_g|
        s_g[:goals].to_f / s_g[:shots]
      end[0]
      find_team_by_team_id(result_id)
    end

    def determine_team_with_worst_accuracy(total_shots_goals)
      result_id = total_shots_goals.min_by do |id, s_g|
        s_g[:goals].to_f / s_g[:shots]
      end[0]
      find_team_by_team_id(result_id)
    end

    def initialize_tackles_per_team(gt_results)
      tackles_per_team = {}
      gt_results.each do |team_result|
        tackles_per_team[team_result['team_id']] = 0
      end
      tackles_per_team
    end

    def add_tackles(gt_results, tackles_start)
      gt_results.each do |team_result|
        tackles_start[team_result['team_id']] += team_result['tackles'].to_i
      end
      tackles_start
    end

    def determine_team_with_most_tackles(total_tackles)
      result_id = total_tackles.max_by do |id, tackle_count|
        tackle_count
      end[0]
      find_team_by_team_id(result_id)
    end

    def determine_team_with_least_tackles(total_tackles)
      result_id = total_tackles.min_by do |id, tackle_count|
        tackle_count
      end[0]
      find_team_by_team_id(result_id)
    end


#------------TeamStatistics
  def team_info(team_id)
    result = { }
    teams.each do |team|
      if team_id == team['team_id']
        result['team_id'] = team['team_id']
        result['franchise_id'] = team['franchiseId']
        result['team_name'] = team['teamName']
        result['abbreviation'] = team['abbreviation']
        result['link'] = team['link']
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

  def average_win_percentage(team_id)
    (result_totals_by_team(team_id)[:wins].to_f / result_totals_by_team(team_id)[:total].to_f).round(2)
  end

  def most_goals_scored(team_id)
    game_info_by_team(team_id).max_by do |game|
      (game['goals']).to_i
    end['goals'].to_i
  end

  def fewest_goals_scored(team_id)
    game_info_by_team(team_id).min_by do |game|
      (game['goals']).to_i
    end['goals'].to_i
  end

  def favorite_opponent(team_id)
    opponent_stats = find_opponent_games(team_id)
    opponent_stats.each do |team_id, team_info|
      opponent_stats[team_id][:total] = team_info[:game_data].length
      opponent_stats[team_id][:wins] = team_info[:game_data].select do |game|
        game['result'] == "WIN"
      end.length
      opponent_stats[team_id][:win_percentage] = (opponent_stats[team_id][:wins]/opponent_stats[team_id][:total].to_f).round(2)
    end
    favorite_team_id = opponent_stats.keys.min_by do |opponent_id|
      opponent_stats[opponent_id][:win_percentage]
    end
    team_info(favorite_team_id)["team_name"]
  end

  def rival(team_id)
    opponent_stats = find_opponent_games(team_id)
    opponent_stats.each do |team_id, team_info|
      opponent_stats[team_id][:total] = team_info[:game_data].length
      opponent_stats[team_id][:wins] = team_info[:game_data].select do |game|
        game['result'] == "WIN"
      end.length
      opponent_stats[team_id][:win_percentage] = (opponent_stats[team_id][:wins]/opponent_stats[team_id][:total].to_f).round(2)
    end
    favorite_team_id = opponent_stats.keys.max_by do |opponent_id|
      opponent_stats[opponent_id][:win_percentage]
    end
    team_info(favorite_team_id)["team_name"]
  end

  def find_opponent_games(team_id)
    game_ids = games_by_game_id(games_by_team(team_id))
    opponent_games = {}
    teams.each do |team|
      next if team['team_id'] == team_id
        opponent_games[team['team_id']] = {}
        opponent_games[team['team_id']][:game_data] = game_teams.select do |game|
          (game['team_id'] == team['team_id']) && game_ids.include?(game['game_id'])
          end
        end
        opponent_games
      end

  def games_by_game_id(games)
    games.map do |game|
      game['game_id']
    end
  end


#---------------------------
  # private

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

#----------TeamStatsHelpers
  def average_of_wins_by_season(team_id)
    counts_by_season = {}
    unique_game_info(team_id).each do |season, games|
      counts_by_season[season] = {}
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
    results_by_season = {}
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
    result = {}
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
      game['home_team_id'] == team_id || game['away_team_id'] == team_id
    end
  end

  def game_info_by_team(team_id)
    game_teams.select do |game_team|
      game_team['team_id'] == team_id
    end
  end

  def result_totals_by_team(team_id)
    result = {}
    result[:total]  = game_info_by_team(team_id).length
    result[:wins]   = (result_totals_helper(team_id, "WIN")).length
    result[:ties]   = (result_totals_helper(team_id, "TIES")).length
    result[:losses] = (result_totals_helper(team_id, "LOSSES")).length
    result
  end

  def result_totals_helper(team_id, result)
    game_info_by_team(team_id).select do |game|
      game['result'] == result
    end
  end
end
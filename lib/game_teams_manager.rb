require_relative '../lib/findable'
require_relative '../lib/assistant_to_the_game_teams_manager'

class GameTeamsManager
  include Findable
  include AssistantToTheGameTeamsManager
  attr_reader :game_teams, :tracker
  def initialize(path, tracker)
    @game_teams = []
    @tracker = tracker
    create_game_teams(path)
  end

  def create_game_teams(path)
    game_teams_data = CSV.read(path, headers: true)
    @game_teams = game_teams_data.map do |data|
      GameTeams.new(data, self)
    end
  end
  #-------SeasonStats
  def winningest_coach(season)
    coaches_records(season).max_by do |_coach, w_l|
      w_l[:wins].to_f / (w_l[:wins] + w_l[:losses] + w_l[:ties])
    end[0]
  end

  def worst_coach(season)
    coaches_records(season).min_by do |_coach, w_l|
      w_l[:wins].to_f / (w_l[:wins] + w_l[:losses] + w_l[:ties])
    end[0]
  end

  def most_accurate_team(season)
    most_accurate_team_id = teams_shots_to_goals(season).max_by do |_id, s_g|
      s_g[:goals].to_f / s_g[:shots]
    end[0]
    find_team_by_team_id(most_accurate_team_id)
  end

  def least_accurate_team(season)
    least_accurate_team_id = teams_shots_to_goals(season).min_by do |_id, s_g|
      s_g[:goals].to_f / s_g[:shots]
    end[0]
    find_team_by_team_id(least_accurate_team_id)
  end

  def most_tackles(season)
    result_id = team_tackles(season).max_by { |_id, tackle_count| tackle_count }
    find_team_by_team_id(result_id[0])
  end

  def fewest_tackles(season)
    result_id = team_tackles(season).min_by { |_id, tackle_count| tackle_count }
    find_team_by_team_id(result_id[0])
  end

  def coaches_records(season)
    gt_results = game_teams_results_by_season(season)
    coach_record_start = start_coaches_records(gt_results)
    add_wins_losses(gt_results, coach_record_start)
  end

  def teams_shots_to_goals(season)
    gt_results = game_teams_results_by_season(season)
    teams_shots_to_goals_start = start_shots_and_goals_per_team(gt_results)
    add_shots_and_goals(gt_results, teams_shots_to_goals_start)
  end

  def team_tackles(season)
    gt_results = game_teams_results_by_season(season)
    tackles_start = start_tackles_per_team(gt_results)
    add_tackles(gt_results, tackles_start)
  end

  def start_coaches_records(gt_results)
    coach_record_hash = {}
    gt_results.each do |team_result|
      coach_record_hash[team_result.head_coach] = {wins: 0, losses: 0, ties:0}
    end
    coach_record_hash
  end
  #-------------GameStatistics
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
  #-------------TeamStats
  def best_season(team_id)
    best_season = win_percentage_by_season(team_id).max_by do |_season, wins_percent|
      wins_percent
    end
    best_year = best_season[0].to_i
    "#{best_year}201#{best_year.digits[0] + 1}"
  end

  def worst_season(team_id)
    worst_season = win_percentage_by_season(team_id).min_by do |_season, wins_percent|
      wins_percent
    end
    worst_year = worst_season[0].to_i
    "#{worst_year}201#{worst_year.digits[0] + 1}"
  end

  def average_win_percentage(team_id)
    (result_totals_by_team(team_id)[:wins] / result_totals_by_team(team_id)[:total].to_f).round(2)
  end

  def most_goals_scored(team_id)
    game_info_by_team(team_id).max_by do |game|
      game.goals.to_i
    end.goals.to_i
  end

  def fewest_goals_scored(team_id)
    game_info_by_team(team_id).min_by do |game|
      game.goals.to_i
    end.goals.to_i
  end

  def favorite_opponent(team_id)
    opponent = find_opponent_win_percentage(team_id).min_by do |_team_id, percentage|
      percentage
    end.first
    find_team_name(opponent)
  end

  def rival(team_id)
    opponent = find_opponent_win_percentage(team_id).max_by do |_team_id, percentage|
      percentage
    end.first
    find_team_name(opponent)
  end
end

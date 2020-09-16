module AssistantToTheGameTeamsManager
  # -------SeasonStatsHelpers
  def game_teams_results_by_season(season)
    game_teams.find_all do |team_result|
      team_result.game_id.start_with?(season[0..3])
    end
  end
  
  def add_wins_losses(gt_results, coach_record_start)
    gt_results.each do |team_result|
      if team_result.result == "WIN"
        coach_record_start[team_result.head_coach][:wins] += 1
      elsif team_result.result == "LOSS"
        coach_record_start[team_result.head_coach][:losses] += 1
      elsif team_result.result == "TIE"
        coach_record_start[team_result.head_coach][:ties] += 1
      end
    end
    coach_record_start
  end

  def start_shots_and_goals_per_team(gt_results)
    total_shots_goals = {}
    gt_results.each do |team_result|
      total_shots_goals[team_result.team_id] = { shots: 0, goals: 0 }
    end
    total_shots_goals
  end

  def add_shots_and_goals(gt_results, teams_shots_to_goals_start)
    gt_results.each do |team_result|
      teams_shots_to_goals_start[team_result.team_id][:shots] += team_result.shots.to_i
      teams_shots_to_goals_start[team_result.team_id][:goals] += team_result.goals.to_i
    end
    teams_shots_to_goals_start
  end

  def start_tackles_per_team(gt_results)
    tackles_per_team = {}
    gt_results.each do |team_result|
      tackles_per_team[team_result.team_id] = 0
    end
    tackles_per_team
  end

  def add_tackles(gt_results, tackles_start)
    gt_results.each do |team_result|
      tackles_start[team_result.team_id] += team_result.tackles.to_i
    end
    tackles_start
  end
#-------------TeamStatsHelpers
  def game_info_by_team(team_id)
    @game_teams.select do |game_team|
      game_team.team_id == team_id
    end
  end

  def team_games_by_season(team_id)
    team_games_by_season = {}
    game_info_by_team(team_id).each do |game|
      (team_games_by_season[game.game_id.to_s[0..3]] ||= []) << game
    end
    team_games_by_season
  end

  def win_percentage_by_season(team_id)
    wins = {}
    team_games_by_season(team_id).each do |season, games|
      total_games = 0
      total_wins = 0
      games.each do |game|
       total_wins += 1 if game.result == 'WIN'
       total_games += 1
        end
        wins[season] = (total_wins.to_f / total_games).round(3)
      end
    wins
  end

  def result_totals_by_team(team_id)
    result = {}
    result[:total]  = game_info_by_team(team_id).length
    result[:wins]   = (find_all_game_results(team_id, "WIN")).length
    result[:ties]   = (find_all_game_results(team_id, "TIE")).length
    result[:losses] = (find_all_game_results(team_id, "LOSS")).length
    result
  end

  def find_all_game_results(team_id, result)
    game_info_by_team(team_id).select do |game|
      game.result == result
    end
  end

  def find_opponent_games(team_id)
    game_ids = game_info_by_team(team_id).map(&:game_id)
    @game_teams.select do |game_team|
      game_ids.include?(game_team.game_id) && game_team.team_id != team_id
    end
  end

  def find_opponent_win_percentage(team_id)
    opponent_games_by_team = find_opponent_games(team_id).group_by(&:team_id)
    win_percentage = {}
    opponent_games_by_team.each do |team_id, game_teams|
      total = 0
      opponent_wins = game_teams.count {|game_teams| game_teams.result == 'WIN'}
      win_percentage[team_id] = total += (opponent_wins.to_f / game_teams.length).round(2)
    end
    win_percentage
  end

  def find_team_name(team_id)
    @tracker.team_info(team_id)['team_name']
  end

#-------------GameStatisticsHelpers
  def all_games
    @game_teams.find_all do |game|
      game.hoa == "away" || game.hoa == "home"
    end
  end

  def all_tie_games
    all_games.find_all do |game|
      game.result == "TIE"
    end
  end

  def all_away_games
    @game_teams.find_all do |game|
      game.hoa == "away"
    end
  end

  def all_away_game_wins
    all_away_games.find_all do |game|
      game.result == "WIN"
    end
  end

    def all_home_games
    @game_teams.find_all do |game|
      game.hoa == "home"
    end
  end

  def all_home_game_wins
    all_home_games.find_all do |game|
      game.result == "WIN"
    end
  end
end

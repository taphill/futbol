require 'csv'
require_relative '../lib/game_manager'
require_relative '../lib/team_manager'
require_relative '../lib/game_teams_manager'
require_relative '../lib/game'
require_relative '../lib/team'
require_relative '../lib/game_teams'

class StatTracker
  attr_reader :game_manager, :team_manager, :game_teams_manager

  def initialize(game_path, team_path, game_teams_path)
    @game_manager = GameManager.new(game_path, self)
    @team_manager = TeamManager.new(team_path, self)
    @game_teams_manager = GameTeamsManager.new(game_teams_path, self)
  end

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_teams_path = locations[:game_teams]

    new(game_path, team_path, game_teams_path)
  end

  # ----------SeasonStats

  def winningest_coach(season)
    @game_teams_manager.winningest_coach(season)
  end

  def find_game_ids_for_season(season)
    @game_manager.find_game_ids_for_season(season)
  end

    # game_manager = CSV.read(locations[:games], headers:true)
    # team_manager = CSV.read(locations[:teams], headers:true)
    # game_teams_manager = CSV.read(locations[:game_teams], headers:true)

#-------------TeamStats
  def team_info(team_id)
    @team_manager.team_info(team_id)
  end

  def best_season(team_id)
    @game_teams_manager.best_season(team_id)
  end

  def worst_season(team_id)
    @game_teams_manager.best_season(team_id)
  end

  def average_win_percentage(team_id)
    @game_teams_manager.average_win_percentage(team_id)
  end

#------------TeamStatsHelpers

end #this is the end of the class

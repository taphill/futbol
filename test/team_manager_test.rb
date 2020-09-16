# require 'minitest/autorun'
# require 'minitest/pride'
# require 'mocha/minitest'
# require './lib/stat_tracker'
# require './lib/team_manager'
require './test/test_helper'

class TeamManagerTest < Minitest::Test
  def setup
    @game_path = './fixture/games_dummy.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './fixture/game_teams_dummy.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of TeamManager, @stat_tracker.team_manager
  end

  def test_it_can_read_csv_data
    assert_equal '1', @stat_tracker.team_manager.teams[0].team_id
    assert_equal '23', @stat_tracker.team_manager.teams[0].franchise_id
    assert_equal 'Atlanta United', @stat_tracker.team_manager.teams[0].team_name
    assert_equal 'ATL', @stat_tracker.team_manager.teams[0].abbreviation
    assert_equal 'Mercedes-Benz Stadium', @stat_tracker.team_manager.teams[0].stadium
    assert_equal '/api/v1/teams/1', @stat_tracker.team_manager.teams[0].link
  end

  def test_it_can_return_team_stats_hash
    path = './fixture/team_blank.csv'
    team_manager = TeamManager.new(path, nil)

    team = mock('Team Object')
    team_manager.teams << team

    team.stubs(:team_id).returns('45')

    expected = {
      '45' => { total_games: 0, total_goals: 0, away_games: 0, home_games: 0,
                away_goals: 0, home_goals: 0 }
    }

    assert_equal expected, team_manager.initialize_team_stats_hash
  end

  def test_it_can_find_team_info
      expected = {
        'team_id'=> "4",
        'franchise_id'=>  "16",
        'team_name'=>  "Chicago Fire",
        'abbreviation'=>  "CHI",
        'link'=>  "/api/v1/teams/4"
      }
      assert_equal expected, @stat_tracker.team_manager.team_info("4")
  end
end

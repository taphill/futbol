require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def test_it_exists
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_instance_of StatTracker, stat_tracker
  end

#   def test_it_can_read_csv_data
#     game_path = './data/games_dummy.csv'
#     team_path = './data/teams_dummy.csv'
#     game_teams_path = './data/game_teams_dummy.csv'
#     locations = {
#       games: game_path,
#       teams: team_path,
#       game_teams: game_teams_path
#     }
#     stat_tracker = StatTracker.from_csv(locations)
#
#     assert_equal "2012030221", stat_tracker.games[0].game_id
#     # assert_equal [], stat_tracker.teams
#     # assert_equal [], stat_tracker.game_teams
#   end
#
#
# #---------GameStatisticsTests
#
  def test_it_can_find_highest_total_score
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 6, stat_tracker.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 3, stat_tracker.lowest_total_score
  end

  def test_it_knows_home_win_percentage
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0.67, stat_tracker.home_win_percentage
  end
#
#---------------LeagueStatisticsTests

  def test_it_can_count_of_teams
    game_path = './data/games_count_teams.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 8, stat_tracker.count_of_teams
  end
#
#   #--------------SeasonStatisticsTests
#   def test_it_can_find_winningest_coach
#     game_path = './data/games_dummy.csv'
#     team_path = './data/teams_dummy.csv'
#     game_teams_path = './data/game_teams_dummy.csv'
#
#     locations = {
#       games: game_path,
#       teams: team_path,
#       game_teams: game_teams_path
#     }
#     stat_tracker = StatTracker.from_csv(locations)
#
#     assert_equal "Claude Julien", stat_tracker.winningest_coach
#   end
#
#   def test_it_can_find_worst_coach
#     game_path = './data/games_dummy.csv'
#     team_path = './data/teams_dummy.csv'
#     game_teams_path = './data/game_teams_dummy.csv'
#     locations = {
#       games: game_path,
#       teams: team_path,
#       game_teams: game_teams_path
#     }
#     stat_tracker = StatTracker.from_csv(locations)
#     assert_equal "John Tortorella", stat_tracker.worst_coach
#   end


#---------TeamStatisticsTests
  def test_it_can_get_team_info
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    expected = {
      team_id: ["1", "4"],
      franchiseId: ["23", "16"],
      teamName: ["Atlanta United", "Chicago Fire"],
      abbreviation: ["ATL", "CHI"],
      link: ["/api/v1/teams/1", "/api/v1/teams/4"]
    }
    assert_equal expected, stat_tracker.team_info
  end
#----------------------------
end

require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  # def test_it_exists
  #   game_path = './data/games_dummy.csv'
  #   team_path = './data/teams_dummy.csv'
  #   game_teams_path = './data/game_teams_dummy.csv'
  #   locations = {
  #     games: game_path,
  #     teams: team_path,
  #     game_teams: game_teams_path
  #   }
  #   stat_tracker = StatTracker.from_csv(locations)
  #
  #   assert_instance_of StatTracker, stat_tracker
  # end

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
#   def test_it_can_find_highest_total_score
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
#     assert_equal 6, stat_tracker.highest_total_score
#   end
#
#   def test_it_can_find_lowest_total_score
#     game_path = './data/games_dummy.csv'
#     team_path = './data/teams_dummy.csv'
#     game_teams_path = './data/game_teams.csv'
#     locations = {
#       games: game_path,
#       teams: team_path,
#       game_teams: game_teams_path
#     }
#     stat_tracker = StatTracker.from_csv(locations)
#
#     assert_equal 3, stat_tracker.lowest_total_score
#   end
#
# #---------------LeagueStatisticsTests
#
#   def test_it_can_count_of_teams
#     game_path = './data/games_count_teams.csv'
#     team_path = './data/teams_dummy.csv'
#     game_teams_path = './data/game_teams.csv'
#
#     locations = {
#       games: game_path,
#       teams: team_path,
#       game_teams: game_teams_path
#     }
#     stat_tracker = StatTracker.from_csv(locations)
#
#     assert_equal 8, stat_tracker.count_of_teams
#   end
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
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    expected = {
      team_id: "4",
      franchise_id: "16",
      team_name: "Chicago Fire",
      abbreviation: "CHI",
      link: "/api/v1/teams/4"
    }
    assert_equal expected, stat_tracker.team_info("4")
  end

  def test_it_can_find_teams_best_season
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "20132014", stat_tracker.best_season("6")
  end

  def test_games_by_team
    skip
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    # expected = [<CSV::Row "game_id":"2012030231" "season":"20122013" "type":"Postseason" "date_time":"5/16/13" "away_team_id":"17" "home_team_id":"16" "away_goals":"1" "home_goals":"2" "venue":"Gillette Stadium" "venue_link":"/api/v1/venues/null">, <CSV::Row "game_id":"2012030232" "season":"20122013" "type":"Postseason" "date_time":"5/18/13" "away_team_id":"17" "home_team_id":"16" "away_goals":"2" "home_goals":"1" "venue":"Gillette Stadium" "venue_link":"/api/v1/venues/null">, <CSV::Row "game_id":"2012030233" "season":"20122013" "type":"Postseason" "date_time":"5/20/13" "away_team_id":"16" "home_team_id":"17" "away_goals":"1" "home_goals":"3" "venue":"Dignity Health Sports Park" "venue_link":"/api/v1/venues/null">, <CSV::Row "game_id":"2012030234" "season":"20122013" "type":"Postseason" "date_time":"5/24/13" "away_team_id":"16" "home_team_id":"17" "away_goals":"0" "home_goals":"2" "venue":"Dignity Health Sports Park" "venue_link":"/api/v1/venues/null">, <CSV::Row "game_id":"2012030235" "season":"20122013" "type":"Postseason" "date_time":"5/26/13" "away_team_id":"17" "home_team_id":"16" "away_goals":"1" "home_goals":"2" "venue":"Gillette Stadium" "venue_link":"/api/v1/venues/null">, <CSV::Row "game_id":"2012030236" "season":"20122013" "type":"Postseason" "date_time":"5/28/13" "away_team_id":"16" "home_team_id":"17" "away_goals":"2" "home_goals":"3" "venue":"Dignity Health Sports Park" "venue_link":"/api/v1/venues/null">, <CSV::Row "game_id":"2012030237" "season":"20122013" "type":"Postseason" "date_time":"5/30/13" "away_team_id":"17" "home_team_id":"16" "away_goals":"1" "home_goals":"2" "venue":"Gillette Stadium" "venue_link":"/api/v1/venues/null">]

    assert_equal expected, stat_tracker.games_by_team("16")
  end
#----------------------------
end

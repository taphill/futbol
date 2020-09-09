require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def test_it_exists
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
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
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 11, stat_tracker.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0, stat_tracker.lowest_total_score
  end

  def test_it_knows_home_win_percentage
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0.44, stat_tracker.percentage_home_wins
  end

  def test_it_knows_visitor_win_percentage
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0.36, stat_tracker.percentage_visitor_wins
  end

  def test_it_knows_tie_percentage
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0.20, stat_tracker.percentage_ties
  end
#
#---------------LeagueStatisticsTests

  def test_it_can_count_of_teams
    game_path = './fixture/games_count_teams.csv'
    team_path = './fixture/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 8, stat_tracker.count_of_teams
  end

  def test_it_can_find_the_best_offense
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Reign FC", stat_tracker.best_offense
  end

  def test_it_can_find_the_worst_offense
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Utah Royals FC", stat_tracker.worst_offense
  end

  def test_it_can_find_the_highest_scoring_visitor
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "FC Dallas", stat_tracker.highest_scoring_visitor
  end

  def test_it_can_find_the_highest_scoring_home_team
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Reign FC", stat_tracker.highest_scoring_home_team
  end

  def test_it_can_find_the_lowest_scoring_visitor
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "San Jose Earthquakes", stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_find_the_lowest_scoring_home_team
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Utah Royals FC", stat_tracker.lowest_scoring_home_team
  end
#   #--------------SeasonStatisticsTests
  def test_it_can_find_winningest_coach
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Claude Julien", stat_tracker.winningest_coach('20122013')
  end
#
  def test_it_can_find_worst_coach
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal "John Tortorella", stat_tracker.worst_coach('20122013')
  end

  def test_most_accurate_team
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal "FC Dallas", stat_tracker.most_accurate_team('20122013')
  end

  def test_least_accurate_team
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal "Sporting Kansas City", stat_tracker.least_accurate_team('20122013')
  end


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

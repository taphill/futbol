require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def test_it_exists
    game_path = './fixture/games_empty.csv'
    team_path = './fixture/teams_empty.csv'
    game_teams_path = './fixture/game_teams_empty.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_read_csv_games_data
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_empty.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal '2012030221', stat_tracker.games[0]['game_id']
    assert_equal '20122013', stat_tracker.games[0]['season']
    assert_equal 'Postseason', stat_tracker.games[0]['type']
    assert_equal '5/16/13', stat_tracker.games[0]['date_time']
    assert_equal '3', stat_tracker.games[0]['away_team_id']
    assert_equal '6', stat_tracker.games[0]['home_team_id']
    assert_equal '2', stat_tracker.games[0]['away_goals']
    assert_equal '3', stat_tracker.games[0]['home_goals']
    assert_equal 'Toyota Stadium', stat_tracker.games[0]['venue']
    assert_equal '/api/v1/venues/null', stat_tracker.games[0]['venue_link']
  end

  def test_it_can_read_csv_teams_data
    game_path = './fixture/games_empty.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal '1', stat_tracker.teams[0]['team_id']
    assert_equal '23', stat_tracker.teams[0]['franchiseId']
    assert_equal 'Atlanta United', stat_tracker.teams[0]['teamName']
    assert_equal 'ATL', stat_tracker.teams[0]['abbreviation']
    assert_equal 'Mercedes-Benz Stadium', stat_tracker.teams[0]['Stadium']
    assert_equal '/api/v1/teams/1', stat_tracker.teams[0]['link']
  end

  def test_it_can_read_csv_game_teams_data
    game_path = './fixture/games_empty.csv'
    team_path = './fixture/teams_empty.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal '2012030221', stat_tracker.game_teams[0]['game_id']
    assert_equal '3', stat_tracker.game_teams[0]['team_id']
    assert_equal 'away', stat_tracker.game_teams[0]['HoA']
    assert_equal 'LOSS', stat_tracker.game_teams[0]['result']
    assert_equal 'OT', stat_tracker.game_teams[0]['settled_in']
    assert_equal 'John Tortorella', stat_tracker.game_teams[0]['head_coach']
    assert_equal '2', stat_tracker.game_teams[0]['goals']
    assert_equal '8', stat_tracker.game_teams[0]['shots']
    assert_equal '44', stat_tracker.game_teams[0]['tackles']
    assert_equal '8', stat_tracker.game_teams[0]['pim']
    assert_equal '3', stat_tracker.game_teams[0]['powerPlayOpportunities']
    assert_equal '0', stat_tracker.game_teams[0]['powerPlayGoals']
    assert_equal '44.8', stat_tracker.game_teams[0]['faceOffWinPercentage']
    assert_equal '17', stat_tracker.game_teams[0]['giveaways']
    assert_equal '7', stat_tracker.game_teams[0]['takeaways']
  end

#---------GameStatisticsTests
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

  def test_it_can_count_games_by_season
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    expected = {
      "20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355
    }
    assert_equal expected, stat_tracker.count_of_games_by_season
  end

  def test_it_knows_average_goals_per_game
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 4.22, stat_tracker.average_goals_per_game
  end

  def test_it_knows_average_goals_by_season
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    expected = {
    "20122013"=>4.12,
    "20162017"=>4.23,
    "20142015"=>4.14,
    "20152016"=>4.16,
    "20132014"=>4.19,
    "20172018"=>4.44
  }
    assert_equal expected, stat_tracker.average_goals_by_season
  end

#---------------LeagueStatisticsTests
  def test_it_can_count_teams
    game_path = './fixture/games_count_teams.csv'
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 8, stat_tracker.count_of_teams
  end

  def test_it_can_find_the_best_offense
    game_path = './fixture/game_league_stats_dummy.csv'
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "FC Dallas", stat_tracker.best_offense
  end

  def test_it_can_find_the_worst_offense
    game_path = './fixture/game_league_stats_dummy.csv'
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Houston Dash", stat_tracker.worst_offense
  end

  def test_it_can_find_the_highest_scoring_visitor
    game_path = './fixture/game_league_stats_dummy.csv'
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Washington Spirit FC", stat_tracker.highest_scoring_visitor
  end

  def test_it_can_find_the_highest_scoring_home_team
    game_path = './fixture/game_league_stats_dummy.csv'
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "FC Dallas", stat_tracker.highest_scoring_home_team
  end

  def test_it_can_find_the_lowest_scoring_visitor
    game_path = './fixture/game_league_stats_dummy.csv'
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Toronto FC", stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_find_the_lowest_scoring_home_team
    game_path = './fixture/game_league_stats_dummy.csv'
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_empty.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "New York City FC", stat_tracker.lowest_scoring_home_team
  end

#--------------SeasonStatisticsTests
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

  def test_team_with_most_tackles
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal "FC Dallas", stat_tracker.most_tackles('20122013')
  end

  def test_team_with_fewest_tackles
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal "Sporting Kansas City", stat_tracker.fewest_tackles('20122013')
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
      'team_id'=> "4",
      'franchise_id'=>  "16",
      'team_name'=>  "Chicago Fire",
      'abbreviation'=>  "CHI",
      'link'=>  "/api/v1/teams/4"
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

  def test_it_can_find_teams_worst_season
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "20142015", stat_tracker.worst_season("6")
  end

  def test_it_can_find_average_percentage
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0.49, stat_tracker.average_win_percentage("6")
  end

  def test_it_can_find_most_goals
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 7, stat_tracker.most_goals_scored("18")
  end

  def test_it_can_find_least_goals
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0, stat_tracker.fewest_goals_scored("18")
  end

  def test_it_can_find_fave_opponent
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "DC United", stat_tracker.favorite_opponent("18")
  end
end

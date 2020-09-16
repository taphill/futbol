# require 'minitest/autorun'
# require 'minitest/pride'
# require 'mocha/minitest'
# require './lib/stat_tracker'
require './test/test_helper'

class StatTrackerTest < Minitest::Test
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
    assert_instance_of StatTracker, @stat_tracker
  end

# ---------SeasonStatsTests
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
    team_path = './data/teams.csv'
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
    team_path = './data/teams.csv'
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
    team_path = './data/teams.csv'
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
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal "Sporting Kansas City", stat_tracker.fewest_tackles('20122013')
  end

#---------------LeagueStatisticsTests
  def test_it_can_return_team_stats_hash
    game_path = './fixture/game_blank.csv'
    team_path = './fixture/team_blank.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

    tracker = StatTracker.new(game_path, team_path, game_teams_path)

    team = mock('Team Object')
    tracker.team_manager.teams << team

    team.stubs(:team_id).returns('45')

    expected = {
      '45' => { total_games: 0, total_goals: 0, away_games: 0, home_games: 0,
                away_goals: 0, home_goals: 0 }
    }

    assert_equal expected, tracker.initialize_team_stats_hash
  end

  def test_it_can_count_teams
    game_path = './fixture/games_count_teams.csv'
    team_path = './fixture/team_blank.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 8, stat_tracker.count_of_teams
  end


#----------------GameStatistics

  def test_it_can_find_highest_total_score
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

     locations = {
       games: game_path,
       teams: team_path,
       game_teams: game_teams_path
     }
     stat_tracker = StatTracker.from_csv(locations)

    assert_equal 5, stat_tracker.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

     locations = {
       games: game_path,
       teams: team_path,
       game_teams: game_teams_path
     }
     stat_tracker = StatTracker.from_csv(locations)

    assert_equal 1, stat_tracker.lowest_total_score
  end

  def test_it_can_find_percentage_home_wins
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

     locations = {
       games: game_path,
       teams: team_path,
       game_teams: game_teams_path
     }
     stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0.69, stat_tracker.percentage_home_wins
  end

  def test_it_can_find_percentage_visitor_wins
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

     locations = {
       games: game_path,
       teams: team_path,
       game_teams: game_teams_path
     }
     stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0.31, stat_tracker.percentage_visitor_wins
  end

  def test_it_can_find_percentage_ties
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

     locations = {
       games: game_path,
       teams: team_path,
       game_teams: game_teams_path
     }
     stat_tracker = StatTracker.from_csv(locations)

    assert_equal 0.0, stat_tracker.percentage_ties
  end

  def test_it_can_find_count_of_games_by_season
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

     locations = {
       games: game_path,
       teams: team_path,
       game_teams: game_teams_path
     }
     stat_tracker = StatTracker.from_csv(locations)
     expected = {"20122013"=>16}
    assert_equal expected, stat_tracker.count_of_games_by_season
  end

  def test_it_can_find_average_goals_per_game
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

     locations = {
       games: game_path,
       teams: team_path,
       game_teams: game_teams_path
     }
     stat_tracker = StatTracker.from_csv(locations)

    assert_equal 3.56, stat_tracker.average_goals_per_game
  end

  def test_it_can_find_average_goals_by_season
    game_path = './fixture/games_dummy.csv'
    team_path = './fixture/teams_dummy.csv'
    game_teams_path = './fixture/game_teams_dummy.csv'

     locations = {
       games: game_path,
       teams: team_path,
       game_teams: game_teams_path
     }
     stat_tracker = StatTracker.from_csv(locations)
     expected = {"20122013"=>3.56}

    assert_equal expected, stat_tracker.average_goals_by_season
  end

  def test_it_can_find_best_offense
    game_path = './fixture/game_league_stats_dummy.csv'
    team_path = './data/teams.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

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
    game_teams_path = './fixture/game_teams_blank.csv'

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
    game_teams_path = './fixture/game_teams_blank.csv'

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
    game_teams_path = './fixture/game_teams_blank.csv'

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
    game_teams_path = './fixture/game_teams_blank.csv'

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
    game_teams_path = './fixture/game_teams_blank.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "New York City FC", stat_tracker.lowest_scoring_home_team
  end

# --------TeamStats
  def test_it_can_find_team_info
    game_path = './fixture/game_blank.csv'
    team_path = './fixture/team_blank.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

    tracker = StatTracker.new(game_path, team_path, game_teams_path)
    team_1 = mock("Team 1")

    tracker.team_manager.teams << team_1

    team_1.stubs(:team_id).returns('7')
    team_1.stubs(:franchise_id).returns('12')
    team_1.stubs(:team_name).returns('The Best')
    team_1.stubs(:abbreviation).returns('BES')
    team_1.stubs(:link).returns('linkgoeshere')

    expected = {
      'team_id'=> "7",
      'franchise_id'=>  "12",
      'team_name'=>  "The Best",
      'abbreviation'=>  "BES",
      'link'=>  "linkgoeshere"
    }

   assert_equal expected, tracker.team_info("7")
 end

 def test_it_can_find_best_season
   assert_equal "20122013", @stat_tracker.best_season("6")
 end

 def test_it_can_find_worst_season
   assert_equal "20122013", @stat_tracker.worst_season("6")
 end

 def test_it_can_find_average_win_percentage
   assert_equal 1.0, @stat_tracker.average_win_percentage("6")
   assert_equal 0.43, @stat_tracker.average_win_percentage('16')
 end

 def test_it_can_find_most_and_fewest_goals_scored
   game_path = './fixture/game_blank.csv'
   team_path = './fixture/team_blank.csv'
   game_teams_path = './fixture/game_teams_blank.csv'

   tracker = StatTracker.new(game_path, team_path, game_teams_path)
   game_teams_1 = mock("Game Team Object 1")
   game_teams_2 = mock("Game Team Object 2")
   game_teams_3 = mock("Game Team Object 3")
   game_teams_4 = mock("Game Team Object 4")
   tracker.game_teams_manager.game_teams << game_teams_1
   tracker.game_teams_manager.game_teams << game_teams_2
   tracker.game_teams_manager.game_teams << game_teams_3
   tracker.game_teams_manager.game_teams << game_teams_4
   game_teams_1.stubs(:team_id).returns('123')
   game_teams_2.stubs(:team_id).returns('123')
   game_teams_3.stubs(:team_id).returns('123')
   game_teams_4.stubs(:team_id).returns('987')
   game_teams_1.stubs(:goals).returns('3')
   game_teams_2.stubs(:goals).returns('1')
   game_teams_3.stubs(:goals).returns('2')
   game_teams_4.stubs(:goals).returns('2')

   assert_equal 3, tracker.most_goals_scored('123')
   assert_equal 2, tracker.most_goals_scored('987')
   assert_equal 1, tracker.fewest_goals_scored('123')
   assert_equal 2, tracker.fewest_goals_scored('987')
 end

 def test_it_can_find_favorite_opponent
   assert_equal 'LA Galaxy', @stat_tracker.favorite_opponent('16')
 end

 def test_it_can_find_rival
   assert_equal 'FC Dallas', @stat_tracker.rival('3')
 end
end

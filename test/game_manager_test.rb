require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'


class GameManagerTest < Minitest::Test
  def setup
    @game_path = './fixture/games_dummy.csv'
    @team_path = './fixture/teams_dummy.csv'
    @game_teams_path = './fixture/game_teams_dummy.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of GameManager, @stat_tracker.game_manager
  end

  def test_it_can_read_csv_games_data
    assert_equal '2012030221', @stat_tracker.game_manager.games[0].game_id
    assert_equal '20122013', @stat_tracker.game_manager.games[0].season
    assert_equal 'Postseason', @stat_tracker.game_manager.games[0].type
    assert_equal '5/16/13', @stat_tracker.game_manager.games[0].date_time
    assert_equal '3', @stat_tracker.game_manager.games[0].away_team_id
    assert_equal '6', @stat_tracker.game_manager.games[0].home_team_id
    assert_equal '2', @stat_tracker.game_manager.games[0].away_goals
    assert_equal '3', @stat_tracker.game_manager.games[0].home_goals
    assert_equal 'Toyota Stadium', @stat_tracker.game_manager.games[0].venue
    assert_equal '/api/v1/venues/null', @stat_tracker.game_manager.games[0].venue_link
  end

  def test_it_finds_game_of_season
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:season).returns('20122013')
    game_2.stubs(:season).returns('20122013')
    game_3.stubs(:season).returns('20132014')
    assert_equal [game_1, game_2], game_manager.games_of_season('20122013')
  end

  def test_find_game_ids_per_season
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:season).returns('20122013')
    game_2.stubs(:season).returns('20122013')
    game_3.stubs(:season).returns('20132014')
    game_1.stubs(:game_id).returns('123')
    game_2.stubs(:game_id).returns('456')
    game_3.stubs(:game_id).returns('789')

    assert_equal ["123", "456"], game_manager.find_game_ids_for_season('20122013')
  end


#----------GameStatistics

  def test_it_can_find_highest_total_score
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:away_goals).returns(6)
    game_1.stubs(:home_goals).returns(5)
    game_2.stubs(:away_goals).returns(3)
    game_2.stubs(:home_goals).returns(2)
    game_3.stubs(:away_goals).returns(0)
    game_3.stubs(:home_goals).returns(0)

    assert_equal 11, game_manager.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:away_goals).returns(6)
    game_1.stubs(:home_goals).returns(5)
    game_2.stubs(:away_goals).returns(7)
    game_2.stubs(:home_goals).returns(7)
    game_3.stubs(:away_goals).returns(0)
    game_3.stubs(:home_goals).returns(0)

    assert_equal 0, game_manager.lowest_total_score

  end

  def test_it_can_count_games_by_season
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:season).returns('20122013')
    game_2.stubs(:season).returns('20122013')
    game_3.stubs(:season).returns('20132014')

    expected = {"20122013"=>2, "20132014"=>1}
    assert_equal expected, game_manager.count_of_games_by_season
  end

  def test_it_knows_games_by_season
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:season).returns('20122013')
    game_2.stubs(:season).returns('20122013')
    game_3.stubs(:season).returns('20132014')

    expected = {"20122013"=>[game_1, game_2], "20132014"=>[game_3]}
    assert_equal expected, game_manager.games_by_season
  end

  def test_it_knows_average_goals_per_game
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:away_goals).returns(6)
    game_1.stubs(:home_goals).returns(5)
    game_2.stubs(:away_goals).returns(7)
    game_2.stubs(:home_goals).returns(7)
    game_3.stubs(:away_goals).returns(0)
    game_3.stubs(:home_goals).returns(0)

    assert_equal 8.33, game_manager.average_goals_per_game
  end

  def test_it_knows_total_goals
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:away_goals).returns(6)
    game_1.stubs(:home_goals).returns(5)
    game_2.stubs(:away_goals).returns(7)
    game_2.stubs(:home_goals).returns(7)
    game_3.stubs(:away_goals).returns(0)
    game_3.stubs(:home_goals).returns(0)

    assert_equal 25, game_manager.total_goals
  end

  def test_it_knows_total_number_of_games
    path = './fixture/game_blank.csv'
    game_manager = GameManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_manager.games << game_1
    game_manager.games << game_2
    game_manager.games << game_3

    game_1.stubs(:away_goals).returns(6)
    game_1.stubs(:home_goals).returns(5)
    game_2.stubs(:away_goals).returns(7)
    game_2.stubs(:home_goals).returns(7)
    game_3.stubs(:away_goals).returns(0)
    game_3.stubs(:home_goals).returns(0)

    assert_equal 3, game_manager.total_number_of_games
  end

  def test_it_knows_average_goals_by_season
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

    assert_equal expected, stat_tracker.game_manager.average_goals_by_season
  end

  def test_it_can_initialize_season_information_hash
      game_path = './fixture/games_dummy.csv'
      team_path = './fixture/teams_dummy.csv'
      game_teams_path = './fixture/game_teams_dummy.csv'
      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)

      expected = {"20122013"=>{:total_goals=>0, :away_goals=>0, :home_goals=>0, :total_games=>0}}

    assert_equal expected, stat_tracker.game_manager.initialize_season_information_hash
  end

  def test_it_knows_aseason_information
      game_path = './fixture/games_dummy.csv'
      team_path = './fixture/teams_dummy.csv'
      game_teams_path = './fixture/game_teams_dummy.csv'
      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)

      expected = {"20122013"=>{:total_goals=>57, :away_goals=>26, :home_goals=>31, :total_games=>16}}

    assert_equal expected, stat_tracker.game_manager.season_information
  end

end

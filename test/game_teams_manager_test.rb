# require 'minitest/autorun'
# require 'minitest/pride'
# require 'mocha/minitest'
# require './lib/stat_tracker'
# require './lib/game_teams_manager'
require './test/test_helper'

class GameTeamsManagerTest < Minitest::Test
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
    assert_instance_of GameTeamsManager, @stat_tracker.game_teams_manager
  end

  def test_find_team_results_by_season
    game_path = './fixture/game_blank.csv'
    team_path = './fixture/team_blank.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

    tracker = StatTracker.new(game_path, team_path, game_teams_path)

    game_teams_1 = mock("Game Team Object 1")
    game_teams_2 = mock("Game Team Object 2")
    game_teams_3 = mock("Game Team Object 3")

    tracker.game_teams_manager.game_teams << game_teams_1
    tracker.game_teams_manager.game_teams << game_teams_2
    tracker.game_teams_manager.game_teams << game_teams_3

    game_teams_1.stubs(:game_id).returns('2012030221')
    game_teams_2.stubs(:game_id).returns('2012030235')
    game_teams_3.stubs(:game_id).returns('2014030314')

    assert_equal [game_teams_1, game_teams_2], tracker.game_teams_manager.game_teams_results_by_season('20122013')
  end

  # -----------SeasonStats

  def test_initialize_coaches_records
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    expected = {"John Tortorella"=>{:wins=>0, :losses=>0, :ties=>0},
              "Claude Julien"=>{:wins=>0, :losses=>0, :ties=>0}, "Dan Bylsma"=>{:wins=>0, :losses=>0, :ties=>0},
              "Mike Babcock"=>{:wins=>0, :losses=>0, :ties=>0}, "Joel Quenneville"=>{:wins=>0, :losses=>0, :ties=>0}}
    assert_equal expected, @stat_tracker.game_teams_manager.start_coaches_records(results)
  end

  def test_add_wins_losses
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    coach_record_start = @stat_tracker.game_teams_manager.start_coaches_records(results)
    expected = {"John Tortorella"=>{:wins=>0, :losses=>5, :ties=>0}, "Claude Julien"=>{:wins=>9, :losses=>0, :ties=>0},
                "Dan Bylsma"=>{:wins=>0, :losses=>4, :ties=>0}, "Mike Babcock"=>{:wins=>4, :losses=>3, :ties=>0},
                "Joel Quenneville"=>{:wins=>3, :losses=>4, :ties=>0}}
    assert_equal expected, @stat_tracker.game_teams_manager.add_wins_losses(results, coach_record_start)
  end

  def test_winningest_coach
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    coach_record_start = @stat_tracker.game_teams_manager.start_coaches_records(results)
    total_record = @stat_tracker.game_teams_manager.add_wins_losses(results, coach_record_start)
    assert_equal "Claude Julien", @stat_tracker.game_teams_manager.winningest_coach('20122013')
  end

  def test_worst_coach
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    coach_record_start = @stat_tracker.game_teams_manager.start_coaches_records(results)
    total_record = @stat_tracker.game_teams_manager.add_wins_losses(results, coach_record_start)
    assert_equal "John Tortorella", @stat_tracker.game_teams_manager.worst_coach('20122013')
  end

  def test_it_knows_home_win_percentage
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns("home")
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal 1.0, game_teams_manager.percentage_home_wins
  end

  def test_it_knows_all_home_games
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns("home")
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal [game_1], game_teams_manager.all_home_games
  end

  def test_it_knows_all_home_game_wins
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns("home")
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal [game_1], game_teams_manager.all_home_game_wins
  end

  def test_it_knows_visitor_win_percentage
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns(6)
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal 0.5, game_teams_manager.percentage_visitor_wins
  end

  def test_it_knows_all_away_games
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns(6)
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal [game_2, game_3], game_teams_manager.all_away_games
  end

  def test_it_knows_all_away_game_wins
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns(6)
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal [game_2], game_teams_manager.all_away_game_wins
  end

  def test_it_knows_tie_percentage
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns("home")
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal 0.0, game_teams_manager.percentage_ties
  end

  def test_it_knows_all_games
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns("home")
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal [game_1, game_2, game_3], game_teams_manager.all_games
  end

  def test_it_knows_all_tie_games
    path = './fixture/game_teams_blank.csv'
    game_teams_manager = GameTeamsManager.new(path, nil)
    game_1 = mock("Season Game 1")
    game_2 = mock("Season Game 2")
    game_3 = mock("Season Game 3")
    game_teams_manager.game_teams << game_1
    game_teams_manager.game_teams << game_2
    game_teams_manager.game_teams << game_3

    game_1.stubs(:hoa).returns("home")
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:hoa).returns("away")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:hoa).returns("away")
    game_3.stubs(:result).returns("LOSS")

    assert_equal [], game_teams_manager.all_tie_games
  end

  def test_initialize_shots_and_goals_per_team
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    expected = {"3"=>{:shots=>0, :goals=>0}, "6"=>{:shots=>0, :goals=>0}, "5"=>{:shots=>0, :goals=>0},
                "17"=>{:shots=>0, :goals=>0}, "16"=>{:shots=>0, :goals=>0}}
    assert_equal expected, @stat_tracker.game_teams_manager.start_shots_and_goals_per_team(results)
  end

  def test_add_shots_and_goals
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    teams_shots_to_goals_start = @stat_tracker.game_teams_manager.start_shots_and_goals_per_team(results)
    expected = {"3"=>{:shots=>38, :goals=>8}, "6"=>{:shots=>76, :goals=>24}, "5"=>{:shots=>32, :goals=>2},
                "17"=>{:shots=>46, :goals=>13}, "16"=>{:shots=>58, :goals=>10}}
    assert_equal expected, @stat_tracker.game_teams_manager.add_shots_and_goals(results, teams_shots_to_goals_start)
  end

  def test_most_accurate_team
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    teams_shots_to_goals_start = @stat_tracker.game_teams_manager.start_shots_and_goals_per_team(results)
    total_shot_goals_record = @stat_tracker.game_teams_manager.add_shots_and_goals(results, teams_shots_to_goals_start)
    assert_equal "FC Dallas", @stat_tracker.game_teams_manager.most_accurate_team('20122013')
  end

  def test_least_accurate_team
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    teams_shots_to_goals_start = @stat_tracker.game_teams_manager.start_shots_and_goals_per_team(results)
    total_shot_goals_record = @stat_tracker.game_teams_manager.add_shots_and_goals(results, teams_shots_to_goals_start)
    assert_equal "Sporting Kansas City", @stat_tracker.game_teams_manager.least_accurate_team('20122013')
  end

  def test_initialize_tackles_per_team
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    expected = {"3"=>0, "6"=>0, "5"=>0, "17"=>0, "16"=>0}
    assert_equal expected, @stat_tracker.game_teams_manager.start_tackles_per_team(results)
  end

  def test_add_tackles
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    tackles_start = @stat_tracker.game_teams_manager.start_tackles_per_team(results)
    expected = {"3"=>179, "6"=>271, "5"=>150, "17"=>219, "16"=>178}
    assert_equal expected, @stat_tracker.game_teams_manager.add_tackles(results, tackles_start)
  end

  def test_team_with_most_tackles
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    tackles_start = @stat_tracker.game_teams_manager.start_tackles_per_team(results)
    added_tackles = @stat_tracker.game_teams_manager.add_tackles(results, tackles_start)
    assert_equal "FC Dallas", @stat_tracker.game_teams_manager.most_tackles('20122013')
  end

  def test_team_with_fewest_tackles
    results = @stat_tracker.game_teams_manager.game_teams_results_by_season('20122013')
    tackles_start = @stat_tracker.game_teams_manager.start_tackles_per_team(results)
    added_tackles = @stat_tracker.game_teams_manager.add_tackles(results, tackles_start)
    assert_equal "Sporting Kansas City", @stat_tracker.game_teams_manager.fewest_tackles('20122013')
  end

  def test_coaches_records
    expected = {"John Tortorella"=>{:wins=>0, :losses=>5, :ties=>0},
                "Claude Julien"=>{:wins=>9, :losses=>0, :ties=>0},
                "Dan Bylsma"=>{:wins=>0, :losses=>4, :ties=>0},
                "Mike Babcock"=>{:wins=>4, :losses=>3, :ties=>0},
                "Joel Quenneville"=>{:wins=>3, :losses=>4, :ties=>0}}
    assert_equal expected, @stat_tracker.game_teams_manager.coaches_records('20122013')
  end

  def test_teams_shots_to_goals
    expected = {"3"=>{:shots=>38, :goals=>8}, "6"=>{:shots=>76, :goals=>24},
                "5"=>{:shots=>32, :goals=>2}, "17"=>{:shots=>46, :goals=>13}, "16"=>{:shots=>58, :goals=>10}}
    assert_equal expected, @stat_tracker.game_teams_manager.teams_shots_to_goals('20122013')
  end

  def test_team_tackles
    expected = {"3"=>179, "6"=>271, "5"=>150, "17"=>219, "16"=>178}
    assert_equal expected, @stat_tracker.game_teams_manager.team_tackles('20122013')
  end
#------------TeamStatsTests

  def test_it_can_find_game_info_by_team
    game_path = './fixture/game_blank.csv'
    team_path = './fixture/team_blank.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

    tracker = StatTracker.new(game_path, team_path, game_teams_path)
    game_teams_1 = mock("Game Team Object 1")
    game_teams_2 = mock("Game Team Object 2")
    game_teams_3 = mock("Game Team Object 3")
    tracker.game_teams_manager.game_teams << game_teams_1
    tracker.game_teams_manager.game_teams << game_teams_2
    tracker.game_teams_manager.game_teams << game_teams_3
    game_teams_1.stubs(:team_id).returns('123')
    game_teams_2.stubs(:team_id).returns('987')
    game_teams_3.stubs(:team_id).returns('123')

    assert_equal [game_teams_1, game_teams_3], tracker.game_teams_manager.game_info_by_team('123')
  end

  def test_it_can_find_team_games_by_season
    game_path = './fixture/game_blank.csv'
    team_path = './fixture/team_blank.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

    tracker = StatTracker.new(game_path, team_path, game_teams_path)
    game_teams_1 = mock("Game Team Object 1")
    game_teams_2 = mock("Game Team Object 2")
    game_teams_3 = mock("Game Team Object 3")
    tracker.game_teams_manager.game_teams << game_teams_1
    tracker.game_teams_manager.game_teams << game_teams_2
    tracker.game_teams_manager.game_teams << game_teams_3
    game_teams_1.stubs(:team_id).returns('123')
    game_teams_2.stubs(:team_id).returns('987')
    game_teams_3.stubs(:team_id).returns('123')
    game_teams_1.stubs(:game_id).returns('2012030221')
    game_teams_2.stubs(:game_id).returns('2012030221')
    game_teams_3.stubs(:game_id).returns('2013030221')

    expected = {"2012"=>[game_teams_1], "2013" => [game_teams_3]}
    assert_equal expected, tracker.game_teams_manager.team_games_by_season('123')
  end

  def test_it_can_find_wins_percentage_by_season
    assert_equal ({"2012" => 1.0}), @stat_tracker.game_teams_manager.win_percentage_by_season('6')
  end

  def test_it_can_find_best_season
    assert_equal "20122013", @stat_tracker.game_teams_manager.best_season("6")
  end

  def test_it_can_find_worst_season
    assert_equal "20122013", @stat_tracker.game_teams_manager.worst_season("6")
  end

  def test_it_can_find_all_game_results
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
    game_teams_1.stubs(:result).returns('WIN')
    game_teams_2.stubs(:result).returns('LOSS')
    game_teams_3.stubs(:result).returns('WIN')
    game_teams_4.stubs(:result).returns('TIE')

    assert_equal [game_teams_1, game_teams_3], tracker.game_teams_manager.find_all_game_results('123', 'WIN')
    assert_equal [game_teams_2], tracker.game_teams_manager.find_all_game_results('123', 'LOSS')
    assert_equal [game_teams_4], tracker.game_teams_manager.find_all_game_results('987', 'TIE')
  end

  def test_it_can_find_result_totals_by_team
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
    game_teams_1.stubs(:result).returns('WIN')
    game_teams_2.stubs(:result).returns('LOSS')
    game_teams_3.stubs(:result).returns('WIN')
    game_teams_4.stubs(:result).returns('TIE')

    assert_equal ({:total => 3, :wins => 2, :ties => 0, :losses => 1}), tracker.game_teams_manager.result_totals_by_team('123')
    assert_equal ({:total => 1, :wins => 0, :ties => 1, :losses => 0}), tracker.game_teams_manager.result_totals_by_team('987')
  end

  def test_it_can_find_average_win_percentage
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
    game_teams_1.stubs(:result).returns('WIN')
    game_teams_2.stubs(:result).returns('LOSS')
    game_teams_3.stubs(:result).returns('WIN')
    game_teams_4.stubs(:result).returns('TIE')

    assert_equal 0.67, tracker.game_teams_manager.average_win_percentage('123')
    assert_equal 0.0, tracker.game_teams_manager.average_win_percentage('987')
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

    assert_equal 3, tracker.game_teams_manager.most_goals_scored('123')
    assert_equal 2, tracker.game_teams_manager.most_goals_scored('987')
    assert_equal 1, tracker.game_teams_manager.fewest_goals_scored('123')
    assert_equal 2, tracker.game_teams_manager.fewest_goals_scored('987')
  end

  def test_it_can_find_opponent_games
    game_path = './fixture/game_blank.csv'
    team_path = './fixture/team_blank.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

    tracker = StatTracker.new(game_path, team_path, game_teams_path)
    game_teams_1 = mock("Game Team Object 1")
    game_teams_2 = mock("Game Team Object 2")
    game_teams_3 = mock("Game Team Object 3")
    game_teams_4 = mock("Game Team Object 4")
    game_teams_5 = mock("Game Team Object 5")
    game_teams_6 = mock("Game Team Object 6")
    tracker.game_teams_manager.game_teams << game_teams_1
    tracker.game_teams_manager.game_teams << game_teams_2
    tracker.game_teams_manager.game_teams << game_teams_3
    tracker.game_teams_manager.game_teams << game_teams_4
    tracker.game_teams_manager.game_teams << game_teams_5
    tracker.game_teams_manager.game_teams << game_teams_6

    game_teams_1.stubs(:team_id).returns('123')
    game_teams_2.stubs(:team_id).returns('123')
    game_teams_3.stubs(:team_id).returns('456')
    game_teams_4.stubs(:team_id).returns('987')
    game_teams_5.stubs(:team_id).returns('456')
    game_teams_6.stubs(:team_id).returns('123')
    game_teams_1.stubs(:game_id).returns('2012030221')
    game_teams_2.stubs(:game_id).returns('2012030222')
    game_teams_3.stubs(:game_id).returns('2012030221')
    game_teams_4.stubs(:game_id).returns('2012030222')
    game_teams_5.stubs(:game_id).returns('2012030223')
    game_teams_6.stubs(:game_id).returns('2012030224')

    expected = [game_teams_3, game_teams_4]
    assert_equal expected, tracker.game_teams_manager.find_opponent_games('123')
  end

  def test_it_can_find_opponent_win_percentage
    game_path = './fixture/game_blank.csv'
    team_path = './fixture/team_blank.csv'
    game_teams_path = './fixture/game_teams_blank.csv'

    tracker = StatTracker.new(game_path, team_path, game_teams_path)
    game_teams_1 = mock("Game Team Object 1")
    game_teams_2 = mock("Game Team Object 2")
    game_teams_3 = mock("Game Team Object 3")
    game_teams_4 = mock("Game Team Object 4")
    game_teams_5 = mock("Game Team Object 5")
    game_teams_6 = mock("Game Team Object 6")
    tracker.game_teams_manager.game_teams << game_teams_1
    tracker.game_teams_manager.game_teams << game_teams_2
    tracker.game_teams_manager.game_teams << game_teams_3
    tracker.game_teams_manager.game_teams << game_teams_4
    tracker.game_teams_manager.game_teams << game_teams_5
    tracker.game_teams_manager.game_teams << game_teams_6

    game_teams_1.stubs(:team_id).returns('123')
    game_teams_2.stubs(:team_id).returns('123')
    game_teams_3.stubs(:team_id).returns('456')
    game_teams_4.stubs(:team_id).returns('987')
    game_teams_5.stubs(:team_id).returns('456')
    game_teams_6.stubs(:team_id).returns('123')
    game_teams_1.stubs(:game_id).returns('2012030221')
    game_teams_2.stubs(:game_id).returns('2012030222')
    game_teams_3.stubs(:game_id).returns('2012030221')
    game_teams_4.stubs(:game_id).returns('2012030222')
    game_teams_5.stubs(:game_id).returns('2012030224')
    game_teams_6.stubs(:game_id).returns('2012030224')
    game_teams_1.stubs(:result).returns('LOSS')
    game_teams_2.stubs(:result).returns('LOSS')
    game_teams_3.stubs(:result).returns('WIN')
    game_teams_4.stubs(:result).returns('WIN')
    game_teams_5.stubs(:result).returns('WIN')
    game_teams_6.stubs(:result).returns('LOSS')

    assert_equal ({'456'=>1.0, '987'=>1.0}), tracker.game_teams_manager.find_opponent_win_percentage('123')
  end

  def test_it_finds_favorite_opponent
    assert_equal 'Houston Dynamo', @stat_tracker.game_teams_manager.favorite_opponent('6')
  end

  def test_it_finds_rival
    assert_equal 'Houston Dynamo', @stat_tracker.game_teams_manager.rival('6')
  end
end

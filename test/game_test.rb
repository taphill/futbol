# require 'minitest/autorun'
# require 'minitest/pride'
# require 'mocha/minitest'
# require './lib/stat_tracker'
# require './lib/game_manager'
# require './lib/game'
require './test/test_helper'

class GameTest < Minitest::Test
  def setup
    @game_path = './fixture/games_dummy.csv'

    @game_manager = GameManager.new(@game_path,nil)
  end

  def test_it_exists
    assert_instance_of Game, @game_manager.games[0]
  end

  def test_it_has_attributes
    assert_equal '2012030221', @game_manager.games[0].game_id
    assert_equal '20122013', @game_manager.games[0].season
    assert_equal 'Postseason', @game_manager.games[0].type
    assert_equal '5/16/13', @game_manager.games[0].date_time
    assert_equal '3', @game_manager.games[0].away_team_id
    assert_equal '6', @game_manager.games[0].home_team_id
    assert_equal '2', @game_manager.games[0].away_goals
    assert_equal '3', @game_manager.games[0].home_goals
    assert_equal 'Toyota Stadium', @game_manager.games[0].venue
    assert_equal '/api/v1/venues/null', @game_manager.games[0].venue_link
  end
end

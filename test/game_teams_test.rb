require './test/test_helper'

class GameTeamsTest < Minitest::Test
  def setup
    @game_path = './fixture/game_teams_dummy.csv'

    @game_teams_manager = GameTeamsManager.new(@game_path,nil)
  end

  def test_it_exists
    assert_instance_of GameTeams, @game_teams_manager.game_teams[0]
  end

  def test_it_has_attributes
    assert_equal '2012030221', @game_teams_manager.game_teams[0].game_id
    assert_equal '3', @game_teams_manager.game_teams[0].team_id
    assert_equal 'away', @game_teams_manager.game_teams[0].hoa
    assert_equal 'LOSS', @game_teams_manager.game_teams[0].result
    assert_equal 'OT', @game_teams_manager.game_teams[0].settled_in
    assert_equal 'John Tortorella', @game_teams_manager.game_teams[0].head_coach
    assert_equal '2', @game_teams_manager.game_teams[0].goals
    assert_equal '8', @game_teams_manager.game_teams[0].shots
    assert_equal '44', @game_teams_manager.game_teams[0].tackles
    assert_equal '3', @game_teams_manager.game_teams[0].power_play_opportunities
    assert_equal '0', @game_teams_manager.game_teams[0].power_play_goals
    assert_equal '44.8', @game_teams_manager.game_teams[0].face_off_win_percentage
    assert_equal '17', @game_teams_manager.game_teams[0].giveaways
    assert_equal '7', @game_teams_manager.game_teams[0].takeaways
  end
end

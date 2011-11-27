require "test_helper"
require 'test/unit'

class NCAATest < Test::Unit::TestCase

  def test_create_schools
    ncaa = NCAA::Base.new(ncaa_file)

    assert_kind_of NCAA::School, ncaa.schools["2675"]
    assert_equal 1138, ncaa.schools.length
  end

  def test_create_sports
    ncaa = NCAA::Base.new(ncaa_file)

    assert_kind_of NCAA::Sport, ncaa.sports["MBA"]
    assert_equal 56, ncaa.sports.length
  end

  def test_add_team_schedule
    ncaa = NCAA::Base.new(ncaa_file)

    ncaa.add_games("MBB", ncaa.schools.find(21), game_file)

    assert_kind_of NCAA::Game, ncaa.games.first
    assert_equal 24, ncaa.games.length
  end

  def ncaa_file
    File.read(File.join(File.dirname(__FILE__), 'fixtures', 'ncaa_listing_page.html'))
  end

  def game_file
    File.read(File.join(File.dirname(__FILE__), 'fixtures', '2011-alma-basketball.html'))
  end

end

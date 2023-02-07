require "test_helper"

class MovieTest < ActiveSupport::TestCase
  test "#upcoming" do
    travel_to Time.new(2019, 3, 1) do
      assert_equal 2, Movie.upcoming.size
    end
  end
end

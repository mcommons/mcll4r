require 'mcll4r'
require 'test/unit'
 
class Mcll4rTest < Test::Unit::TestCase
  
  def setup
    @mcll4r = Mcll4r.new
  end
  
  def test_assert_stories_return
    #assert_equal 3, @mcll4r.stories.size
    p @mcll4r.district_lookup(31.76321,-106.490969)
  end
end
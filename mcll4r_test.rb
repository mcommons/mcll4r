require 'mcll4r'
require 'test/unit'
 
class Mcll4rTest < Test::Unit::TestCase
  
  def setup
    @mcll4r = Mcll4r.new
  end
  
  def test_assert_we_get_back_correct_district_data
    lat, lng = 31.76321, -106.490969
    expected = { 
      :federal     => {:district=>"16", :display_name=>"TX 16th", :state=>"TX" }, 
      :state_upper => {:district=>"029", :display_name=>"TX 29th", :state=>"TX"}, 
      :state_lower => {:district=>"077", :display_name=>"TX 77th", :state=>"TX"}
    }
    assert_equal @mcll4r.district_lookup(lat, lng), expected
  end
end

require 'rest_client_base'

class Mcll4r < RestClientBase

  MAPPINGS = { 
    :district_lookup => "districts/lookup.xml"
  }
  
  def district_lookup(lat, lng)
    get(:district_lookup, {:lat=>lat, :lng=>lng})
  end

private

  def host
    "http://congress.mcommons.com"    
  end

  def mapping(action)
    MAPPINGS[action]
  end

  def check_for_errors(xml)
    error = (xml/"response/error").innerHTML
    raise RestClientException.new(error) if error && error.size>0
  end

  def process_district_lookup_response(xml)
    response = (xml/"response")
    val = {}
    [:federal, :state_upper, :state_lower].each do |level|
      val[level] = {}
      [:state, :district, :display_name].each do |category|
        val[level][category] = (response/"#{level}/#{category}").innerHTML
      end
    end
    val
  end

end


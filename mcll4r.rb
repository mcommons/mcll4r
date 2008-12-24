require 'rest_client_base'

class Mcll4r < RestClientBase
  
  HOST = "http://congress.mcommons.com"

  def initialize(options={})
    super
    @host = options[:host] || HOST  #override default for testing
  end
  
  def district_lookup(lat, lng)
    rest(:get, :district_lookup, {'lat'=>lat.to_s, 'lng'=>lng.to_s})
  end

protected

  def mapping(action)
    {
      :district_lookup => "districts/lookup.xml"
    }[action]
  end

  def check_for_errors(xml)
    error = (xml/"response/error").innerHTML
    raise Mcll4rException.new(error) if error && error.size>0
  end

  def parse_district_lookup(xml)
    response = (xml/"response")
    [response/"lat", response/"lng"].map{|ll| ll.innerHTML}
  end

end

class Mcll4rException < RestClientException
end


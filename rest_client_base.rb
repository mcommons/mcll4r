require 'rubygems'
require 'net/http'
require 'net/https'
require 'hpricot'


# To use the RestClient, create a new subclass for your particular REST service
# The subclass should implement the following:
#  * mapping(action): takes in a symbol, returns the path to the action as a string
#  * check_for_errors(xml): takes in an hpricot document, raises a RestClientException if there is an error
#  * process_{action}_response(xml): 1 callback function for each action. Takes an hpricot doc, returns business data
#
# The following methods are optional:
#  * host: optional method to specify a default host


class RestClientBase

  def initialize(options={})
    @ssl      = options[:ssl]
    @host     = options[:host] || host()
    @username = options[:username]
    @password = options[:password]
  end

protected

  #optionally override in subclass
  def host
    nil
  end

  def get(action, params={})
    rest(action) do |path|
      net_http(URI.parse(path)).start do |http|
        http.request( Net::HTTP::Get.new( path_with_params(path, params) ) )
      end
    end
  end

  def post(path, params={})
    rest(action) do |path|
      net_http(URI.parse(path)).start do |http|
        http.request( Net::HTTP::Post.new( path_with_params(path, params) ) )
      end
    end
  end

  def check_for_errors(xml)
    raise "implement in subclass"
  end

private 

  def net_http(uri)
    h = Net::HTTP.new(uri.host, uri.port)
    h.use_ssl = @ssl
    h
  end

  def rest(action, &block)
    res = yield url_for(action)
    validate_http_response(res)
    doc = Hpricot.XML(res.body)
    check_for_errors(doc)
    send("process_#{action}_response", doc)
  end

  def url_for(action)
    "#{@host}/#{mapping(action)}"
  end

  def path_with_params(path, params={})
     "#{path}?#{encode_params(params)}"
  end
  
  def encode_params(params)
    params.map{|k,v| "#{k}=#{v}"}.join("&")
  end

  def validate_http_response(res)
    if !res.kind_of?(Net::HTTPSuccess)
      raise "HTTP error posting to #{@hostname}: #{res}"
    end
  end

end

class RestClientException < Exception
end


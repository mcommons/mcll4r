require 'rubygems'
require 'hpricot'
include Hpricot

require 'net/http'
require 'net/https'


class RestClientBase

  def initialize(options={})
    @ssl  = options[:ssl]
    @host = options[:host]
  end

protected

  def rest(method, action, params)
    res = send(method.to_s, url_for(action), params)
    validate_http_response(res)
    doc = Hpricot.XML(res.body)
    check_for_errors(doc)
    send("parse_#{action}", doc)
  end

  def url_for(action)
    "#{@host}/#{mapping(action)}"
  end

  def get(path, params={})
    response = net_http(URI.parse(path)).start do |http|
      http.request( Net::HTTP::Get.new( path_with_params(path,params) ) )
    end
  end

  def post(path, params={})
  end

  def rest_url(path)
    "#{@host}/#{path}"
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

  def path_with_params(path, params={})
     "#{path}?#{encode_params(params)}"
  end
  
  def encode_params(params)
    params.map{|k,v| "#{k}=#{v}"}.join("&")
  end

  def validate_http_response(res)
    if !res.kind_of?(Net::HTTPSuccess)
      raise "HTTP error posting to #{@hostname}: #{res}"
    else
      puts "OK!"
    end
  end

end

class RestClientException < Exception
end


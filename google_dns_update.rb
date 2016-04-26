#!/usr/bin/env ruby

require 'net/http'
require 'net/https'
require 'uri'
require 'pp'
require 'yaml'

$config_file = '~/.google_domains.yaml'

$config=YAML::load(open(File.expand_path($config_file)))
$domains=$config[:domains]

uri = URI('https://domains.google.com/checkip') 
Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new uri
    response = http.request request # Net::HTTPResponse object
    $myip=response.body
end


$domains.each do |domain|
  domain_name=domain.keys[0] 
  puts "Updating Google Dynamic DNS record for #{domain_name} with #{$myip}" 
  username=domain.values[0][:username]
  password=domain.values[0][:password]
  post_params={'hostname' => "#{domain_name}", 'myip' => "#{$myip}"}
  uri = URI.parse('https://domains.google.com/nic/update')
  Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https', 
  :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

    request = Net::HTTP::Post.new uri.request_uri
    request.basic_auth username, password
    request.set_form_data(post_params)
    response = http.request request # Net::HTTPResponse object

    puts response.body
  end
end





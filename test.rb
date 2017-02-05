#!/usr/bin/env ruby

require 'pry'
require 'ipfs/client'
require 'net/http/post/multipart'

host, port = 'http://ipfs.io', 80
host, port = 'http://localhost', 5001

cli = IPFS::Client.new host: host, port: port
results = cli.ls 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'
links = results.collect(&:links).flatten

links.each do |entry|
  puts entry.name
end

links.find{ |link| link.name == 'readme' }.tap do |readme|
  content = cli.cat readme.hashcode
  puts content
end

url = URI.parse("#{cli.api_url}/add")
request = Net::HTTP::Post::Multipart.new(
  url.path,
  file1: UploadIO.new(File.new('README.md'), 'plain/text', 'README.md'),
  file2: UploadIO.new(File.new('test.rb'), 'plain/text', 'test/test.rb')
)
response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }

puts response.body

#binding.pry

#res = cli.add $0

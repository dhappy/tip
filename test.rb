#!/usr/bin/env ruby

require 'pry'
require 'ipfs/client'
require 'net/http/post/multipart'

host, port = 'http://ipfs.io', 80
host, port = 'http://localhost', 5001

@cli = IPFS::Client.new host: host, port: port
hashes = ['QmZ8qhLpcZkF3JZ6zmrZCgVn5d54P78fFJ4BTWjR38zZ51',
          'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG',
          'QmP9xigWettR229mBvq2oFbSqhZ3PVijVGAyqPwTRfJ718',
         ]

def print_hash(hash, pad = '')
  links = @cli.ls(hash).collect(&:links).flatten

  print "#{pad}#{hash} (#{links.count})"

  pad += '  '

  if not links.empty?
    puts ':'
    links.each do |entry|
      puts "#{pad}#{entry.name} (#{entry.hashcode})"
      print_hash entry.hashcode, pad
    end
  else
    puts
    puts @cli.cat hash
  end
end

hashes.each { |hash| print_hash hash }

#binding.pry; exit

=begin
links.find{ |link| link.name == 'readme' }.tap do |readme|
  content = cli.cat readme.hashcode
  puts content
end

url = URI.parse("#{cli.api_url}/add")
request = Net::HTTP::Post::Multipart.new(
  url.path,
  'readme.md': UploadIO.new(File.new('README.md'), 'plain/text', 'README.md'),
  'test/test.rb': UploadIO.new(File.new('test.rb'), 'plain/text', 'test/test.rb')
)

binding.pry

response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }

puts response.body
=end


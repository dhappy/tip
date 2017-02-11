#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'pry'
require 'ipfs/client'
require 'net/http/post/multipart'
require 'ostruct'

@host, @port = 'http://ipfs.io', 80
@host, @port = 'http://localhost', 5001

@cli = IPFS::Client.new host: @host, port: @port
hashes = [
  'QmaCA9KqX9zrjcRCo9LE6mGHKnZ4Fjwv26eyLPEyhC3iRt',
  'QmZbF7ZqXvTXwiwhaJWMUQMJtFt3HvGWiZeBM5TFdo9TMu',
#  'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG',
#  'QmP9xigWettR229mBvq2oFbSqhZ3PVijVGAyqPwTRfJ718',
#  'QmZ8qhLpcZkF3JZ6zmrZCgVn5d54P78fFJ4BTWjR38zZ51',
#  'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG',
]

def print_entry(entry, pad = '')
  links = @cli.ls(entry.hashcode).collect(&:links).flatten

  if not links.empty?
    puts "#{pad}#{entry.hashcode} (#{links.count}):"

    pad += '  '
    
    links.each do |link|
      link = OpenStruct.new({
        hashcode: link.hashcode,
        name: link.name,
        size: link.size
      }).tap do |link|
        link.tree = "#{entry.tree}#{entry.tree ? '/' : 
 ''}#{link.name}"
      end
      puts "#{pad}#{link.name} (#{link.hashcode})"
      print_entry link, pad
    end
  else
    query = "#{@host}:#{@port}/api/v0/block/get?arg=#{entry.hashcode}"
    ret = Net::HTTP.get(URI.parse(query))
    
    if ret.unpack('C*').first == 10 # really rough symlink check
      puts "Link: #{entry.tree} → #{ret[6..-1].force_encoding('utf-8')}"
    end

    #binding.pry; exit
    #IO.write(entry.name, ret.to_s)
  end
end

hashes.each do |hash|
  print_entry OpenStruct.new(hashcode: hash)
end

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


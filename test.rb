#!/usr/bin/env ruby

require 'pry'
require 'ipfs/client'

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

res = cli.add $0

#!/usr/bin/env ruby

require 'pry'
require 'ipfs/client'

cli = IPFS::Client.new host: 'http://ipfs.io', port: 80
results = cli.ls 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'
links = results.collect(&:links).flatten

links.each do |entry|
  puts entry.name
end

links.find{ |link| link.name == 'readme' }.tap do |readme|
  content = cli.cat readme.hashcode
  puts content
end



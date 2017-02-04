#!/usr/bin/env ruby

require 'pry'
require 'ipfs/client'

cli = IPFS::Client.new host: 'http://ipfs.io', port: 80
result = cli.ls 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'
binding.pry

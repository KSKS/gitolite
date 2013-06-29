#!/usr/bin/ruby
require 'fileutils'

# Redirect to stderr so it will show up in user console. stdout causes protocol error
$stdout.reopen($stderr)
#$stdout.reopen("/dev/null")

if ARGV[1] == 'gitolite-admin'
	exit(true)
end

out = %x[rm -v ./refs/heads/* 2>/dev/null] 
puts out if ENV['GITOLITE_LOG']


#!/usr/bin/ruby
require 'fileutils'

LOGGING=false

# Redirect to stderr so it will show up in user console. stdout causes protocol error
$stdout.reopen($stderr)
#$stdout.reopen("/dev/null")

if ARGV[1] == 'gitolite-admin'
	exit(true)
end


puts "==== #{__FILE__} ====" if LOGGING

puts ARGV.join(' ') if LOGGING

reponame = File.basename(FileUtils.pwd)
reponame = reponame[0..-5] if reponame.end_with?('.git')

puts "reponame: #{reponame}" if LOGGING

url_file =  File.expand_path("../#{reponame}.url")

puts %x[which git] if LOGGING
puts %x[git --version] if LOGGING

if File.exist?(url_file)
	git_url = File.read(url_file)
	puts "git_url: #{git_url}" if LOGGING

	# Using bash to invoke so in case the remote origin is already added
	# and the git-remote-add would fatally ended the command, bash can
	# still redirect the stderr
	output = %x[bash -l -c "git remote add --mirror=fetch origin #{git_url}" 2>&1]
	puts output if LOGGING

	# OPTIMIZE: use a seperate thread to fetch while git is receiving 
	# objects from users
	output = `git fetch --force --prune --verbose origin 2>&1`
	puts output if LOGGING

	output = `gitolite setup 2>&1`
	puts output if LOGGING
else
	puts "#{url_file} not exist" if LOGGING
end

puts "====================" if LOGGING

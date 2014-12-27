#!/usr/bin/env ruby
require 'open3'

ARROW  = "----->"
INDENT = "      "

def log_main(s)
	$stdout.puts ARROW + " " + s
end

def log_detail(s)
	$stdout.puts INDENT + " " + s
end

def run_command(*cmd)
	exit_status = -1 
	Open3.popen2e(*cmd) do |i,oe,t|
		oe.each { |line| log_detail line }
		exit_status = t.value
	end
	return exit_status
end

build_dir = ARGV[0]
cache_dir = ARGV[1]
env_dir = ARGV[2]

log_main "Found a valid resolutionizer application"

log_main "Obtaining client dependencies"
Dir.chdir File.join(build_dir, "resolutionizer")
log_detail "Entering directory #{Dir.pwd}"

log_detail "Using node version"
if run_command('node', '--version') != 0
	log_main "Error checking node verison"
	exit 1
end

log_detail "Using npm version"
if run_command('npm', '--version') != 0
	log_main "Error checking npm version"
	exit 1
end

log_detail "Installing grunt-cli"
if run_command('npm', 'install', '-g', 'grunt-cli@0.1.13') != 0
	if run_command('grunt', '--version') != 0
		log_main "Error occured installing grunt-cli"
		exit 1
	end
end

log_detail "Installing node-modules"
if run_command('npm install') != 0
	log_main "Error occured installing node-modules"
	exit 1
end

exit 0
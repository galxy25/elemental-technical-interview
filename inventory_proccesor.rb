#!/usr/bin/ruby
require 'json'
#A script to read a JSON formatted data structure from STDIN

input = $stdin.read
parsed_input = JSON.parse(input)
puts "Parsed Input: #{parsed_input}"

#!/usr/bin/env ruby

require 'optparse'
DISALLOWED = / be | being | been | am | is | isn't | are | aren't | was | wasn't | were | weren't |'m |'re |'s | ain't | hain't | whatcha | yer /

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: blah blah blah TODO"

  opts.on("-f S", "--file S", String, "Read from file") do |f|
    options[:file] = f
  end

  opts.on("-c", "--count", "Print count of instances") do |c|
    options[:count] = true
  end

  opts.on("-r [S]", "--ratio [S]", String, "Print ratio of instances / word-count or sentence count") do |r|
    options[:ratio] = true
    options[:ratio_total] = r || "word"
  end

  opts.on("-t", "--test", "Tests whether input contains restricted words. Results via exit code") do |r|
    options[:test] = true
  end
end.parse!

if options[:file]
  str = File.read(options[:file]).split("\n")
else
  str = ARGF
end


result = 0
if options[:count]
  count = 0
  str.each do |line|
    count += line.scan(DISALLOWED).count
  end
  puts count
elsif options[:ratio]
  bad = 0.0
  total = 0.0
  str.each do |line|
    bad += line.scan(DISALLOWED).count
    if options[:ratio_total] == "sentence"
      total += line.scan(/\./).count
    else
      total += line.scan(/ /).count
    end
  end
  puts ((bad / total) * 100)
elsif options[:test]
  str.each do |line|
    if line =~ DISALLOWED
      result = 1
      break
    end
  end
else
  trap("SIGINT") { exit result }

  str.each do |line|
    if line =~ DISALLOWED
      puts line
    end
  end
end

exit result

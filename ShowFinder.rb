require 'net/http'
require_relative "crawler"

include ShowFinder

File.open("venues.txt").each_line do |venue|
  root = URI(venue)
  Crawler.new(root)
end

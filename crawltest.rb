require 'net/http'
require_relative "uri_list"
require_relative "uri_object"

include ShowFinder

list = URIList.new

def get_uri(link)
  link.scan(/href\s*=\s*["']([^'"]*)['"]/)[0][0]
end

def crawl(root)
end


File.open("venues.txt").each_line do |venue|
  root = URI(venue)
  source = Net::HTTP.get(root)
  
  anchors = source.scan(/<a.*>.*<\/a>/)
  
  anchors.each do |anchor| 
    uri = get_uri(anchor)
    if /^http/.match(uri)
      list.push_uri(uri)
    else
      list.push_uri(root + uri)
    end
  end
  list.uri_list.each { |item| puts item.uri}
end






require 'net/http'

def find_shows
  File.open("venues.txt").each_line do |venue|
    uri = URI(venue)
    root = Net::HTTP.get(uri)
    find_bands(root, venue)
    get_links(source)
  end
end

def find_bands(source, venue)
  File.open("bands.txt").each_line do |band|
    if source.downcase.include?(band)
      puts band + " @ " + venue
    end
  end
end

def get_links(source)
  links = source.scan(/<a.*>.*<\/a>/)
  links.each { |link| get_url(link)}
end

def get_url(link)
  puts link.scan(/href\s*=\s*["']([^'"]*)['"]/)
end


find_shows
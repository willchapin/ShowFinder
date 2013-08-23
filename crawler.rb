require 'net/http'

module ShowFinder
  class Crawler

    attr_accessor :root_uri, :waiting_uris, :crawled_uris

    def initialize(root)
      @waiting_uris = [root]
      @crawled_uris = []
      @root_uri = root
      crawl(root)
    end

    def crawl(uri)
      source = Net::HTTP.get(uri)
      anchors = get_anchors(source)
      anchors.each do |anchor|
        uri = get_uri(anchor)
        add_uri_to_waiting_uri(uri)
      end
      next_to_crawl = @waiting_uris.pop
      puts next_to_crawl
      puts @waiting_uris.length
      crawl(URI(next_to_crawl))
    end

    def get_anchors(source)
      source.scan(/<a.*>.*<\/a>/)
    end

    def get_uri(link)
      link.scan(/href\s*=\s*["']([^'"]*)['"]/)[0][0]
    end

    def add_uri_to_waiting_uri(uri)
      if /^http/.match(uri)
        @waiting_uris << uri
      else
        @waiting_uris << @root_uri + uri
      end
    end


  end
end


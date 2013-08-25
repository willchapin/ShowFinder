module ShowFinder
  class Crawler

    attr_accessor :uncrawled_list, :crawled_list

    def initialize(root_url)
      @uncrawled_list = [root_url]
      @crawled_list = []
      run
    end

    def run
      until @uncrawled_list.empty?
        puts "togo: " + @uncrawled_list.length.to_s
        puts "crawled: " + @crawled_list.length.to_s
        next_url = @uncrawled_list.pop
        @crawled_list << next_url
        puts next_url
        crawl(URI(next_url))
      end
    end

    def crawl(page_url)
      begin
        source = Net::HTTP.get(page_url)
        hrefs = get_hrefs(source)
        hrefs.each do |href|
          add_to_uncrawled_list(page_url, href[0])
        end
      rescue
        "Net::HTTP.get failed."
      end
    end

    def get_hrefs(source)
      source.scan(/<a.*href\s*=\s*["']([^'"]*)['"]>.*<\/a>/)
    end

    def add_to_uncrawled_list(page_url, href)
      absolute_url = URI.join(page_url, href).to_s
      unless @crawled_list.include?(absolute_url) or @uncrawled_list.include?(absolute_url)
        @uncrawled_list << absolute_url
      end
    end
  end
end

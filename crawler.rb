module ShowFinder
  class Crawler

    attr_accessor :host, :uncrawled_list, :crawled_list, :bands

    def initialize(root_url)
      @bands = []
      set_bands
      @uncrawled_list = [root_url]
      @crawled_list = []
      @host = root_url.host
      run
    end

    def set_bands
      File.open("bands.txt").each_line do |band|
        @bands << band.strip
      end
    end

    def run
      until @uncrawled_list.empty?
        puts "togo: " + @uncrawled_list.length.to_s
        puts "crawled: " + @crawled_list.length.to_s
        next_url = @uncrawled_list.pop
        @crawled_list << next_url
        puts next_url
        crawl(next_url)
      end
    end

    def crawl(page_url)
      begin
        source = Net::HTTP.get(page_url)
        scan_for_bands(source)
        hrefs = get_hrefs(source)
        hrefs.each do |href|
          add_to_uncrawled_list(page_url, URI(href[0]))
        end
      rescue => error
        puts error
      end
    end

    def get_hrefs(source)
      source.scan(/<a.*href\s*=\s*["']([^'"]*)['"]>.*<\/a>/)
    end

    def add_to_uncrawled_list(page_url, href)
      absolute_url = URI.join(page_url, href)
      unless ( @crawled_list.include?(absolute_url) or
               @uncrawled_list.include?(absolute_url) or
               different_host?(absolute_url) )
        @uncrawled_list << absolute_url
      end
    end

    def scan_for_bands(source)
      downcase_source = source.downcase
      @bands.each do |band|
        if downcase_source.include?(band)
          print_band(band)
        end
      end
    end

    def print_band(band)
      puts "\n" * 4
      puts band + " @ " + @host
      puts "\n" * 4
    end

    def different_host?(url)
      url.host != @host
    end

  end
end

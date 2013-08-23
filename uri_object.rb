module ShowFinder
  class URIObject
    attr_accessor :crawled, :uri
    def initialize(uri)
      @uri = uri
      @crawled = false
    end  
  end
end

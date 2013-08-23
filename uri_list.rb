module ShowFinder
  class URIList < Array
   
    attr_accessor :uri_list
    
    def initialize
      @uri_list = []
    end
  
    def push_uri(uri)
      unless @uri_list.include?(uri)
        uri_object = URIObject.new(uri)
        @uri_list << uri_object
      end
    end
  
    def pop_URI
    end
  end  
end


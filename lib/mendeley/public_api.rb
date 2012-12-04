module Mendeley
  module API
    def request(sub_url, params = nil)
      request = build_request_url(sub_url, params)
      JSON.parse(RestClient.get(request))
    end

    def build_request_url(sub_url, params = nil )
      request_url = File.join(self.base_url, sub_url)
      param_string = "?consumer_key=#{Mendeley.consumer_key}"
      if params
        params.each do |key,value|
          param_string << "&#{key}=#{value}"
        end
      end
      request_url.concat(param_string)
    end
    private :build_request_url
    
    #Wrapper for the public /documents/ domain on mendeley
    #see http://apidocs.mendeley.com/home/public-resources
    #All of the following actions will take place on the 
    #documents namespace of the API. 
    #
    #EX// to search all documents for "hello world" you would do 
    #       Mendeley::API::Documents.search("hello world")
    # All Responses will be a ruby hash created by parsing the 
    # response json from the mendeley api
    class Documents
      extend API

      @base_url = "http://api.mendeley.com/oapi/documents/"

      def self.base_url
        @base_url
      end

      #Search all documents using the public API for the given term
      def self.search(term, options = {})
        request(File.join("search", URI.escape(term)), options)
      end

      #Fetch the detailed description of the document from mendeley
      def self.document_details(doc_id)
        unless doc_id.is_a?(String)
          raise "Invalid argument type. Must be a string"
        end
        request(File.join("details", URI.escape(doc_id)))
      end

      def self.authored_by(name)
        request(File.join("authored", URI.escape(name)))
      end

    end

  end
end

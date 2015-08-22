module Textminer
  class Request #:nodoc:

    def initialize(doi)
      self.doi = doi
    end

    def raw_body
      @raw_request.body
    end

    def parsed
      JSON.parse(@raw_request.body)
    end

    def perform
      http
    end

    private

    def http
      @raw_request = HTTParty.get(@base_url + self.doi)
    end

    @base_url = "http://localhost:9200/gbif/record/"
    # @base_url = "http://api.crossref.org/works/"

  end
end

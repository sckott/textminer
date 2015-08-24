module Textminer
  class Request #:nodoc:
    attr_accessor :doi

    def initialize(doi)
      self.doi = doi
    end

    def perform
      url = "http://api.crossref.org/works/"
      coll = []
      Array(self.doi).each do |x|
        coll << HTTParty.get(url + x)
      end
      # res = HTTParty.get(url + self.doi)
      Response.new(self.doi, coll)
    end
  end
end

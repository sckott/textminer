require 'cites'
require 'api_cache'
require 'bibtex'
require 'digest/sha1'
require 'httparty'
require 'json'
require 'moneta'

module Textminer
	##
	# Examples:
	#     require 'textminer'
	#     # link to full text available
	#     Textminer.links("10.5555/515151")
	#     # no link to full text available
	#     Textminer.links("10.1371/journal.pone.0000308")
	def self.links(doi, type = 'xml')
	  Request.new(doi).perform
  end

  class Request #:nodoc:
  	attr_accessor :doi

    def initialize(doi)
      self.doi = doi
    end

    def perform
    	url = "http://api.crossref.org/works/"
      res = HTTParty.get(url + self.doi)
      Response.new(self.doi, res)
    end
  end

  class Response #:nodoc:
    attr_reader :doi, :response

    def initialize(doi, res)
      @doi          = doi
      @res          = res
    end

    def raw_body
      @res
    end

    def parsed
      JSON.parse(@res.body)
    end

    def links
      @res['message']['link']
    end

    def pdf
    	tmp = links
    	if !tmp.nil?
    		tmp.select{|x| x['content-type'] == "application/pdf"}[0]['URL']
    	end
    end

    def xml
    	tmp = links
    	if !tmp.nil?
    		tmp.select{|x| x['content-type'] == "application/xml"}[0]['URL']
    	end
    end
	end

end

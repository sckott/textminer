require 'digest/sha1'
require 'httparty'
require 'json'

module Textminer
  ##
  # Examples:
  #     require 'textminer'
  #     # link to full text available
  #     Textminer.links("10.5555/515151")
  #     # no link to full text available
  #     Textminer.links("10.1371/journal.pone.0000308")
  def self.links(doi)
    Request.new(doi).perform
  end

  ##
  # Examples:
  #     require 'textminer'
  #     # fetch full text by DOI
  #     Textminer.fetch("10.5555/515151")
  def self.fetch(doi, type = 'xml')
    Fetch.new(doi, type).fetchtext
  end

  class Fetch #:nodoc:
    attr_accessor :doi, :type

    def initialize(doi, type)
      self.doi = doi
      self.type = type
    end

    def fetchtext
      lks = Textminer.links(self.doi)
      lk = pick_link(lks)
      case self.type
      when "xml"
        HTTParty.get(lk)
      when "pdf"
        serialize_pdf(lk)
      end
    end

    private

    def pick_link(x)
      case self.type
      when "xml"
        x.xml
      when "pdf"
        x.pdf
      else
        puts "type must be xml or pdf"
      end
    end

    def serialize_pdf(x)
      File.open("/Users/sacmac/.textminer/one.pdf", "wb") do |f|
        f.write HTTParty.get(x).parsed_response
      end
    end

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

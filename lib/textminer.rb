require 'digest/sha1'
require 'httparty'
require 'json'
require 'pdf-reader'
require "fileutils"
require "textminer/version"

module Textminer
  ##
  # Get links meant for text mining
  #
  # @param doi [Array] A DOI, digital object identifier
  # @return [Array] the output
  #
  # @example
  #     require 'textminer'
  #     # link to full text available
  #     Textminer.links("10.5555/515151")
  #     # no link to full text available
  #     Textminer.links("10.1371/journal.pone.0000308")
  #     # many DOIs at once
  #     res = Textminer.links(["10.3897/phytokeys.42.7604", "10.3897/zookeys.516.9439"])
  #     res.links
  #     res.pdf
  #     res.xml
  def self.links(doi)
    Request.new(doi).perform
  end

  ##
  # Thin layer around pdf-reader gem's {PDF::Reader}
  #
  # @param doi [Array] A DOI, digital object identifier
  # @param type [Array] One of two options to download: xml (default) or pdf
  #
  # @example
  #     require 'textminer'
  #     # fetch full text by DOI - xml by default
  #     Textminer.fetch("10.3897/phytokeys.42.7604")
  #     # many DOIs - xml output
  #     res = Textminer.fetch(["10.3897/phytokeys.42.7604", "10.3897/zookeys.516.9439"])
  #     # fetch full text - pdf
  #     Textminer.fetch("10.3897/phytokeys.42.7604", "pdf")
  def self.fetch(doi, type = 'xml')
    Fetch.new(doi, type).fetchtext
  end

  ##
  # Thin layer around pdf-reader gem's PDF::Reader
  #
  # @param path [String] Path to a pdf file downloaded via {fetch}, or
  #   another way.
  #
  # @example
  #     require 'textminer'
  #     # fetch full text - pdf
  #     res = Textminer.fetch("10.3897/phytokeys.42.7604", "pdf")
  #     # extract pdf to text
  #     Textminer.extract(res)
  def self.extract(path)
    rr = PDF::Reader.new(path)
    rr.pages.map { |page| page.text }.join("\n")
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
        # HTTParty.get(lk)
        coll = []
        Array(lk).each do |x|
          coll << HTTParty.get(x)
        end
        return coll
      when "pdf"
        serialize_pdf(lk, self.doi)
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

    def serialize_pdf(x, y)
      path = "/Users/sacmac/.textminer/" + y.gsub('/', '_') + ".pdf"
      File.open(path, "wb") do |f|
        f.write HTTParty.get(x).parsed_response
      end

      return path
    end

  end

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

  class Response #:nodoc:
    attr_reader :doi, :response

    def initialize(doi, res)
      @doi = doi
      @res = res
    end

    def raw_body
      # @res
      @res.collect { |x| x.body }
    end

    def parsed
      # JSON.parse(@res.body)
      @res.collect { |x| JSON.parse(x.body) }
    end

    def links
      # @res['message']['link']
      @res.collect { |x| x['message']['link'] }
    end

    def pdf
      tmp = links
      if !tmp.nil?
        tmp.collect { |z|
          z.select{ |x| x['content-type'] == "application/pdf" }[0]['URL']
        }
      end
    end

    def xml
      tmp = links
      if !tmp.nil?
        tmp.collect { |z|
          z.select{ |x| x['content-type'] == "application/xml" }[0]['URL']
        }
      end
    end

    def all
      [xml, pdf]
    end

    # def browse

    # end

  end

end

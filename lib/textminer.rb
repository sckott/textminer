require 'digest/sha1'
require 'httparty'
require 'json'
require 'pdf-reader'
require "textminer/version"
require "textminer/request"
require "textminer/response"
require "textminer/fetch"

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

end

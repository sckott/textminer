require 'httparty'
require 'json'
require 'pdf-reader'
require 'serrano'
require "textminer/version"
require "textminer/request"
require "textminer/response"
require "textminer/fetch"

module Textminer
  ##
  # Search for papers and get full text links
  #
  # @param doi [Array] A DOI, digital object identifier
  # @param options [Array] Curl request options
  # @return [Array] the output
  #
  # @example
  #     require 'textminer'
  #     # link to full text available
  #     Textminer.search(doi: '10.7554/elife.06430')
  #     # no link to full text available
  #     Textminer.search(doi: "10.1371/journal.pone.0000308")
  #     # many DOIs at once
  #     require 'serrano'
  #     dois = Serrano.random_dois(sample: 6)
  #     res = Textminer.search(doi: dois)
  #     res = Textminer.search(doi: ["10.3897/phytokeys.42.7604", "10.3897/zookeys.516.9439"])
  #     res.links
  #     res.links_pdf
  #     res.links_xml
  #     res.links_plain
  #     # only full text available
  #     x = Textminer.search(doi: '10.3816/clm.2001.n.006')
  #     x.links_xml
  #     x.links_plain
  #     x.links_pdf
  #     # no dois
  #     x = Textminer.search(filter: {has_full_text: true})
  #     x.links_xml
  #     x.links_plain
  #     x = Textminer.search(member: 311, filter: {has_full_text: true})
  #     x.links_pdf
  def self.search(doi: nil, member: nil, filter: nil, limit: nil, options: nil)
    Request.new(doi, member, filter, limit, options).perform
  end

  ##
  # Thin layer around pdf-reader gem's PDF::Reader
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

  protected

  def self.link_switch(x, y)
    case y
    when nil
      x.links
    when 'xml'
      x.links_xml
    when 'pdf'
      x.links_pdf
    when 'plain'
      x.links_plain
    end
  end

end

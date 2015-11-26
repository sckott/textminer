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
  # Get links meant for text mining
  #
  # @param doi [Array] A DOI, digital object identifier
  # @return [Array] the output
  #
  # @example
  #     require 'textminer'
  #     # link to full text available
  #     Textminer.links(doi: "10.5555/515151")
  #     # no link to full text available
  #     Textminer.links(doi: "10.1371/journal.pone.0000308")
  #     # many DOIs at once
  #     res = Textminer.links(doi: ["10.3897/phytokeys.42.7604", "10.3897/zookeys.516.9439"])
  #     res.links
  #     res.pdf
  #     res.xml
  #     # only full text available
  #     x = Textminer.links(doi: '10.3816/clm.2001.n.006')
  #     x = Textminer.links(doi: '10.3816/clm.2001.n.006', type: 'xml')
  #     x = Textminer.links(doi: '10.3816/clm.2001.n.006', type: 'plain')
  #     x = Textminer.links(doi: '10.3816/clm.2001.n.006', type: 'pdf') # elsevier doesn't give pdf
  #     # no dois
  #     x = Textminer.links(filter: {has_full_text: true})
  #     x = Textminer.links(filter: {has_full_text: true}, type: "xml")
  #     x = Textminer.links(filter: {has_full_text: true}, type: "plain")
  #     x = Textminer.links(member: 311, filter: {has_full_text: true}, type: "pdf")
  def self.links(doi: nil, member: nil, filter: nil, type: nil, **kwargs)
    if member.nil?
      res = Serrano.works(ids: doi, filter: filter, **kwargs)
    else
      res = Serrano.members(ids: member, filter: filter, works: true, **kwargs)
    end
    if !type.nil?
      case type
      when 'xml'
        type = "text/xml"
      when 'pdf'
        type = "application/pdf"
      when 'plain'
        type = "text/plain"
      end
    end

    if doi.nil?
      links = res['message']['items'].collect { |x| x['link'] }
      if type.nil?
        return links
      else
        return links.keep_if { |e| e.keep_if { |z| z['content-type'] == type } }
      end
    else
      links = []
      res.each do |x|
        tt = x['message']['link']
        if type.nil?
          links << tt
        else
          links << tt.keep_if { |z| z['content-type'] == type }
        end
      end
      return links
    end
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

end

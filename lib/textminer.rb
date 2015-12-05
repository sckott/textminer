require 'httparty'
require 'json'
require 'pdf-reader'
require 'serrano'
require "textminer/miner"
require "textminer/version"
require "textminer/request"
require "textminer/response"

module Textminer
  extend Configuration

  define_setting :tdm_key

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
  #     Textminer.search(doi: '10.3897/phytokeys.42.7604')
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
  # Get full text
  #
  # Work easily for open access papers, but for closed. For non-OA papers, use
  # Crossref's Text and Data Mining service, which requires authentication and
  # pre-authorized IP address. Go to https://apps.crossref.org/clickthrough/researchers
  # to sign up for the TDM service, to get your key. The only publishers
  # taking part at this time are Elsevier and Wiley.
  #
  # @param url [String] A url for full text
  # @return [Mined] An object of class Mined, with methods for extracting
  # the url requested, the file path, and parsing the plain text, XML, or extracting
  # text from the pdf.
  #
  # @example
  #   require 'textminer'
  #   # Set authorization
  #   Textminer.configuration do |config|
  #     config.tdm_key = "<your key>"
  #   end
  #   # Get some elsevier works
  #   res = Textminer.search(member: 78, filter: {has_full_text: true});
  #   links = res.links_xml(true);
  #   # Get full text for an article
  #   out = Textminer.fetch(url: links[0]);
  #   out.url
  #   out.path
  #   out.type
  #   xml = out.parse()
  #   puts xml
  #   xml.xpath('//xocs:cover-date-text', xml.root.namespaces).text
  #   # Get lots of articles
  #   links = links[1..3]
  #   out = links.collect{ |x| Textminer.fetch(url: x) }
  #   out.collect{ |z| z.path }
  #   out.collect{ |z| z.parse }
  #   zz = out[0].parse
  #   zz.xpath('//xocs:cover-date-text', zz.root.namespaces).text
  #
  #   ## plain text
  #   # get full text links, here doing xml
  #   links = res.links_plain(true);
  #   # Get full text for an article
  #   res = Textminer.fetch(url: links[0]);
  #   res.url
  #   res.parse
  #
  #   # With open access content - using Pensoft
  #   res = Textminer.search(member: 2258, filter: {has_full_text: true});
  #   links = res.links_xml(true);
  #   # Get full text for an article
  #   res = Textminer.fetch(url: links[0]);
  #   res.url
  #   res.parse
  #
  #   # OA content - pdfs, using pensoft again
  #   res = Textminer.search(member: 2258, filter: {has_full_text: true});
  #   links = res.links_pdf(true);
  #   # Get full text for an article
  #   res = Textminer.fetch(url: links[0]);
  #   # url used
  #   res.url
  #   # document type
  #   res.type
  #   # document path on your machine
  #   res.path
  #   # get text
  #   res.parse
  def self.fetch(url)
    Miner.new(url).perform
  end

  ##
  # Thin layer around pdf-reader gem's PDF::Reader
  #
  # @param path [String] Path to a pdf file downloaded via {fetch}, or
  #   another way.
  #
  # This method is used internally within fetch to parse PDFs.
  #
  # @example
  #   require 'textminer'
  #   res = Textminer.search(member: 2258, filter: {has_full_text: true});
  #   links = res.links_pdf(true);
  #   # Get full text for an article
  #   out = Textminer.fetch(url: links[0]);
  #   # extract pdf to text
  #   Textminer.extract(out.path)
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

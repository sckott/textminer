require 'launchy'
require "textminer/link_methods_hash"
require "textminer/link_methods_array"

module Textminer
  class Response #:nodoc:
    attr_reader :doi, :member, :response, :facet

    def initialize(doi, member, response, facet)
      @doi = doi
      @member = member
      @response = response
      @facet = facet
    end

    def to_s
      if !@doi.nil?
        if @doi.length > 3
          ending = '...'
        else
          ending = ''
        end
        tt = sprintf('dois: %s %s', Array(@doi)[0..2].join(', '), ending)
      end
      if !@member.nil?
        tt = 'member: ' + @member.to_s
      end
      if @doi.nil? && @member.nil?
        tt = ''
      end
      sprintf("<textminer>: \n      search: %s\n      no. licenses: %s", tt, @facet)
    end

    def inspect
      to_s
    end

    def body
      @response
    end

    def links(just_urls = true)
      tmp = @response.links(just_urls)
      compactif(tmp)
    end

    def links_xml(just_urls = true)
      tmp = @response.links_xml(just_urls)
      compactif(tmp)
    end

    def links_pdf(just_urls = true)
      tmp = @response.links_pdf(just_urls)
      compactif(tmp)
    end

    def links_plain(just_urls = true)
      tmp = @response.links_plain(just_urls)
      compactif(tmp)
    end

    protected

    def compactif(z)
      if z.nil?
        return z
      else
        return z.compact
      end
    end
    # def browse
    #   url = 'http://doi.org/' + @doi
    #   Launchy.open(url)
    # end
  end
end

require 'launchy'

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

    def links(just_urls = false)
      @response.links(just_urls).compact
    end

    def links_xml(just_urls = false)
      @response.links_xml(just_urls).compact
    end

    def links_pdf(just_urls = false)
      @response.links_pdf(just_urls).compact
    end

    def links_plain(just_urls = false)
      @response.links_plain(just_urls).compact
    end

    # def browse
    #   url = 'http://doi.org/' + @doi
    #   Launchy.open(url)
    # end
  end
end

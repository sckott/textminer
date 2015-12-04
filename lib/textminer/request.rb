module Textminer
  class Request #:nodoc:
    attr_accessor :doi
    attr_accessor :member
    attr_accessor :filter
    attr_accessor :limit
    attr_accessor :options

    def initialize(doi, member, filter, limit, options)
      self.doi = doi
      self.member = member
      self.filter = filter
      self.limit = limit
      self.options = options
    end

    def perform
      fac = nil

      if member.nil?
        res = Serrano.works(ids: doi, filter: filter, limit: limit, options: options)
        if doi.nil?
          fac = Serrano.works(ids: doi, filter: filter, options: options, facet: 'license:*', limit: 0)
          fac = fac['message']['facets']['license']['value-count'].to_s
        end
      else
        res = Serrano.members(ids: member, filter: filter, works: true, limit: limit, options: options)
        if member.nil?
          fac = Serrano.member(ids: member, filter: filter, options: options, facet: 'license:*', limit: 0)
          fac = fac['message']['facets']['license']['value-count'].to_s
        end
      end
      Response.new(self.doi, self.member, res, fac)
    end
  end
end

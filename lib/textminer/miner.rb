require "faraday"
require "faraday_middleware"
require "multi_json"
require 'textminer/helpers/configuration'
require 'textminer/mined'
require 'textminer/mine_utils'

##
# Textminer::Miner
#
# Class to give back text mining object
module Textminer
  class Miner #:nodoc:
    attr_accessor :url

    def initialize(url)
      self.url = url
    end

    def perform
      conn = Faraday.new self.url do |c|
        c.use FaradayMiddleware::FollowRedirects
        c.adapter Faraday.default_adapter
        #c.adapter :net_http
      end

      if is_elsevier_wiley(self.url)
        res = conn.get do |req|
          req.headers['CR-Clickthrough-Client-Token'] = Textminer.tdm_key
        end
      else
        res = conn.get
      end

      type = detect_type(res)
      path = make_path(type)
      write_disk(res, path)

      return Mined.new(self.url, path, type)
    end

  end
end

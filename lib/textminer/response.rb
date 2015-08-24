module Textminer
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

require "textminer"
require 'fileutils'
require "test/unit"

class TestResponse < Test::Unit::TestCase

  def setup
    @doi = '10.5555/515151'
    @pdf = "http://annalsofpsychoceramics.labs.crossref.org/fulltext/10.5555/515151.pdf"
    @xml = "http://annalsofpsychoceramics.labs.crossref.org/fulltext/10.5555/515151.xml"
  end

  def test_links_endpoint
    assert_equal(Textminer::Response, Textminer.links(@doi).class)
  end

  def test_doi
    assert_equal(@doi, Textminer.links(@doi).doi)
  end

  def test_pdf
    assert_equal(@pdf, Textminer.links(@doi).pdf)
  end

  def test_xml
    assert_equal(@xml, Textminer.links(@doi).xml)
  end

end

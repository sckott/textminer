textminer
=========

[![Build Status](https://api.travis-ci.org/sckott/textminer.png)](https://travis-ci.org/sckott/textminer)

__This is alpha software, so expect changes__

## What is it?

__`textminer` helps you text mine through Crossref's TDM:__

## Changes

For changes see the [NEWS file](https://github.com/sckott/textminer/blob/master/NEWS.md).

## Install

### Release version

Not on RubyGems yet

### Development version

Install dependencies

```
gem install httparty launchy json rake api_cache moneta
sudo gem install thor
sudo gem install bundler
git clone https://github.com/sckott/textminer.git
cd textminer
bundle install
```

After `bundle install` the `textminer` gem is installed and available on the command line or in a Ruby repl.

## Within Ruby

Search by DOI

```ruby
require 'textminer'
out = textminer.links("10.5555/515151")
```

Get the pdf link

```ruby
out.pdf
```

```ruby
"http://annalsofpsychoceramics.labs.crossref.org/fulltext/10.5555/515151.pdf"
```

Get the xml link

```ruby
out.xml
```

```ruby
"http://annalsofpsychoceramics.labs.crossref.org/fulltext/10.5555/515151.xml"
```

Fetch XML

```ruby
Textminer.fetch("10.3897/phytokeys.42.7604", "xml")
```

```ruby
=> {"article"=>
  {"front"=>
    {"journal_meta"=>
      {"journal_id"=>
        {"__content__"=>"PhytoKeys", "journal_id_type"=>"publisher-id"},
       "journal_title_group"=>
        {"journal_title"=>{"__content__"=>"PhytoKeys", "lang"=>"en"},
         "abbrev_journal_title"=>{"__content__"=>"PhytoKeys", "lang"=>"en"}},
       "issn"=>
        [{"__content__"=>"1314-2011", "pub_type"=>"ppub"},
         {"__content__"=>"1314-2003", "pub_type"=>"epub"}],
       "publisher"=>{"publisher_name"=>"Pensoft Publishers"}},
     "article_meta"=>

...
```

Fetch PDF

```ruby
Textminer.fetch("10.3897/phytokeys.42.7604", "pdf")
```

> pdf written to disk

## On the CLI

coming soon...

## To do

* CLI executable
* get actual full text
* better test suite
* documentation

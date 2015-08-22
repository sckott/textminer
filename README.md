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

## On the CLI

coming soon...

## To do

* CLI executable
* get actual full text
* better test suite
* documentation

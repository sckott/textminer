textminer
=========

[![Build Status](https://travis-ci.org/sckott/textminer.svg?branch=master)](https://travis-ci.org/sckott/textminer)
[![codecov.io](http://codecov.io/github/sckott/textminer/coverage.svg?branch=master)](http://codecov.io/github/sckott/textminer?branch=master)

__`textminer` helps you text mine through Crossref's TDM (Text & Data Mining) services:__

## Changes

For changes see the [CHANGELOG][changelog]

## gem API

* `Textiner.search` - search by DOI, query string, filters, etc. to get Crossref metadata, which you can use downstream to get full text links. This method essentially wraps `Serrano.works()`, but only a subset of params - this interface may change depending on feedback.
* `Textiner.fetch` - Fetch full text given a url, supports Crossref's Text and Data Mining service
* `Textiner.extract` - Extract text from a pdf

## Install

### Release version

```
gem install textminer
```

### Development version

```
git clone git@github.com:sckott/textminer.git
cd textminer
rake install
```

## Examples

### Within Ruby

#### Search

Search by DOI

```ruby
require 'textminer'
# link to full text available
Textminer.search(doi: '10.7554/elife.06430')
# no link to full text available
Textminer.search(doi: "10.1371/journal.pone.0000308")
```

Many DOIs at once

```ruby
require 'serrano'
dois = Serrano.random_dois(sample: 6)
Textminer.search(doi: dois)
```

Search with filters

```ruby
Textminer.search(filter: {has_full_text: true})
```

#### Get full text links

The object returned form `Textminer.search` is a class, which has methods for pulling out all links, xml only, pdf only, or plain text only

```ruby
x = Textminer.search(filter: {has_full_text: true})
x.links_xml
x.links_pdf
x.links_plain
```

#### Fetch full text

`Textminer.fetch()` gets full text based on URL input. We determine how to pull down and parse the content based on content type.

```ruby
# get some metadata
res = Textminer.search(member: 2258, filter: {has_full_text: true});
# get links
links = res.links_xml(true);
# Get full text for an article
res = Textminer.fetch(url: links[0]);
# url
res.url
# file path
res.path
# content type
res.type
# parse content
res.parse
```

#### Extract text from PDF

`Textminer.extract()` extracts text from a pdf, given a path for a pdf

```ruby
res = Textminer.search(member: 2258, filter: {has_full_text: true});
links = res.links_pdf(true);
res = Textminer.fetch(url: links[0]);
Textminer.extract(res.path)
```

### On the CLI

Get links

```sh
tm links 10.3897/phytokeys.42.7604
```

```sh
http://phytokeys.pensoft.net/lib/ajax_srv/article_elements_srv.php?action=download_xml&item_id=4190
http://phytokeys.pensoft.net/lib/ajax_srv/article_elements_srv.php?action=download_pdf&item_id=4190
```

More than one DOI:

```sh
tm links '10.3897/phytokeys.42.7604,10.3897/zookeys.516.9439'
```

## To do

* CLI executable
* better test suite
* better documentation

[changelog]: https://github.com/sckott/textminer/blob/master/CHANGELOG.md

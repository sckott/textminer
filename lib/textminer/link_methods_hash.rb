# Hash methods
class Hash
  def links(just_urls = true)
    if self['message']['items'].nil?
      tmp = self['message']['link']
      if tmp.nil?
        tmp = nil
      else
        tmp = tmp.reject { |c| c.empty? }
      end
    else
      tmp = self['message']['items'].collect { |x| x['link'] }.reject { |c| c.empty? }
    end

  	return parse_links(tmp, just_urls)
  end
end

class Hash
  def links_xml(just_urls = true)
  	return parse_links(pull_links(self, '^application\/xml$|^text\/xml$'), just_urls)
  end
end

class Hash
  def links_pdf(just_urls = true)
  	return parse_links(pull_links(self, '^application\/pdf$'), just_urls)
  end
end

class Hash
  def links_plain(just_urls = true)
  	return parse_links(pull_links(self, '^application\/plain$|^text\/plain$'), just_urls)
  end
end

def pull_links(x, y)
  if x['message']['items'].nil?
    tmp = self['message']['link']
    if tmp.nil?
      return nil
    else
      return tmp.select { |z| z['content-type'].match(/#{y}/) }.reject { |c| c.empty? }
    end
  else
    return x['message']['items'].collect { |w| w['link'].select { |z| z['content-type'].match(/#{y}/) } }.reject { |c| c.empty? }
  end
end

def parse_links(x, just_urls)
  if x.nil?
    return nil
  else
  	if x.empty?
  		return x
  	else
    	if just_urls
        if x[0].class != Array
          # return x[0]['URL']
          return x.collect { |w| w['URL'] }.flatten
        else
          return x.collect { |w| w.collect { |z| z['URL'] }}.flatten
          # return x.collect { |x| x['URL'] }.flatten.compact
      		# return x.collect { |x| x.collect { |z| z['URL'] }}.flatten
        end
    	else
    		return x
    	end
    end
  end
end

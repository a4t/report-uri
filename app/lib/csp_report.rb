require 'uri'

class CspReport
  def host(data)
    URI.parse(data['csp-report']['document_uri']).host
  end

  def replase_array_key_hyphen_to_underscore(items)
    new_items = {}
    items.each do | key, value |
      new_key = key.gsub(/\-/, '_')
      new_items[new_key] = value
    end
    new_items
  end
end

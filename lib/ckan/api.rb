module CKAN
  class API
    @api_url = "http://ckan.net/api/1/"
    def self.api_url=(api_url)
      @api_url = api_url
    end
    def self.api_url
      @api_url
    end
  end
end

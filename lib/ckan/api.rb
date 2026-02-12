module CKAN
  class API
    @api_url = "http://ckan.net/api/1/"
    @api_version = nil
    @api_key = nil

    def self.api_url=(api_url)
      @api_version ||= api_url[/api\/(\d+)\//, 1] || "1"
      @api_url = api_url
    end

    def self.api_url
      @api_url
    end

    def self.api_version=(version)
      @api_version = version
    end

    def self.api_version
      @api_version
    end

    def self.api_key=(api_key)
      @api_key = api_key
    end

    def self.api_key
      @api_key
    end
  end
end

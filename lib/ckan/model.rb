module CKAN
  class Model
    protected

    def read_lazy_data
      unless @lazy_data_read
        data = if self.class.use_v3_api?
          # v3 API: action/<model>_show?id=<id>
          result = self.class.read_remote_json_data(self.class.v3_show_url(self.id))
          result["result"]
        else
          # v1 API: rest/<model>/<id>
          self.class.read_remote_json_data(self.class.site + "/" + self.id)
        end

        data.each do |name,value|
          self.instance_variable_set("@"+name,value)
        end
        @lazy_data_read = true
      end
    end

    def self.site=(address)
      @site = address
    end

    def self.base
      CKAN::API.api_url
    end

    def self.site
      base + @site
    end

    def self.search=(address)
      @search = address
    end

    def self.search
      base + @search
    end

    def self.read_remote_json_data(address)
      headers = {}
      if CKAN::API.api_key
        headers['Authorization'] = CKAN::API.api_key
        headers['X-CKAN-API-Key'] = CKAN::API.api_key
      end

      JSON.parse(URI.open(address, headers).read)
    end

    def self.lazy_reader(*names)
      names.each do |name|
        define_method(name) do
          read_lazy_data
          instance_variable_get("@" + name.to_s)
        end
      end
    end

    def self.use_v3_api?
      CKAN::API.api_version.to_s == "3"
    end

    def self.v3_show_url(id)
      # Override in subclasses if needed
      # Default: action/<model_name>_show?id=<id>
      model_name = self.name.split('::').last.downcase
      base + "api/3/action/#{model_name}_show?id=#{id}"
    end
  end
end

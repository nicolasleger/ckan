module CKAN
  class Package < Model
    self.site =  "rest/package"
    self.search = "search/package"

    attr_reader :id
    lazy_reader :name, :title, :url, :version, :author, :author_email,
      :maintainer, :maintainer_email, :license_id, :notes

    def initialize(id)
      @id = id
    end

    def self.find(options=nil)
      use_v3_api? ? find_v3(options) : find_v1(options)
    end

    def resources
      read_lazy_data
      @mapped_resources ||= @resources.
        map do |r|
          Resource.new(url: r["url"], format: r["format"], description: r["description"], hash: r["hash"])
        end
    end

    def to_s
      "CKAN::Package[#{@id}]"
    end

    protected
    def self.get(id)
      @package_map ||= {}
      unless @package_map[id]
        @package_map[id] = Package.new(id)
      end
      @package_map[id]
    end

    def self.use_v3_api?
      CKAN::API.api_version.to_s == "3"
    end

    def self.find_v1(options=nil)
      if options.nil?
        @all_packages ||= read_remote_json_data(self.site).map{|id| Package.get(id)}
      else
        query = "?"
        query += options.to_a.
          map{|k,v| v.is_a?(Array) ? v.map{|vv| "#{k}=#{CGI.escape(vv)}"}.join("&") :
            "#{k}=#{CGI.escape(v)}"}.join("&")
        result = read_remote_json_data(self.search + query)
        if result["count"] != result["results"].size
          query += "&offset=#{result["results"].size}&limit=#{result["count"] + result["results"].size}"
          result["results"] += read_remote_json_data(self.search + query)["results"]
        end

        result["results"].map{|id| Package.get(id)}
      end
    end

    def self.find_v3(options=nil)
      if options.nil?
        # v3 API: action/package_list
        result = read_remote_json_data(base + "api/3/action/package_list")
        @all_packages ||= result["result"].map{|id| Package.get(id)}
      else
        # v3 API: action/package_search
        query = "?"
        query += options.to_a.
          map{|k,v| v.is_a?(Array) ? v.map{|vv| "#{k}=#{CGI.escape(vv)}"}.join("&") :
            "#{k}=#{CGI.escape(v)}"}.join("&")
        result = read_remote_json_data(base + "action/package_search" + query)

        # v3 returns different structure with results nested in result
        result["result"]["results"].map do |pkg|
          Package.get(pkg["name"] || pkg["id"])
        end
      end
    end
  end
end

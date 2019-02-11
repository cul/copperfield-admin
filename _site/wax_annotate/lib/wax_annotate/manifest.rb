require 'net/http'

module WaxAnnotate
  #
  #
  class Manifest
    attr_reader :hash, :path

    def initialize(uri, config, listpath)
      @uri      = uri
      @config   = config
      @listpath = "#{config.url}#{config.baseurl}#{listpath}"
      @path     = "#{@config.target_dir}/#{@uri.split('/')[-2]}/clean-manifest.json"
      @hash     = create_clean_manifest
    end

    #
    #
    def fetch_remote_manifest
      return JSON.parse(IO.read(@path)) if File.exist?(@path)

      response = Net::HTTP.get_response(URI(@uri))
      raise WaxAnnotate::Error, "Could not load manifest from '#{@uri}.'" unless response.is_a? Net::HTTPSuccess

      hash                  = JSON.parse(response.body)
      hash['@ogid']         = hash['@id'].clone
      hash['@id']           = File.join(@config.url, @config.baseurl, @path)
      hash['otherContent']  = [{ '@id' => @listpath, '@type' => 'sc:AnnotationList' }]

      hash
    rescue => e
      raise WaxAnnotate::Error.new("Coldn't parse JSON from manifest found at #{@uri}.", e)
    end

    #
    #
    def create_clean_manifest
      hash = fetch_remote_manifest
      return hash if File.exist?(@path)

      FileUtils.mkdir_p(File.dirname(@path))
      File.open(@path, 'w+') { |f| f.write(JSON.pretty_generate(hash)) }

      hash
    end
  end
end

module WaxAnnotate
  #
  #
  class Config
    def initialize(site_config)
      @config = site_config
    end

    #
    #
    def url
      @config.fetch('url', '')
    end

    #
    #
    def baseurl
      @config.fetch('baseurl', '')
    end

    #
    #
    def ingest_dir
      dir = @config.dig('wax_annotate', 'ingest_dir')
      raise WaxAnnotate::Error, "Cannot load 'wax_annotate' 'ingest_dir' in _config.yml" if dir.nil?

      dir
    end

    #
    #
    def target_dir
      dir = @config.dig('wax_annotate', 'target_dir')
      raise WaxAnnotate::Error, "Cannot load 'wax_annotate' 'target_dir' in _config.yml" if dir.nil?

      dir
    end

    #
    #
    def manifests
      manifests = @config.dig('wax_annotate', 'manifests')
      raise WaxAnnotate::Error, "Cannot load 'wax_annotate' 'manifests' in _config.yml" if manifests.nil?

      manifests
    end
  end
end

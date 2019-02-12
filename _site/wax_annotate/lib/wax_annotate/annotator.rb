module WaxAnnotate
  #
  #
  class Annotator
    def initialize(site_config)
      @config       = WaxAnnotate::Config.new(site_config)
      @annotations  = WaxAnnotate.validate_annotations(fetch_annotations)
      @manifests    = @config.manifests.map { |uri| Manifest.new(uri, @config) }

      raise WaxAnnotate::Error, "Couldn't find annotations to process in '#{@config.ingest_dir}'" if @annotations.empty?
      raise WaxAnnotate::Error, "Couldn't find IIIF manifests to process in _config.yml" if @manifests.empty?

      puts  Rainbow("\nFound #{@annotations.length} unique annotations inside ingest_dir '#{@config.ingest_dir}'").cyan
    end

    #
    #
    def process_annotations
      create_annotation_lists
      puts Rainbow("\nSuccess ✓").green
    end

    #
    #
    def create_annotation_lists
      @annotations.group_by(&:manifest).each do |m, m_annotations|
        manifest = @manifests.find { |i| i.hash.fetch('@id') == m }
        m_annotations.group_by(&:canvas).each do |canvas_uri, c_annotations|
          list = WaxAnnotate::AnnotationList.new(manifest, canvas_uri, c_annotations)
          list.write_to_file
        end
      end
    end

    #
    #
    def fetch_annotations
      raise WaxAnnotate::Error, "Cannot find 'ingest_dir'" if @config.ingest_dir.nil?

      annotations = Dir["#{@config.ingest_dir}/*.json"].map do |file|
        date = File.basename(file, '.json').gsub('annotations_', '')
        JSON.parse(IO.read(file)).map do |a|
          a['dateCreated'] = date
          a
        end
      end.flatten

      annotations.map { |h| Annotation.new(h) }
    end
  end
end

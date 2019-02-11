require 'wax_annotate/annotation'
require 'wax_annotate/config'
require 'wax_annotate/error'
require 'wax_annotate/manifest'
require 'wax_annotate/version'

# top level comment todo
module WaxAnnotate

  class Annotator
    def initialize(site_config)
      @config       = WaxAnnotate::Config.new(site_config)
      @annotations  = fetch_annotations.map { |hash| Annotation.new(hash) }
      @listpath     = File.join(@config.target_dir, 'annotations.json')
      @manifests    = @config.manifests.map { |uri| Manifest.new(uri, @config, @listpath) }

      @list = {
        '@context': 'http://iiif.io/api/presentation/2/context.json',
        '@id': @listpath,
        '@type': "sc:AnnotationList",

        'resources': []
      }

      puts @list

      raise WaxAnnotate::Error, "Couldn't find annotations to process in '#{@config.ingest_dir}'" if @annotations.empty?
      raise WaxAnnotate::Error, "Couldn't find IIIF manifests to process in _config.yml" if @manifests.empty?

      validate_annotations
    end

    #
    #
    def process_annotations
      puts Rainbow("\nFound #{@annotations.length} unique annotations inside ingest_dir '#{@config.ingest_dir}'").cyan



      annotation_list = JSON.pretty_generate(@annotations.map { |a| a.hash })
      FileUtils.mkdir_p(File.dirname(@listpath))
      File.open(@listpath, 'w+') { |f| f.write(annotation_list) }

      puts Rainbow("\nSuccess ✓").green
    end

    #
    #
    def fetch_annotations
      raise WaxAnnotate::Error, "Cannot find 'ingest_dir'" if @config.ingest_dir.nil?

      Dir["#{@config.ingest_dir}/*.json"].map do |file|
        date = File.basename(file, '.json').gsub('annotations_', '')
        JSON.parse(IO.read(file)).map do |a|
          a['dateCreated'] = date
          a
        end
      end.flatten
    end

    #
    #
    def validate_annotations
      ids    = @annotations.each.map(&:id)
      dups   = ids.find_all { |i| ids.count(i) > 1 }.uniq

      return if dups.empty?

      valid = (ids - dups).map { |i| @annotations.find{ |a| a.id == i } }
      dups.each do |d|
        possible = @annotations.find_all { |a| a.id == d }
        newest   = possible.sort_by! { |k| k.date }.last

        valid << newest
      end

      @annotations = valid
    end

    #
    #
    def self.add_annotations_to_manifests(annotations, manifests)
      manifest_dict = manifests.map { |m| { path: m.path, ogid: m.hash.fetch('@ogid') } }
      # annotations.each do |anno|
      #   path = manifest_dict.find { |m| m[:ogid] == anno.parent }.fetch(:path)
      # end
    end
  end
end

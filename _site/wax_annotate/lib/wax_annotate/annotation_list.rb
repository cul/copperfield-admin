module WaxAnnotate
  #
  #
  class AnnotationList
    def initialize(manifest, canvas_uri, annotations)
      @manifest      = manifest
      @canvas_uri    = canvas_uri
      @annotations   = annotations
      @listpath      = File.join(@manifest.listdir, "#{@canvas_uri.split('/')[-1]}.json")

      reconcile_existing_annotations if File.exist?(@listpath)

      @list = generate_list
    end



    def generate_list
      {
        '@context': 'http://iiif.io/api/presentation/2/context.json',
        '@id': @listpath,
        '@type': 'sc:AnnotationList',
        'resources': @annotations.map(&:hash)
      }
    end

    #
    #
    def reconcile_existing_annotations
      existing = JSON.parse(IO.read(@listpath)).fetch('resources')
      existing.map! { |h| Annotation.new(h) }
      total = WaxAnnotate.validate_annotations(existing + @annotations)
      @annotations = total
    end

    

    def write_to_file
      FileUtils.mkdir_p(File.dirname(@listpath))
      File.open(@listpath, 'w+') { |f| f.write(JSON.pretty_generate(@list)) }
    end
  end
end

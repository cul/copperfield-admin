require 'net/http'

module WaxAnnotate
  #
  #
  class Manifest
    attr_reader :hash, :path, :listdir

    def initialize(uri, config)
      @uri      = uri
      @config   = config
      @dir      = File.join(@config.target_dir, @uri.split('/')[-2])
      @path     = "#{@dir}/manifest.json"
      @listdir  = File.join(@dir, 'list')
      @hash     = parse_manifest
    end

    #
    #
    def fetch_remote_manifest
      response = Net::HTTP.get_response(URI(@uri))
      raise WaxAnnotate::Error, "Could not load manifest from '#{@uri}.'" unless response.is_a? Net::HTTPSuccess

      JSON.parse(response.body)
    rescue => e
      raise WaxAnnotate::Error.new("Coldn't parse JSON from manifest found at #{@uri}.", e)
    end

    #
    #
    def parse_manifest
      if File.exist?(@path)
        JSON.parse(IO.read(@path))
      else
        manifest = fetch_remote_manifest
        manifest['sequences'].map do |seq|
          seq['canvases'].map do |c|
            canvas_id = c['@id'].split('/')[-1]
            c['otherContent'] = [{
              '@id':   File.join(@listpath, "#{canvas_id}.json"),
              '@type': 'sc:AnnotationList'
            }]
            c
          end
        end
        FileUtils.mkdir_p(File.dirname(@path))
        File.open(@path, 'w+') { |f| f.write(JSON.pretty_generate(manifest)) }
        manifest
      end
    end
  end
end

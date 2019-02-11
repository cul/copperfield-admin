require 'rainbow'
require 'fileutils'
require 'json'
require 'yaml'

require 'wax_annotate'

namespace :wax do
  namespace :annotate do
    desc 'store local iiif annotations and add them to manifest'
    task :iiif do
      site_config = YAML.load_file('./_config.yml')
      annotator   =  WaxAnnotate::Annotator.new(site_config )

      # annotator.process_annotations
    end
  end
end

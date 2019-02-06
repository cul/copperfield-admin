require 'rainbow'
require 'fileutils'
require 'json'

require 'wax_annotate'

namespace :wax do
  namespace :annotate do
    desc 'store local iiif annotations and add them to manifest'
    task :iiif do
      Dir['_annotations/*.json'].each do |annotation_list|
        puts annotation_list
      end
    end
  end
end

require 'wax_annotate/annotation'
require 'wax_annotate/annotation_list'
require 'wax_annotate/annotator'
require 'wax_annotate/canvas'
require 'wax_annotate/config'
require 'wax_annotate/error'
require 'wax_annotate/manifest'
require 'wax_annotate/version'

# top level comment todo
module WaxAnnotate
  #
  #
  def self.validate_annotations(annotations)
    ids    = annotations.each.map(&:id)
    dups   = ids.find_all { |i| ids.count(i) > 1 }.uniq

    return if dups.empty?

    valid = (ids - dups).map { |i| annotations.find { |a| a.id == i } }
    dups.each do |d|
      possible = annotations.find_all { |a| a.id == d }
      newest   = possible.sort_by!(&:date).last

      valid << newest
    end

    valid
  end
end

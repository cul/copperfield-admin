module WaxAnnotate
  #
  #
  class Annotation
    attr_reader :hash, :id, :date, :manifest, :canvas

    def initialize(hash)
      @hash     = hash
      @id       = hash['@id']
      @date     = hash['dateCreated']
      @manifest = hash.dig('on')&.first&.dig('within', '@id')
      @canvas   = hash.dig('on')&.first&.dig('full')

      raise WaxAnnotate::Error, "Couldn't find valid manifest parent for annotation '#{@id}'" unless @manifest =~ URI::DEFAULT_PARSER.make_regexp
      raise WaxAnnotate::Error, "Couldn't find valid canvas parent for annotation '#{@id}'" unless @canvas =~ URI::DEFAULT_PARSER.make_regexp
    end
  end
end

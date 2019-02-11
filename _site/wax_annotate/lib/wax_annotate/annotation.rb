module WaxAnnotate
  #
  #
  class Annotation
    attr_reader :hash, :parent, :id, :date

    def initialize(hash)
      @hash   = hash
      @id     = hash['@id']
      @date   = hash['dateCreated']
      @parent = hash.dig('on')&.first&.dig('within', '@id')

      raise WaxAnnotate::Error, "Couldn't find valid manifest parent for annotation '#{@id}'" unless @parent =~ URI::regexp
    end
  end
end

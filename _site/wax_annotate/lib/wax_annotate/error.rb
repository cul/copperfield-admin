require 'rainbow'

module WaxAnnotate
  # Custom WaxTasks Errors module
  class Error < StandardError
    def initialize(msg = '', exception = '')
      super("#{Rainbow(msg).magenta}\n#{exception}")
    end
  end
end

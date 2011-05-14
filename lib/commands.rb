module OgreIsland::Commands
  class << self
    attr_accessor :commands
  end

  require 'commands/base'
end

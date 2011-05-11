module OgreIsland::Commands
  class << self
    attr_accessor :commands
  end

  require 'commands/base'
  Dir[File.join(File.dirname(__FILE__), 'commands', '*')].each { |file| require file }
end

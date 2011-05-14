class OgreIsland::Commands::ChatChannel < OgreIsland::Commands::Base
  register 'CCHANNEL', :mode => :server do |command|
    command.string :channel
  end
end

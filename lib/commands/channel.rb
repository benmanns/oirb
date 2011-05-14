class OgreIsland::Commands::Channel < OgreIsland::Commands::Base
  register 'CHANNEL', :mode => :client do |command|
    command.string :channel
  end
end

class OgreIsland::Commands::Train < OgreIsland::Commands::Base
  register 'TRAIN', :mode => :client do |command|
    command.string :attribute
  end
end

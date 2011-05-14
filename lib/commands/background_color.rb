class OgreIsland::Commands::BackgroundColor < OgreIsland::Commands::Base
  register 'BGCOLOR', :mode => :server do |command|
    command.string :value
  end
end

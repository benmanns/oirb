class OgreIsland::Commands::InitializeBar < OgreIsland::Commands::Base
  register 'INITBAR', :mode => :server do |command|
    command.string :time
  end
end

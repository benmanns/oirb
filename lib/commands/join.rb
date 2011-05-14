class OgreIsland::Commands::Join < OgreIsland::Commands::Base
  register 'JOIN', :mode => [:client, :server] do |command|
    command.string :name
  end
end

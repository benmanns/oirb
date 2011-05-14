class OgreIsland::Commands::Cast < OgreIsland::Commands::Base
  register 'CAST', :mode => :client do |command|
    command.string :name
  end
end

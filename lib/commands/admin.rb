class OgreIsland::Commands::Admin < OgreIsland::Commands::Base
  register 'ADMIN', :mode => :server do |command|
    command.string :type
    command.string :text
    command.string :uri
  end
end

class OgreIsland::Commands::AddPlayer < OgreIsland::Commands::Base
  register 'ADDPLAYER', :mode => :server do |command|
    command.string :name
    command.string :display
  end
end

class OgreIsland::Commands::RemoveCharacter < OgreIsland::Commands::Base
  register 'REMCHAR', :mode => :server do |command|
    command.string :id
  end
end

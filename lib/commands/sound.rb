class OgreIsland::Commands::Sound < OgreIsland::Commands::Base
  register 'SOUND', :mode => :server do |command|
    command.string :name
    command.string :loops
  end
end

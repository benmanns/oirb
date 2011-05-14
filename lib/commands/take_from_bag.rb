class OgreIsland::Commands::TakeFromBag < OgreIsland::Commands::Base
  register 'TAKEFROMBAG', :mode => :server do |command|
    command.string :name
    command.string :id
  end
end

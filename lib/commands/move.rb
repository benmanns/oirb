class OgreIsland::Commands::Move < OgreIsland::Commands::Base
  register 'MOVE', :mode => :client do |command|
    command.string :x
    command.string :y
    command.string :tile
    command.string :unknown # before dowarp, set to True on my id.
  end
  register 'MOVE', :mode => :server do |command|
    command.string :id
    command.string :x
    command.string :y
    command.string :tile
  end
end

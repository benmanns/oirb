class OgreIsland::Commands::Move < OgreIsland::Commands::Base
  register 'MOVE', :mode => :client do |command|
    command.string :x
    command.string :y
    command.string :tile
  end
  register 'MOVE', :mode => :server do |command|
    command.string :id
    command.string :x
    command.string :y
    command.string :tile
  end
end

class OgreIsland::Commands::Attack < OgreIsland::Commands::Base
  register 'ATTACK', :mode => :server do |command|
    command.string :id
    command.string :x
    command.string :y
    command.string :direction
  end
end

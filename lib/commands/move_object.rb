class OgreIsland::Commands::MoveObject < OgreIsland::Commands::Base
  register 'MOVEOBJECT', :mode => :client do |command|
    command.string :id
    command.string :x
    command.string :y
    command.string :z
  end
end

class OgreIsland::Commands::Action < OgreIsland::Commands::Base
  register 'ACTION', :mode => :server do |command|
    command.string :id
    command.string :action
    command.string :direction
  end
end

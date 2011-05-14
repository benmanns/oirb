class OgreIsland::Commands::ControlClickObject < OgreIsland::Commands::Base
  register 'CTRLCLICKOBJECT', :mode => :client do |command|
    command.string :id
  end
end

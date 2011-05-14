class OgreIsland::Commands::ModifyHouse < OgreIsland::Commands::Base
  register 'MODHOUSE', :mode => :client do |command|
    command.string :action
    command.string :argument
  end
end

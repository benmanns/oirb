class OgreIsland::Commands::EditObject < OgreIsland::Commands::Base
  register 'EDITOBJECT', :mode => :client do |command|
    command.string :id
  end
end

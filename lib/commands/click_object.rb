class OgreIsland::Commands::ClickObject < OgreIsland::Commands::Base
  register 'CLICKOBJECT', :mode => :client do |command|
    command.string :id
  end
end

class OgreIsland::Commands::DoAction < OgreIsland::Commands::Base
  register 'DOACTION', :mode => :client do |command|
    command.string :action
  end
end

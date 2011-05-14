class OgreIsland::Commands::UseBagItem < OgreIsland::Commands::Base
  register 'USEBAGITEM', :mode => :client do |command|
    command.string :name
    command.string :id
  end
end

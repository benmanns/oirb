class OgreIsland::Commands::MoveBagItem < OgreIsland::Commands::Base
  register 'MOVEBAGITEM', :mode => :client do |command|
    command.string :name
    command.string :id
  end
end

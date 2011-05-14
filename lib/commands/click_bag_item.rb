class OgreIsland::Commands::ClickBagItem < OgreIsland::Commands::Base
  register 'CLICKBAGITEM', :mode => :client do |command|
    command.string :name
    command.string :id
  end
end

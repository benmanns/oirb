class OgreIsland::Commands::ClickTree < OgreIsland::Commands::Base
  register 'CLICKTREE', :mode => :client do |command|
    command.string :id
  end
end

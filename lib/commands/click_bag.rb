class OgreIsland::Commands::ClickBag < OgreIsland::Commands::Base
  register 'CLICKBAG', :mode => :client do |command|
    command.string :name
    command.string :x
    command.string :y
  end
end

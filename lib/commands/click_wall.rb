class OgreIsland::Commands::ClickWall < OgreIsland::Commands::Base
  register 'CLICKWALL', :mode => :client do |command|
    command.string :id
  end
end

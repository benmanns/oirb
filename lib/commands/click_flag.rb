class OgreIsland::Commands::ClickFlag < OgreIsland::Commands::Base
  register 'CLICKFLAG', :mode => :client do |command|
    command.string :id
  end
end

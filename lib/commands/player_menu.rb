class OgreIsland::Commands::PlayerMenu < OgreIsland::Commands::Base
  register 'PLAYERMENU', :mode => :client do |command|
    command.string :action
    command.string :id
  end
end

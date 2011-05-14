class OgreIsland::Commands::ControlClickTree < OgreIsland::Commands::Base
  register 'CTRLCLICKTREE', :mode => :client do |command|
    command.string :id
  end
end

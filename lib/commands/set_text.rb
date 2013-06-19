class OgreIsland::Commands::SetText < OgreIsland::Commands::Base
  register 'SETTEXT', :mode => :server do |command|
    command.string :window
    command.string :name
    command.string :value
  end
end

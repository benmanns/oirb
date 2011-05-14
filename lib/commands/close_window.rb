class OgreIsland::Commands::CloseWindow < OgreIsland::Commands::Base
  register 'CLOSEWINDOW', :mode => :server do |command|
    command.string :window
  end
end

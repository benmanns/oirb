class OgreIsland::Commands::SetAction < OgreIsland::Commands::Base
  register 'SETACTION', :mode => :server do |command|
    command.string :id
    command.string :name
    command.string :frame
  end
end

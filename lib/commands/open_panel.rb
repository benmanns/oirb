class OgreIsland::Commands::OpenPanel < OgreIsland::Commands::Base
  register 'OPENPANEL', :mode => :server do |command|
    command.string :panel
    command.string :frame
  end
end

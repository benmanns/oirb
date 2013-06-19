class OgreIsland::Commands::ToolIcon < OgreIsland::Commands::Base
  register 'TOOLICON', :mode => :server do |command|
    command.string :frame
  end
end

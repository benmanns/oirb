class OgreIsland::Commands::OpenWindow < OgreIsland::Commands::Base
  register 'OPENWINDOW', :mode => :server do |command|
    command.string :name
    command.string :text
    command.string :title
    command.string :type
  end
end

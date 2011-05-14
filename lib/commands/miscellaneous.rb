class OgreIsland::Commands::Miscellaneous < OgreIsland::Commands::Base
  register 'MISC', :mode => :server do |command|
    command.string :type
    command.string :text
    command.string :uri
  end
end

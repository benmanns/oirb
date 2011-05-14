class OgreIsland::Commands::Attribute < OgreIsland::Commands::Base
  register 'ATTRIB', :mode => :server do |command|
    command.string :attribute
    command.string :value
  end
end

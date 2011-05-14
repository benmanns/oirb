class OgreIsland::Commands::CharacterAttribute < OgreIsland::Commands::Base
  register 'CHARATTRIB', :mode => :server do |command|
    command.string :attribute
    command.string :base
    command.string :modification
    command.string :total
  end
end

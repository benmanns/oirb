class OgreIsland::Commands::Selected < OgreIsland::Commands::Base
  register 'SELECTED', :mode => :server do |command|
    command.string :unknown1
    command.string :name
    command.string :level
    command.string :clan
    command.string :unknown2
    command.string :unknown3
    command.string :unknown4
  end
end

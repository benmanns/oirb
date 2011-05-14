class OgreIsland::Commands::ModifyBagItem < OgreIsland::Commands::Base
  register 'MODIFYBAGITEM', :mode => :server do |command|
    command.string :name
    command.string :item
  end
end

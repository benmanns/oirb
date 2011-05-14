class OgreIsland::Commands::SetSkill < OgreIsland::Commands::Base
  register 'SETSKILL', :mode => :server do |command|
    command.string :name
    command.string :value
    command.string :icon2
    command.string :text2
    command.string :icon3
    command.string :text3
    command.string :icon4
    command.string :text4
    command.string :icon5
    command.string :text5
    command.string :icon6
    command.string :text6
    command.string :icon7
    command.string :text7
    command.string :icon8
    command.string :text8
  end
end

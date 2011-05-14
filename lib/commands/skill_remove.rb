class OgreIsland::Commands::SkillRemove < OgreIsland::Commands::Base
  register 'SKILLREMOVE', :mode => :client do |command|
    command.string :name
  end
end

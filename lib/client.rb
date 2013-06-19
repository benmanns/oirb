class OgreIsland::Client < OgreIsland::ServerProtocol
  include OgreIsland::Commands

  CLIENT = 'beta 3.3a - '

  BAG_DIMENSIONS = {
    :bank => { :x => 20..320, :y => 30..195 },
    :bag => { :x => 20..199, :y => 30..150 },
    :loot => { :x => 12..217, :y => 32..150 },
  }

  def initialize options={}
    super(*[])
    @options = options
    @sent_login = false
    @inventory = {}
    @attributes = {}
    @characters = {}
    @clips = {}
    @health_bars = {}
    @character_attributes = {}
    @actions = {}
    @statistics = {}
    @skills = {}
    @bags = {}
    @objects = {}
    @variables = {}
    @channels = []
    @get_variables = {
      '_root.me.speed' => Proc.new { @actions[@id][:speed] },
      '_root.map._xscale' => Proc.new { '100' },
    }
    before_receive_command { |command| process_client_command command }
    after_unbind { client_unbind }
  end

  def post_init
    super
    send_command Handshake.new :sender => 'oi_client'
  end

  def process_client_command command
    case command
    when Handshake
      unless @sent_login
        send_command Login.new :id => @options[:auth][:id], :token => @options[:auth][:token], :client => CLIENT
        @sent_login = true
      end
    when LoginReply
      case command.status
      when 'AUTH'
      when 'GOOD'
        @name = command.name
        @id = command.id
        send_command Play.new
      when 'BAD'
        puts "Bad login: #{options[:auth]}"
      else
        p command
      end
    when Say
      puts "#{command.name}: #{command.text}"
    when BackgroundColor
      @color = command.value
    when Inventory
      # item0=111=Boots|tip=Boots - Bars: 2  Chance: 95%
      # sellitem==
      # sellitem=29=iron Dagger
      # equip_leftobject=50=iron Pickaxe|
      command.item.split('|').each do |item|
        unless item.empty?
          item = item.split('=')
          case item.first
          when 'tip'
            @inventory[:tip] = item[1]
          when /\Aequip_(held|helmet|arms|torso|legs|feet|leftobject|rightobject|cloak|leftring|rightring)\Z/
            @inventory[:equip] ||= {}
            @inventory[:equip][$1.to_sym] = { :frame => item[1].to_i, :name => item[2] }
          when /\Aitem(\d+)\Z/
            @inventory[:item] ||= []
            @inventory[:item][$1.to_i] = { :frame => item[1].to_i, :name => item[2] }
          when /\Ares(\d+)\Z/
            @inventory[:res] ||= []
            @inventory[:res][$1.to_i] = { :frame => item[1].to_i, :name => item[2] }
          end
        end
      end
    when Attribute
      case command.attribute
      when 'AC', 'MC', 'LEVEL', 'GOLD', 'EXP', 'EXPNEEDED', 'FOCUSPOINTS', 'KARMA', 'SKILLPOINTS', 'bagitems', 'PLAT'
        @attributes[command.attribute.downcase.to_sym] = command.value.to_i
      when 'bankweight', 'bagweight'
        @attributes[command.attribute.downcase.to_sym] = command.value.split('/').map(&:to_i)
      when 'txtSellPrice'
        #'19g', 'sell item'
        @attributes[command.attribute.downcase.to_sym] = if command.value =~ /\A(\d+)g\Z/
          $1.to_i
        end
      end
    when AddCharacter
      @characters[command.id] = command.attributes
    when SetClips
      @clips[command.id] = command.attributes
    when HealthBar
      @health_bars[command.id] = command.attributes
    when CharacterAttribute
      @character_attributes[command.attribute.downcase.to_sym] = command.attributes
    when SetAction
      @actions[command.id] ||= {}
      @actions[command.id][command.name.downcase.to_sym] = command.frame.to_i
    when Statistic
      @statistics[command.id] ||= {}
      @statistics[command.id][command.attribute.downcase.to_sym] = [command.value.to_i, command.maximum.to_i]
    when SetSkill
      @skills[command.name.downcase.to_sym] = command.value.to_f
    when AddToBag
      items = command.items.split(';').map { |item| item = item.split(','); { :id => item[0], :frame => item[1].to_i, :x => item[2].to_i, :y => item[3].to_i, :name => item[4] } }
      @bags[command.name.downcase.to_sym] ||= {}
      items.each { |item| @bags[command.name.downcase.to_sym][item[:id]] = item }
    when Warp
      @characters[command.id].merge! command.attributes
    when AddObject
      @objects[command.id] = command.attributes
    when ChatChannel
      @channel = command.channel
    when Join
      @channels << command.name unless command.name.empty?
    when SetVariable
      @variables[command.variable] = command.value
    when Play
      puts "#{@name} set to play!"
    when Sound
      # Play sound #{command.name} #{command.loops} times.
    when GetVariable
      if command.response_key == 'GV'
        if @get_variables[command.variable]
          send_command GetVariable.new :variable => command.variable, :value => @get_variables[command.variable].call
        end
      else
        p command
      end
    when Action
      @characters[command.id] ||= {}
      @characters[command.id][:action] = { :action => command.action, :direction => command.direction}
      # collect_ore, horse_still
    when InitializeBar
      # Waiting #{command.time}.
    when ModifyBagItem
      item = command.item.split(',');
      item = { :id => item[0], :frame => item[1].to_i, :x => item[2].to_i, :y => item[3].to_i, :name => item[4] }
      @bags[command.name.downcase.to_sym] ||= {}
      @bags[command.name.downcase.to_sym][item[:id]] = item
    when TakeFromBag
      @bags[command.name.downcase.to_sym] ||= {}
      @bags[command.name.downcase.to_sym].delete command.id
    when ToolIcon
      # Set tool icon to #{command.frame}.
    when RemoveCharacter
      @characters.delete command.id
    when RemoveObject
      @objects.delete command.id
    when Selected
      # Selected #{command.name}.
    end
  end

  def click_bag bag, name
    dimensions = BAG_DIMENSIONS[bag] || { :x => 0..0, :y => 0..0 }
    require 'digest/sha2'
    digest = Digest::SHA512.hexdigest(name).hex
    x_width = dimensions[:x].max - dimensions[:x].min
    y_width = dimensions[:y].max - dimensions[:y].min
    x = dimensions[:x].min + digest % x_width
    y = dimensions[:y].min + (digest / x_width) % y_width
    send_command ClickBag.new :name => bag, :x => x, :y => y
  end

  def client_unbind
    puts 'Bye!'
  end
end

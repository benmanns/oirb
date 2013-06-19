require 'logger'

class OgreIsland::Proxy < OgreIsland::ClientProtocol
  def initialize options
    super(*[])
    @options = options
    before_receive_command { |command| process_client_command command }
    after_receive_command { |command| client_receive_command command }
    after_unbind { client_unbind }
  end

  def post_init
    super
    @logger = Logger.new 'packets.log'
    EventMachine.connect @options[:host], @options[:port], OgreIsland::ServerProtocol do |server_protocol|
      @server_protocol = server_protocol
      @server_protocol.before_receive_command { |command| process_server_command command }
      @server_protocol.after_receive_command { |command| server_receive_command command }
      @server_protocol.after_unbind { server_unbind }
      @server_protocol.after_unprocessable_packet { |packet| server_unprocessable_packet packet }
    end
  end

  def server_receive_command command
    if command.class == OgreIsland::Commands::Base
      @logger.error "S->C: #{command.inspect}"
    else
      @logger.info "S->C: #{command.inspect}"
    end
    if command.class == OgreIsland::Commands::Base
      puts "Server -> Client"
      p command
    end
    send_command command
  end

  def client_receive_command command
    if command.class == OgreIsland::Commands::Base
      @logger.error "C->S: #{command.inspect}"
    else
      @logger.info "C->S: #{command.inspect}"
    end
    if command.class == OgreIsland::Commands::Base
      puts "Client -> Server"
      p command
    end
    @server_protocol.send_command command
  end

  def client_unbind
    @server_protocol.close_connection_after_writing
  end

  def server_unbind
    close_connection_after_writing
  end

  def server_unprocessable_packet packet
    send_packet packet
  end

  BAG_DIMENSIONS = {
    :bank => { :x => 20..320, :y => 30..195 },
    :bag => { :x => 20..199, :y => 30..150 },
    :loot => { :x => 12..217, :y => 32..150 },
  }

  def bag_coordinates bag, name
    dimensions = BAG_DIMENSIONS[bag] || { :x => 0..0, :y => 0..0 }
    require 'digest/sha2'
    digest = Digest::SHA512.hexdigest(name).hex
    x_width = dimensions[:x].max - dimensions[:x].min
    y_width = dimensions[:y].max - dimensions[:y].min
    { :x => dimensions[:x].min + digest % x_width, :y => dimensions[:y].min + (digest / x_width) % y_width }
  end

  def click_bag bag, name
    @server_protocol.send_command OgreIsland::Commands::ClickBag.new bag_coordinates(bag, name).merge :name => bag
  end

	def say text
		send_command OgreIsland::Commands::Say.new :name => 'oirb', :text => text
	end

	def items bag, name
		@bags[bag].select do |id, item|
			if name.is_a? Regexp
				item[:name] =~ name
			else
				item[:name] == name
			end
		end
	end

	def bag_items name
		items 'bag', name
	end

	def bank_items name
		items 'bank', name
	end

	def smith anvil, metal, item
		i = 0.0
    EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickObject.new :id => anvil }
    EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickInventory.new :name => metal }
    EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickInventory.new :name => item }
    EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::DoAction.new :action => 'construction' }
	end

  def process_client_command command
    case command
    when OgreIsland::Commands::Say
      if command.text =~ /\A!(.*)\Z/
        action = $1.split
        case action.first
          when 'eval'
            begin
              result = eval action[1..-1].join ' '
              say "Got result: #{result.inspect}"
            rescue Exception => e
              say "Got error: #{e.inspect}"
            end
          when 'smither'
						if @smither
							@smither.cancel
							@smither = nil
						else
		          @smither = EventMachine::PeriodicTimer.new(16) do
		            i = 0.0
		            iron_count = @bags['bag'].inject(0) { |result, item| (item.last[:name] =~ /\A(\d+) Iron bars\Z/) ? result + $1.to_i : result }
		            if iron_count < 20
									bag_items('iron Breastplate').each do |id, item|
										EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBagItem.new :name => 'bag', :id => item[:id] }
										EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBag.new :name => 'bank', :x => '268.9', :y => '27.45' }
										say "Putting #{item[:name]} in bank."
									end
						      bank_items(/\A(\d+) Iron bars\Z/).to_a.sample(10).each do |item|
						        EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBagItem.new :name => 'bank', :id => item.first }
						        EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBag.new :name => 'bag', :x => '10.0', :y => '10.0' }
						        say "Getting #{item.last[:name]}."
						      end
		            else
									smith 'obj11642', 'res1', 'item3'
		            end
							end
            end
          when 'smith'
						smith 'obj11642', 'res1', 'item3'
          when 'retrieve'
            i = 0.0
            bank_items(/\A(\d+) Iron bars\Z/).to_a.sample(10).each do |item|
              EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBagItem.new :name => 'bank', :id => item.first }
              EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBag.new :name => 'bag', :x => '10.0', :y => '10.0' }
              say "Getting #{item.last[:name]}."
            end
          when 'store'
            i = 0.0
            bag_items('iron Breastplate').each do |id, item|
              EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBagItem.new :name => 'bag', :id => id }
              EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBag.new :name => 'bank', :x => '268.9', :y => '27.45' }
              say "Putting #{item[:name]} in bank."
            end
          when 'miner'
            times = 0
            EventMachine::PeriodicTimer.new(6) do
              if (times += 1) % 10 == 0
                i = 0.0
                bag_items(/(\A(\d+) Iron bars\Z| Gem\Z)/).each do |id, item|
                  EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBagItem.new :name => 'bag', :id => item[:id] }
                  EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBag.new :name => 'bank', :x => '10.0', :y => '10.0' }
                  say "Putting #{item[:name]} in bank."
                end
              else
                rock = @objects.select { |id, item| item[:clip] == 'rockmine' }.to_a.sample.last
                @server_protocol.send_command OgreIsland::Commands::ClickObject.new :id => rock[:id]
              end
            end
          when 'mine'
            rock = @objects.select { |id, item| item[:clip] == 'rockmine' }.to_a.sample.last
            @server_protocol.send_command OgreIsland::Commands::ClickObject.new :id => rock[:id]
          when 'stash'
            i = 0.0
            bag_items(/(\A(\d+) Iron bars\Z| Gem\Z)/).each do |id, item|
              EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBagItem.new :name => 'bag', :id => item[:id] }
              EventMachine::Timer.new(i += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBag.new :name => 'bank', :x => '10.0', :y => '10.0' }
              say "Putting #{item[:name]} in bank."
            end
          when 'zoom'
            send_command OgreIsland::Commands::SetVariable.new :variable => '_root.map._xscale', :value => action[1]
            send_command OgreIsland::Commands::SetVariable.new :variable => '_root.map._yscale', :value => action[1]
          when 'organize'
            bag = action[1]
            t = 0.0
            @bags[bag].each do |id, item|
              EM.add_timer(t += 0.1) { @server_protocol.send_command OgreIsland::Commands::ClickBagItem.new :name => bag, :id => id }
              EM.add_timer(t += 0.1) { click_bag bag.to_sym, item[:name] }
            end
          else
            say 'I don\'t know what that is.'
        end
        raise HaltCallback
      end
    when OgreIsland::Commands::Play
      #@server_protocol.send_command OgreIsland::Commands::Logout.new
      #raise HaltCallback
    when OgreIsland::Commands::Base
      puts "Unhandled client #{command.inspect}"
    end
  end

  def process_server_command command
    case command
      when OgreIsland::Commands::Say
				case command.name
				when '*'
	        puts "-- #{command.text} --"
				when '**'
	        puts "-- #{command.text} --"
				else
					puts "#{command.name}: #{command.text}"
				end
      when OgreIsland::Commands::Sound
        #puts "Play #{command.name} #{command.loops} times"
      when OgreIsland::Commands::GetVariable
        #puts "Get #{command.variable}"
        if command.variable == '_root.map._xscale'
          @server_protocol.send_command OgreIsland::Commands::GetVariable.new :variable => command.variable, :value => '50'
          raise HaltCallback
        end
      when OgreIsland::Commands::Move
        puts "Move #{command.id} to #{command.x}, #{command.y}"
      when OgreIsland::Commands::Play
        #puts "Play!"
      when OgreIsland::Commands::SetVariable
        #puts "Set #{command.variable} to #{command.value}"
      when OgreIsland::Commands::Join
        #puts "Join channel #{command.name}"
      when OgreIsland::Commands::ChatChannel
        #puts "In channel #{command.channel}"
      when OgreIsland::Commands::SetAction
        #puts "Use frame #{command.frame} for #{command.id}'s #{command.name}"
      when OgreIsland::Commands::HealthBar
        #puts "Turn #{command.id}'s healthbar #{command.toggle}"
      when OgreIsland::Commands::SetClips
        #puts "Set clips for #{command.id}"
      when OgreIsland::Commands::AddCharacter
        puts "Added character #{command.name} (#{command.id}) to #{command.x}, #{command.y}, #{command.z}"
      when OgreIsland::Commands::Attribute
        #puts "Set #{command.attribute} to #{command.value}"
      when OgreIsland::Commands::Warp
        puts "Warp #{command.id} to #{command.x}, #{command.y}, #{command.z}"
      when OgreIsland::Commands::AddObject
        #puts "Adding object #{command.id} a #{command.clip} to #{command.x}, #{command.y}"
        object = { :id => command.id, :clip => command.clip, :x => command.x, :y => command.y }
        @objects ||= {}
        @objects[object[:id]] = object
      when OgreIsland::Commands::AddToBag
        #puts "Adding to #{command.name}:"
        items = command.items.split(';').map { |item| a = item.split(','); { :id => a[0], :frame => a[1], :x => a[2], :y => a[3], :name => a[4] } }
        items.each { |item| item.merge bag_coordinates(command.name.to_sym, item[:name]) }
        command.items = items.map { |item| [item[:id], item[:frame], item[:x], item[:y], item[:name]].join(',') }.join(';')
        @bags ||= {}
        @bags[command.name] ||= {}
        items.each { |item| @bags[command.name][item[:id]] = item }
      when OgreIsland::Commands::SetSkill
        puts "Skill #{command.name} is #{command.value}"
      when OgreIsland::Commands::Statistic
        #puts "Statistic #{command.attribute} is #{command.value}/#{command.maximum} (#{command.value.to_i / command.maximum.to_i})%"
      when OgreIsland::Commands::CharacterAttribute
        #puts "Chairacter attribute #{command.attribute} is #{command.base}+#{command.modification}=#{command.total}"
      when OgreIsland::Commands::CloseWindow
        #puts "Closing window #{command.window}"
      when OgreIsland::Commands::Inventory
        return unless command.item
        return unless command.item.split('|').first
        item = command.item.split('|').first.split('=')
        item = { :slot => item[0], :frame => item[1], :name => item[2] }
        #puts "Inventory item #{item[:slot]} is #{item[:name]} frame #{item[:frame]}"
      when OgreIsland::Commands::BackgroundColor
        #puts "Background color set to #{command.value}"
      when OgreIsland::Commands::LoginReply
        #puts "Login Reply for #{command.name} (#{command.id}) is #{command.status}: #{command.message}"
      when OgreIsland::Commands::Handshake
        #puts "Handshake from #{command.sender}"
      when OgreIsland::Commands::ModifyBagItem
        item = command.item.split(',')
        item = { :id => item[0], :frame => item[1], :x => item[2], :y => item[3], :name => item[4] }
        @bags ||= {}
        @bags[command.name] ||= {}
        @bags[command.name][item[:id]] = item
      when OgreIsland::Commands::TakeFromBag
        @bags[command.name] ||= {}
        @bags[command.name].delete command.id
      when OgreIsland::Commands::RemoveObject
        @objects ||= {}
        @objects.delete command.id
      when OgreIsland::Commands::Base
        puts "Unhandled Server->Client #{command.inspect}"
      else
        puts "What? #{command.inspect}"
    end
  end
end

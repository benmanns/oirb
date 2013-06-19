class OgreIsland::ServerProtocol < OgreIsland::Protocol
  def initialize
    super
    after_receive_packet { |packet| receive_packet packet }
  end

  [:receive_command, :unprocessable_packet].each { |event| register_callback event }

  def send_command command
    send_packet command.to_a(:mode => :client).join 1.chr
  end

  def receive_packet packet
    if (commands = Nokogiri::XML(packet).root).name == 'p'
      commands.children.each do |child|
        count = child.attributes['p'].value.to_i + 1
        data = count.times.map { |index| child.attributes["p#{index}"].value }
        command = OgreIsland::Commands::Base.parse(data, :mode => :server)
        run_callback :receive_command, command
      end
    else
      run_callback :unprocessable_packet, packet
    end
  end
end

class OgreIsland::ClientProtocol < OgreIsland::Protocol
  def initialize
    super
    after_receive_packet { |packet| receive_packet packet }
  end

  register_callback :receive_command

  def send_command command
    data = command.to_a :mode => :server
    attributes = { :p => data.count - 1 }
    data.each_index { |index| attributes["p#{index}"] = data[index] }
    packet = Nokogiri::XML::Builder.new do |xml|
      xml.p :c => 1 do
        xml.m attributes
      end
    end.to_xml :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
    send_packet packet.chomp
  end

  def receive_packet packet
    data = packet.split 1.chr
    command = OgreIsland::Commands::Base.parse(data, :mode => :client)
    run_callback :receive_command, command
  end
end

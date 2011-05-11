class OgreIsland::Protocol < EventMachine::Connection
  def post_init
    @buffer = BufferedTokenizer.new 0.chr
  end

  def receive_data data
    @buffer.extract(data).each do |packet|
      receive_packet(packet) if respond_to?(:receive_packet)
    end
  end

  def send_packet packet
    send_data packet
    send_data 0.chr
  end
end

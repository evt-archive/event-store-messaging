require_relative '../bench_init'

context "Read a Stream With an Ending Position that Precedes Starting Position" do
  stream_name = EventStore::Messaging::Controls::Writer.write 3, 'testMessageReader'

  dispatcher = EventStore::Messaging::Controls::Dispatcher.unique
  dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

  context "Starting position is not specified" do
    reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1, ending_position: -1

    message_positions = []

    last_event_number = reader.start do |_, event_data|
      message_positions << event_data.number
    end

    test "No messages are read" do
      assert message_positions == []
    end

    test "Retun value is nil" do
      assert last_event_number == nil
    end
  end

  context "Starting position is specified" do
    reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1, starting_position: 1, ending_position: 0

    message_positions = []

    last_event_number = reader.start do |_, event_data|
      message_positions << event_data.number
    end

    test "No messages are read" do
      assert message_positions == []
    end

    test "Retun value is nil" do
      assert last_event_number == nil
    end
  end
end

require_relative '../bench_init'

context "Read a Stream With a Starting Position that Precedes Ending Position" do
  stream_name = EventStore::Messaging::Controls::Writer.write 3, 'testMessageReader'

  dispatcher = EventStore::Messaging::Controls::Dispatcher.unique
  dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

  reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1, ending_position: 0

  context "Starting position is not specified" do
    reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1, ending_position: 1

    message_positions = []

    last_event_number = reader.start do |_, event_data|
      message_positions << event_data.number
    end

    test "Messages up to ending position are read" do
      assert message_positions == [0, 1]
    end

    test "Retun value is that of ending position" do
      assert last_event_number == 1
    end
  end

  context "Starting position is specified" do
    reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1, starting_position: 1, ending_position: 2

    message_positions = []

    last_event_number = reader.start do |_, event_data|
      message_positions << event_data.number
    end

    test "Messages up to ending position are read" do
      assert message_positions == [1, 2]
    end

    test "Retun value is that of ending position" do
      assert last_event_number == 2
    end
  end
end

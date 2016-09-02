require_relative '../bench_init'

context "Read a Stream With an Ending Position that Matches Starting Position" do
  stream_name = EventStore::Messaging::Controls::Writer.write 3, 'testMessageReader'

  dispatcher = EventStore::Messaging::Controls::Dispatcher.unique
  dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

  context "Starting position is not specified" do
    reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1, ending_position: 0

    message_positions = []

    last_event_number = reader.start do |_, event_data|
      message_positions << event_data.number
    end

    test "First message of stream is read" do
      assert message_positions == [0]
    end

    test "Retun value is zero" do
      assert last_event_number == 0
    end
  end

  context "Starting position is specified" do
    reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1, starting_position: 1, ending_position: 1

    message_positions = []

    last_event_number = reader.start do |_, event_data|
      message_positions << event_data.number
    end

    test "Message at starting position is read" do
      assert message_positions == [1]
    end

    test "Retun value is that of ending position" do
      assert last_event_number == 1
    end
  end
end

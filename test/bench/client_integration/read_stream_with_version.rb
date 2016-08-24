require_relative 'client_integration_init'

context "Read a Stream With a Specific Ending Position" do
  stream_name = EventStore::Messaging::Controls::Writer.write 3, 'testMessageReader'

  dispatcher = EventStore::Messaging::Controls::Dispatcher.unique
  dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

  reader = EventStore::Messaging::Reader.build stream_name, dispatcher, slice_size: 1, ending_position: 1

  messages_read = 0
  message_numbers = []

  reader.start do |_, event_data|
    messages_read += 1
    message_numbers << event_data.number
  end

  test "Messages up to the specified ending position are read" do
    assert messages_read == 2
    assert message_numbers == [0, 1]
  end
end

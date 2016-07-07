require_relative 'message_init'

context "Message Position" do
  metadata = EventStore::Messaging::Controls::Message::Metadata.example

  event_number = 11
  metadata.source_event_uri = "some_stream/some_path/#{event_number}"

  test "Is the last path in the event's source URI" do
    assert(metadata.position == event_number)
  end
end

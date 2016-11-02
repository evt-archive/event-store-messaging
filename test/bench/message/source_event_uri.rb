require_relative 'message_init'

context "Message Metadata Source Event URI" do
  event_data = EventStore::Messaging::Controls::EventData::Read.example

  message_cls = EventStore::Messaging::Controls::Message::SomeMessage

  message = EventStore::Messaging::Message::Import::EventData.(event_data, message_cls)

  test "Is Set from Event Data Edit Link" do
    control_source_event_uri = EventStore::Messaging::Controls::Message::Metadata.source_event_uri

    assert(message.metadata.source_event_uri == control_source_event_uri)
  end
end

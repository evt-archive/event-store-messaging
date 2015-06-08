require_relative 'spec_init'

describe "Stream Subscription" do
  specify "Read data from stream and dispatches it as a message and the original data represented as a stream entry" do
    dispatcher = Fixtures::SingleDispatcher.new
    entry_data = Fixtures.stream_entry_data

    reader = EventStore::Messaging::Stream::Reader.new
    reader.dispatcher = dispatcher

    message, stream_entry = reader.read(entry_data)

    assert(message.handled?)
    assert(message.handler? Fixtures::SomeHandler.name)
  end

  specify "Data for an unknown message type is not dispatched" do
    dispatcher = Fixtures.dispatcher
    entry_data = Fixtures::Anomalies.stream_entry_data

    reader = EventStore::Messaging::Stream::Reader.new
    reader.dispatcher = dispatcher

    message, stream_entry = reader.read(entry_data)

    assert(message.nil?)
  end
end

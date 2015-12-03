require_relative '../spec_init'

describe "Writer Telemetry" do
  context "Write" do
    message = EventStore::Messaging::Controls::Message.example
    writer = EventStore::Messaging::Writer.build

    SubstAttr::Substitute.(:writer, writer)

    stream_name = EventStore::Messaging::Controls::StreamName.get 'testWriter'

    sink = EventStore::Messaging::Writer.register_telemetry_sink(writer)

    writer.write message, stream_name

    specify "Records written telemetry" do
      assert(sink.recorded_written?)
    end
  end

  context "Reply" do
    message = EventStore::Messaging::Controls::Message.example
    writer = EventStore::Messaging::Writer.build

    SubstAttr::Substitute.(:writer, writer)

    sink = EventStore::Messaging::Writer.register_telemetry_sink(writer)

    writer.reply message

    specify "Records replied telemetry" do
      assert(sink.recorded_replied?)
    end
  end
end
require_relative 'spec_init'

describe "Metadata Builder" do
  previous_metadata = Fixtures::Metadata.metadata

  describe "Copying Metadata" do
    builder = EventStore::Messaging::Message::Metadata::Builder.new

    builder.copy(previous_metadata)

    metadata = builder.get

    specify "Sets the causation event ID to the previous event ID" do
      assert(metadata.causation_event_id == previous_metadata.event_id)
    end

    specify "Sets the causation stream name to the previous source stream name" do
      assert(metadata.causation_stream_name == previous_metadata.source_stream_name)
    end

    specify "Sets the correlation stream name to the previous correlation stream name" do
      assert(metadata.correlation_stream_name == previous_metadata.correlation_stream_name)
    end

    specify "Sets the reply stream name to the previous reply stream name" do
      assert(metadata.reply_stream_name == previous_metadata.reply_stream_name)
    end

    specify "Does not copy the event ID to the previous event ID" do
      refute(metadata.event_id == previous_metadata.event_id)
    end

    specify "Does not copy the source stream name" do
      assert(metadata.source_stream_name.nil?)
    end
  end

  describe "Initiating an Event Stream" do
    builder = EventStore::Messaging::Message::Metadata::Builder.new

    initiated_stream_id = UUID.random
    initiated_stream_name = "initiatedStream-#{initiated_stream_id}"

    builder.initiate_stream(initiated_stream_name)

    builder.copy(previous_metadata)

    metadata = builder.get

    specify "Clears all data except for the correlation stream" do
      assert(metadata.source_stream_name.nil?)
      assert(metadata.causation_event_id.nil?)
      assert(metadata.causation_stream_name.nil?)
      assert(metadata.reply_stream_name.nil?)
    end

    specify "Sets the correlation stream to the new stream name" do
      assert(metadata.correlation_stream_name == initiated_stream_name)
    end
  end

  describe "No Reply" do
    builder = EventStore::Messaging::Message::Metadata::Builder.new

    builder.no_reply

    builder.copy(previous_metadata)

    metadata = builder.get

    specify "Clears the reply stream name" do
      assert(metadata.reply_stream_name.nil?)
    end

    specify "Doesn't remove the other data" do
      refute(metadata.causation_event_id.nil?)
      refute(metadata.causation_stream_name.nil?)
      refute(metadata.correlation_stream_name.nil?)
    end
  end
end

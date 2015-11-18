require_relative 'message_init'

describe "Metadata Precedence" do
  let(:source_metadata) { EventStore::Messaging::Controls::Message::Metadata.example }
  let(:metadata) { EventStore::Messaging::Message::Metadata.new }

  context "Relevant attributes are equal" do
    specify "Message metadata has precedence" do
      metadata.causation_event_uri = source_metadata.source_event_uri
      metadata.correlation_stream_name = source_metadata.correlation_stream_name
      metadata.reply_stream_name = source_metadata.reply_stream_name

      assert(metadata.precedence?(source_metadata))
    end
  end

  context "Any of the relevant attributes are not equal" do
    [:causation_event_uri, :correlation_stream_name, :reply_stream_name].each do |attribute|

      specify attribute do
        metadata.causation_event_uri = source_metadata.source_event_uri
        metadata.correlation_stream_name = source_metadata.correlation_stream_name
        metadata.reply_stream_name = source_metadata.reply_stream_name

        metadata.send "#{attribute}=", SecureRandom.hex

        refute(metadata.precedence?(source_metadata))
      end
    end
  end
end
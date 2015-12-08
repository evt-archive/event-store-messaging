require_relative '../spec_init'

describe "Writer Substitute" do
  context "Records writes" do
    substitute_writer = EventStore::Messaging::Writer::Substitute.build

    message = EventStore::Messaging::Controls::Message.example

    stream_name = 'some stream name'

    substitute_writer.write message, stream_name, expected_version: 11, reply_stream_name: 'some_stream_name'

    context "Records telemetry about the write" do
      specify "No block arguments" do
        assert(substitute_writer.written?)
      end

      specify "Message block argument only" do
        assert(substitute_writer.written? { |msg| msg == message })
      end

      specify "Message and stream name block arguments" do
        assert(substitute_writer.written? { |msg, stream| stream == stream_name })
      end

      specify "Message, stream name, and expected_version block arguments" do
        assert(substitute_writer.written? { |msg, stream, expected_version | expected_version == 11 })
      end

      specify "Message, stream name, expected_version, and reply_stream_name block arguments" do
        assert(substitute_writer.written? { |msg, stream, expected_version, reply_stream_name | reply_stream_name == 'some_stream_name' })
      end
    end

    context "Access the data recorded" do
      specify "No block arguments" do
        assert(substitute_writer.writes.length == 1)
      end

      specify "Message block argument only" do
        assert(substitute_writer.writes { |msg| msg == message }.length == 1 )
      end

      specify "Message and stream name block arguments" do
        assert(substitute_writer.writes { |msg, stream| stream == stream_name }.length == 1)
      end

      specify "Message, stream name, and expected_version block arguments" do
        assert(substitute_writer.writes { |msg, stream, expected_version | expected_version == 11 }.length == 1)
      end

      specify "Message, stream name, expected_version, and reply_stream_name block arguments" do
        assert(substitute_writer.writes { |msg, stream, expected_version, reply_stream_name | reply_stream_name == 'some_stream_name' }.length == 1)
      end
    end
  end

  context "Records replies" do
    substitute_writer = EventStore::Messaging::Writer::Substitute.build

    message = EventStore::Messaging::Controls::Message.example

    stream_name = message.metadata.reply_stream_name

    substitute_writer.reply message

    context "Records replied telemetry" do
      specify "No block arguments" do
        assert(substitute_writer.written?)
      end

      specify "Message argument only" do
        assert(substitute_writer.replied? { |msg| msg == message })
      end

      specify "Message and stream name arguments" do
        assert(substitute_writer.replied? { |msg, stream| stream == stream_name })
      end
    end

    context "Access the data recorded" do
      specify "No block arguments" do
        assert(substitute_writer.replies.length == 1)
      end

      specify "Message block argument only" do
        assert(substitute_writer.replies { |msg| msg == message }.length == 1 )
      end

      specify "Message and stream name block arguments" do
        assert(substitute_writer.replies { |msg, stream| stream == stream_name }.length == 1)
      end
    end
  end
end
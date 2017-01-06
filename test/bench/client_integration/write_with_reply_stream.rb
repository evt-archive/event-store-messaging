require_relative 'client_integration_init'

context "Message Writer" do
  test "Write a message with a reply stream" do
    message = EventStore::Messaging::Controls::Message.example

    writer = EventStore::Messaging::Writer.build

    stream_name = EventStore::Messaging::Controls::StreamName.get 'testReply'

    reply_stream_name = EventStore::Messaging::Controls::StreamName.get 'replyToTestReply'

    writer.write message, stream_name, reply_stream_name: reply_stream_name

    path = "/streams/#{stream_name}"

    session = EventStore::Client::HTTP::Session.build
    get = EventSource::EventStore::HTTP::Request::Get.build session: session

    body_text, get_response = get.("#{path}/0")

    body_data = JSON.parse body_text

    metadata_reply_stream_name = body_data['content']['metadata']['replyStreamName']

    assert(metadata_reply_stream_name == reply_stream_name)
  end
end

require_relative '../bench_init'

context "Stream Category" do
  test "Can be derived from the stream name" do
    stream_name = "someStream-id"

    stream_category = EventStore::Messaging::StreamName.get_category stream_name
    assert(stream_category == 'someStream')
  end
end

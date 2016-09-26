require_relative '../bench_init'

context "Stream ID" do
  test "Can be derived from the stream name" do
    id = Identifier::UUID.random
    stream_name = "someStream-#{id}"

    stream_id = EventStore::Messaging::StreamName.get_id stream_name
    assert(stream_id == id)
  end

  test "Is nil if there is no type 4 UUID in the stream name" do
    stream_id = EventStore::Messaging::StreamName.get_id 'someStream'
    assert(stream_id.nil?)
  end
end

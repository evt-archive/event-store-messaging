require_relative '../bench_init'

context "Stream Name" do
  example = EventStore::Messaging::Controls::StreamName.example

  test "Composes the stream name from the category name and an ID" do
    stream_name = example.stream_name('some_id')
    assert(stream_name == 'someCategory-some_id')
  end

  test "Composes the command stream name from the category name and an ID" do
    command_stream_name = example.command_stream_name('some_id')
    assert(command_stream_name == 'someCategory:command-some_id')
  end
end

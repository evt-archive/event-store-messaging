require_relative '../bench_init'

context "Stream Name Module is Extended" do
  example = EventStore::Messaging::Controls::StreamName::Anomaly::Module::Example

  test "Category stream name method is added to module" do
    assert(example.category_name == 'someCategory')
  end

  test "Compose the stream name from the category name and an ID" do
    stream_name = example.stream_name('some_id')
    assert(stream_name == 'someCategory-some_id')
  end
end

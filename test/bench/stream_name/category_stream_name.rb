require_relative '../bench_init'

context "Category Stream Name (Mixin)" do
  example = EventStore::Messaging::Controls::StreamName.example

  test "Category name method is added to instance" do
    assert(example.category_name == 'someCategory')
  end

  test "Composes the category stream name from the declared category name" do
    category_stream_name = example.category_stream_name
    assert(category_stream_name == '$ce-someCategory')
  end

  test "Composes the category command stream name from the declared category name" do
    command_category_stream_name = example.command_category_stream_name
    assert(command_category_stream_name == '$ce-someCategory:command')
  end
end

context "Underscore Cased Stream Name" do
  example = EventStore::Messaging::Controls::StreamName::Anomaly::Underscore.example

  test "Is converted to camel case" do
    assert(example.category_name == 'someCategory')
  end
end

context "Category Stream Name (Module Function)" do
  test "Composes the category stream name from the declared category name" do
    category_stream_name = EventStore::Messaging::StreamName.category_stream_name('someCategory')
    assert(category_stream_name == '$ce-someCategory')
  end

  test "Composes the category command stream name from the declared category name" do
    command_category_stream_name = EventStore::Messaging::StreamName.command_category_stream_name('someCategory')
    assert(command_category_stream_name == '$ce-someCategory:command')
  end
end

require_relative 'spec_init'

describe "Deserialize Stream Entry Data" do
  specify "Message corresponding to the entry type is built with the entry's data" do
    stream_entry = Fixtures.stream_entry
    msg = Fixtures::SomeDispatcher.deserialize stream_entry
    assert(msg.is_a? Fixtures::SomeEvent)
    assert(msg.some_attribute == 'some value')
  end
end

describe "Deserialize Stream Entry Data for an Unknown Message" do
  specify "Message is nil" do
    stream_entry = Fixtures::Anomalies.stream_entry

    msg = Fixtures::SomeDispatcher.deserialize stream_entry
    assert(msg.nil?)
  end
end
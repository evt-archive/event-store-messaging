require_relative '../message_init'

context "Message Equality" do
  val_1 = Controls::ID.get
  val_2 = Controls::ID.get

  message = EventStore::Messaging::Controls::Message.example
  message.some_attribute = val_1
  message.some_time = val_2

  context "Ignore Class" do
    context "Message classes aren't equal" do
      other_message = EventStore::Messaging::Controls::Message::NotEqualMessage.new

      other_message.some_attribute = val_1
      other_message.some_time = val_2

      test "Messages are equal" do
        assert(message.eql(other_message, ignore_class: true))
      end
    end
  end
end

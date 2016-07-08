require_relative '../message_init'

context "Message Equality" do
  val_1 = Controls::ID.get
  val_2 = Controls::ID.get

  message = EventStore::Messaging::Controls::Message.example
  message.some_attribute = val_1
  message.some_time = val_2

  context "Attributes are equal" do
    other_message = EventStore::Messaging::Controls::Message.example
    other_message.some_attribute = val_1
    other_message.some_time = val_2

    test "Messages are equal" do
      assert(message == other_message)
    end
  end

  context "Message classes aren't equal" do
    other_message = EventStore::Messaging::Controls::Message::NotEqualMessage.new

    other_message.some_attribute = val_1
    other_message.some_time = val_2

    test "Messages aren't equal" do
      assert(message != other_message)
    end
  end

  context "Any attributes are not equal" do
    other_message = EventStore::Messaging::Controls::Message.example
    other_message.some_attribute = "X #{val_1}"
    other_message.some_time = "X #{val_2}"

    test "Messages are not equal" do
      assert(message != other_message)
    end
  end
end

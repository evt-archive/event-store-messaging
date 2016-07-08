require_relative '../message_init'

context "Message Equality" do
  val_1 = Controls::ID.get
  val_2 = Controls::ID.get

  message = EventStore::Messaging::Controls::Message.example
  message.some_attribute = val_1
  message.some_time = val_2

  context "Specified attributes are equal" do
    other_message = EventStore::Messaging::Controls::Message.example
    other_message.some_attribute = val_1

    refute(message.some_time == other_message.some_time)

    test "Messages are equal" do
      assert(message.eql(other_message, :some_attribute))
    end
  end

  context "Specified attributes are not equal" do
    other_message = EventStore::Messaging::Controls::Message.example
    other_message.some_attribute = val_1
    other_message.some_time = "X #{val_2}"

    test "Messages are not equal" do
      refute(message == other_message)
    end
  end
end

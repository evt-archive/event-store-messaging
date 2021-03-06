require_relative '../message_init'

context "Proceed from Previous Message and Copy Message Attributes with Strictness" do
  context "Strict" do
    context "Receiver has same attributes as source" do
      source = EventStore::Messaging::Controls::Message.example
      receiver = source.class.new

      test "No error" do
        EventStore::Messaging::Message::Proceed.(source, receiver, copy: true)
      end
    end

    context "Receiver doesn't have all of the source's attributes" do
      source = EventStore::Messaging::Controls::Message.example
      receiver = EventStore::Messaging::Controls::Message::FewerAttributesMessage.new

      test "Is an error" do
        assert proc { EventStore::Messaging::Message::Proceed.(source, receiver, copy: true) } do
          raises_error? EventStore::Messaging::Message::Copy::Error
        end
      end
    end
  end

  context "Not Strict" do
    context "Receiver doesn't have all of the source's attributes" do
      source = EventStore::Messaging::Controls::Message.example
      receiver = EventStore::Messaging::Controls::Message::FewerAttributesMessage.new

      EventStore::Messaging::Message::Proceed.(source, receiver, copy: true, strict: false)

      test "Copies the attributes supported by the receiver" do
        assert(source.some_attribute == receiver.some_attribute)
      end
    end
  end
end

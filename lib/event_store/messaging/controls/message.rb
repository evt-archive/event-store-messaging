module EventStore
  module Messaging
    module Controls
      module Message
        class SomeMessage
          include EventStore::Messaging::Message

          attribute :some_attribute
          attribute :some_time
        end

        class FewerAttributesMessage
          include EventStore::Messaging::Message

          attribute :some_attribute
        end

        class OtherMessage
          include EventStore::Messaging::Message
        end

        class AnotherMessage
          include EventStore::Messaging::Message
        end

        class HandledMessage
          include EventStore::Messaging::Message

          def handlers
            @handlers ||= []
          end

          def handler?(handler_name)
            handlers.any? { |name| name == handler_name }
          end
        end

        class NotEqualMessage
          include EventStore::Messaging::Message

          attribute :some_attribute
          attribute :some_time
        end

        def self.message_class
          SomeMessage
        end

        def self.attribute
          'some value'
        end

        def self.time(time=nil)
          time || Time.example
        end

        def self.data(time=nil)
          {
            some_attribute: attribute,
            some_time: time(time)
          }
        end

        def self.example(time=nil, metadata: nil)
          time ||= time(time)
          metadata ||= EventStore::Messaging::Controls::Message::Metadata.example

          msg = message_class.new
          msg.some_attribute = attribute
          msg.some_time = time

          msg.metadata = metadata

          msg
        end

        module Mapped
          class Example
            include EventStore::Messaging::Message

            attribute :an_attribute
            attribute :some_time
          end

          def self.example
            msg = Example.new

            msg.an_attribute = Message.attribute
            msg.some_time = Message.time

            msg
          end
        end
      end
    end
  end
end

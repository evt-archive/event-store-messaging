module EventStore
  module Messaging
    module Controls
      module Message
        class SomeMessage
          include EventStore::Messaging::Message

          attribute :some_attribute
          attribute :some_time
        end

        class OtherMessage
          include EventStore::Messaging::Message
        end

        class AnotherMessage
          include EventStore::Messaging::Message
        end

        class HandledMessage
          include EventStore::Messaging::Message

          attribute :handlers, Array, default: [], lazy: true

          def handler?(handler)
            handler_name = handler if handler.instance_of? String
            handler_name ||= handler.name if handler.instance_of? Class

            handlers.any? { |handler_class| handler_class.name.end_with? handler_name }
          end

          def handled?
            handlers.length > 0
          end
        end

        def self.message_class
          SomeMessage
        end

        def self.attribute
          'some value'
        end

        def self.time(time=nil)
          time || ::Controls::Time.reference
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

          msg = SomeMessage.new
          msg.some_attribute = attribute
          msg.some_time = time

          msg.metadata = metadata

          msg
        end
      end
    end
  end
end

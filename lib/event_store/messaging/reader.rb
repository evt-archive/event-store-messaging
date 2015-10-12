module EventStore
  module Messaging
    class Reader < MessageReader
      def self.http_reader
        Client::HTTP::Reader
      end

      class Substitute
        attr_reader :messages
        attr_reader :reader

        dependency :dispatcher, EventStore::Messaging::Dispatcher

        def initialize(reader)
          @reader = reader
          @messages = []
        end

        def self.build
          reader = Messaging::Reader.new "substituteStream"
          new reader
        end

        def add(message)
          messages << message
        end

        def start(&supplementary_action)
          messages.each_with_index do |message, index|
            number = index + 1
            event_data = OpenStruct.new :number => number
            dispatcher.dispatch message, event_data
            supplementary_action.(message, event_data) if supplementary_action
          end
        end
      end
    end
  end
end

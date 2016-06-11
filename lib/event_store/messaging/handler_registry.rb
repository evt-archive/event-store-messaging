module EventStore
  module Messaging
    class HandlerRegistry
      include Registry

      def get(message)
        items.select do |handler|
          handler.handles? message
        end
      end
    end
  end
end

module EventStore
  module Messaging
    module HandlerRegistry
      def handler_classes
        @handler_classes ||= []
      end

      def handler_registered?(handler_class)
        handler_classes.include? handler_class
      end

      def register_handler_class(handler_class)
        logger = Telemetry::Logger.get self

        logger.trace "Registering handler class: #{handler_class}"

        unless handler_registered?(handler_class)
          handler_classes.push(handler_class)
          logger.debug "Registered handler class: #{handler_class}"
        else
          logger.debug "Handler class: #{handler_class} is already registered. It was not registered again."
        end

        register_message_classes(handler_class.message_classes)

        handler_classes
      end

      def register_message_classes(message_classes)
        message_classes.each { |message_class| register_message_class(message_class) }
      end
    end
  end
end

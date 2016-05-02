 module EventStore
  module Messaging
    module Handler
      def self.included(cls)
        cls.extend HandleMacro
        cls.extend MessageRegistry
        cls.extend Info
        cls.extend Handle
        cls.extend Build
        cls.extend Virtual::Macro

        cls.send :virtual, :configure_dependencies
        cls.send :dependency, :logger, Telemetry::Logger
      end

      module HandleMacro
        class Error < RuntimeError; end

        def handle_macro(message_class, &blk)
          logger = Telemetry::Logger.get self

          define_handler_method(message_class, &blk)
          message_registry.register(message_class)
        end
        alias :handle :handle_macro

        def define_handler_method(message_class, &blk)
          logger = Telemetry::Logger.get self

          logger.opt_trace "Defining handler method (Message: #{message_class})"

          handler_method_name = handler_name(message_class)
          send(:define_method, handler_method_name, &blk).tap do
            logger.opt_debug "Defined handler method (Method Name: #{handler_method_name}, Message: #{message_class})"
          end

          handler_method = instance_method(handler_method_name)
          if handler_method.arity < 0
            error_msg = "Handler for #{message_class.name} cannot have optional parameters"
            Telemetry::Logger.get(self).error error_msg
            raise Error, error_msg
          end

          handler_method_name
        end
      end

      module MessageRegistry
        def message_registry
          @message_registry ||= EventStore::Messaging::MessageRegistry.build
        end
      end

      module Info
        extend self

        def handles?(message)
          method_defined? handler_name(message)
        end

        def handler_name(message)
          name = Message::Info.message_name(message)
          "handle_#{name}"
        end
      end

      module Build
        def build
          new.tap do |instance|
            Telemetry::Logger.configure instance
            instance.configure_dependencies
          end
        end
      end

      module Handle
        def call(message, event_data=nil)
          instance = build

          handler_method_name = Info.handler_name(message)

          method = instance.method(handler_method_name)

          case method.arity
          when 0
            instance.send handler_method_name
          when 1
            instance.send handler_method_name, message
          when 2
            instance.send handler_method_name, message, event_data
          end
        end
        alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]
      end

      def handle(message, event_data=nil)
        self.class.(message, event_data)
      end
    end
  end
end

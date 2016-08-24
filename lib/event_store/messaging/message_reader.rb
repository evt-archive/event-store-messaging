module EventStore
  module Messaging
    class MessageReader
      configure :reader

      attr_reader :stream_name
      attr_reader :ending_position

      dependency :reader, EventStore::Client::HTTP::EventReader
      dependency :dispatcher, EventStore::Messaging::Dispatcher
      dependency :logger, Telemetry::Logger

      def starting_position
        @starting_position ||= 0
      end

      def slice_size
        @slice_size ||= 20
      end

      def initialize(stream_name, starting_position=nil, slice_size=nil, ending_position=nil)
        @stream_name = stream_name
        @starting_position = starting_position
        @slice_size = slice_size
        @ending_position = ending_position
      end

      def self.build(stream_name, dispatcher, starting_position: nil, slice_size: nil, session: nil, ending_position: nil)
        new(stream_name, starting_position, slice_size, ending_position).tap do |instance|
          http_reader.configure instance, stream_name, starting_position: starting_position, slice_size: slice_size, session: session
          Telemetry::Logger.configure instance

          instance.dispatcher = dispatcher
        end
      end

      def start(&supplemental_action)
        logger.opt_trace "Reading messages (Stream Name: #{stream_name}, Version: #{ending_position.inspect})"

        last_event_number = nil
        reader.each do |event_data|
          dispatch_event_data event_data, &supplemental_action
          last_event_number = event_data.number

          break if last_event_number == ending_position
        end

        logger.opt_debug "Read messages (Stream Name: #{stream_name}, Last Event Number: #{last_event_number}, Version: #{ending_position.inspect})"

        last_event_number
      end

      def dispatch_event_data(event_data, &supplemental_action)
        message = dispatch(event_data)

        if !!supplemental_action
          supplemental_action.call(message, event_data)
        end
      end

      def dispatch(event_data)
        logger.opt_trace "Dispatching event data (Type: #{event_data.type})"
        logger.opt_data event_data.inspect

        message = dispatcher.build_message(event_data)

        if message.nil?
          logger.debug "Cannot dispatch \"#{event_data.type}\". The \"#{dispatcher}\" dispatcher has no handlers that handle it."
          return nil
        end

        dispatcher.dispatch(message, event_data)
        logger.opt_debug "Dispatched event data (Type: #{event_data.type})"

        message
      end

      def self.logger
        Telemetry::Logger.get self
      end
    end
  end
end

module EventStore
  module Messaging
    class MessageReader
      configure :reader

      attr_accessor :ending_position
      attr_writer :slice_size
      attr_writer :starting_position
      attr_reader :stream_name

      dependency :reader, EventStore::Client::HTTP::EventReader
      dependency :dispatcher, EventStore::Messaging::Dispatcher
      dependency :logger, Telemetry::Logger

      def starting_position
        @starting_position ||= 0
      end

      def slice_size
        @slice_size ||= 20
      end

      def initialize(stream_name)
        @stream_name = stream_name
      end

      def self.build(stream_name, dispatcher, starting_position: nil, ending_position: nil, slice_size: nil, session: nil)
        new(stream_name).tap do |instance|
          instance.starting_position = starting_position
          instance.ending_position = ending_position
          instance.slice_size = slice_size

          http_reader.configure instance, stream_name, starting_position: starting_position, slice_size: slice_size, session: session
          Telemetry::Logger.configure instance

          instance.dispatcher = dispatcher
        end
      end

      def start(&supplemental_action)
        log_attributes = "Stream Name: #{stream_name}, StartingPosition: #{starting_position}, EndingPosition: #{ending_position.inspect}"

        logger.opt_trace "Reading messages (#{log_attributes})"

        if ending_position && ending_position < starting_position
          logger.opt_debug "Did not read messages; ending position precedes starting position (#{log_attributes})"
          return nil
        end

        last_event_number = nil
        reader.each do |event_data|
          dispatch_event_data event_data, &supplemental_action
          last_event_number = event_data.number

          break if last_event_number == ending_position
        end

        logger.opt_debug "Read messages (#{log_attributes}, LastEventNumber: #{last_event_number})"

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

module EventStore
  module Messaging
    module Message
      module Import
        module EventData
          def self.logger
            @logger ||= Telemetry::Logger.get self
          end

          def self.call(event_data, message_class)
            logger.opt_trace "Importing event data to message (Message Class: #{message_class})"

            metadata_data = event_data.metadata || {}

            metadata = EventStore::Messaging::Message::Metadata.build metadata_data
            metadata.source_event_uri = get_source_event_uri event_data

            message_class.build(event_data.data).tap do |instance|
              instance.metadata = metadata

              logger.data event_data.inspect
              logger.data instance.inspect

              logger.opt_debug "Imported event data to message (Message Class: #{message_class})"
            end
          end
          class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def self.get_source_event_uri(event_data)
            event_data.links.edit_uri
          end
        end
      end
    end
  end
end

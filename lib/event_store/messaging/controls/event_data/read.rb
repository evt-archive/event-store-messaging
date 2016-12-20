module EventStore
  module Messaging
    module Controls
      module EventData
        module Read
          def self.data(number=nil, time: nil, stream_name: nil, metadata: nil, type: nil, omit_metadata: nil)
            type ||= 'SomeMessage'

            data = Message.data

            EventStore::Client::HTTP::Controls::EventData::Read.data(
              number,
              data: data,
              stream_name: stream_name,
              metadata: metadata,
              type: type
            )
          end

          def self.example(omit_metadata: nil)
            raw_data = data(omit_metadata: omit_metadata)

            Serialize::Read.instance raw_data, Client::HTTP::EventData::Read
          end

          module Anomaly
            def self.data
              Read.data type: 'SomeUnknownMessage'
            end

            def self.example
              Serialize::Read.instance data, Client::HTTP::EventData::Read
            end
          end
        end
      end
    end
  end
end

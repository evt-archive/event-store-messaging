module EventStore
  module Messaging
    module Message
      def self.included(cls)
        cls.send :include, Schema::DataStructure
        cls.extend Info
        cls.extend Build
        cls.extend Linked
        cls.extend Copy
        cls.extend Proceed
        cls.extend Initial
      end

      attr_writer :metadata
      def metadata
        @metadata ||= Metadata.new
      end

      def message_type
        self.class.message_type
      end

      def message_name
        self.class.message_name
      end

      def precedence?(other_message)
        metadata.precedence?(other_message.metadata)
      end

      def ==(other, attributes=nil, ignore_class: nil)
        attributes ||= self.class.attribute_names
        attributes = Array(attributes)

        ignore_class = false if ignore_class.nil?

        if !ignore_class
          return false if self.class != other.class
        end

        attributes.each do |attribute|
          return false if public_send(attribute) != other.public_send(attribute)
        end

        true
      end
      alias :eql :==

      module Info
        extend self

        def message_type(msg=self)
          class_name(msg).split('::').last
        end

        def message_name(msg=self)
          message_type(msg).gsub(/([^\^])([A-Z])/,'\1_\2').downcase
        end

        def class_name(message)
          class_name = nil
          class_name = message if message.instance_of? String
          class_name ||= message.name if message.instance_of? Class
          class_name ||= message.class.name
          class_name
        end
      end

      module Build
        def build(data=nil, metadata=nil)
          data ||= {}
          metadata ||= {}

          metadata = build_metadata(metadata)

          new.tap do |instance|
            set_attributes(instance, data)
            instance.metadata = metadata
          end
        end

        def set_attributes(instance, data)
          SetAttributes.(instance, data)
        end

        def build_metadata(metadata)
          if metadata.nil?
            Metadata.new
          else
            Metadata.build(metadata.to_h)
          end
        end
      end

      module Linked
        def linked(metadata)
          Telemetry::Logger.build(self).obsolete "The `linked' method is obsolete. Consider using the `proceed' method."
          proceed(metadata, copy: false)
        end
      end

      module Initial
        def initial(initiated_stream_name)
          metadata = Metadata.new

          metadata.correlation_stream_name = initiated_stream_name

          message = build
          message.metadata = metadata

          message
        end
      end

      module Assertions
        def attributes_equal?(message, attributes=nil)
          self.eql(message, attributes, ignore_class: true)
        end
      end
    end
  end
end

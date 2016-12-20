module EventStore
  module Messaging
    module StreamName
      extend self

      def self.included(cls)
        cls.extend Macro
      end

      def self.extended(mod)
        mod.extend Macro
      end

      module Macro
        def category_macro(category_name)
          category_name = Casing::Camel.(category_name, symbol_to_string: true)
          self.send :define_method, :category_name do
            @category_name || category_name
          end

          if self.instance_of? Module
            self.send :module_function, :category_name
          end
        end
        alias :category :category_macro

        def self.activate(target_class=nil)
          target_class ||= Object
          macro_module = self
          return if target_class.is_a? macro_module
          target_class.extend(macro_module)
        end
      end

      def stream_name(id, category_name=nil)
        category_name ||= self.category_name

        EventSource::StreamName.stream_name category_name, id
      end

      def command_stream_name(id, category_name=nil)
        category_name ||= self.category_name

        EventSource::StreamName.stream_name "#{category_name}:command", id
      end

      def category_stream_name(category_name=nil)
        category_name ||= self.category_name

        "$ce-#{category_name}"
      end

      def command_category_stream_name(category_name=nil)
        category_name ||= self.category_name
        category_stream_name = category_stream_name(category_name)

        "#{category_stream_name}:command"
      end

      def self.get_category(stream_name)
        category, _ = split stream_name
        category
      end

      def self.get_id(stream_name)
        _, stream_id = split stream_name
        stream_id
      end

      def self.split(stream_name)
        if stream_name.start_with? '$ce-'
          _, category = stream_name.split '-', 2
        else
          category, stream_id = stream_name.split '-', 2
        end

        return category, stream_id
      end
    end
  end
end

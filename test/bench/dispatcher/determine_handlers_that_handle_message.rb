require_relative 'dispatcher_init'

context "Dispatcher" do
  context "Determines handlers that it can dispatch a message to" do
    dispatcher = EventStore::Messaging::Controls::Dispatcher.example
    message = EventStore::Messaging::Controls::Message.example

    handlers = dispatcher.handlers.get(message)

    names = handlers.map do |handler|
      handler.class.name.split('::').last
    end

    test 'SomeHandler' do
      assert(names.include? 'SomeHandler')
    end

    test 'OtherHandler' do
      assert(names.include? 'OtherHandler')
    end

    test 'AnotherHandler' do
      assert(!(names.include? 'AnotherHandler'))
    end
  end
end

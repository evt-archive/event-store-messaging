require_relative './subscription_init'

stream_name = EventStore::Messaging::Controls::StreamName.get 'testStreamNotFound'

dispatcher = EventStore::Messaging::Controls::Dispatcher.unique
dispatcher.register_handler EventStore::Messaging::Controls::Handler::SomeHandler

reader = EventStore::Messaging::Subscription.build stream_name, dispatcher

reader.start do |message, event_data|
  raise "Should not enumerate"
end
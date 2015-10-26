require 'bundler/setup' unless ENV['DISABLE_BUNDLER'] == 'on'

lib_dir = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'event_store/messaging'
EventStore::Messaging::StreamName::Macro.activate

libraries_dir = ENV['LIBRARIES_DIR']
unless libraries_dir.nil?
  libraries_dir = File.expand_path(libraries_dir)
  $LOAD_PATH.unshift libraries_dir unless $LOAD_PATH.include?(libraries_dir)
end

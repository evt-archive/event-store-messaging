require_relative 'handler_init'

context "Handler Has Optional Parameter" do
  test "Is an error" do
    assert proc { EventStore::Messaging::Controls::Handler.define_optional_parameter_handler } do
      raises_error? EventStore::Messaging::Handler::HandleMacro::Error
    end
  end
end

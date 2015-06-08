require_relative 'spec_init'

module SymbolHashKeys
  def self.!(hash)
    convert_keys hash
  end

  def self.convert_keys(val)
    case val
      when ::Array
        val.map { |v| convert_keys(v) }
      when ::Hash
        ::Hash[val.map { |k, v| [convert_key(k), convert_keys(v)] }]
      else
        val
    end
  end

  def self.convert_key(key)
    key = key.to_sym if key.respond_to? :to_sym
    key
  end
end

describe "Entry data with JSON names" do
  specify "Is converted to data Ruby names" do
    entry_json_data = Fixtures.stream_entry_json_data
    _, stream_entry = Fixtures::SomeDispatcher.deserialize entry_json_data

    stream_entry_data = stream_entry.to_h
    stream_entry_data = SymbolHashKeys.!(stream_entry_data)

    control_data = Fixtures.stream_entry_data

    assert(stream_entry_data == control_data)
  end
end

require 'active_support/core_ext/hash/indifferent_access'
require 'forwardable'

module Asynk
  class Message
    extend Forwardable

    attr_reader :delivery_info, :properties, :payload, :body

    def initialize(delivery_info, properties, payload)
      @delivery_info = delivery_info
      @properties    = properties
      @payload       = payload
      @body          = JSON.parse(payload).with_indifferent_access
    end

    def_delegator :@body, :[]
    def_delegators :@properties, :message_id, :timestamp
    def_delegators :@delivery_info, :routing_key, :exchange


    def to_s
      attrs = { :@body => body.to_s, message_id: message_id,
                timestamp: timestamp, routing_key: routing_key }
      "#<Message #{attrs.map { |k,v| "#{k}=#{v.inspect}" }.join(', ')}>"
    end

    alias_method :inspect, :to_s
  end
end
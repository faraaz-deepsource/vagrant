module Vagrant
  class BoxCollection
    # This module enables the BoxCollection for server mode
    module Remote

      # Add an attribute reader for the client
      # when applied to the BoxCollection class
      def self.prepended(klass)
        klass.class_eval do
          attr_reader :client
        end
      end
     
      def initialize(directory, options=nil)
        @client = options[:client]
        if @client.nil?
          raise ArgumentError,
            "Remote client is required for `#{self.class.name}'"
        end
        @hook      = options[:hook]
        @logger    = Log4r::Logger.new("vagrant::box_collection")
      end

      # @return [Vagrant::Box]
      def add(path, name, version, **opts)
        client.add(
          path, name, version, force: opts[:force],
          metadata_url: opts[:metadata_url], provider:opts[:providers] 
        )
      end


      # @return [Array] Array of `[name, version, provider]` of the boxes
      #   installed on this system.
      def all
        client.all
      end

      # @return [Box] The box found, or `nil` if not found.
      def find(name, providers, version)
        client.find(name, providers, version)
      end

      def clean(name)
        client.clean(name)
      end
    end
  end
end

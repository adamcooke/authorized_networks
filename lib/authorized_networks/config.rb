module AuthorizedNetworks
  class Config

    # The path where the networks file can be found.
    #
    # @return [String]
    def networks_file_path
      @networks_file_path || ENV['AUTHORIZED_NETWORKS_CONFIG_PATH'] || find_default_networks_file_path
    end
    attr_writer :networks_file_path

    # Return an array of groups that are allowed by default when using the `AuthorizedNetworks.valid?`
    #
    # @return [Array<Symbol>]
    def default_groups
      @default_groups ||= [:default]
    end

    # Set a networks hash directly in the configuration rather than using a config file file
    #
    # @return [Hash<Symbol, Array>]
    attr_accessor :networks

    # The length of time networks should be cached in the instance before being loaded
    # again. This is in seconds.
    #
    # @return [Integer]
    def network_list_cache_ttl
      @network_list_cache_ttl || 3600
    end
    attr_writer :network_list_cache_ttl

    # Is this disabled?
    #
    # @return [Boolean]
    def disabled?
      @disabled || false
    end

    # Disable everything. Any call to valid_ip? will be returned as true and no
    # network lists will be loaded.
    def disable!
      @disabled = true
    end

    private

    def find_default_networks_file_path
      if defined?(Rails)
        Rails.root.join('config', 'authorized_networks.yml')
      else
        "/etc/authorized_networks.yml"
      end
    end

  end
end

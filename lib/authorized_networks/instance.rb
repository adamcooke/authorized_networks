require 'authorized_networks/config'

module AuthorizedNetworks
  class Instance

    def initialize(config = nil, &block)
      @config = config || Config.new
      block.call(@config) if block_given?
    end

    # Return a hash of all configured network groups
    #
    # @return [Hash<Symbol,Array>]
    def networks
      if @networks && @networks_cached_at && (@networks_cached_at + @config.network_list_cache_ttl) >= Time.now.utc
        # If we have cached some networks and it has expired, clear the
        # cache so we can get a new copy of the networks list.
        @networks = nil
      end

      @networks ||= begin
        if @config.networks
          if @config.networks.is_a?(Proc)
            normalize_ips(@config.networks.call)
          elsif @config.networks.is_a?(Hash)
            normalize_ips(@config.networks)
          elsif @config.networks.is_a?(Array)
            normalize_ips(:default => @config.networks)
          else
            {}
          end
        elsif File.exist?(@config.networks_file_path)
          @networks_cached_at = Time.now.utc
          normalize_ips(YAML.safe_load(File.read(@config.networks_file_path)))
        else
          raise NetworksConfigFileNotFoundError, "No config file was found at #{@config.networks_file_path}"
        end
      end
    end

    # Is the given IP a valid IP?
    #
    # @return [Boolean]
    def valid_ip?(ip, options = {})
      return true if @config.disabled?

      ip = IPAddr.new(ip.to_s) rescue nil
      return false unless ip.is_a?(IPAddr)
      groups = options[:groups] || @config.default_groups
      groups.each do |group|
        if group_ips = networks[group.to_sym]
          if group_ips.any? { |gip| gip.include?(ip) }
            return true
          end
        end
      end
      return false
    end

    # Is the given IP a valid IP? Raises an error if not
    #
    # @raises [AuthorizedNetworks::UnauthorizedNetworkError]
    # @return [True]
    def valid_ip!(ip, options = {})
      valid_ip?(ip, options) || raise(AuthorizedNetworks::UnauthorizedNetworkError, "#{ip} is not a valid IP")
    end

    private

    def normalize_ips(hash)
      hash.each_with_object({}) do |(group_name, networks), hash|
        networks = [networks.to_s] unless networks.is_a?(Array)
        hash[group_name.to_sym] = networks.map do |network|
          if network.is_a?(IPAddr)
            network
          else
            begin
              IPAddr.new(network.to_s)
            rescue IPAddr::InvalidAddressError
              nil
            end
          end
        end.compact
      end
    end

  end
end

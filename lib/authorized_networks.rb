require 'ipaddr'
require 'yaml'
require 'authorized_networks/error'
require 'authorized_networks/config'
require 'authorized_networks/instance'

if defined?(Rails)
  require 'authorized_networks/railtie'
end

module AuthorizedNetworks

  # Provide a configuration
  #
  def self.config
    @config ||= Config.new
  end

  # Provide a configuration object to the given block and reteurn the config
  #
  # @return [AuthorizedNetworks::Config]
  def self.configure(&block)
    block.call(config)
    config
  end

  # Provide an instance for global use
  #
  # @return [AuthorizedNetwork::Instance]
  def self.instance
    @instance ||= Instance.new(config)
  end

  # Is the given IP a valid IP on the global instance?
  #
  # @return [Boolean]
  def self.valid_ip?(ip, options = {})
    instance.valid_ip?(ip, options)
  end

  # Is the given IP a valid IP? Raises an error if not
  #
  # @raises [AuthorizedNetworks::UnauthorizedNetworkError]
  # @return [True]
  def self.valid_ip!(ip, options = {})
    instance.valid_ip!(ip, options)
  end

end

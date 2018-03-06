module AuthorizedNetworks
  class Error < StandardError
  end

  class NetworksConfigFileNotFoundError < Error
  end

  class UnauthorizedNetworkError < Error
  end
end

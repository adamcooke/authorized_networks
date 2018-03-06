module AuthorizedNetworks
  module ControllerExtension

    def require_authorized_network(options = {})
      unless AuthorizedNetworks.valid_ip?(request.ip, options)
        raise AuthorizedNetworks::UnauthorizedNetworkError, "#{request.ip} does not have access to this resource"
      end
    end

  end
end

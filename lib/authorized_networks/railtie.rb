module AuthorizedNetworks
  class Railtie < Rails::Railtie

    initializer 'authorized_networks.initialize' do
      ActiveSupport.on_load(:action_controller) do
        require 'authorized_networks/controller_extension'
        include AuthorizedNetworks::ControllerExtension
      end
    end

  end
end

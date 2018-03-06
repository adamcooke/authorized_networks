require 'spec_helper'
require 'authorized_networks/controller_extension'

class FakeRequest
  attr_accessor :ip
end

class FakeController

  include AuthorizedNetworks::ControllerExtension

  def initialize(ip)
    @request = FakeRequest.new
    @request.ip = ip
  end

  def request
    @request
  end

end

describe AuthorizedNetworks::ControllerExtension do

  context "require_authorized_network" do
    it "should raise an error for invalid IPs" do
      controller = FakeController.new('1.1.1.1')
      expect { controller.require_authorized_network }.to raise_error(AuthorizedNetworks::UnauthorizedNetworkError)
    end

    it "should not raise if the IP is valid" do
      controller = FakeController.new('127.0.0.1')
      expect { controller.require_authorized_network }.to_not raise_error
    end

  end
end

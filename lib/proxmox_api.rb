# frozen_string_literal: true

require 'rest_client'
require 'json'

# This class is wrapper for Proxmox PVE APIv2.
# See README for usage examples.
#
# @author Eugene Lapeko
class ProxmoxAPI
  AUTH_PARAMS  = %i[username realm password otp].freeze
  REST_METHODS = %i[get post put delete].freeze

  # This class is used to collect api path before request
  class ApiPath
    # @param [ProxmoxAPI] api ProxmoxAPI object to call when request is executed
    def initialize(api)
      raise ArgumentError, 'Not an instance of ProxmoxAPI' unless api.is_a? ProxmoxAPI

      @api = api
      @path = []
    end

    def to_s
      @path.join('/')
    end

    def [](index)
      @path << index.to_s
      self
    end

    def method_missing(method, *args)
      return @api.__send__(:submit, method, to_s, *args) if REST_METHODS.any? { |rm| /^#{rm}!?$/.match? method }

      @path << method.to_s
      self
    end

    def respond_to_missing?(*)
      true
    end
  end

  # This exception is raised when Proxmox API returns error code
  #
  # @!attribute [r] response
  #   @return [RestClient::Response] answer from Proxmox server
  class ApiException < RuntimeError
    attr_reader :response

    def initialize(response, description)
      @response = response

      super description
    end
  end

  # Constructor method for ProxmoxAPI
  #
  # @param [String] cluster hostname/ip of cluster to control
  # @param [Hash] options cluster connection parameters
  #
  # @option options [String] :username - username to be used for connection
  # @option options [String] :password - password to be used for connection
  # @option options [String] :realm - auth realm, can be given in :username ('user@realm')
  # @option options [String] :otp - one-time password for two-factor auth
  #
  # @option options [Boolean] :verify_ssl - verify server certificate
  #
  # You can also pass here all ssl options supported by rest-client gem
  # @see https://github.com/rest-client/rest-client
  def initialize(cluster, options)
    @connection = RestClient::Resource.new(
      "https://#{cluster}:#{options[:port] || 8006}/api2/json/",
      options.select { |k, _v| RestClient::Request::SSLOptionList.include? k }
    )
    @auth_ticket = create_auth_ticket(options.select { |k, _v| AUTH_PARAMS.include? k })
  end

  def [](index)
    ApiPath.new(self)[index]
  end

  def method_missing(method, *args)
    ApiPath.new(self).__send__(method, *args)
  end

  def respond_to_missing?(*)
    true
  end

  private

  def raise_on_failure(response, message = 'Proxmox API request failed')
    return unless response.code.to_i >= 400

    raise ApiException.new(response, message)
  end

  def create_auth_ticket(options)
    @connection['access/ticket'].post options do |response, _request, _result, &_block|
      raise_on_failure(response, 'Proxmox authentication failure')

      data = JSON.parse(response.body, symbolize_names: true)[:data]
      {
        cookies: { PVEAuthCookie: data[:ticket] },
        CSRFPreventionToken: data[:CSRFPreventionToken]
      }
    end
  end

  def prepare_options(method, data)
    case method
    when :post, :put
      [data, @auth_ticket]
    when :delete
      [@auth_ticket]
    when :get
      [@auth_ticket.merge(data)]
    end
  end

  def submit(method, url, data = {})
    if /!$/.match? method
      method = method.to_s.tr('!', '').to_sym
      skip_raise = true
    end

    @connection[url].__send__(method, *prepare_options(method, data)) do |response|
      raise_on_failure(response) unless skip_raise

      JSON.parse(response.body, symbolize_names: true)[:data]
    end
  end
end

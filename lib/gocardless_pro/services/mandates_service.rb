require_relative './base_service'

# encoding: utf-8
#
# WARNING: Do not edit by hand, this file was generated by Crank:
#
#   https://github.com/gocardless/crank

module GoCardlessPro
  module Services
    # Service for making requests to the Mandate endpoints
    class MandatesService < BaseService
      # Creates a new mandate object.
      # Example URL: /mandates
      # @param options [Hash] parameters as a hash, under a params key.
      def create(options = {})
        path = '/mandates'

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params][envelope_key] = params
        response = make_request(:post, path, options)

        return if response.body.nil?
        Resources::Mandate.new(unenvelope_body(response.body))
      end

      # Returns a [cursor-paginated](#overview-cursor-pagination) list of your
      # mandates. Except where stated, these filters can only be used one at a time.
      # Example URL: /mandates
      # @param options [Hash] parameters as a hash, under a params key.
      def list(options = {})
        path = '/mandates'

        response = make_request(:get, path, options)
        ListResponse.new(
          raw_response: response,
          unenveloped_body: unenvelope_body(response.body),
          resource_class: Resources::Mandate
        )
      end

      # Get a lazily enumerated list of all the items returned. This is simmilar to the `list` method but will paginate for you automatically.
      #
      # @param options [Hash] parameters as a hash. If the request is a GET, these will be converted to query parameters.
      # Otherwise they will be the body of the request.
      def all(options = {})
        Paginator.new(
          service: self,
          path: '/mandates',
          options: options,
          resource_class: Resources::Mandate
        ).enumerator
      end

      # Retrieves the details of an existing mandate.
      #
      # If you specify `Accept:
      # application/pdf` on a request to this endpoint it will return a PDF complying
      # to the relevant scheme rules, which you can present to your customer.
      #
      # PDF
      # mandates can be retrieved in Dutch, English, French, German, Italian,
      # Portuguese and Spanish by specifying the [ISO
      # 639-1](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes#Partial_ISO_639_table)
      # language code as an `Accept-Language` header.
      # Example URL: /mandates/:identity
      #
      # @param identity       # Unique identifier, beginning with "MD".
      # @param options [Hash] parameters as a hash, under a params key.
      def get(identity, options = {})
        path = sub_url('/mandates/:identity',           'identity' => identity)

        response = make_request(:get, path, options)

        return if response.body.nil?
        Resources::Mandate.new(unenvelope_body(response.body))
      end

      # Updates a mandate object. This accepts only the metadata parameter.
      # Example URL: /mandates/:identity
      #
      # @param identity       # Unique identifier, beginning with "MD".
      # @param options [Hash] parameters as a hash, under a params key.
      def update(identity, options = {})
        path = sub_url('/mandates/:identity',           'identity' => identity)

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params][envelope_key] = params
        response = make_request(:put, path, options)

        return if response.body.nil?
        Resources::Mandate.new(unenvelope_body(response.body))
      end

      # Immediately cancels a mandate and all associated cancellable payments. Any
      # metadata supplied to this endpoint will be stored on the mandate cancellation
      # event it causes.
      #
      # This will fail with a `cancellation_failed` error if the
      # mandate is already cancelled.
      # Example URL: /mandates/:identity/actions/cancel
      #
      # @param identity       # Unique identifier, beginning with "MD".
      # @param options [Hash] parameters as a hash, under a params key.
      def cancel(identity, options = {})
        path = sub_url('/mandates/:identity/actions/cancel',           'identity' => identity)

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]['data'] = params
        response = make_request(:post, path, options)

        return if response.body.nil?
        Resources::Mandate.new(unenvelope_body(response.body))
      end

      # <a name="mandate_not_inactive"></a>Reinstates a cancelled or expired mandate
      # to the banks. You will receive a `resubmission_requested` webhook, but after
      # that reinstating the mandate follows the same process as its initial creation,
      # so you will receive a `submitted` webhook, followed by a `reinstated` or
      # `failed` webhook up to two working days later. Any metadata supplied to this
      # endpoint will be stored on the `resubmission_requested` event it causes.
      #
      #
      # This will fail with a `mandate_not_inactive` error if the mandate is already
      # being submitted, or is active.
      #
      # Mandates can be resubmitted up to 3 times.
      # Example URL: /mandates/:identity/actions/reinstate
      #
      # @param identity       # Unique identifier, beginning with "MD".
      # @param options [Hash] parameters as a hash, under a params key.
      def reinstate(identity, options = {})
        path = sub_url('/mandates/:identity/actions/reinstate',           'identity' => identity)

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]['data'] = params
        response = make_request(:post, path, options)

        return if response.body.nil?
        Resources::Mandate.new(unenvelope_body(response.body))
      end

      # Unenvelope the response of the body using the service's `envelope_key`
      #
      # @param body [Hash]
      def unenvelope_body(body)
        body[envelope_key] || body['data']
      end

      private

      # return the key which API responses will envelope data under
      def envelope_key
        'mandates'
      end

      # take a URL with placeholder params and substitute them out for the acutal value
      # @param url [String] the URL with placeholders in
      # @param param_map [Hash] a hash of placeholders and their actual values
      def sub_url(url, param_map)
        param_map.reduce(url) do |new_url, (param, value)|
          new_url.gsub(":#{param}", value)
        end
      end
    end
  end
end
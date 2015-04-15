

# encoding: utf-8
#
# WARNING: Do not edit by hand, this file was generated by Crank:
#
#   https://github.com/gocardless/crank
#
require 'uri'

module GoCardless
  # A module containing classes for each of the resources in the GC Api
  module Resources
    # Payment objects represent payments from a
    # [customer](https://developer.gocardless.com/pro/#api-endpoints-customers) to
    # a [creditor](https://developer.gocardless.com/pro/#api-endpoints-creditors),
    # taken against a Direct Debit
    # [mandate](https://developer.gocardless.com/pro/#api-endpoints-mandates).
    #
    #
    # GoCardless will notify you via a
    # [webhook](https://developer.gocardless.com/pro/#webhooks) whenever the state
    # of a payment changes.
    # Represents an instance of a payment resource returned from the API
    class Payment
      attr_reader :amount

      attr_reader :amount_refunded

      attr_reader :charge_date

      attr_reader :created_at

      attr_reader :currency

      attr_reader :description

      attr_reader :id

      attr_reader :metadata

      attr_reader :reference

      attr_reader :status
      # initialize a resource instance
      # @param object [Hash] an object returned from the API
      def initialize(object)
        @object = object

        @amount = object['amount']
        @amount_refunded = object['amount_refunded']
        @charge_date = object['charge_date']
        @created_at = object['created_at']
        @currency = object['currency']
        @description = object['description']
        @id = object['id']
        @links = object['links']
        @metadata = object['metadata']
        @reference = object['reference']
        @status = object['status']
      end

      # return the links that the resource has
      def links
        Struct.new(
          *{

            creditor: '',

            mandate: '',

            payout: '',

            subscription: ''

          }.keys.sort
        ).new(*@links.sort.map(&:last))
      end
    end
  end
end

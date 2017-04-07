module GoCardlessPro
  module Middlewares
    class RaiseGoCardlessErrors < Faraday::Response::Middleware
      API_ERROR_STATUSES = 501..600
      OTHER_ERROR_STATUSES = 400..500

      def on_complete(env)
        if !json?(env) || API_ERROR_STATUSES.include?(env.status)
          fail ApiError, generate_error_data(env)
        end

        if OTHER_ERROR_STATUSES.include?(env.status)
          json_body ||= JSON.parse(env.body) unless env.body.empty?
          error_type = json_body['error']['type']
          fail(error_class_for_type(error_type), json_body['error'])
        end
      end

      private

      def error_class_for_type(type)
        {
          validation_failed: GoCardlessPro::ValidationError,
          gocardless: GoCardlessPro::GoCardlessError,
          invalid_api_usage: GoCardlessPro::InvalidApiUsageError,
          invalid_state: GoCardlessPro::InvalidStateError
        }.fetch(type.to_sym)
      end

      def generate_error_data(env)
        {
          'message' => "Something went wrong with this request\n" \
          "code: #{env.status}\n" \
          "headers: #{env.response_headers}\n" \
          "body: #{env.body}"
        }
      end

      def json?(env)
        content_type = env.response_headers['Content-Type'] ||
                       env.response_headers['content-type'] || ''

        content_type.include?('application/json')
      end
    end
  end
end

Faraday::Response.register_middleware raise_gocardless_errors: GoCardlessPro::Middlewares::RaiseGoCardlessErrors

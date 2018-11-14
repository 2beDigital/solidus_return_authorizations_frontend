module Spree
  module Admin
    class ReturnAuthorizationRequestsController < BaseController
      def index
        @return_authorizations = Spree::ReturnAuthorization.all
      end
    end
  end
end

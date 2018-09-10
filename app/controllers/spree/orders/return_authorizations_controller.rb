module Spree
  module Orders
    class ReturnAuthorizationsController < Spree::StoreController
      include Spree::Core::ControllerHelpers::Store
      include Spree::Core::ControllerHelpers::Auth
      helper Spree::BaseHelper
      helper Spree::StoreHelper

      before_action :load_order
      before_action :check_return_eligibility, only: [:new, :create]

      def new
        @return_authorization = Spree::ReturnAuthorization.new(order: @order)
        load_form_data
      end

      def create
        @return_authorization = Spree::ReturnAuthorization.new(return_authorization_params)
        if @return_authorization.save
          flash.notice = Spree.t('return_authorizations_frontend.created')
          redirect_to spree.account_path
        else
          load_form_data
          render :new
        end
      end

      private

      def load_order
        @order = Spree::Order.where(number: params[:order_id]).first
        authorize! :read, @order
      end

      def check_return_eligibility
        unless @order.eligible_for_return_authorization?
          flash.alert = Spree.t('return_authorizations_frontend.not_eligibile')
          redirect_to spree.account_path
        end
      end

      def return_authorization_params
        params
          .require(:return_authorization)
          .permit(:memo, {return_items_attributes: [:inventory_unit_id, :_destroy]}, :inventory_units_attributes, :return_reason_id)
          .merge(order: @order, stock_location: Spree::StockLocation.first)
      end

      # This logic is basically copied/pasted from backend:
      # backend/app/controllers/spree/admin/return_authorizations_controller.rb
      def load_form_data
        load_reasons
        load_return_items
        load_reimbursement_types
      end

      def load_return_items
        all_inventory_units = @return_authorization.order.inventory_units
        @order.return_authorizations.each do |ra|
          all_inventory_units -= ra.return_items.map(&:inventory_unit)
        end
        associated_inventory_units = @return_authorization.return_items.map(&:inventory_unit)
        unassociated_inventory_units = all_inventory_units - associated_inventory_units

        new_return_items = unassociated_inventory_units.map do |new_unit|
          Spree::ReturnItem.new(inventory_unit: new_unit).tap(&:set_default_amount)
        end

        @form_return_items = (@return_authorization.return_items + new_return_items).sort_by(&:inventory_unit_id)
      end

      def load_reimbursement_types
        @reimbursement_types = Spree::ReimbursementType.accessible_by(current_ability, :read).active
      end

      def load_reasons
        @reasons = Spree::ReturnReason.reasons_for_return_items(@return_authorization.return_items)
      end
    end
  end
end

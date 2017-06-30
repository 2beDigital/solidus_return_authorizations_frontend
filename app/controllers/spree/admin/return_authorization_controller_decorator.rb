Spree::Admin::ReturnAuthorizationsController.class_eval do
  def fire
    @return_authorization.send("#{params[:e]}!")
    flash[:success] = Spree.t(:return_authorization_updated)
    redirect_back(fallback_location: admin_order_return_authorization_url(@order))
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      user_subscriptions_url(resource_or_scope)
    else
      super
    end
  end
end

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :resume_session

    helper_method :current_admin,
                  :current_customer,
                  :admin_signed_in?,
                  :customer_signed_in?
  end

  private

  def require_admin_authentication
    return if admin_signed_in?

    redirect_to new_admin_session_path,
                alert: "管理者としてログインしてください"
  end

  def require_customer_authentication
    return if customer_signed_in?

    redirect_to new_customer_session_path,
                alert: "ログインしてください"
  end

  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    return unless cookies.signed[:session_id]

    Session.find_by(id: cookies.signed[:session_id])
  end

  def start_new_session_for(account)
    account.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    ).tap do |session_record|
      Current.session = session_record

      cookies.signed.permanent[:session_id] = {
        value: session_record.id,
        httponly: true,
        same_site: :lax
      }
    end
  end

  def terminate_session
    Current.session&.destroy!
    Current.session = nil
    cookies.delete(:session_id)
  end

  def current_admin
    Current.account if Current.account.is_a?(Admin)
  end

  def current_customer
    Current.account if Current.account.is_a?(Customer)
  end

  def admin_signed_in?
    current_admin.present?
  end

  def customer_signed_in?
    current_customer.present?
  end
end

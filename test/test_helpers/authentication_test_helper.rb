module AuthenticationTestHelper
  def sign_in_as_admin(admin, password: "password")
    post admin_session_path,
         params: {
           admin: {
             email: admin.email,
             password: password
           }
         }
  end

  def sign_in_as_customer(customer, password: "password")
    post customer_session_path,
         params: {
           customer: {
             email: customer.email,
             password: password
           }
         }
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationTestHelper
end

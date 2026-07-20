class Admin::ApplicationController < ApplicationController
  before_action :require_admin_authentication
end

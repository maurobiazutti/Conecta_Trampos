class HomeController < ApplicationController
  def index
    @service_requests = ServiceRequest.includes(:category, :user).order(created_at: :desc)
  end
end

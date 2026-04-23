class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!, except: :start
  before_action :ensure_customer_registration!, only: [ :new, :create ]

  def start
    store_post_onboarding_path(new_service_request_path)

    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Faca login para cadastrar um servico."
      return
    end

    redirect_to next_onboarding_step_for(current_user, fallback: new_service_request_path)
  end

  def new
    @service_request = current_user.service_requests.build(status: "pending")
  end

  def create
    @service_request = current_user.service_requests.build(service_request_params)
    @service_request.status = "pending"

    if @service_request.save
      redirect_to root_path, notice: "Servico cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ensure_customer_registration!
    next_step = onboarding_path_for(current_user)
    return unless next_step

    store_post_onboarding_path(new_service_request_path)
    redirect_to next_step, alert: "Complete seu perfil e endereco para cadastrar um servico."
  end

  def service_request_params
    params.require(:service_request).permit(:title, :description, :category_id)
  end
end

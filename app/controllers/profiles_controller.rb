# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [ :show, :edit, :update ]

  def show
    redirect_to new_profile_path unless @profile
  end

  def new
    redirect_to edit_profile_path if current_user.profile.present?
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)

    if @profile.save
      redirect_to new_address_path, notice: "Perfil criado com sucesso! Agora cadastre seu endereco."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @profile = current_user.profile
    # @profile.build_user unless @profile.user
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Perfil atualizado!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:description, :phone, :active, user_attributes: [ :name ])
  end
end

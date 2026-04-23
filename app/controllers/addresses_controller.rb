class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [ :show, :edit, :update ]

  def show
    redirect_to new_address_path unless @address
  end

  def new
    redirect_to edit_address_path if current_user.address.present?
    @address = current_user.build_address
  end

  def create
    @address = current_user.build_address(address_params)

    if @address.save
      redirect_to next_onboarding_step_for(current_user, fallback: root_path), notice: "Endereco cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @address = current_user.address
  end

  def update
    if @address.update(address_params)
      redirect_to next_onboarding_step_for(current_user, fallback: address_path), notice: "Endereco atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_address
    @address = current_user.address
  end

  def address_params
    params.require(:address).permit(:cep, :street, :number, :complement, :neighborhood, :city, :state)
  end
end

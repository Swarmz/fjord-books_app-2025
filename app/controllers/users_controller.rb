# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update]
  before_action :user_authorization, only: %i[edit update]
  def index
    @users = User.order(:id).page(params[:page])
  end

  def show; end
  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: t('controllers.common.notice_update', name: User.model_name.human) }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end

  def user_params
    params.expect(user: %i[email address postal_code self_introduction])
  end

  # Prevents users from accessing or modifying other users' pages with URL tampering (/users/{another_user}/edit)
  def user_authorization
    return if @user == current_user

    redirect_back(
      fallback_location: root_path,
      alert: t('controllers.common.not_authorized')
    )
  end
end

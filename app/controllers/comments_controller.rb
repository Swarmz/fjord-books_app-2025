# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create edit update destroy]
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :authorize_comment!, only: %i[edit update destroy]

  def show; end

  def new
    @comment = Comment.new
  end

  def edit; end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: @comment.errors.full_messages.to_sentence
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
    redirect_to @commentable, status: :see_other, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def comment_params
    params.expect(comment: %i[body])
  end

  def set_comment
    @comment = @commentable.comments.find(params.expect(:id))
  end

  def set_commentable
    if params[:report_id]
      @commentable = Report.find(params[:report_id])
    elsif params[:book_id]
      @commentable = Book.find(params[:book_id])
    else
      raise ActionController::RoutingError, 'Not Found'
    end
  end

  def authorize_comment!
    current_user.comments.find(@comment.id)
  end
end

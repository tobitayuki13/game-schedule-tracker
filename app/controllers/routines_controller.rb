class RoutinesController < ApplicationController
  before_action :require_login

  def index
    @routines = current_user.routines.order(created_at: :desc)
  end

  def new
    @routine = current_user.routines.new
  end

  def create
    @routine = current_user.routines.new(routine_params)

    if @routine.save
      redirect_to routines_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @routine = current_user.routines.find(params[:id])
    @tasks = @routine.tasks.order(:position, :id)
    @task = @routine.tasks.new
  end

  def execute
    @routine = current_user.routines.find(params[:id])
    @task = @routine.tasks.where(status: [:not_started, :in_progress]).order(:position, :id).first
  end

  def reset
    routine = current_user.routines.find(params[:id])
    routine.tasks.update_all(status: Task.statuses[:not_started])
    redirect_to routine_path(routine), notice: "リセットしました"
  end

  def destroy
    routine = current_user.routines.find(params[:id])
    routine.destroy
    redirect_to routines_path, notice: "ルーティンを削除しました"
  end

  private

  def routine_params
    params.require(:routine).permit(:name)
  end
end

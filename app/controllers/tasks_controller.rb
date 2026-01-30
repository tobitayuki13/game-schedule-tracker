class TasksController < ApplicationController
  before_action :require_login

  def create
    routine = current_user.routines.find(params[:routine_id])
    task = routine.tasks.new(task_params)

    if task.save
      redirect_to routine_path(routine)
    else
      @routine = routine
      @tasks = routine.tasks.order(:position, :id)
      @task = task
      render "routines/show", status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :position)
  end
end

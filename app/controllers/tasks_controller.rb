class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:start, :finish, :reset]

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

  def start
    @task.routine.tasks.in_progress.update_all(status: :not_started)
    @task.update!(status: :in_progress)
    redirect_to execute_routine_path(@task.routine)
  end

  def finish
    @task.update!(status: :done)
    redirect_to execute_routine_path(@task.routine)
  end

  def reset
    @task.reset_status!
    redirect_to execute_routine_path(@task.routine)
  end

  private

  def task_params
    params.require(:task).permit(:name, :position)
  end

  def set_task
    @task = Task.joins(:routine)
                .where(id: params[:id], routines: { user_id: current_user.id })
                .first!
  end
end

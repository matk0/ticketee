class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update]
  helper_method :sort_column, :sort_direction

  def index
    @projects = policy_scope(Project)
  end

  def show
    authorize @project, :show?
    @tickets = @project.tickets.order(sort_column + " " + sort_direction)
  end

  def edit
    authorize @project, :update?
  end

  def update
    authorize @project, :update?
    if @project.update(project_params)
      flash[:notice] = "Project has been updated."
      redirect_to @project
    else
      flash.now[:alert] = "Project has not been updated."
      render "edit"
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The project you were looking for could not be found."
    redirect_to projects_path
  end

  def sort_column
    Ticket.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end

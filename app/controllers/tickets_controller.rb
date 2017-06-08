class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :toggle_completed, :watch]

  def index
  end

  def show
    authorize @ticket, :show?
    @comment = @ticket.comments.build(state_id: @ticket.state_id)
  end

  def new
    @ticket = @project.tickets.build
    authorize @ticket, :create?
    @ticket.attachments.build
  end

  def create
    @ticket = @project.tickets.new

    whitelisted_params = ticket_params
    unless policy(@ticket).tag?
      whitelisted_params.delete(:tag_names)
    end

    @ticket.attributes = whitelisted_params
    @ticket.author = current_user
    authorize @ticket, :create?

    if @ticket.save
      flash[:notice] = "Ticket has been created."
      redirect_to [@project, @ticket]
    else
      flash.now[:alert] = "Ticket has not been created."
      render "new"
    end
  end

  def edit
    authorize @ticket, :update?
  end

  def update
    authorize @ticket, :update?
    if @ticket.update(ticket_params)
      flash[:notice] = "Ticket has been updated."
      redirect_to [@project, @ticket]
    else
      flash.now[:alert] = "Ticket has not been updated."
      render "edit"
    end
  end

  def destroy
    authorize @ticket, :destroy?
    @ticket.destroy
    flash[:notice] = "Ticket has been deleted."

    redirect_to @project
  end

  def search
    authorize @project, :show?
    if params[:search].present?
      if params[:exact_match]
        @tickets = @project.tickets.search(params[:search] + negation)
      elsif params[:at_least_one_matches]
        @tickets = @project.tickets.search_for_at_least_one_match(params[:search])
      else
        @tickets = @project.tickets.search(params[:search])
      end
    else
      @tickets = @project.tickets
    end
    render "projects/show"
  end

  def toggle_completed
    respond_to do |format|
      format.js { @ticket.toggle_completed! }
    end
  end

  def watch
    authorize @ticket, :show?
    if @ticket.watchers.exists?(current_user.id)
      @ticket.watchers.destroy(current_user)
      flash[:notice] = "You are no longer watching this ticket."
    else
      @ticket.watchers << current_user
      flash[:notice] = "You are now watching this ticket."
    end

    redirect_to project_ticket_path(@ticket.project, @ticket)
  end

  private

  def negation
    negative_tags = Tag.where.not(name: tags_from_params)
    negative_tags.inject(" ") {|negatives, tag| negatives += "!#{tag.name} "}
  end

  def tags_from_params
    params[:search].gsub(/\s+/, '').split(",")
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:name, :description, :tag_names, attachments_attributes: [:file, :file_cache])
  end
end

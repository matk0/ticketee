class AttachmentsController < ApplicationController
  def show
    attachment = Attachment.find(params[:id])
    authorize attachment, :show?
    send_file attachment.file.path, disposition: :inline
  end

  def new
    @index = params[:index].to_i
    @ticket = Ticket.new
    @ticket.attachments.build
    render layout: false
  end
end

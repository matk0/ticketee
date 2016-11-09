module TicketsHelper
  def state_transition_for(comment)
    if comment.previous_state != comment.state
      content_tag(:p) do
        value = "<strong><i class='fa fa-gear'></i> state changed</strong>"
        if comment.previous_state.present?
          value += " from <span class='#{label_style(comment.previous_state.name)} label'>#{render comment.previous_state}</span>"
        end
        value += " to <span class='label #{label_style(comment.state.name)}'>#{render comment.state}</span>"
        value.html_safe
      end
    end
  end

  def label_style name
    case name
    when 'New'
      "alert"
    when 'Open'
      "warning"
    when 'Closed'
      "secondary"
    when 'Awesome'
      "success"
    end
  end
end

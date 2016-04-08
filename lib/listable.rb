module Listable
  def format_description(description)
    "#{description}".ljust(25)
  end

  def format_date(*dates)
    empty_message = dates.size == 2 ? 'N/A' : 'No due date'
    formatted_date = dates.compact.map! { |d| d.strftime("%D") }.join ' -- '
    formatted_date.empty? ? empty_message : formatted_date
  end

  def format_priority(priority)
    priority_values = {'high' => ' ⇧', 'medium' => ' ⇨', 'low'  => ' ⇩', nil => ''}
    priority_values[priority]
  end
end

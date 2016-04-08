class TodoItem
  include Listable
  attr_reader :description, :due, :priority

  def initialize(description, options={})
    @description = description
    @due = options[:due] ? Date.parse(options[:due]) : options[:due]
    if priority_values.include?(options[:priority])
      @priority = options[:priority]
    else
      raise UdaciListErrors::InvalidPriorityValue, "\"#{options[:priority]}\" is not a valid priority."
    end
  end

  def details
    format_description(@description) + "due: " +
    format_date(@due) +
    format_priority(@priority)
  end

  def priority_values
    ['high', 'medium', 'low', nil]
  end
end

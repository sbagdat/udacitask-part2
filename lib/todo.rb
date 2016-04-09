class TodoItem
  include Listable
  attr_reader :description, :due, :priority

  def initialize(description, options={})
    build_todo_item({description: description}.merge(options))
  end

  def details
    format_description(@description) + "due: " +
    format_date(@due) +
    format_priority(@priority)
  end

  def update(options={})
    build_todo_item(options)
  end

  private

  def build_todo_item(options = {})
    @description = options[:description] if options[:description]
    @due = Chronic.parse(options[:due])  if options[:due]

    if options[:priority]
      if valid_priority?(options[:priority])
        @priority = options[:priority]
      else
        raise UdaciListErrors::InvalidPriorityValue, "\"#{options[:priority]}\" is not a valid priority."
      end
    end
  end

  def valid_priority?(priority)
    ['high', 'medium', 'low', nil].include? priority
  end
end

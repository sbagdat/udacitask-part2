class EventItem
  include Listable
  attr_reader :description, :start_date, :end_date

  def initialize(description, options={})
    build_event_item({description: description}.merge(options))
  end

  def details
    format_description(@description) + "event dates: " + format_date(@start_date, @end_date)
  end

  def update(options = {})
    build_event_item(options)
  end

  private

  def build_event_item(options = {})
    @description = options[:description] if options[:description]
    @start_date = Chronic.parse(options[:start_date]) if options[:start_date]
    @end_date = Chronic.parse(options[:end_date]) if options[:end_date]
  end
end

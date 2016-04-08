class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] || 'Untitled List'
    @items = []
  end

  def add(type, description, options={})
    type.downcase!
    raise UdaciListErrors::InvalidItemType, "\"#{type}\" type is not supported." unless valid_type?(type)

    @items.push TodoItem.new(description, options) if type == "todo"
    @items.push EventItem.new(description, options) if type == "event"
    @items.push LinkItem.new(description, options) if type == "link"
  end

  def delete(index)
    @items[index-1] ? @items.delete_at(index - 1)
                    : (raise UdaciListErrors::IndexExceedsListSize, "There is no item at ##{index}.")
  end

  def all
    print_items
  end

  def filter(type)
    print_items(case type
                when 'todo'  then @items.select {|item| item.is_a? TodoItem}
                when 'event' then @items.select {|item| item.is_a? EventItem}
                when 'link'  then @items.select {|item| item.is_a? LinkItem}
                else raise UdaciListErrors::InvalidItemType, "\"#{type}\" type is not supported."
                end)
  end

  private

  def valid_type?(type)
    %w(todo event link).include?(type)
  end

  def print_items(items=@items)
    puts "-" * @title.length
    puts @title
    puts "-" * @title.length
    items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end
end

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
    print_items case type
    when 'todo'
      {items: @items.select {|item| item.is_a? TodoItem}, title_extend: 'Todo Items'}
    when 'event'
      {items: @items.select {|item| item.is_a? EventItem}, title_extend: 'Event Items'}
    when 'link'
      {items: @items.select {|item| item.is_a? LinkItem}, title_extend: 'Link Items'}
    else raise UdaciListErrors::InvalidItemType, "\"#{type}\" type is not supported."
    end
  end

  private

  def valid_type?(type)
    %w(todo event link).include?(type)
  end

  def print_items(options = {items: @items, title_extend: nil})
    rows = []
    items = options[:items]
    title = [@title, options[:title_extend]].compact.join(' - ')
    items.each_with_index do |item, position|
      rows << [position + 1, item.details]
    end

    table = Terminal::Table.new :title => title, :headings => ['#', 'Details'], :rows => rows
    puts table
  end
end

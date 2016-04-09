class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] || 'Untitled List'
    @items = []
  end

  def add(type, description, options={})
    type.downcase!

    if types.key?(type)
      @items << types[type].new(description, options)
    else
      raise UdaciListErrors::InvalidItemType, %Q("#{type}"" type is not supported.)
    end
  end

  def delete(*indexes)
    indexes.each do |index|
      if @items[index-1]
        @items[index-1] = nil
      else
        raise UdaciListErrors::IndexExceedsListSize, "There is no item at ##{index}."
      end
    end
    @items.compact!
  end

  def all
    print_items
  end

  def update(index, options={})
    @items[index-1].update(options)
  end

  def filter(type)
    print_items case type
    when 'todo'
      {items: @items.select {|item| item.is_a? TodoItem}, filtered: true}
    when 'event'
      {items: @items.select {|item| item.is_a? EventItem}, filtered: true}
    when 'link'
      {items: @items.select {|item| item.is_a? LinkItem}, filtered: true}
    else raise UdaciListErrors::InvalidItemType, "\"#{type}\" type is not supported."
    end
  end

  private

  def types
    {'todo' => TodoItem, 'event' => EventItem, 'link' => LinkItem}
  end

  def print_items(options = {items: @items, filtered: nil})
    rows = []
    items = options[:items]
    title = "#{@title}" + (options[:filtered] ? " - #{items.first.class.to_s.gsub('Item', ' Items')}" : '')

    items.each_with_index do |item, position|
      row = [position + 1]
      row << item.class.to_s.gsub('Item', '') unless options[:filtered]
      row << item.details
      rows << row
    end

    headings = ['#']
    headings << 'Type' unless options[:filtered]
    headings << 'Item Details'

    table = Terminal::Table.new :title => title, :headings => headings, :rows => rows
    puts table
  end
end

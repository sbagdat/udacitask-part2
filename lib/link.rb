class LinkItem
  include Listable
  attr_reader :description, :site_name

  def initialize(url, options={})
    build_link_item({description: url}.merge(options))
  end

  def format_name
    @site_name ? @site_name : ""
  end

  def details
    format_description(@description) + "site name: " + format_name
  end

  def update(options = {})
    build_link_item(options)
  end

  private

  def build_link_item(options = {})
    @description = options[:description] if options[:description]
    @site_name = options[:site_name] if options[:site_name]
  end
end

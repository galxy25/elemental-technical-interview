#!/usr/bin/ruby
require 'json'

class InventoryManager
  attr_accessor :data

  def initialize(inventory_items)
    @data = inventory_items
  end

  def most_expensive_by_category(limit)
      result = []
      grouped_data(default_group_field).each do |group|
        #The first element of group is the item type,
        #The second element is the array of actual items
        result << most_expensive(limit, group[1])
      end
      result
  end

  def epic_length_cds(minute_length)
    result = []
    cds = items_by_category("cd")
    cds.each do |cd|
      result << cd if cd_length_in_minutes(cd) > minute_length
    end

    result
  end

  def potential_egots
    book_authors = items_by_category("book").flat_map {|book| book["author"]}
    cd_authors = items_by_category("cd").flat_map {|cd| cd["author"]}
    book_authors & cd_authors
  end

  def chronic_descriptions
    result = []
    books = items_by_category("book")
    cds = items_by_category("cd")
    dvds = items_by_category("dvd")
    result << dvds.select { |dvd| chronic_dvd?(dvd)}
    result << cds.select { |cd| chronic_cd?(cd)}
    result << books.select { |book| chronic_book?(book)}
  end

  private

  def price_comparasion_field
    "price"
  end

  def default_group_field
    "type"
  end

  def grouped_data(group_on)
    data.group_by { |inventory_items| inventory_items[group_on] }
  end

  def items_by_category(category)
    grouped_data(default_group_field)[category]
  end

  def most_expensive(limit, item_group)
    item_group.max(limit) do |item1, item2|
      item1[price_comparasion_field] <=> item2[price_comparasion_field]
    end
  end

  def cds
    items_by_category("cd")
  end

  def cd_length_in_minutes(cd)
    length_in_seconds = 0
    cd["tracks"].each do |track|
      length_in_seconds = length_in_seconds + track["seconds"]
    end
    length_in_seconds / 60
  end

  def chronic_book?(book)
    string_has_year_value?(book["title"]) || book["chapters"].any? do |chapter|
      string_has_year_value?(chapter)
    end
  end

  def chronic_cd?(cd)
    string_has_year_value?(cd["title"]) || cd["tracks"].any? do |track|
      string_has_year_value?(track["name"])
    end
  end

  def chronic_dvd?(dvd)
    string_has_year_value?(dvd["title"])
  end

  def string_has_year_value?(string)
    !!/\d+/.match(string)
  end
end


input = $stdin.read
parsed_input = JSON.parse(input)
# puts "Parsed Input: #{parsed_input}"

@inventory_manager = InventoryManager.new(parsed_input)

puts "Five most expensive items by category: #{@inventory_manager.most_expensive_by_category(5)}"
puts "CD's with running length greater than 60 minutes: #{@inventory_manager.epic_length_cds(60)}"
puts "Authors who have also released a cd: #{@inventory_manager.potential_egots}"
puts "Items with a title/track/chapter containing a year value: #{@inventory_manager.chronic_descriptions}"

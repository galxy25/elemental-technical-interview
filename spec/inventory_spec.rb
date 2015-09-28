require 'spec_helper'
require 'pry'

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
end

describe InventoryManager do
  let (:item_types) { ["book", "dvd", "cd"] }
  let (:expensive_book_authors) { ["mary", "had", "a", "little", "lamb"] }
  let (:cheap_book_author) { "joseph" }
  let (:expensive_cd_artists) { [ "joan", "juan", "john"] }
  let (:expensive_dvd_titles) { ["An", "Affair", "To", "Remember"] }
  let (:limit) { 5 }
  let(:epic_cd_minute_length) { 60 }
  let(:long_winded_artists) { [ "juan", "john" ] }
  let(:short_winded_artist) { "joan" }

  before(:each) do
    @inventory_manager = InventoryManager.new(test_data)
  end

  describe "#epic_length_cds" do
    before(:each) do
      @long_running_cds = @inventory_manager.epic_length_cds(epic_cd_minute_length)
      @long_running_cds_artist = @long_running_cds.flat_map { |cd| cd["author"] }
    end

    it "returns all cd's that have a running time greater than a specified time" do
      long_winded_artists.each do |artist|
        expect(@long_running_cds_artist).to include artist
      end
    end

    it "does not return cds with running time less than the specified time" do
      expect(@long_running_cds_artist).to_not include short_winded_artist
    end
  end

  describe "#most_expensive" do
    before(:each) do
      @most_expensive_items = @inventory_manager.most_expensive_by_category(limit)
      @most_expensive_creators = @most_expensive_items.flat_map do |expensive_items|
        #Obviously this is hard coded to the particular data types I have in
        #the test data sample
        expensive_items.flat_map do |expensive_item|
          if expensive_item["type"] == "cd"
            expensive_item["author"]
          elsif expensive_item["type"] == "dvd"
            expensive_item["title"]
          else
            expensive_item["author"]
          end
        end
      end
    end

    it "returns up to the specified number of most expensive items per category" do
      expensive_dvd_titles.each do | title|
       expect(@most_expensive_creators).to include title
      end

      expensive_cd_artists.each do | artitst|
       expect(@most_expensive_creators).to include artitst
      end

      expensive_book_authors.each do | author|
       expect(@most_expensive_creators).to include author
      end
    end

    it "does not include a non top 5 expensive item" do
      expect(@most_expensive_creators).to_not include cheap_book_author
    end

  end

end

def test_data
  [
    {
      "price"=>15.99,
      "chapters"=> [
        "one",
        "two",
        "three"],
      "year"=>1999,
      "title"=>"foo",
      "author"=>"mary",
      "type"=>"book"
    },
    {
      "price"=>14.99,
      "chapters"=> [
        "one",
        "two",
        "three"],
      "year"=>1999,
      "title"=>"foo",
      "author"=>"had",
      "type"=>"book"
    },
    {
      "price"=>13.99,
      "chapters"=> [
        "one",
        "two",
        "three"],
      "year"=>1999,
      "title"=>"foo",
      "author"=>"a",
      "type"=>"book"
    },
    {
      "price"=>12.99,
      "chapters"=> [
        "one",
        "two",
        "three"],
      "year"=>1999,
      "title"=>"foo",
      "author"=>"little",
      "type"=>"book"
    },
    {
      "price"=>11.99,
      "chapters"=> [
        "one",
        "two",
        "three"],
      "year"=>1999,
      "title"=>"foo",
      "author"=>"lamb",
      "type"=>"book"
    },
    {
      "price"=>10.99,
      "chapters"=> [
        "one",
        "two",
        "three"],
      "year"=>1999,
      "title"=>"foo",
      "author"=>"joseph",
      "type"=>"book"
    },
    {
      "price"=>11.99,
      "minutes"=>90,
      "year"=>2004,
      "title"=>"An",
      "director"=>"alan",
      "type"=>"dvd"
    },
    {
      "price"=>11.99,
      "minutes"=>90,
      "year"=>2004,
      "title"=>"Affair",
      "director"=>"alan",
      "type"=>"dvd"
    },
    {
      "price"=>11.99,
      "minutes"=>90,
      "year"=>2004,
      "title"=>"To",
      "director"=>"alan",
      "type"=>"dvd"
    },
    {
      "price"=>11.99,
      "minutes"=>90,
      "year"=>2004,
      "title"=>"Remember",
      "director"=>"alan",
      "type"=>"dvd"
    },
    {
      "price"=>15.99,
      "tracks"=> [
        {
          "seconds"=>180,
          "name"=>"one"
        },
        {
          "seconds"=>200,
          "name"=>"two"
        }
      ],
      "year"=>2000,
      "title"=>"baz",
      "author"=>"joan",
      "type"=>"cd"
    },
    {
      "price"=>15.99,
      "tracks"=> [
        {
          "seconds"=>1900,
          "name"=>"one"
        },
        {
          "seconds"=>1800,
          "name"=>"two"
        }
      ],
      "year"=>2000,
      "title"=>"baz",
      "author"=>"juan",
      "type"=>"cd"
    },
    {
      "price"=>15.99,
      "tracks"=> [
        {
          "seconds"=>1800,
          "name"=>"one"
        },
        {
          "seconds"=>2800,
          "name"=>"two"
        }
      ],
      "year"=>2000,
      "title"=>"baz",
      "author"=>"john",
      "type"=>"cd"
    }
  ]
end



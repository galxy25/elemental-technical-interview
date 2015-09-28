require 'spec_helper'
require 'pry'

class InventoryManager
  attr_accessor :data

  def initialize(inventory_items)
    @data = inventory_items
  end

  def grouped_data(group_on)
    data.group_by { |inventory_items| inventory_items[group_on] }
  end

  private

end

describe InventoryManager do
  let (:type_variable) { "type"}
  let (:item_types) { ["book", "dvd", "cd"]}


  before(:each) do
    @inventory_manager = InventoryManager.new(test_data)
  end

  describe "#grouped_data" do
    it "groups the data according to the item type" do
      expect(@inventory_manager.grouped_data(type_variable).keys).to eq item_types
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
      "title"=>"bar",
      "director"=>"alan",
      "type"=>"dvd"},
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
    }
  ]
end



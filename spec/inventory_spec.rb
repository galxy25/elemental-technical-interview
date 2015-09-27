require 'spec_helper'
require 'json'
require 'pry'

class InventoryManager
  attr_accessor :data

  def initialize(inventory_items)
    @data = inventory_items
  end

  def say_hello
    "Hello"
  end

  private

end

describe InventoryManager do

  before(:each) do
    @inventory_manager = InventoryManager.new(test_data)
  end

  describe "#say_hello" do
    it "returns hello" do
      expect(@inventory_manager.say_hello).to match "Hello"
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



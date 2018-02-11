require "./spec_helper"
require "json"

describe API::Parser do
  post_body = JSON.parse(File.read("move.json"))

  parser = API::Parser.new(post_body)

  describe "#width" do
    it "returns the width as an int" do
      parser.width.should eq 20
    end
  end

  describe "#height" do
    it "returns the height as an int" do
      parser.height.should eq 25
    end
  end

  describe "#turn" do
    it "returns the turn as an int" do
      parser.turn.should eq 0
    end
  end

  describe "#food" do
    it "returns food with x and y" do
      food = parser.food.first 

      food["x"].should eq 15
      food["y"].should eq 12
    end
  end

  describe "#me" do
    it "returns snakes" do
      puts parser.me.inspect
      true.should eq true
    end
  end
end

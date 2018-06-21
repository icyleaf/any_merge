require "./spec_helper"
require "json"
require "yaml"

private def json_hash
  data = JSON.parse %Q{{"string":"foo","int":123,"float":1.23,"bool":true}}
  data.as_h
end

private def yaml_hash
  data = YAML.parse <<-YAML
string: foo
int: 123
float: 1.23
bool: true
YAML

  data.as_h
end

describe Hash do
  describe ".any_merge" do
    context "with Hash(String, JSON::Any)" do
      it "should merge Hash(String, String)" do
        other = {"string" => "bar", "string2" => "new"}
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "bar"
        hash.has_key?("string2").should be_true
      end

      it "should merge Hash(String, Int32)" do
        other = {"int" => 1, "int2" => 2}
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["int"].should eq 1_i64
        hash["int2"].should eq 2_i64
      end

      it "should merge Hash(String, JSON::Any)" do
        other = JSON.parse(%Q{{"title": "bar", "int": 456}}).as_h
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["title"].should eq "bar"
        hash["int"].should eq 456_i64

        other = {"title" => JSON::Any.new("bar"), "int" => JSON::Any.new(456_i64) }
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["title"].should eq "bar"
        hash["int"].should eq 456_i64
      end

      it "should merge Hash(Int32, String)" do
        other = { 1 => "bar", 2 => "new"}
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "foo"
        hash["1"].should eq "bar"
      end

      it "should merge Hash(Symbol, String)" do
        other = { :string => "bar", :string2 => "new"}
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "bar"
        hash.has_key?("string2").should be_true
      end

      it "should merge Hash(Int32 | Int64 | Symbol | String, String)" do
        other = { 1 => "foo", 2_i64 => "bar", :symbol => "any", "string" => "bar"}
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "bar"
        hash["1"].should eq "foo"
        hash["2"].should eq "bar"
        hash["symbol"].should eq "any"
      end

      it "should merge Hash(String, String | Int32 | Int64 | Float64 | Bool | Nil)" do
        other = { "string" => "bar", "int" => 321, "int64" => 321_i64, "float64" => 3.21, "bool" => false, "nil" => nil }
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "bar"
        hash["int"].should eq 321
        hash["int64"].should eq 321_i64
        hash["float64"].should eq 3.21
        hash["bool"].should eq false
        hash["nil"].should eq nil
      end

      it "should merge Hash(YAML::Any, YAML::Any)" do
        other = YAML.parse(%Q{string: "bar"\n"int": 456}).as_h
        hash = json_hash.any_merge other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "bar"
        hash["int"].should eq 456_i64
      end

      it "should merge Hash(String, Array)" do
        pending { "TODO" }
      end

      it "should merge Hash(String, Hash)" do
        pending { "TODO" }
      end
    end

    context "with Hash(YAML::Any, YAML::Any)" do
      it "should merge Hash(String, String)" do
        other = {"string" => "bar", "string2" => "new"}
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash.has_key?("string2").should be_true
      end

      it "should merge Hash(String, Int32)" do
        other = {"int" => 1, "int2" => 2}
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["int"].should eq 1_i64
        hash["int2"].should eq 2_i64
      end

      it "should merge Hash(YAML::Any, YAML::Any)" do
        other = YAML.parse(%Q{title: "bar"\n"int": 456}).as_h
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["title"].should eq "bar"
        hash["int"].should eq 456_i64

        other = {"title" => YAML::Any.new("bar"), "int" => YAML::Any.new(456_i64) }
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["title"].should eq "bar"
        hash["int"].should eq 456_i64
      end

      it "should merge Hash(Int32, String)" do
        other = { 1 => "1", 2 => "2"}
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "foo"
        hash[1].should eq "1"
      end

      it "should merge Hash(Symbol, String)" do
        other = { :string => "bar", :string2 => "new"}
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash.has_key?("string2").should be_true
      end

      it "should merge Hash(Int32 | Int64 | Symbol | String, String)" do
        other = { 1 => "foo", 2_i64 => "bar", :symbol => "any", "string" => "bar"}
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash[1].should eq "foo"
        hash[2].should eq "bar"
        hash["symbol"].should eq "any"
      end

      it "should merge Hash(String, String | Int32 | Int64 | Float64 | Bool | Nil)" do
        other = { "string" => "bar", "int" => 321, "int64" => 321_i64, "float64" => 3.21, "bool" => false, "nil" => nil }
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash["int"].should eq 321
        hash["int64"].should eq 321_i64
        hash["float64"].should eq 3.21
        hash["bool"].should eq false
        hash["nil"].should eq nil
      end

      it "should merge Hash(String, JSON::Any)" do
        other = JSON.parse(%Q{{"string": "bar", "int": 456}}).as_h
        hash = yaml_hash.any_merge other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash["int"].should eq 456_i64
      end

      it "should merge Hash(String, Array)" do
        pending { "TODO" }
      end

      it "should merge Hash(String, Hash)" do
        pending { "TODO" }
      end
    end
  end

  describe ".any_merge!" do
    context "with Hash(String, JSON::Any)" do
      it "should merge Hash(String, String)" do
        other = {"string" => "bar", "string2" => "new"}
        hash = json_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "bar"
        hash.has_key?("string2").should be_true
      end

      it "should merge Hash(String, Int32)" do
        other = {"int" => 1, "int2" => 2}
        hash = json_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(String, JSON::Any)
        hash["int"].should eq 1.to_i64
        hash["int2"].should eq 2.to_i64
      end

      it "should merge Hash(String, JSON::Any)" do
        other = JSON.parse(%Q{{"title": "bar", "int": 456}}).as_h
        hash = json_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(String, JSON::Any)
        hash["title"].should eq "bar"
        hash["int"].should eq 456.to_i64

        other = {"title" => JSON::Any.new("bar"), "int" => JSON::Any.new(456.to_i64) }
        hash = json_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(String, JSON::Any)
        hash["title"].should eq "bar"
        hash["int"].should eq 456.to_i64
      end

      it "should merge Hash(Int32 | Int64 | Symbol | String, String)" do
        other = { 1 => "foo", 2_i64 => "bar", :symbol => "any", "string" => "bar"}
        hash = json_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "bar"
        hash["1"].should eq "foo"
        hash["2"].should eq "bar"
        hash["symbol"].should eq "any"
      end

      it "should merge Hash(String, String | Int32 | Int64 | Float64 | Bool | Nil)" do
        other = { "string" => "bar", "int" => 321, "int64" => 321_i64, "float64" => 3.21, "bool" => false, "nil" => nil }
        hash = json_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "bar"
        hash["int"].should eq 321
        hash["int64"].should eq 321_i64
        hash["float64"].should eq 3.21
        hash["bool"].should eq false
        hash["nil"].should eq nil
      end

      it "should merge Hash(Int32, String)" do
        other = { 1 => "bar", 2 => "new"}
        hash = json_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(String, JSON::Any)
        hash["string"].should eq "foo"
        hash["1"].should eq "bar"
      end
    end

    context "with Hash(YAML::Any, YAML::Any)" do
      it "should merge Hash(String, String)" do
        other = {"string" => "bar", "string2" => "new"}
        hash = yaml_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash.has_key?("string2").should be_true
      end

      it "should merge Hash(String, Int32)" do
        other = {"int" => 1, "int2" => 2}
        hash = yaml_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["int"].should eq 1_i64
        hash["int2"].should eq 2_i64
      end

      it "should merge Hash(YAML::Any, YAML::Any)" do
        other = YAML.parse(%Q{title: "bar"\n"int": 456}).as_h
        hash = yaml_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["title"].should eq "bar"
        hash["int"].should eq 456_i64

        other = {"title" => YAML::Any.new("bar"), "int" => YAML::Any.new(456_i64) }
        hash = yaml_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["title"].should eq "bar"
        hash["int"].should eq 456_i64
      end

      it "should merge Hash(Int32, String)" do
        other = { 1 => "1", 2 => "2"}
        hash = yaml_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "foo"
        hash[1].should eq "1"
      end

      it "should merge Hash(Symbol, String)" do
        other = { :string => "bar", :string2 => "new"}
        hash = yaml_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash.has_key?("string2").should be_true
      end

      it "should merge Hash(Int32 | Int64 | Symbol | String, String)" do
        other = { 1 => "foo", 2_i64 => "bar", :symbol => "any", "string" => "bar"}
        hash = yaml_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash[1].should eq "foo"
        hash[2].should eq "bar"
        hash["symbol"].should eq "any"
      end

      it "should merge Hash(String, String | Int32 | Int64 | Float64 | Bool | Nil)" do
        other = { "string" => "bar", "int" => 321, "int64" => 321_i64, "float64" => 3.21, "bool" => false, "nil" => nil }
        hash = yaml_hash.dup
        hash.any_merge! other
        hash.should be_a Hash(YAML::Any, YAML::Any)
        hash["string"].should eq "bar"
        hash["int"].should eq 321
        hash["int64"].should eq 321_i64
        hash["float64"].should eq 3.21
        hash["bool"].should eq false
        hash["nil"].should eq nil
      end
    end
  end
end

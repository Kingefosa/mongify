require 'spec_helper'

describe Mongify::Database::Table do
  before(:each) do
    @table = Mongify::Database::Table.new('users')
  end
  
  it "should have name" do
    @table.name.should == "users"
  end
  it "should allow you to change table name" do
    @table.name = 'accounts'
    @table.name.should == 'accounts'
  end
  
  it "should get setup options" do
    @table = Mongify::Database::Table.new('users', :embed_in => 'accounts', :as => 'users')
    @table.options.should == {'embed_in' => 'accounts', 'as' => 'users'}
  end
  
  context "column" do
    it "should add to count" do
      lambda { @table.column 'name' }.should change{@table.columns.count}.by(1)
    end
    
    it "should work without a type" do
      col = @table.column 'name', :default => '123'
      col.type.should == :string
    end
    
    it "should be able to find" do
      col = @table.column 'dark'
      @table.find_column('dark').should == col
    end
    
    it "should return nil if not found" do
      @table.column 'dark'
      @table.find_column('blue').should be_nil
    end
  end
  
  context "add_column" do
    it "should require Mongify::Database::Column" do
      lambda { @table.add_column("Not a column") }.should raise_error(Mongify::DatabaseColumnExpected)
    end
    it "shold except Mongify::Database::Column as a parameter" do
      lambda { @table.add_column(Mongify::Database::Column.new('test')) }.should_not raise_error(Mongify::DatabaseColumnExpected)
    end
    
    it "should add to the column count" do
      lambda { @table.add_column(Mongify::Database::Column.new('test')) }.should change{@table.columns.count}.by(1)
    end
    
    context "on initialization" do
      before(:each) do
        columns = [Mongify::Database::Column.new('test1'), Mongify::Database::Column.new('test2')]
        @table = Mongify::Database::Table.new('users', :columns => columns)
      end
      it "should add columns" do
        @table.columns.should have(2).columns
      end
      it "should remove columns from the options" do
        @table.options.should_not have_key('columns')
      end
    end
  end
end

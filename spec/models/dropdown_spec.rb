# == Schema Information
#
# Table name: dropdowns
#
#  id           :bigint           not null, primary key
#  display_name :string
#  drop_down    :string
#  value        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_dropdowns_on_drop_down  (drop_down)
#  index_dropdowns_on_value      (value)
#

require 'rails_helper'

describe Dropdown do
  describe '#get_collection' do
    before(:each) do
      @option1 = Dropdown.where(display_name: "type1", value: "option1", drop_down: "type1").create
      @option2 = Dropdown.where(display_name: "type2", value: "option2", drop_down: "type2").create
    end

    # Class methods
    it 'returns a collection of the dropdown options of a certain type' do
      expect(Dropdown.get_collection("type1")).to include @option1
      expect(Dropdown.get_collection("type1")).not_to include @option2
    end

    it 'returns null when the dropdown type does not exist' do
      expect(Dropdown.get_collection("type3")).to be_empty
    end

    # Validation 
    it 'is valid with valid attributes' do
      expect(@option1).to be_valid
    end

    it 'is invalid with no display name' do
      option = Dropdown.new(value: "option1", drop_down: "type1")
      expect(option).not_to be_valid
    end

    it 'is invalid with no value' do
      option = Dropdown.new(display_name: "type1", drop_down: "type1")
      expect(option).not_to be_valid
    end

    it 'is invalid with no drop down type' do
      option = Dropdown.new(value: "option1", display_name: "type1")
      expect(option).not_to be_valid
    end

    # Object relations do not need testing as they are has many not belongs to

  end
end

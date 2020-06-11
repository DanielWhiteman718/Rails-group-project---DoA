# == Schema Information
#
# Table name: uni_modules
#
#  id          :bigint           not null, primary key
#  code        :string           not null
#  credits     :integer
#  level       :integer          not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  semester_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_uni_modules_on_code         (code)
#  index_uni_modules_on_semester_id  (semester_id)
#  index_uni_modules_on_user_id      (user_id)
#

require 'rails_helper'

RSpec.describe UniModule, type: :model do

  it 'is valid with all valid attributes' do
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.build(:uni_module, user_id: u.id, semester_id: s.id)
    expect(m).to be_valid
  end

  it 'is invalid with no attributes' do
    m = UniModule.new()
    expect(m).to_not be_valid
  end

  it 'must have a non-blank module code' do
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.build(:uni_module, user_id: u.id, semester_id: s.id)
    # Default code in FactoryBot is 'TST124'
    expect(m).to be_valid
    m.code = ''
    expect(m).to_not be_valid
  end

  it 'is invalid with a non-unique module code' do
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    m2 = FactoryBot.build(:uni_module, user_id: u.id, semester_id: s.id)
    expect(m).to be_valid
    expect(m2).to_not be_valid
  end

  it 'only accepts levels between 1 and 6' do
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.build(:uni_module, user_id: u.id, semester_id: s.id)
    # Default level in FactoryBot is 1
    expect(m).to be_valid
    m.level = 0
    expect(m).to_not be_valid
    m.level = 6
    expect(m).to be_valid
    m.level = 7
    expect(m).to_not be_valid
  end

  it 'only accepts credits >= 0' do
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.build(:uni_module, user_id: u.id, semester_id: s.id)
    # Default credit value is 20
    expect(m).to be_valid
    m.credits = 0
    expect(m).to be_valid
    m.credits = -1
    expect(m).to_not be_valid
  end

end

# == Schema Information
#
# Table name: activities
#
#  id            :bigint           not null, primary key
#  archived      :boolean          default(FALSE), not null
#  code          :string           not null
#  in_drive      :boolean          default(FALSE), not null
#  name          :string           not null
#  name_abrv     :string
#  notes         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  theme_id      :bigint           not null
#  uni_module_id :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  index_activities_on_theme_id                             (theme_id)
#  index_activities_on_theme_id_and_code_and_uni_module_id  (theme_id,code,uni_module_id) UNIQUE
#  index_activities_on_uni_module_id                        (uni_module_id)
#  index_activities_on_user_id                              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Activity, type: :model do

  it 'is valid with valid attributes' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.build(:activity, uni_module_id: m.id, theme_id: t.id)
    expect(a).to be_valid
  end

  it 'is invalid with blank attributes' do
    a = Activity.new
    expect(a).to_not be_valid
  end

  it 'is invalid with no theme' do
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.build(:activity, uni_module_id: m.id)
    expect(a).to_not be_valid
  end

  it 'is invalid with no module' do
    t = Theme.create(code: 'ACME')
    a = FactoryBot.build(:activity, theme_id: t.id)
    expect(a).to_not be_valid
  end

  it 'is invalid with no name' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.build(:activity, name: '', uni_module_id: m.id, theme_id: t.id)
    expect(a).to_not be_valid
  end

  it 'is invalid with no code' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.build(:activity, code: '', uni_module_id: m.id, theme_id: t.id)
    expect(a).to_not be_valid
  end

  it 'is invalid with a non-unique full code' do
    t = Theme.create(code: 'ACME')
    t2 = Theme.create(code: 'MBCE')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, code: 'AMR125', user_id: u.id, semester_id: s.id)
    m2 = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    expect(a).to be_valid
    # Same theme, code and module, invalid
    a2 = FactoryBot.build(:activity, uni_module_id: m.id, theme_id: t.id)
    expect(a2).to_not be_valid
    # Different theme
    a2.theme_id = t2.id
    expect(a2).to be_valid
    # Different code
    a2.theme_id = t.id
    a2.code = '123c'
    expect(a2).to be_valid
    # Different module
    a2.code = '111b'
    a2.uni_module_id = m2.id
    expect(a2).to be_valid
  end

  it 'is invalid if the boolean values in_drive and archived are nil' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.build(:activity, in_drive: nil, archived: nil, uni_module_id: m.id, theme_id: t.id)
    expect(a).to_not be_valid
  end

  describe '#unique_id' do
    it  'Outputs a string concatenating the theme id, activity id, and module id' do
      theme = double('theme', code: 'ACME')
      uni_module = double('uni_module', code: 'AMR124')
      a = Activity.new(code: '100c')
      allow(a).to receive(:theme).and_return(theme)
      allow(a).to receive(:uni_module).and_return(uni_module)
      expected = a.theme.code + a.code + a.uni_module.code
      expect(a.unique_id).to eq expected
    end
  end

  describe '#degree_string' do
    it 'Outputs a blank string when an activity has no degree programmes linked with it' do
      a = Activity.new
      allow(a).to receive(:programmes).and_return([])
      expect(a.degree_string).to eq ""
    end

    it 'Outputs the code of the degree programme, if it is associated with one degree programme' do
      a = Activity.new
      p1 = double('programme', code: 'MEC')

      allow(a).to receive(:programmes).and_return([p1])
      expect(a.degree_string).to eq p1.code
    end

    it 'Outputs a comma separated list of programme codes for the degree programmes it is associated with' do
      a = Activity.new

      p1 = double('programme', code: 'MEC')
      p2 = double('programme', code: 'COM')
      p3 = double('programme', code: 'GEE')

      allow(a).to receive(:programmes).and_return([p1, p2, p3])
      expected = "#{p1.code}, #{p2.code}, #{p3.code}"
      expect(a.degree_string).to eq expected
    end
  end

end

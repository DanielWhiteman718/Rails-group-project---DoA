# == Schema Information
#
# Table name: edit_requests
#
#  id           :bigint           not null, primary key
#  message      :text
#  new_val      :string
#  status       :integer
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  activity_id  :bigint
#  bulk_id      :integer
#  column_id    :bigint
#  initiator_id :bigint
#  target_id    :bigint
#
# Indexes
#
#  index_edit_requests_on_activity_id   (activity_id)
#  index_edit_requests_on_column_id     (column_id)
#  index_edit_requests_on_initiator_id  (initiator_id)
#  index_edit_requests_on_target_id     (target_id)
#
# Foreign Keys
#
#  fk_rails_...  (column_id => columns.id)
#

require 'rails_helper'

RSpec.describe EditRequest, type: :model do

  it 'is valid when all required attributes are valid' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
    er = FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
    expect(er).to be_valid
  end
  
  it 'is invalid with blank attributes' do
    er = EditRequest.new
    expect(er).to_not be_valid
  end

  it 'is invalid with no message' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
    er = FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
    # Default is "Test message"
    expect(er).to be_valid
    er.message = nil
    expect(er).to_not be_valid
  end
  
  it 'is invalid with no status' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
    er = FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
    # Default is "Test message"
    expect(er).to be_valid
    er.status = nil
    expect(er).to_not be_valid
  end

  it 'is invalid with no title' do 
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
    er = FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
    # Default is "Test message"
    expect(er).to be_valid
    er.title = nil
    expect(er).to_not be_valid
  end

  it 'is invalid with no bulk id' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
    er = FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
    # Default is "Test message"
    expect(er).to be_valid
    er.bulk_id = nil
    expect(er).to_not be_valid
  end

  it 'is invalid with no initiator id' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
    er = FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
    # Default is "Test message"
    expect(er).to be_valid
    er.initiator_id = nil
    expect(er).to_not be_valid
  end

  it 'is invalid with no target id' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
    er = FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
    # Default is "Test message"
    expect(er).to be_valid
    er.target_id = nil
    expect(er).to_not be_valid
  end

  it 'is invalid with no column id' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
    er = FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
    # Default is "Test message"
    expect(er).to be_valid
    er.column_id = nil
    expect(er).to_not be_valid
  end

  describe '#convert_status' do
    let(:t) {Theme.create(code: 'ACME')}
    let(:u) {FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')}
    let(:s) {Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')}
    let(:m) {FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)}
    let(:a) {FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)}
    let(:c) {Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')}
    let(:er) {FactoryBot.build(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}

    it 'outputs new with input 0' do
      # Default status is 0
      expect(er.convert_status).to eq("New")
    end

    it 'outputs outstanding with inuput 1' do
      er.status = 1
      expect(er.convert_status).to eq("Outstanding")
    end

    it 'outputs completed with input 2' do
      er.status = 2
      expect(er.convert_status).to eq("Completed")
    end

    it 'outputs nothing when the input is not 0, 1, 2' do
      er.status = 3
      expect(er.convert_status).to eq(nil)
    end
  end

  describe '#self.bulk_status' do
      let(:t) {Theme.create(code: 'ACME')}
      let(:u) {FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')}
      let(:s) {Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')}
      let(:m) {FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)}
      let(:a) {FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)}
      let(:c1) {Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')}
      let(:c2) {Column.create(db_name: 'theme_id', display_name: 'test', table: 'activities')}
      let(:er1) {FactoryBot.build(:edit_request, activity_id: a.id, column_id: c1.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}
      let(:er2) {FactoryBot.build(:edit_request, activity_id: a.id, column_id: c2.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}

    it 'outputs new if there is at least 1 new item in the bulk request' do
      # Default both new
      req1 = [er1, er2]
      expect(EditRequest.bulk_status(req1)).to eq(0)
      # One new, one other
      er1.status = 1
      req2 = [er1, er2]
      expect(EditRequest.bulk_status(req2)).to eq(0)
    end

    it 'outputs outstanding if there is at least 1 outstanding item in the bulk request and 0 new items' do
      # Both outstanding
      er1.status = 1
      er2.status = 1
      req1 = [er1, er2]
      expect(EditRequest.bulk_status(req1)).to eq(1)
      # One outstanding, one completed
      er1.status = 2
      req2 = [er1, er2]
      expect(EditRequest.bulk_status(req2)).to eq(1)
    end

    it 'outputs completed if all items in the bulk request are complete' do
      # Both completed
      er1.status = 2
      er2.status = 2
      req1 = [er1, er2]
      expect(EditRequest.bulk_status(req1)).to eq(2)
    end
  end

  describe '#self.outstanding_requests' do
    let(:t) {Theme.create(code: 'ACME')}
    let(:u) {FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')}
    let(:s) {Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')}
    let(:m) {FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)}
    let(:a) {FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)}
    let(:c1) {Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')}
    let(:c2) {Column.create(db_name: 'theme_id', display_name: 'test', table: 'activities')}
    let(:er1) {FactoryBot.build(:edit_request, activity_id: a.id, column_id: c1.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}
    let(:er2) {FactoryBot.build(:edit_request, activity_id: a.id, column_id: c2.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}

    it 'outputs the number of outstanding items in a bulk request' do
      # Default for both is new
      req1 = [er1, er2]
      expect(EditRequest.outstanding_requests(req1)).to eq(2)
      # Mix of new and outstanding
      er1.status = 1
      req2 = [er1, er2]
      expect(EditRequest.outstanding_requests(req2)).to eq(2)
    end

    it 'outputs 0 if there are no outstanding items in a bulk request' do
      # Both completed
      er1.status = 2
      er2.status = 2
      req1 = [er1, er2]
      expect(EditRequest.outstanding_requests(req1)).to eq(0)
    end
  end

  describe '#set_status' do
    let(:t) {Theme.create(code: 'ACME')}
    let(:u) {FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')}
    let(:s) {Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')}
    let(:m) {FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)}
    let(:a) {FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)}
    let(:c) {Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')}
    let(:er) {FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}

    it 'updates the status if the input is 0, 1, 2' do
      er.set_status(0)
      expect(er.status).to eq(0)
      er.set_status(1)
      expect(er.status).to eq(1)
      er.set_status(2)
      expect(er.status).to eq(2)
    end

    it 'rejects updating the status is the input is not 0, 1, 2' do
      er.set_status(3)
      expect(er).to_not be_valid
    end
  end

  describe '#update' do
    let(:t) {Theme.create(code: 'ACME')}
    let(:u) {FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')}
    let(:s) {Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')}
    let(:m) {FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)}
    # Activity
    let(:a) {FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)}
    # Activity assess
    let(:post_mole) {Dropdown.create(drop_down: "post_lab", value: "MOLE MCQ", display_name: "Post lab assessment type")}
    let(:p2p) {Dropdown.create(drop_down: "assessment", value: "Pass to progress", display_name: "Assessment type")}
    let(:aa) {FactoryBot.create(:activity_assess, pre_assess_type_id: p2p.id, activity_id: a.id, during_assess_type_id: p2p.id, post_assess_type_id: p2p.id, post_lab_type_id: post_mole.id)}
    # Activity GTA
    let(:gta) {FactoryBot.create(:activity_gta, activity_id: a.id)}  
    # Activity teaching
    let(:resit) {Dropdown.create(drop_down: "resit", value: "Low", display_name: "Resit priority")}
    let(:ateach) {FactoryBot.create(:activity_teaching, activity_id: a.id, resit_priority_id: resit.id, user_id: u.id)}
    # Activity tech
    let(:atech) {FactoryBot.create(:activity_tech, activity_id: a.id, tech_lead_id: u.id, tech_ustudy_id: u.id)}
    # Activity timetable
    let(:r) {FactoryBot.create(:room)}
    let(:at) {FactoryBot.create(:activity_timetable, activity_id: a.id, pref_room_id: r.id)}
    # Edit request
    let(:c1) {Column.create(db_name: 'notes', display_name: 'test', table: 'activities')}
    let(:c2) {Column.create(db_name: 'notes', display_name: 'test', table: 'activity_assesses')}
    let(:c3) {Column.create(db_name: 'criteria', display_name: 'test', table: 'activity_gta')}
    let(:c4) {Column.create(db_name: 'g_drive_link', display_name: 'test', table: 'activity_teachings')}
    let(:c5) {Column.create(db_name: 'equip_needed', display_name: 'test', table: 'activity_teches')}
    let(:c6) {Column.create(db_name: 'notes', display_name: 'test', table: 'activity_timetables')}
    let(:c7) {Column.create(db_name: 'archived', display_name: 'test', table: 'activities')}
    let(:er) {FactoryBot.create(:edit_request, activity_id: a.id, column_id: c1.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}

    it 'updates the activity/correct activity model when the input is valid' do
      # Set up associations
      er.activity.activity_assess = aa
      er.activity.activity_gta = gta
      er.activity.activity_teaching = ateach
      er.activity.activity_tech = atech
      er.activity.activity_timetable = at

      # Default c1
      er.update("test update")
      expect(er.activity.notes).to eq("test update")
      expect(er.status).to eq(2)
      expect(er.new_val).to eq("test update")

      # c2
      er.column_id = c2.id
      er.update("test update")
      expect(er.activity.activity_assess.notes).to eq("test update")
      expect(er.status).to eq(2)
      expect(er.new_val).to eq("test update")

      # c3
      er.column_id = c3.id
      er.update("test update")
      expect(er.activity.activity_gta.criteria).to eq("test update")
      expect(er.status).to eq(2)
      expect(er.new_val).to eq("test update")

      # c4
      er.column_id = c4.id
      er.update("test update")
      expect(er.activity.activity_teaching.g_drive_link).to eq("test update")
      expect(er.status).to eq(2)
      expect(er.new_val).to eq("test update")

      # c5
      er.column_id = c5.id
      er.update("test update")
      expect(er.activity.activity_tech.equip_needed).to eq("test update")
      expect(er.status).to eq(2)
      expect(er.new_val).to eq("test update")

      # c6
      er.column_id = c6.id
      er.update("test update")
      expect(er.activity.activity_timetable.notes).to eq("test update")
      expect(er.status).to eq(2)
      expect(er.new_val).to eq("test update")
    end

    it 'returns error messages when the input is invalid' do
      # c7
      er.column_id = c7.id
      expect(er.update("test update")).to_not be_nil
    end
  end

  describe '#field_current_val' do
    let(:t) {Theme.create(code: 'ACME')}
    let(:u) {FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')}
    let(:s) {Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')}
    let(:m) {FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)}
    # Activity
    let(:a) {FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id, user_id: u.id)}
    let(:prog) {FactoryBot.create(:programme)}
    # Activity assess
    let(:post_mole) {Dropdown.create(drop_down: "post_lab", value: "MOLE MCQ", display_name: "Post lab assessment type")}
    let(:p2p) {Dropdown.create(drop_down: "assessment", value: "Pass to progress", display_name: "Assessment type")}
    let(:aa) {FactoryBot.create(:activity_assess, pre_assess_type_id: p2p.id, activity_id: a.id, during_assess_type_id: p2p.id, post_assess_type_id: p2p.id, post_lab_type_id: post_mole.id)}
    # Activity GTA
    let(:gta) {FactoryBot.create(:activity_gta, activity_id: a.id)}  
    # Activity teaching
    let(:resit) {Dropdown.create(drop_down: "resit", value: "Low", display_name: "Resit priority")}
    let(:ateach) {FactoryBot.create(:activity_teaching, activity_id: a.id, resit_priority_id: resit.id, user_id: u.id)}
    # Activity tech
    let(:atech) {FactoryBot.create(:activity_tech, activity_id: a.id, tech_lead_id: u.id, tech_ustudy_id: u.id)}
    # Activity timetable
    let(:r) {FactoryBot.create(:room)}
    let(:at) {FactoryBot.create(:activity_timetable, activity_id: a.id, pref_room_id: r.id)}
    # Edit request
    let(:c1) {Column.create(db_name: 'notes', display_name: 'test', table: 'activities')}
    let(:c2) {Column.create(db_name: 'notes', display_name: 'test', table: 'activity_assesses')}
    let(:c3) {Column.create(db_name: 'criteria', display_name: 'test', table: 'activity_gta')}
    let(:c4) {Column.create(db_name: 'g_drive_link', display_name: 'test', table: 'activity_teachings')}
    let(:c5) {Column.create(db_name: 'equip_needed', display_name: 'test', table: 'activity_teches')}
    let(:c6) {Column.create(db_name: 'notes', display_name: 'test', table: 'activity_timetables')}
    let(:c7) {Column.create(db_name: 'archived', display_name: 'test', table: 'activities')}
    let(:c8) {Column.create(db_name: 'user_id', display_name: 'test', table: 'gta_invites')}
    let(:c9) {Column.create(db_name: 'objective_id', display_name: 'test', table: 'activity_objective')}
    let(:c10) {Column.create(db_name: 'room_id', display_name: 'test', table: 'room_bookings')}
    let(:c11) {Column.create(db_name: 'id', display_name: 'test', table: 'programmes')}
    let(:er) {FactoryBot.create(:edit_request, activity_id: a.id, column_id: c1.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}

    it 'outputs the current value and collection for a specified field' do
      # Set up associations
      er.activity.activity_assess = aa
      er.activity.activity_gta = gta
      er.activity.activity_teaching = ateach
      er.activity.activity_tech = atech
      er.activity.activity_timetable = at

      # General cases
      # c1
      result, collection = er.field_current_val
      expect(result).to eq(er.activity.notes)
      expect(collection).to eq(nil)

      # c2
      er.column_id = c2.id
      result, collection = er.field_current_val
      expect(result).to eq(er.activity.activity_assess.notes)
      expect(collection).to eq(nil)

      # c3
      er.column_id = c3.id
      result, collection = er.field_current_val
      expect(result).to eq(er.activity.activity_gta.criteria)
      expect(collection).to eq(nil)

      # c4
      er.column_id = c4.id
      result, collection = er.field_current_val
      expect(result).to eq(er.activity.activity_teaching.g_drive_link)
      expect(collection).to eq(nil)

      # c5
      er.column_id = c5.id
      result, collection = er.field_current_val
      expect(result).to eq(er.activity.activity_tech.equip_needed)
      expect(collection).to eq(nil)

      # c6
      er.column_id = c6.id
      result, collection = er.field_current_val
      expect(result).to eq(er.activity.activity_timetable.notes)
      expect(collection).to eq(nil)

      # All special cases - Dropdowns
      # Module
      er.column_id = c1.id
      er.column.db_name = "uni_module_id"
      result, collection = er.field_current_val
      expect(result).to eq(m.code)
      expect(collection).to include([m.id, m.code])

      # Theme
      er.column.db_name = "theme_id"
      result, collection = er.field_current_val
      expect(result).to eq(t.code)
      expect(collection).to include([t.id, t.code])

      # MEE lead
      er.column.db_name = "user_id"
      result, collection = er.field_current_val
      expect(result).to eq(u.display_name)
      expect(collection).to include([u.id, u.display_name])

      # Module understudy
      er.column_id = c4.id
      er.column.db_name = "user_id"
      result, collection = er.field_current_val
      expect(result).to eq(u.display_name)
      expect(collection).to include([u.id, u.display_name])

      # Resit priority
      er.column.db_name = "resit_priority_id"
      result, collection = er.field_current_val
      expect(result).to eq(resit.value)
      expect(collection).to include([resit.id, resit.value])

      # Tech lead
      er.column_id = c5.id
      er.column.db_name = "tech_lead_id"
      result, collection = er.field_current_val
      expect(result).to eq(u.display_name)
      expect(collection).to include([u.id, u.display_name])

      # Tech ustudy
      er.column.db_name = "tech_ustudy_id"
      result, collection = er.field_current_val
      expect(result).to eq(u.display_name)
      expect(collection).to include([u.id, u.display_name])

      # Pre assess
      er.column_id = c2.id
      er.column.db_name = "pre_assess_type_id"
      result, collection = er.field_current_val
      expect(result).to eq(p2p.value)
      expect(collection).to include([p2p.id, p2p.value])

      # During assess
      er.column.db_name = "during_assess_type_id"
      result, collection = er.field_current_val
      expect(result).to eq(p2p.value)
      expect(collection).to include([p2p.id, p2p.value])

      # Post assess
      er.column.db_name = "post_assess_type_id"
      result, collection = er.field_current_val
      expect(result).to eq(p2p.value)
      expect(collection).to include([p2p.id, p2p.value])

      # During assess
      er.column.db_name = "post_lab_type_id"
      result, collection = er.field_current_val
      expect(result).to eq(post_mole.value)
      expect(collection).to include([post_mole.id, post_mole.value])

      # Other special cases
      # Gta invites
      er.column_id = c8.id
      gta_invite = GtaInvite.create(activity_gta_id: gta.id, user_id: u.id)
      er.activity.activity_gta.gta_invites.find_or_create_by(user_id: gta_invite.user_id)
      result, collection = er.field_current_val
      expect(result).to eq(gta_invite.user.display_name)
      expect(collection).to eq(nil)

      # Activity objectives
      er.column_id = c9.id
      obj = FactoryBot.create(:objective)
      ao = FactoryBot.create(:activity_objective, objective_id: obj.id, programme_id: prog.id)
      obj_linker = ObjectiveLinker.create(activity_id: a.id, activity_objective_id: ao.id)
      er.activity.objective_linkers.find_or_create_by(activity_objective_id: obj_linker.activity_objective_id)
      result, collection = er.field_current_val
      expect(result).to eq(obj_linker.activity_objective.display)
      expect(collection).to eq(nil)

      # Room bookings
      er.column_id = c10.id
      room_booking = RoomBooking.create(activity_timetable_id: a.id, room_id: r.id)
      er.activity.activity_timetable.room_bookings.find_or_create_by(room_id: room_booking.room_id)
      result, collection = er.field_current_val
      expect(result).to eq("#{room_booking.room.name} (#{room_booking.room.code})")
      expect(collection).to eq(nil)
      
      # Programmes
      er.column_id = c11.id
      activity_prog = ActivityProgramme.create(activity_id: a.id, programme_id: prog.id)
      er.activity.activity_programmes.find_or_create_by(programme_id: activity_prog.programme_id)
      result, collection = er.field_current_val
      expect(result).to eq(prog.code)
      expect(collection).to eq(nil)
    end
  end

  describe '#field_new_val' do
    let(:t) {Theme.create(code: 'ACME')}
    let(:u) {FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')}
    let(:s) {Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')}
    let(:m) {FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)}
    # Activity
    let(:a) {FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id, user_id: u.id)}
    let(:prog) {FactoryBot.create(:programme)}
    # Activity assess
    let(:post_mole) {Dropdown.create(drop_down: "post_lab", value: "MOLE MCQ", display_name: "Post lab assessment type")}
    let(:p2p) {Dropdown.create(drop_down: "assessment", value: "Pass to progress", display_name: "Assessment type")}
    let(:aa) {FactoryBot.create(:activity_assess, pre_assess_type_id: p2p.id, activity_id: a.id, during_assess_type_id: p2p.id, post_assess_type_id: p2p.id, post_lab_type_id: post_mole.id)}
    # Activity GTA
    let(:gta) {FactoryBot.create(:activity_gta, activity_id: a.id)}  
    # Activity teaching
    let(:resit) {Dropdown.create(drop_down: "resit", value: "Low", display_name: "Resit priority")}
    let(:ateach) {FactoryBot.create(:activity_teaching, activity_id: a.id, resit_priority_id: resit.id, user_id: u.id)}
    # Activity tech
    let(:atech) {FactoryBot.create(:activity_tech, activity_id: a.id, tech_lead_id: u.id, tech_ustudy_id: u.id)}
    # Activity timetable
    let(:r) {FactoryBot.create(:room)}
    let(:at) {FactoryBot.create(:activity_timetable, activity_id: a.id, pref_room_id: r.id)}
    # Edit request
    let(:c1) {Column.create(db_name: 'notes', display_name: 'test', table: 'activities')}
    let(:c2) {Column.create(db_name: 'notes', display_name: 'test', table: 'activity_assesses')}
    let(:c3) {Column.create(db_name: 'criteria', display_name: 'test', table: 'activity_gta')}
    let(:c4) {Column.create(db_name: 'g_drive_link', display_name: 'test', table: 'activity_teachings')}
    let(:c5) {Column.create(db_name: 'equip_needed', display_name: 'test', table: 'activity_teches')}
    let(:c6) {Column.create(db_name: 'notes', display_name: 'test', table: 'activity_timetables')}
    let(:c7) {Column.create(db_name: 'archived', display_name: 'test', table: 'activities')}
    let(:c8) {Column.create(db_name: 'user_id', display_name: 'test', table: 'gta_invites')}
    let(:c9) {Column.create(db_name: 'objective_id', display_name: 'test', table: 'activity_objective')}
    let(:c10) {Column.create(db_name: 'room_id', display_name: 'test', table: 'room_bookings')}
    let(:c11) {Column.create(db_name: 'id', display_name: 'test', table: 'programmes')}
    let(:er) {FactoryBot.create(:edit_request, activity_id: a.id, column_id: c1.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)}

    it 'outputs the new value given after responding to an edit request' do
      # Set up associations
      er.activity.activity_assess = aa
      er.activity.activity_gta = gta
      er.activity.activity_teaching = ateach
      er.activity.activity_tech = atech
      er.activity.activity_timetable = at

      # General cases
      # c1
      er.new_val = "test update"
      result = er.field_new_val
      expect(result).to eq("test update")

      # c2
      er.column_id = c2.id
      er.new_val = "test update"
      result = er.field_new_val
      expect(result).to eq("test update")

      # c3
      er.column_id = c3.id
      er.new_val = "test update"
      result = er.field_new_val
      expect(result).to eq("test update")

      # c4
      er.column_id = c4.id
      er.new_val = "test update"
      result = er.field_new_val
      expect(result).to eq("test update")

      # c5
      er.column_id = c5.id
      er.new_val = "test update"
      result = er.field_new_val
      expect(result).to eq("test update")

      # c6
      er.column_id = c6.id
      er.new_val = "test update"
      result = er.field_new_val
      expect(result).to eq("test update")

      # Special cases
      # Theme
      er.column_id = c1.id
      er.column.db_name = "theme_id"
      er.new_val = t.id
      result = er.field_new_val
      expect(result).to eq(t.code)

      # Module
      er.column.db_name = "uni_module_id"
      er.new_val = m.id
      result = er.field_new_val
      expect(result).to eq(m.code)

      # User
      er.column.db_name = "user_id"
      er.new_val = u.id
      result = er.field_new_val
      expect(result).to eq(u.display_name)

      # Assessment
      er.column_id = c2.id
      er.column.db_name = "pre_assess_type_id"
      er.new_val = p2p.id
      result = er.field_new_val
      expect(result).to eq(p2p.value)     

      # Other special cases
      # Gta invites
      er.column_id = c8.id
      gta_invite = GtaInvite.create(activity_gta_id: gta.id, user_id: u.id)
      er.activity.activity_gta.gta_invites.find_or_create_by(user_id: gta_invite.user_id)
      result = er.field_new_val
      expect(result).to eq(gta_invite.user.display_name)

      # Activity objectives
      er.column_id = c9.id
      obj = FactoryBot.create(:objective)
      ao = FactoryBot.create(:activity_objective, objective_id: obj.id, programme_id: prog.id)
      obj_linker = ObjectiveLinker.create(activity_id: a.id, activity_objective_id: ao.id)
      er.activity.objective_linkers.find_or_create_by(activity_objective_id: obj_linker.activity_objective_id)
      result = er.field_new_val
      expect(result).to eq(obj_linker.activity_objective.display)

      # Room bookings
      er.column_id = c10.id
      room_booking = RoomBooking.create(activity_timetable_id: a.id, room_id: r.id)
      er.activity.activity_timetable.room_bookings.find_or_create_by(room_id: room_booking.room_id)
      result = er.field_new_val
      expect(result).to eq("#{room_booking.room.name} (#{room_booking.room.code})")
      
      # Programmes
      er.column_id = c11.id
      activity_prog = ActivityProgramme.create(activity_id: a.id, programme_id: prog.id)
      er.activity.activity_programmes.find_or_create_by(programme_id: activity_prog.programme_id)
      result = er.field_new_val
      expect(result).to eq(prog.code)
    end

    it 'outputs nil if an edit request has not been responded to yet' do
      result = er.field_new_val
      expect(result).to eq(nil)
    end
  end
end

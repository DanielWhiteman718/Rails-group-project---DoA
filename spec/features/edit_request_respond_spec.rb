require 'rails_helper'

describe 'Responding to requests' do
    specify 'I can see the details of an outstanding edit request where the field requires a dropdown' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        expect(page).to have_content("Requested by Request details #{er.initiator.display_name} #{er.title}")
        current_val, collection = er.field_current_val
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nCurrent value of the field that requires editing:\n#{current_val}")
        expect(page).to have_content("New Value:\n#{collection[0][1]}")
    end

    specify 'I can see the details of an outstanding edit request where the field requires a text box' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'notes', display_name: 'test', table: 'activities')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        expect(page).to have_content("Requested by Request details #{er.initiator.display_name} #{er.title}")
        current_val, collection = er.field_current_val
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nCurrent value of the field that requires editing:\n#{current_val}")
        expect(page).to have_content("New Value:")
    end

    specify 'I can see the details of an outstanding edit request where the field requires a check box' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'archived', display_name: 'test', table: 'activities')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        expect(page).to have_content("Requested by Request details #{er.initiator.display_name} #{er.title}")
        current_val, collection = er.field_current_val
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nCurrent value of the field that requires editing:\n#{current_val}")
        expect(page).to have_content("New Value:\n#{c.display_name}")
    end

    specify 'I can see the details of an outstanding edit request where the field requires a date' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        # Activity tech
        atech = FactoryBot.create(:activity_tech, activity_id: a.id, tech_lead_id: u.id, tech_ustudy_id: u.id)    
        c = Column.create(db_name: 'last_risk_assess', display_name: 'test', table: 'activity_teches')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        er.activity.activity_tech = atech
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        expect(page).to have_content("Requested by Request details #{er.initiator.display_name} #{er.title}")
        current_val, collection = er.field_current_val
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nCurrent value of the field that requires editing:\n#{current_val}")
        expect(page).to have_content("New Value:")
    end

    specify 'I can see the details of an outstanding edit request where the field requires a radio button' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        # Activity timetable
        r = FactoryBot.create(:room)
        at = FactoryBot.create(:activity_timetable, activity_id: a.id, pref_room_id: r.id)
        c = Column.create(db_name: 'pref_room_id', display_name: 'test', table: 'activity_timetables')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        er.activity.activity_timetable = at
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        expect(page).to have_content("Requested by Request details #{er.initiator.display_name} #{er.title}")
        current_val, collection = er.field_current_val
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nCurrent value of the field that requires editing:\n#{current_val}")
        expect(page).to have_content("New Value:\n#{collection[0][1]}")
    end

    specify 'I can see the details of an outstanding edit request where the field requires learning objectives' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'objective_id', display_name: 'test', table: 'activity_objective')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        obj = FactoryBot.create(:objective)
        prog = FactoryBot.create(:programme)
        ao = FactoryBot.create(:activity_objective, objective_id: obj.id, programme_id: prog.id)
        obj_linker = ObjectiveLinker.create(activity_id: a.id, activity_objective_id: ao.id)
        er.activity.objective_linkers.find_or_create_by(activity_objective_id: obj_linker.activity_objective_id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        expect(page).to have_content("Requested by Request details #{er.initiator.display_name} #{er.title}")
        current_val, collection = er.field_current_val
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nCurrent value of the field that requires editing:\n#{current_val}")
        expect(page).to have_content("New Value:\nLearning Outcome#{ao.display_str}\nRemove Learning Outcome\nAdd Learning Outcome")
    end

    specify 'I can see the details of an outstanding edit request where the field requires gta invites' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'user_id', display_name: 'test', table: 'gta_invites')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        gta = FactoryBot.create(:activity_gta, activity_id: a.id)
        gta_invite = GtaInvite.create(activity_gta_id: gta.id, user_id: u.id)
        er.activity.activity_gta.gta_invites.find_or_create_by(user_id: gta_invite.user_id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        expect(page).to have_content("Requested by Request details #{er.initiator.display_name} #{er.title}")
        current_val, collection = er.field_current_val
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nCurrent value of the field that requires editing:\n#{current_val}")
        expect(page).to have_content("New Value:\nInvited User *#{gta_invite.user.email}\nRemove GTA Invite\nAdd GTA Invite")
    end

    # Respond
    specify 'I can respond to an outstanding edit request where the field requires a dropdown' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m1 = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        m2 = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id, code: 'TST123')
        a = FactoryBot.create(:activity, uni_module_id: m1.id, theme_id: t.id)
        c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        select('TST123', :from => "edit_requests[#{er.id}][new_val]")
        click_button 'Save Changes'
        expect(page).to have_content("Activity:\nACME111bTST123 Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nNew value assigned by you:\nTST123")
    end

    specify 'I can respond to an outstanding edit request where the field requires a text box' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'notes', display_name: 'test', table: 'activities')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        fill_in("edit_requests[#{er.id}][new_val]", :with => 'Test change')
        click_button 'Save Changes'
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nNew value assigned by you:\nTest change")
    end

    specify 'I can respond to an outstanding edit request where the field requires a check box' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'archived', display_name: 'test', table: 'activities')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        check("edit_requests[#{er.id}][new_val]")
        click_button 'Save Changes'
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nNew value assigned by you:\ntrue")
    end

    specify 'I can respond to an outstanding edit request where the field requires a date' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        # Activity tech
        atech = FactoryBot.create(:activity_tech, activity_id: a.id, tech_lead_id: u.id, tech_ustudy_id: u.id)    
        c = Column.create(db_name: 'last_risk_assess', display_name: 'test', table: 'activity_teches')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        er.activity.activity_tech = atech
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        page.find("#edit_requests_#{er.id}_new_val").set("2019-01-01")
        click_button 'Save Changes'
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nNew value assigned by you:\n2019-01-01")
    end

    specify 'I can respond to an outstanding edit request where the field requires a radio button' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        # Activity timetable
        r = FactoryBot.create(:room)
        r = FactoryBot.create(:room, name: "Test Room Change", code: "1.02")
        at = FactoryBot.create(:activity_timetable, activity_id: a.id, pref_room_id: r.id)
        c = Column.create(db_name: 'pref_room_id', display_name: 'test', table: 'activity_timetables')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        er.activity.activity_timetable = at
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        select("Test Room Change (1.02)", :from => "edit_requests[#{er.id}][new_val]")
        click_button 'Save Changes'
        expect(page).to have_content("Activity:\n#{er.activity.unique_id} Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nNew value assigned by you:\nTest Room Change (1.02)")
    end

    # No changes required
    specify 'I can respond to an outstanding edit request and say there are no changes to be made' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
        er = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        click_button 'No Changes Required'
        expect(page).to have_content("Activity:\nACME111bTST124 Full Details\nMessage:\n#{er.message}\nField that requires editing:\n#{er.column.display_name}\nNew value assigned by you:\nNo changes required")
    end

    # Bulk save
    specify 'I can respond to multiple edit requests at once' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m1 = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        m2 = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id, code: 'TST123')
        a = FactoryBot.create(:activity, uni_module_id: m1.id, theme_id: t.id)
        c1 = Column.create(db_name: 'notes', display_name: 'test', table: 'activities')
        c2 = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
        er1 = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c1.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        er2 = FactoryBot.create(:edit_request, activity_id: a.id, column_id: c2.id, bulk_id: 1, initiator_id: u.id, target_id: u.id)
        login_as u, scope: :user
        
        visit '/'
        click_link 'Show'
        fill_in("edit_requests[#{er1.id}][new_val]", :with => 'Test change')
        select('TST123', :from => "edit_requests[#{er2.id}][new_val]")
        click_button 'Save All Changes'
        expect(page).to have_content("Activity:\nACME111bTST123 Full Details\nMessage:\n#{er1.message}\nField that requires editing:\n#{er1.column.display_name}\nNew value assigned by you:\nTest change")
        expect(page).to have_content("Activity:\nACME111bTST123 Full Details\nMessage:\n#{er2.message}\nField that requires editing:\n#{er2.column.display_name}\nNew value assigned by you:\nTST123")
    end

end
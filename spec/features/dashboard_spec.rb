require 'rails_helper'

describe 'Viewing the dashboard' do
    specify 'The dashboard is the root page' do
        email = "dperry1@sheffield.ac.uk"
        display_name = "Dan Perry"
        u = FactoryBot.create(:user, email: email, display_name: display_name, role: 0)
        login_as u, scope: :user
        visit '/'
        expect(page).to have_content(display_name)
        expect(page).to have_content("Welcome to the Directory of Activities")
    end

    specify 'I can see all of my edit requests and only my edit requests' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        u_not_me = FactoryBot.create(:user, email: 'njridsdale1@sheffield.ac.uk', display_name: 'Nicki Ridsdale')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
        er1 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id, title: "Test message new", status: 0, message: "Test message new")
        er2 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 2, initiator_id: u.id, target_id: u.id, title: "Test message outstanding", status: 1, message: "Test message outstanding")
        er3 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 3, initiator_id: u.id, target_id: u.id, title: "Test message completed", status: 2, message: "Test message completed")
        er4 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 3, initiator_id: u.id, target_id: u_not_me.id, title: "Test message completed", status: 2, message: "Test message completed")

        login_as u, scope: :user
        visit '/'
        # Correct count
        save_and_open_page
        expect(page).to have_content("New Outstanding Completed 1 1 1")
        expect(page).to have_content("New Dan Perry Test message new")
        expect(page).to have_content("Outstanding Dan Perry Test message outstanding")
        expect(page).to have_content("Completed Dan Perry Test message completed")
        expect(page).to_not have_content("Completed Nicki Ridsdale Test message completed")
    end

    specify 'I can see only new edit requests and only my new edit requests' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        u_not_me = FactoryBot.create(:user, email: 'njridsdale1@sheffield.ac.uk', display_name: 'Nicki Ridsdale')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
        er1 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id, title: "Test message new", status: 0, message: "Test message new")
        er2 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 2, initiator_id: u.id, target_id: u.id, title: "Test message outstanding", status: 1, message: "Test message outstanding")
        er3 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 3, initiator_id: u.id, target_id: u.id, title: "Test message completed", status: 2, message: "Test message completed")
        er4 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 3, initiator_id: u.id, target_id: u_not_me.id, title: "Test message new", status: 0, message: "Test message new")

        login_as u, scope: :user
        visit '/'
        click_link 'New'
        expect(page).to have_content("New Outstanding Completed 1 1 1")
        expect(page).to have_content("New Dan Perry Test message new")
        expect(page).to_not have_content("New Nicki Ridsdale Test message new")
        expect(page).to_not have_content("Outstanding Dan Perry Test message outstanding")
        expect(page).to_not have_content("Completed Dan Perry Test message completed")
    end

    specify 'I can see only outstanding edit requests and only my outstanding edit requests' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        u_not_me = FactoryBot.create(:user, email: 'njridsdale1@sheffield.ac.uk', display_name: 'Nicki Ridsdale')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
        er1 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id, title: "Test message new", status: 0, message: "Test message new")
        er2 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 2, initiator_id: u.id, target_id: u.id, title: "Test message outstanding", status: 1, message: "Test message outstanding")
        er3 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 3, initiator_id: u.id, target_id: u.id, title: "Test message completed", status: 2, message: "Test message completed")
        er4 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 3, initiator_id: u.id, target_id: u_not_me.id, title: "Test message outstanding", status: 1, message: "Test message outstanding")

        login_as u, scope: :user
        visit '/'
        click_link 'Outstanding'
        expect(page).to have_content("New Outstanding Completed 1 1 1")
        expect(page).to_not have_content("New Dan Perry Test message new")
        expect(page).to have_content("Outstanding Dan Perry Test message outstanding")
        expect(page).to_not have_content("Outstanding Nicki Ridsdale Test message outstanding")
        expect(page).to_not have_content("Completed Dan Perry Test message completed")
    end

    specify 'I can see only completed edit requests and only my completed edit requests' do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        u_not_me = FactoryBot.create(:user, email: 'njridsdale1@sheffield.ac.uk', display_name: 'Nicki Ridsdale')
        s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        c = Column.create(db_name: 'uni_module_id', display_name: 'test', table: 'activities')
        er1 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 1, initiator_id: u.id, target_id: u.id, title: "Test message new", status: 0, message: "Test message new")
        er2 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 2, initiator_id: u.id, target_id: u.id, title: "Test message outstanding", status: 1, message: "Test message outstanding")
        er3 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 3, initiator_id: u.id, target_id: u.id, title: "Test message completed", status: 2, message: "Test message completed")
        er4 = EditRequest.create(activity_id: a.id, column_id: c.id, bulk_id: 3, initiator_id: u.id, target_id: u_not_me.id, title: "Test message completed", status: 2, message: "Test message compelted")

        login_as u, scope: :user
        visit '/'
        click_link 'Completed'
        expect(page).to have_content("New Outstanding Completed 1 1 1")
        expect(page).to_not have_content("New Dan Perry Test message new")
        expect(page).to_not have_content("Outstanding Dan Perry Test message outstanding")
        expect(page).to have_content("Completed Dan Perry Test message completed")
        expect(page).to_not have_content("Completed Nicki Ridsdale Test message completed")
    end
end
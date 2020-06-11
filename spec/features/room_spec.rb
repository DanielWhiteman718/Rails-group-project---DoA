require 'rails_helper'

describe 'Adding a room' do
    specify 'I can add a room with valid attributes, then remove it', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = '1.01'
        name = 'Testing Room'
        login_as user, scope: :user
        visit '/rooms'
        click_link 'New Room'
        fill_in 'Room Code (eg. 2.01)', with: code
        fill_in 'Room Name', with: name
        click_button 'Create Room'
        within(:css, '#rooms-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(Room.count).to eq 1

        # Deleting room
        within(:css, '#rooms-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to_not have_content(code)
        expect(page).to_not have_content(name)
        expect(Room.count).to eq 0
    end

    specify 'I cannot add a room with empty attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/rooms'
        click_link 'New Room'
        click_button 'Create Room'
        expect(page).to have_content("Code can't be blank")
        expect(page).to have_content("Name can't be blank")
    end

    specify 'I cannot remove a room which is still associated with an activity', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = '1.01'
        name = 'Testing Room'
        login_as user, scope: :user
        visit '/rooms'
        click_link 'New Room'
        fill_in 'Room Code (eg. 2.01)', with: code
        fill_in 'Room Name', with: name
        click_button 'Create Room'
        within(:css, '#rooms-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(Room.count).to eq 1

        # Creating activity
        t = FactoryBot.create(:theme, code: 'AMT')
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        u = FactoryBot.create(:uni_module, code: 'AMR124', user_id: user.id, semester_id: sem_aut.id)
        a = FactoryBot.create(:activity, theme_id: t.id, uni_module_id: u.id)
        at = FactoryBot.create(:activity_timetable, activity_id: a.id)
        FactoryBot.create(:room_booking, activity_timetable_id: at.id, room_id: Room.first.id)

        # Trying to delete room
        within(:css, '#rooms-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to have_content(code)
        expect(page).to have_content(name)
        expect(page).to have_content("You cannot remove this room. Please make sure it is not connected to other records before removing.")
        expect(Room.count).to eq 1
    end

    specify 'I can create, edit, and audit a room', js: true do
        code = '1.01'
        name = 'Testing room'
        new_code = '1.02'
        new_name = "Different name"
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        # Creating room
        visit '/rooms'
        click_link 'New Room'
        fill_in 'Room Code (eg. 2.01)', with: code
        fill_in 'Room Name', with: name
        click_button 'Create Room'
        # Editing room
        within(:css, '#rooms-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
            click_link 'Edit'
        }
        fill_in 'Room Code (eg. 2.01)', with: new_code
        fill_in 'Room Name', with: new_name
        click_button 'Update Room'
        # Auditing room
        within(:css, '#rooms-table'){
            expect(page).not_to have_content(code)
            expect(page).not_to have_content(name)
            expect(page).to have_content(new_code)
            expect(page).to have_content(new_name)
            click_link 'Audit Log'
        }
        within(:css, 'table.audit-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(new_code)
            expect(page).to have_content(name)
            expect(page).to have_content(new_name)
        }
    end
end

require 'rails_helper'

describe 'Adding a module' do
    specify 'I can add a module with valid attributes, then remove it', js: true do
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: "semester", value: "Both", display_name: "Semester")
        sem_ns = FactoryBot.create(:dropdown, drop_down: "semester", value: "Not standard", display_name: "Semester")

        email = 'dperry1@sheffield.ac.uk'
        display_name = 'Dan Perry'
        user = FactoryBot.create(:user, email: email, display_name: display_name)
        code  = 'COM1001'
        name = 'Module Name'
        credits = 20
        level = 1
        login_as user, scope: :user
        visit '/uni_modules'
        click_link 'New Module'
        fill_in 'Module code', with: code
        fill_in 'Name', with: name
        fill_in 'Credits', with: credits
        fill_in 'Level', with: level
        select(display_name, from: 'Module Lead')
        select('Autumn', from: 'Semester')
        click_button 'Create Module'
        within(:css, '#uni_modules-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(UniModule.count).to eq 1

        # Deleting module
        within(:css, '#uni_modules-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to_not have_content(code)
        expect(page).to_not have_content(name)
        expect(UniModule.count).to eq 0

    end

    specify 'I cannot add a module with empty attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/uni_modules'
        click_link 'New Module'
        click_button 'Create Module'
        expect(page).to have_content("Code can't be blank")
    end

    specify 'I cannot remove a module while it is still attached to an activity', js: true do
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: "semester", value: "Both", display_name: "Semester")
        sem_ns = FactoryBot.create(:dropdown, drop_down: "semester", value: "Not standard", display_name: "Semester")

        email = 'dperry1@sheffield.ac.uk'
        display_name = 'Dan Perry'
        user = FactoryBot.create(:user, email: email, display_name: display_name)
        code  = 'COM1001'
        name = 'Module Name'
        credits = 20
        level = 1
        login_as user, scope: :user
        visit '/uni_modules'
        click_link 'New Module'
        fill_in 'Module code', with: code
        fill_in 'Name', with: name
        fill_in 'Credits', with: credits
        fill_in 'Level', with: level
        select(display_name, from: 'Module Lead')
        select('Autumn', from: 'Semester')
        click_button 'Create Module'
        within(:css, '#uni_modules-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(UniModule.count).to eq 1

        t = FactoryBot.create(:theme, code: 'AMT')
        FactoryBot.create(:activity, theme_id: t.id, uni_module_id: UniModule.where(code: code).first.id)

        # Trying to delete module
        within(:css, '#uni_modules-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to have_content(code)
        expect(page).to have_content(name)
        expect(page).to have_content("You cannot remove this module. Please make sure it is not connected to other records before removing.")
        expect(UniModule.count).to eq 1
    end

    specify 'I can create, edit, and audit a module', js: true do
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: "semester", value: "Both", display_name: "Semester")
        sem_ns = FactoryBot.create(:dropdown, drop_down: "semester", value: "Not standard", display_name: "Semester")

        # Info needed for making the module
        email = 'dperry1@sheffield.ac.uk'
        display_name = 'Dan Perry'
        email2 = 'djwhiteman1@sheffield.ac.uk'
        display_name2 = 'Dan Whiteman'
        code = 'COM1001'
        # audit gem messes with capitals
        code_no_caps = "Com1001"
        name = 'Module name'
        credits = 20
        level = 1
        new_code = 'COM2001'
        new_code_no_caps = "Com2001"
        new_name = "Different module name"
        new_credits = 10
        new_level = 2

        # Logging in
        user = FactoryBot.create(:user, email: email, display_name: display_name)
        user2 = FactoryBot.create(:user, email: email2, display_name: display_name2)
        login_as user, scope: :user
        visit '/uni_modules'

        # Creating module
        click_link 'New Module'
        fill_in 'Module code', with: code
        fill_in 'Name', with: name
        fill_in 'Credits', with: credits
        fill_in 'Level', with: level
        select(display_name, from: 'Module Lead')
        select('Autumn', from: 'Semester')
        click_button 'Create Module'
        # Editing module
        within(:css, '#uni_modules-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
            click_link 'Edit'
        }
        fill_in 'Module code', with: new_code
        fill_in 'Name', with: new_name
        fill_in 'Credits', with: new_credits
        fill_in 'Level', with: new_level
        select(display_name2, from: 'Module Lead')
        select('Spring', from: 'Semester')
        click_button 'Update Module'
        # Check table has only the update values
        within(:css, '#uni_modules-table'){
            expect(page).not_to have_content(code)
            expect(page).not_to have_content(name)
            expect(page).to have_content(new_code)
            expect(page).to have_content(new_name)
        }

        # Check the audit log has both new and old values
        within(:css, '#uni_modules-table'){
            click_link 'Audit Log'
        }
        within(:css, 'table.audit-table'){
            expect(page).to have_content(code_no_caps)
            expect(page).to have_content(new_code_no_caps)
            expect(page).to have_content(name)
            expect(page).to have_content(new_name)
            expect(page).to have_content(credits)
            expect(page).to have_content(new_credits)
            expect(page).to have_content(user.display_name)
        }
    end
end

require 'rails_helper'

describe 'Adding a degree programme' do
    specify 'I can add a programme with valid attributes, then remove it', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = 'GEE'
        name = 'General Engineering'
        login_as user, scope: :user
        visit '/programmes'
        click_link 'New Programme'
        fill_in 'Code', with: code
        fill_in 'Name', with: name
        click_button 'Create Programme'
        within(:css, '#programmes-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(Programme.count).to eq 1

        # Deleting programme
        within(:css, '#programmes-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to_not have_content(code)
        expect(page).to_not have_content(name)
        expect(Programme.count).to eq 0
    end

    specify 'I cannot add a programme with empty attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/programmes'
        click_link 'New Programme'
        click_button 'Create Programme'
        expect(page).to have_content("Code can't be blank")
        expect(page).to have_content("Name can't be blank")
    end

    specify 'I cannot remove a programme while it is still associated with an activity', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = 'GEE'
        name = 'General Engineering'
        login_as user, scope: :user
        visit '/programmes'
        click_link 'New Programme'
        fill_in 'Code', with: code
        fill_in 'Name', with: name
        click_button 'Create Programme'
        within(:css, '#programmes-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(Programme.count).to eq 1

        # Creating activity and programme link
        t = FactoryBot.create(:theme, code: 'AMT')
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        u = FactoryBot.create(:uni_module, code: 'AMR124', user_id: user.id, semester_id: sem_aut.id)
        a = FactoryBot.create(:activity, theme_id: t.id, uni_module_id: u.id)
        FactoryBot.create(:activity_programme, activity_id: a.id, programme_id: Programme.first.id)

        # Trying to delete programme
        within(:css, '#programmes-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to have_content(code)
        expect(page).to have_content(name)
        expect(page).to have_content("You cannot remove this programme. Please make sure it is not connected to other records before removing.")
        expect(Programme.count).to eq 1
    end

    specify 'I cannot remove a programme while it is still associated with a learning outcome', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = 'GEE'
        name = 'General Engineering'
        login_as user, scope: :user
        visit '/programmes'
        click_link 'New Programme'
        fill_in 'Code', with: code
        fill_in 'Name', with: name
        click_button 'Create Programme'
        within(:css, '#programmes-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(Programme.count).to eq 1

        # Creating learning outcome
        o_code = FactoryBot.create(:objective)
        FactoryBot.create(:activity_objective, objective_id: o_code.id, programme_id: Programme.first.id)

        # Trying to delete programme
        within(:css, '#programmes-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to have_content(code)
        expect(page).to have_content(name)
        expect(page).to have_content("You cannot remove this programme. Please make sure it is not connected to other records before removing.")
        expect(Programme.count).to eq 1
    end

    specify 'I can create, edit, and audit a programme', js: true do
        code = 'GEE'
        # Audit gem messes with capitals
        code_no_caps = 'Gee'
        name = 'General engineering'
        new_code = 'MEC'
        new_code_no_caps = 'Mec'
        new_name = "Mechanical engineering"
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        # Creating programme
        visit '/programmes'
        click_link 'New Programme'
        fill_in 'Code', with: code
        fill_in 'Name', with: name
        click_button 'Create Programme'
        # Editing programme
        within(:css, '#programmes-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
            click_link 'Edit'
        }
        fill_in 'Code', with: new_code
        fill_in 'Name', with: new_name
        click_button 'Update Programme'
        # Auditing programme
        within(:css, '#programmes-table'){
            expect(page).not_to have_content(code)
            expect(page).not_to have_content(name)
            expect(page).to have_content(new_code)
            expect(page).to have_content(new_name)
            click_link 'Audit Log'
        }
        
        within(:css, 'table.audit-table'){
            expect(page).to have_content(code_no_caps)
            expect(page).to have_content(new_code_no_caps)
            expect(page).to have_content(name)
            expect(page).to have_content(new_name)
        }
    end
end

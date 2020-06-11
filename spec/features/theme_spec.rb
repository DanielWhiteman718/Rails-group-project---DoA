require 'rails_helper'

describe 'Adding a theme' do
    specify 'I can add a theme with valid attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = 'ACME'
        login_as user, scope: :user
        visit '/themes'
        click_link 'New Theme'
        fill_in 'Code', with: code
        click_button 'Create Theme'
        within(:css, '#themes-table'){
            expect(page).to have_content(code)
        }
        expect(Theme.count).to eq 1

        # Deleting theme
        within(:css, '#themes-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to_not have_content(code)
        expect(Theme.count).to eq 0
    end

    specify 'I cannot add a theme with empty attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/themes'
        click_link 'New Theme'
        click_button 'Create Theme'
        expect(page).to have_content("Code can't be blank")
    end

    specify 'I cannot remove a theme when it is connected to an activity', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = 'ACME'
        login_as user, scope: :user
        visit '/themes'
        click_link 'New Theme'
        fill_in 'Code', with: code
        click_button 'Create Theme'
        within(:css, '#themes-table'){
            expect(page).to have_content(code)
        }
        expect(Theme.count).to eq 1

        # Creating the activity

        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: "semester", value: "Both", display_name: "Semester")
        sem_ns = FactoryBot.create(:dropdown, drop_down: "semester", value: "Not standard", display_name: "Semester")

        u = FactoryBot.create(:uni_module, code: 'AMR124', user_id: user.id, semester_id: sem_aut.id)
        FactoryBot.create(:activity, theme_id: Theme.where(code: code).first.id, uni_module_id: u.id)

        expect(Activity.count).to eq 1

        # Trying to delete theme
        within(:css, '#themes-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to have_content(code)
        expect(page).to have_content "You cannot remove this theme. Please make sure it is not connected to other records before removing."
        expect(Theme.count).to eq 1
    end

    specify 'I can create, edit, and audit a theme', js: true do
        code = 'ACME'
        # Audit log messes with capitals
        code_no_caps = 'Acme'
        new_code = 'CCEE'
        new_code_no_caps = 'Ccee'
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        # Creating theme
        visit '/themes'
        click_link 'New Theme'
        fill_in 'Code', with: code
        click_button 'Create Theme'
        # Editing theme
        within(:css, '#themes-table'){
            expect(page).to have_content(code)
            click_link 'Edit'
        }
        fill_in 'Code', with: new_code
        click_button 'Update Theme'
        within(:css, '#themes-table'){
            expect(page).not_to have_content(code)
            expect(page).to have_content(new_code)
            click_link "Audit Log"
        }

        within(:css, 'table.audit-table'){
            expect(page).to have_content(code_no_caps)
            expect(page).to have_content(new_code_no_caps)
        }
    end
end
require 'rails_helper'

describe 'Adding an objective code' do
    specify 'I can add a code with valid attributes, then remove it', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = 'A1'
        name = 'Testing'
        login_as user, scope: :user
        visit '/objectives'
        click_link 'New Outcome Code'
        fill_in 'Code', with: code
        fill_in 'Title', with: name
        click_button 'Create Objective'
        within(:css, 'tbody#objectives-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(Objective.count).to eq 1

        # Deleting code
        within(:css, 'tbody#objectives-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to_not have_content(code)
        expect(page).to_not have_content(name)
        expect(Objective.count).to eq 0
    end

    specify 'I cannot add a code with empty attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/objectives'
        click_link 'New Outcome Code'
        click_button 'Create Objective'
        expect(page).to have_content("Code can't be blank")
        expect(page).to have_content("Name can't be blank")
    end

    specify 'I cannot remove a code when it still attached to a learning outcome', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        code  = 'A1'
        name = 'Testing'
        login_as user, scope: :user
        visit '/objectives'
        click_link 'New Outcome Code'
        fill_in 'Code', with: code
        fill_in 'Title', with: name
        click_button 'Create Objective'
        within(:css, 'tbody#objectives-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
        }
        expect(Objective.count).to eq 1

        # Creating a learning outcome
        pr = FactoryBot.create(:programme)
        FactoryBot.create(:activity_objective, objective_id: Objective.first.id, programme_id: pr.id)

        # Trying to delete outcome code
        within(:css, 'tbody#objectives-table'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to have_content(code)
        expect(page).to have_content(name)
        expect(page).to have_content("You cannot remove this learning outcome code. Please make sure it is not connected to other records before removing.")
        expect(Objective.count).to eq 1
    end

    specify 'I can create, edit, and audit a code', js: true do
        code = 'A1'
        name = 'Testing'
        new_code = 'B1'
        new_name = "Different name"
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        # Creating code
        visit '/objectives'
        click_link 'New Outcome Code'
        fill_in 'Code', with: code
        fill_in 'Title', with: name
        click_button 'Create Objective'
        # Editing code
        within(:css, 'tbody#objectives-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(name)
            click_link 'Edit'
        }
        fill_in 'Code', with: new_code
        fill_in 'Title', with: new_name
        click_button 'Update Objective'
        within(:css, 'tbody#objectives-table'){
            expect(page).not_to have_content(code)
            expect(page).not_to have_content(name)
            expect(page).to have_content(new_code)
            expect(page).to have_content(new_name)
            click_link 'Audit Log'
        }
        # Auditing code
        within(:css, 'table.audit-table'){
            expect(page).to have_content(code)
            expect(page).to have_content(new_code)
            expect(page).to have_content(name)
            expect(page).to have_content(new_name)
        }
    end
end

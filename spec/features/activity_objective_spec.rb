require 'rails_helper'

describe 'Adding an activity objective' do
    before(:each) do
        # Adding objective codes to select from
        FactoryBot.create(:objective)
        FactoryBot.create(:objective, code: 'T2', name: 'Test Objective 2')
        FactoryBot.create(:objective, code: 'T3', name: 'Test Objective 3')

        FactoryBot.create(:programme, code: 'GEE', name: 'General Engineering')
        FactoryBot.create(:programme, code: 'MEC', name: 'Mechanical Engineering')
        FactoryBot.create(:programme, code: 'CIV', name: 'Civil Engineering')
    end

    specify 'I can add and remove a learning outcome with valid attributes', js: true do
        obj_str = "T1 - Test Objective 1"
        short_desc = "Short"
        long_desc = "Long"
        prog_code = "GEE"
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/activity_objectives'
        click_link 'New Learning Objective'
        select(obj_str, from: 'Outcome Code')
        fill_in 'Short Description', with: short_desc
        fill_in 'Long Description', with: long_desc
        select(prog_code, from: "Degree Programme")
        click_button 'Create Activity objective'
        within(:css, '#objectives-table'){
            expect(page).to have_content(obj_str)
            expect(page).to have_content(short_desc)
            expect(page).to have_content(long_desc)
            expect(page).to have_content(prog_code)
        }
        expect(ActivityObjective.count).to eq 1
        # Deleting
        within(:css, '#objectives-table'){
            accept_alert do
                click_link 'Remove'
            end
            expect(page).to_not have_content(obj_str)
            expect(page).to_not have_content(short_desc)
            expect(page).to_not have_content(long_desc)
            expect(page).to_not have_content(prog_code)
        }
        expect(ActivityObjective.count).to eq 0
    end

    specify 'I cannot add an objective with empty attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/activity_objectives'
        click_link 'New Learning Objective'
        click_button 'Create Activity objective'
        expect(page).to have_content("Short desc can't be blank")
    end

    specify 'I cannot remove an outcome when it is still attached to an activity', js: true do
        obj_str = "T1 - Test Objective 1"
        short_desc = "Short"
        long_desc = "Long"
        prog_code = "GEE"
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/activity_objectives'
        click_link 'New Learning Objective'
        select(obj_str, from: 'Outcome Code')
        fill_in 'Short Description', with: short_desc
        fill_in 'Long Description', with: long_desc
        select(prog_code, from: "Degree Programme")
        click_button 'Create Activity objective'
        within(:css, '#objectives-table'){
            expect(page).to have_content(obj_str)
            expect(page).to have_content(short_desc)
            expect(page).to have_content(long_desc)
            expect(page).to have_content(prog_code)
        }
        expect(ActivityObjective.count).to eq 1

        # Creating activity and programme link
        t = FactoryBot.create(:theme, code: 'AMT')
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        u = FactoryBot.create(:uni_module, code: 'AMR124', user_id: user.id, semester_id: sem_aut.id)
        a = FactoryBot.create(:activity, theme_id: t.id, uni_module_id: u.id)
        FactoryBot.create(:objective_linker, activity_id: a.id, activity_objective_id: ActivityObjective.first.id)

        # Trying to delete outcome
        within(:css, '#objectives-table'){
            accept_alert do
                click_link 'Remove'
            end
            expect(page).to have_content(obj_str)
            expect(page).to have_content(short_desc)
            expect(page).to have_content(long_desc)
            expect(page).to have_content(prog_code)
        }
        expect(page).to have_content("You cannot remove this learning outcome. Please make sure it is not connected to other records before removing.")
        expect(ActivityObjective.count).to eq 1
    end

    specify 'I can create, edit and audit a learning outcome', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        # Create a learning objective with an associated code and programme
        short_desc = "Short1"
        long_desc = "Long1"

        short_desc2 = "Short2"
        long_desc2 = "Long2"

        obj_str = "T1 - Test Objective"
        obj_str_new = "T2 - Test Objective 2"

        prog1 = "GEE"
        prog2 = "MEC"

        login_as user, scope: :user
        visit '/activity_objectives'
        # Creating objective
        click_link "New Learning Objective"
        select(obj_str, from: 'Outcome Code')
        fill_in 'Short Description', with: short_desc
        fill_in 'Long Description', with: long_desc
        select(prog1, from: "Degree Programme")
        # Editing objective
        click_button 'Create Activity objective'
        within(:css, '#objectives-table'){
            expect(page).to have_content(Objective.find(1).display_str)
            expect(page).to have_content(short_desc)
            expect(page).to have_content(long_desc)
            click_link 'Edit'
        }
        select("T2 - Test Objective 2", from: 'Outcome Code')
        fill_in 'Short Description', with: short_desc2
        fill_in 'Long Description', with: long_desc2
        select(prog2, from: "Degree Programme")
        click_button 'Update Activity objective'
        within(:css, '#objectives-table'){
            expect(page).not_to have_content(short_desc)
            expect(page).not_to have_content(long_desc)
            expect(page).to have_content(obj_str_new)
            expect(page).to have_content(short_desc2)
            expect(page).to have_content(long_desc2)
            expect(page).not_to have_content(prog1)
            expect(page).to have_content(prog2)
        }
        # Auditing objective
        click_link 'Audit Log'
        within(:css, 'table.audit-table'){
            expect(page).to have_content(short_desc)
            expect(page).to have_content(short_desc2)
            expect(page).to have_content(long_desc)
            expect(page).to have_content(long_desc2)
            expect(page).to have_content(obj_str)
            expect(page).to have_content(obj_str_new)
            expect(page).to have_content(prog1)
            expect(page).to have_content(prog2)
        }
    end

    specify 'I can filter objectives by their degree code', js: true do
        code1 = 'T1'
        code2 = 'T2'
        prog1 = 'GEE'
        prog2 = 'MEC'
        FactoryBot.create(:activity_objective, objective_id: Objective.where(code: 'T1').first.id, programme_id: Programme.where(code: prog1).first.id)
        FactoryBot.create(:activity_objective, objective_id: Objective.where(code: 'T2').first.id, programme_id: Programme.where(code: prog2).first.id)
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/activity_objectives'
        # Can see both objective pre-filter
        within(:css, '#objectives-table'){
            expect(page).to have_content(prog2)
            expect(page).to have_content(code2)
            expect(page).to have_content(prog1)
            expect(page).to have_content(code1)
        }

        select(prog1, from: 'search[programme]')
        click_button 'Search'
        # Can only see one post-filter
        within(:css, '#objectives-table'){
            expect(page).not_to have_content(prog2)
            expect(page).not_to have_content(code2)
            expect(page).to have_content(prog1)
            expect(page).to have_content(code1)
        }
    end
end

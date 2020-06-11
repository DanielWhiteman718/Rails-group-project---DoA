require 'rails_helper'

describe 'Adding a dropdown option' do
    specify 'I can view different tables for the different dropdown option groups' do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        d1 = FactoryBot.create(:dropdown, drop_down: "dropdown1", value: "1", display_name: "dropdown1")
        d2 = FactoryBot.create(:dropdown, drop_down: "dropdown2", value: "2", display_name: "dropdown2")
        d3 = FactoryBot.create(:dropdown, drop_down: "dropdown3", value: "3", display_name: "dropdown3")
        login_as user, scope: :user
        visit '/dropdowns'
        expect(page).to have_content("dropdown1\nAdd dropdown1\nValue 1")
        expect(page).to have_content("dropdown2\nAdd dropdown2\nValue 2")
        expect(page).to have_content("dropdown3\nAdd dropdown3\nValue 3")
    end

    specify 'I can add a dropdown with valid attributes, then remove it', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        d = FactoryBot.create(:dropdown)
        login_as user, scope: :user
        visit '/dropdowns'
        click_link 'Add MyString'
        fill_in 'Value', with: "New Dropdown"
        click_button 'Create Option'
        expect(page).to have_content("New Dropdown")
        expect(Dropdown.count).to eq 2

        # Deleting dropdown
        accept_alert do
            click_link "Remove"
        end
        expect(page).to_not have_content("MyString Edit")
        expect(Dropdown.count).to eq 1
    end

    specify 'I cannot add a programme with empty attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        d = FactoryBot.create(:dropdown)
        login_as user, scope: :user
        visit '/dropdowns'
        click_link 'Add MyString'
        click_button 'Create Option'
        expect(page).to have_content("Value can't be blank")
    end

    specify 'I cannot remove a dropdown while it is still associated with other things', js: true do
        t = Theme.create(code: 'ACME')
        u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        d = FactoryBot.create(:dropdown, display_name: "Semester", drop_down: "semester")
        m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: d.id)
        a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
        login_as u, scope: :user
        visit '/dropdowns'
    
        # Deleting dropdown
        accept_alert do
            click_link "Remove"
        end
        expect(Dropdown.count).to eq 1
        expect(page).to have_content("Cannot remove dropdown option as there are still dependencies.")
    end

    specify 'I can create, edit, and audit a programme', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        d = FactoryBot.create(:dropdown)
        login_as user, scope: :user
        visit '/dropdowns'
        # Creating dropdown
        click_link 'Add MyString'
        fill_in 'Value', with: "New Dropdown"
        click_button 'Create Option'
        expect(page).to have_content("New Dropdown")
        # Editing dropdown
        click_link 'Edit'
        fill_in 'Value', with: "New value"
        click_button 'Update Option'
        # Auditing dropdown
        within(:css, '#dropdowns-table'){
            expect(page).not_to have_content("MyString")
            expect(page).to have_content("New value")
            click_link 'Audit Log'
        }
        
        within(:css, 'table.audit-table'){
            expect(page).to have_content("Mystring")
            expect(page).to have_content("New value")
        }
    end
end
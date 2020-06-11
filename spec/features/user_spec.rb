require 'rails_helper'

describe 'CRUD on users' do
    specify 'I can see myself on the list of users, but I cannot delete myself', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/users'

        within(:css, '#users-table'){
            expect(page).to have_content 'Dan Perry'
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to have_content 'Dan Perry'
        expect(page).to have_content 'You cannot remove yourself.'

    end

    specify 'I can create a valid user, edit it and then audit the changes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/users'
        click_link 'New User'
        fill_in 'Email', with: 'djwhiteman1@sheffield.ac.uk'
        fill_in 'Display Name', with: 'Dan Whiteman'
        select('Technical', from: 'Role')
        check('user_analyst')
        click_button 'Create User'
        within(:css, '#users-table'){
            expect(page).to have_content 'Dan Whiteman'
            click_link 'Edit'
        }
        fill_in 'Display Name', with: 'Someone Else'
        click_button 'Update User'
        
        within(:css, '#users-table'){
            expect(page).to have_content 'Someone Else'
            expect(page).to_not have_content 'Dan Whiteman'
            click_link 'Audit Log'
        }

        within(:css, 'table.audit-table'){
            expect(page).to have_content 'Someone else'
            expect(page).to have_content 'Dan whiteman'
        }
    end

    specify 'I cannot create a user with blank attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/users'
        click_link 'New User'
        click_button 'Create User'
        expect(page).to have_content "Email can't be blank"
        expect(page).to have_content "Display name can't be blank"
    end

    specify 'I can create a valid user and then delete it', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        user2 = FactoryBot.create(:user, email: 'djwhiteman1@sheffield.ac.uk', display_name: 'Dan Whiteman', role: 0, analyst: false, super_user: false)

        login_as user, scope: :user
        visit '/users'

        expect(page).to have_content 'Dan Whiteman'

        tr = nil
        
        within(:css, '#users-table'){
            td = page.find(:css, 'td', text: 'Dan Whiteman')
            tr = td.find(:xpath, './parent::tr')
        }

        accept_alert do
            tr.click_link 'Remove'
        end

        within(:css, '#users-table'){
            expect(page).to_not have_content 'Dan Whiteman'
        }
    end
end
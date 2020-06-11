require 'rails_helper'

describe 'Viewing the settings menu' do
    specify 'I can see my user information on the settings menu' do
        email = "dperry1@sheffield.ac.uk"
        display_name = "Dan Perry"
        u = FactoryBot.create(:user, email: email, display_name: display_name, role: 0)
        login_as u, scope: :user
        visit '/settings'
        expect(page).to have_content email
        expect(page).to have_content display_name
        expect(page).to have_content User.role_strings[u.role]
    end
end

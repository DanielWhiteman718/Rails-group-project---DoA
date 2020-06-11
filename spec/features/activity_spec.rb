require 'rails_helper'

# Wrapper method for creating the required dropdown elements for an activity
def make_dependents
    user = FactoryBot.create(:user, email: 'djwhiteman1@sheffield.ac.uk', display_name: 'Dan Whiteman')
    theme = FactoryBot.create(:theme, code: 'AMT')

    # Semester drop down options
    sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
    sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
    sem_both = FactoryBot.create(:dropdown, drop_down: "semester", value: "Both", display_name: "Semester")
    sem_ns = FactoryBot.create(:dropdown, drop_down: "semester", value: "Not standard", display_name: "Semester")

    # Assessment type drop down options
    ass_p2p = FactoryBot.create(:dropdown, drop_down: "assessment", value: "Pass to progress", display_name: "Assessment type")
    ass_sum = FactoryBot.create(:dropdown, drop_down: "assessment", value: "Summative", display_name: "Assessment type")
    ass_form = FactoryBot.create(:dropdown, drop_down: "assessment", value: "Formative", display_name: "Assessment type")
    ass_none = FactoryBot.create(:dropdown, drop_down: "assessment", value: "None", display_name: "Assessment type")

    # Post lab assessment drop down options
    post_mole = FactoryBot.create(:dropdown, drop_down: "post_lab", value: "MOLE MCQ", display_name: "Post lab assessment type")
    post_short = FactoryBot.create(:dropdown, drop_down: "post_lab", value: "Short report", display_name: "Post lab assessment type")
    post_full = FactoryBot.create(:dropdown, drop_down: "post_lab", value: "Full lab report", display_name: "Post lab assessment type")
    post_other = FactoryBot.create(:dropdown, drop_down: "post_lab", value: "Other", display_name: "Post lab assessment type")
    post_none = FactoryBot.create(:dropdown, drop_down: "post_lab", value: "None", display_name: "Post lab assessment type")

    # Resit priority drop down options
    resit_low = FactoryBot.create(:dropdown, drop_down: "resit", value: "Low", display_name: "Resit priority")
    resit_med = FactoryBot.create(:dropdown, drop_down: "resit", value: "Medium", display_name: "Resit priority")
    resit_high = FactoryBot.create(:dropdown, drop_down: "resit", value: "High", display_name: "Resit priority")

    FactoryBot.create(:uni_module, code: 'AMR124', user_id: user.id, semester_id: sem_aut.id)
end

describe 'Adding Activities' do
    before(:each) do
        make_dependents
    end

    specify 'I can add an activity with only the required attributes, edit it to add more, then audit the changes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        theme_code = 'AMT'
        # Audit gem messes with capitals
        theme_code_no_caps = 'Amt'
        act_code = '111b'
        mod_code = 'AMR124'
        mod_code_no_caps = 'Amr124'
        act_name = 'Test activity'
        new_act_name = 'Different activity'
        login_as user, scope: :user
        # Creating activity
        visit '/activities'
        click_link 'New Activity'
        select(theme_code, from: 'Theme')
        fill_in 'Unique Code', with: act_code
        fill_in 'Experiment Name', with: act_name
        select(user.display_name, from: 'MEE Lead')
        click_link 'Teaching'
        select(mod_code, from: 'Module')
        click_button 'Create Activity'
        # Editing activity
        within(:css, 'tbody#doa-body'){
            expect(page).to have_content("#{theme_code}#{act_code}#{mod_code}")
            expect(page).to have_content(act_name)
            click_link 'Full Details'
        }
        fill_in "Experiment Name", with: new_act_name
        click_link "Assessment"
        fill_in "Number of assessments", with: "2"
        select("Formative", from: "Pre-assessment type")
        select("Summative", from: "Post-assessment type")
        select("Short report", from: "Post-lab type")
        fill_in "Assessment weight", with: "20"
        click_button "Update Activity"
        within(:css, 'tbody#doa-body'){
            expect(page).to have_content("#{theme_code}#{act_code}#{mod_code}")
            expect(page).to_not have_content(act_name)
            expect(page).to have_content(new_act_name)
            click_link "Audit Log"
        }
        within(:css, 'table.audit-table'){
            expect(page).to have_content(act_name)
            expect(page).to have_content(new_act_name)
            expect(page).to have_content("20")
            expect(page).to have_content("Formative")
            expect(page).to have_content("Summative")
        }

    end

    specify 'I can add an activity with all fields having valid attributes, and then remove it', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        display_name = 'Dan Whiteman'
        FactoryBot.create(:programme, code: 'AERO', name: 'Aerospace')

        r1 = FactoryBot.create(:room, code: '1.01', name: 'EA Workshop')
        r2 = FactoryBot.create(:room, code: '1.02', name: 'Structures and Dynamics')
        r3 = FactoryBot.create(:room, code: '1.07', name: 'Analytics Lab')
        r4 = FactoryBot.create(:room, code: '1.08', name: 'Pilot Plant')

        theme_code = 'AMT'
        act_code = '111b'
        mod_code = 'AMR124'
        act_name = 'Test Activity'

        login_as user, scope: :user
        visit '/activities'
        click_link 'New Activity'
        select(theme_code, from: 'Theme')
        fill_in 'Unique Code', with: act_code
        fill_in 'Experiment Name', with: act_name
        select(display_name, from: 'MEE Lead')
        within(:css, '#lab_info'){
            check('AERO')
        }
        fill_in 'General notes', with: 'Notes blah blah'

        click_link 'Teaching'
        select(mod_code, from: 'Module')
        select('Dan Whiteman', from: 'Understudy Email Address')
        fill_in 'MOLE Public Link', with: 'link.com/ortnoerf'
        fill_in 'G Drive Link', with: 'link.com/aionekw'
        select('High', from: 'Resit Priority')

        click_link 'Assessment'
        fill_in 'Number of assessments', with: '2'
        select('Pass to progress', from: 'Pre-assessment type')
        select('None', from: 'During-assessment type')
        select('Formative', from: 'Post-assessment type')
        select('MOLE MCQ', from: 'Post-lab type')
        fill_in 'Assessment weight', with: '50'
        fill_in 'Assessment notes', with: 'Assessment blah blah blah'

        click_link 'GTA Information'
        fill_in 'GTA to Student Ratio', with: '12'
        fill_in 'Marking Time (minutes per student)', with: '20'
        fill_in 'Job Description', with: 'Job Description text text text'
        fill_in 'Jobshop Entry', with: 'Jobshop text text text text text'
        fill_in 'GTA Skills Required', with: 'GTAs must do text text text text text'

        click_link 'Technical'
        select(display_name, from: 'Technical Lead Email Address')
        select(display_name, from: 'Technical Understudy Email Address')
        within(:css, '.activity_activity_tech_last_risk_assess'){
            find(:css, '#activity_activity_tech_attributes_last_risk_assess_3i').find(:option, '3').select_option
            find(:css, '#activity_activity_tech_attributes_last_risk_assess_2i').find(:option, 'October').select_option
            find(:css, '#activity_activity_tech_attributes_last_risk_assess_1i').find(:option, '2019').select_option
        }

        within(:css, '.activity_activity_tech_next_risk_assess'){
            find(:css, '#activity_activity_tech_attributes_next_risk_assess_3i').find(:option, '3').select_option
            find(:css, '#activity_activity_tech_attributes_next_risk_assess_2i').find(:option, 'October').select_option
            find(:css, '#activity_activity_tech_attributes_next_risk_assess_1i').find(:option, '2021').select_option
        }

        fill_in 'Equipment Needed', with: 'Saw, Hammer, Particle Accelerator'
        fill_in 'Cost Per Student (£)', with: "2.50"

        click_link 'Timetabling'
        check('Same as Last Year?')
        fill_in 'Minimum Week Number', with: '2'
        fill_in 'Maximum Week Number', with: '10'
        fill_in 'Capacity', with: '30'

        within(:css, '.activity_activity_timetable_pref_room'){
            choose(r1.display_str)
        }

        within(:css, '.activity_activity_timetable_rooms'){
            check(r2.display_str)
            check(r4.display_str)
        }

        fill_in 'Duration (minutes)', with: '120'
        fill_in 'Setup Time (minutes)', with: '60'
        fill_in 'Series Setup Time (minutes)', with: '20'
        fill_in 'Takedown Time (minutes)', with: '25'
        fill_in 'Kit Preparation Time (minutes)', with: '10'
        fill_in 'Timetabling Notes', with: 'Timetabling blah blah blah'
        fill_in 'Capacity', with: '60'

        click_button 'Create Activity'
        within(:css, 'tbody#doa-body'){
            expect(page).to have_content(theme_code << act_code << mod_code)
            expect(page).to have_content(act_name)
        }
        expect(Activity.count).to eq 1
        expect(ActivityTech.count).to eq 1
        expect(ActivityTimetable.count).to eq 1
        expect(ActivityTeaching.count).to eq 1
        expect(ActivityGta.count).to eq 1
        expect(ActivityAssess.count).to eq 1
        expect(ActivityProgramme.count).to eq 1
        expect(RoomBooking.count).to eq 2

        # Deleting activity
        within(:css, 'tbody#doa-body'){
            accept_alert do
                click_link "Remove"
            end
        }
        expect(page).to_not have_content(theme_code << act_code << mod_code)
        expect(page).to_not have_content(act_name)
        # Check dependencies have been deleted
        expect(Activity.count).to eq 0
        expect(ActivityTech.count).to eq 0
        expect(ActivityTimetable.count).to eq 0
        expect(ActivityTeaching.count).to eq 0
        expect(ActivityGta.count).to eq 0
        expect(ActivityAssess.count).to eq 0
        expect(ActivityProgramme.count).to eq 0
        expect(RoomBooking.count).to eq 0

    end

    specify 'I cannot create an activity with missing required attributes', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/activities'
        click_link 'New Activity'
        click_button 'Create Activity'
        expect(page).to have_content "Code can't be blank"
        expect(page).to have_content "Name can't be blank"
    end
end

describe 'Filtering activities' do
    before(:each) do
        make_dependents
        mod2 = FactoryBot.create(:uni_module, name: 'Test Module 2', code: 'AMR125', user_id: User.first.id, level: 1, credits: 10, semester_id: Dropdown.where(drop_down: 'semester').first.id)

        a1 = FactoryBot.create(:activity, code: '111', name: 'Test 1', theme_id: Theme.first.id, uni_module_id: UniModule.first.id)
        a2 = FactoryBot.create(:activity, code: '112', name: 'Test 2', theme_id: Theme.first.id, uni_module_id: mod2.id)

        atime1 = FactoryBot.create(:activity_timetable, activity_id: a1.id)
        atime2 = FactoryBot.create(:activity_timetable, activity_id: a2.id)
    end

    specify 'I can search for an activity by name, then clear the filter', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/activities'
        select('Test 1', from: 'search_fils_id')
        click_button 'Search'
        within(:css, 'tbody#doa-body'){
            expect(page).to have_content 'Test 1'
            expect(page).to_not have_content 'Test 2'
        }

        click_link 'Reset All Filters'
        within(:css, 'tbody#doa-body'){
            expect(page).to have_content 'Test 1'
            expect(page).to have_content 'Test 2'
        }
    end

    specify 'I can filter activities by module, then reset the filters', js: true do
        user = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
        login_as user, scope: :user
        visit '/activities'
        click_button 'Add More Filters'
        select('AMR124', from: 'search_fils_uni_module')
        click_button 'Update'
        within(:css, 'tbody#doa-body'){
            expect(page).to have_content 'Test 1'
            expect(page).to_not have_content 'Test 2'
        }
        
        click_link 'Reset All Filters'
        within(:css, 'tbody#doa-body'){
            expect(page).to have_content 'Test 1'
            expect(page).to have_content 'Test 2'
        }
    end
end

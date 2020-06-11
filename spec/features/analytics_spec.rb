require 'rails_helper'

# Given a table, finds a td element with the identifier string in it
# Expects to find the target string somewhere in that row
def find_value_from_row(table, identifier, target)
    within(:css, table){
        td = page.find(:css, 'td', text: identifier)
        tr = td.find(:xpath, './parent::tr')
        expect(tr).to have_content(target)
    }
end

describe 'Viewing the number of activities per technician' do
    specify 'The table should contain the number of activities for each user. Users should only appear if they have activities', js: true do
        email1 = "dperry1@sheffield.ac.uk"
        display_name1 = "Dan Perry"
        u1 = FactoryBot.create(:user, email: email1, display_name: display_name1)
        email2 = "djwhiteman1@sheffield.ac.uk"
        display_name2 = "Dan Whiteman"
        u2 = FactoryBot.create(:user, email: email2, display_name: display_name2)
        email3 = "njridsdale1@sheffield.ac.uk"
        display_name3 = "Nicola Ridsdale"
        u3 = FactoryBot.create(:user, email: email3, display_name: display_name3)

        # Creating 2 activities for one user, and 1 for the other, 0 for the third
        t = FactoryBot.create(:theme, code: 'AMT')
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: 'semester', value: 'Both', display_name: 'Semester')
        u = FactoryBot.create(:uni_module, code: 'AMR124', user_id: u1.id, semester_id: sem_aut.id)
        a1 = FactoryBot.create(:activity, uni_module_id: u.id, theme_id: t.id)
        a2 = FactoryBot.create(:activity, uni_module_id: u.id, code: '112', theme_id: t.id)
        a3 = FactoryBot.create(:activity, uni_module_id: u.id, code: '113', theme_id: t.id)

        atech1 = FactoryBot.create(:activity_tech, activity_id: a1.id, tech_lead_id: u1.id)
        atech2 = FactoryBot.create(:activity_tech, activity_id: a2.id, tech_lead_id: u2.id)
        atech3 = FactoryBot.create(:activity_tech, activity_id: a3.id, tech_lead_id: u1.id)

        login_as u1, scope: :user
        visit '/analytics'
        tbl = 'table#acts-per-tech'
        click_link 'Activities per Technician'
        find_value_from_row(tbl, display_name1, "2")
        find_value_from_row(tbl, display_name2, "1")
        within(:css, tbl){
            expect(page).to_not have_content display_name3
        }
    end
end

describe 'Viewing Contact Hours/Activities per MEE lead' do
    specify 'The tables should contain the total duration/number of all activities which each MEE lead runs, the tables should only contains users who are MEE leads', js: true do
        email1 = "dperry1@sheffield.ac.uk"
        display_name1 = "Dan Perry"
        u1 = FactoryBot.create(:user, email: email1, display_name: display_name1)
        email2 = "djwhiteman1@sheffield.ac.uk"
        display_name2 = "Dan Whiteman"
        u2 = FactoryBot.create(:user, email: email2, display_name: display_name2)
        email3 = "njridsdale1@sheffield.ac.uk"
        display_name3 = "Nicola Ridsdale"
        u3 = FactoryBot.create(:user, email: email3, display_name: display_name3)

        # Creating 2 activities for one user, and 1 for the other, 0 for the third
        t = FactoryBot.create(:theme, code: 'AMT')
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: 'semester', value: 'Both', display_name: 'Semester')
        u = FactoryBot.create(:uni_module, code: 'AMR124', user_id: u1.id, semester_id: sem_aut.id)
        a1 = FactoryBot.create(:activity, uni_module_id: u.id, theme_id: t.id, user_id: u1.id)
        a2 = FactoryBot.create(:activity, uni_module_id: u.id, code: '112', theme_id: t.id, user_id: u1.id)
        a3 = FactoryBot.create(:activity, uni_module_id: u.id, code: '113', theme_id: t.id, user_id: u2.id)

        dur1 = 60
        dur2 = 120
        dur3 = 150
        u1_time = (dur1 + dur2) / 60
        u2_time = dur3 / 60

        atime1 = FactoryBot.create(:activity_timetable, activity_id: a1.id, duration: dur1)
        atime2 = FactoryBot.create(:activity_timetable, activity_id: a2.id, duration: dur2)
        atime3 = FactoryBot.create(:activity_timetable, activity_id: a3.id, duration: dur3)

        login_as u1, scope: :user
        visit '/analytics'
        tbl = 'table#hours-per-lead'
        click_link 'Contact Hours per MEE Lead'
        find_value_from_row(tbl, display_name1, u1_time)
        find_value_from_row(tbl, display_name2, u2_time)
        within(:css, tbl){
            expect(page).to_not have_content display_name3
        }

        tbl2 = 'table#acts-per-lead'
        visit '/analytics'
        click_link 'Activities per MEE Lead'
        find_value_from_row(tbl2, display_name1, "2")
        find_value_from_row(tbl2, display_name2, "1")
        within(:css, tbl2){
            expect(page).to_not have_content display_name3
        }
    end
end

describe 'Viewing Assessments and Activities for each MEE lead' do
    specify 'The table should list every activity-MEE lead pair', js: true do
        email1 = "dperry1@sheffield.ac.uk"
        display_name1 = "Dan Perry"
        u1 = FactoryBot.create(:user, email: email1, display_name: display_name1)
        email2 = "djwhiteman1@sheffield.ac.uk"
        display_name2 = "Dan Whiteman"
        u2 = FactoryBot.create(:user, email: email2, display_name: display_name2)
        email3 = "njridsdale1@sheffield.ac.uk"
        display_name3 = "Nicola Ridsdale"
        u3 = FactoryBot.create(:user, email: email3, display_name: display_name3)

        # User 1 has activity 1, user 2 has activity 2 and 3
        t = FactoryBot.create(:theme, code: 'AMT')
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: 'semester', value: 'Both', display_name: 'Semester')
        u = FactoryBot.create(:uni_module, code: 'AMR124', user_id: u1.id, semester_id: sem_aut.id)

        a1 = FactoryBot.create(:activity, uni_module_id: u.id, theme_id: t.id, user_id: u1.id)
        a2 = FactoryBot.create(:activity, uni_module_id: u.id, code: '112', theme_id: t.id, user_id: u2.id)
        a3 = FactoryBot.create(:activity, uni_module_id: u.id, code: '113', theme_id: t.id)

        login_as u1, scope: :user
        visit '/analytics'
        tbl = 'table#assess-per-lead'
        click_link 'Activities/Assessments for each MEE Lead'
        find_value_from_row(tbl, display_name1, a1.unique_id)
        find_value_from_row(tbl, display_name2, a2.unique_id)
        within(:css, tbl){
            expect(page).to_not have_content display_name3
            expect(page).to_not have_content a3.unique_id
        }
    end
end

describe 'Viewing contact hours per theme' do
    specify 'The table should break down contact hours by theme and semester', js: true do
        email1 = "dperry1@sheffield.ac.uk"
        display_name1 = "Dan Perry"
        u1 = FactoryBot.create(:user, email: email1, display_name: display_name1)

        # I have made 2 activities for each theme and semester
        t1 = FactoryBot.create(:theme, code: 'AMT')
        t2 = FactoryBot.create(:theme, code: 'ACME')
        t3 = FactoryBot.create(:theme, code: 'FNDY')
        # Semester drop down options
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: 'semester', value: 'Both', display_name: 'Semester')
        mod1 = FactoryBot.create(:uni_module, code: 'AMR124', user_id: u1.id, semester_id: sem_aut.id)
        mod2 = FactoryBot.create(:uni_module, code: 'AMR125', user_id: u1.id, semester_id: sem_spr.id)

        a1 = FactoryBot.create(:activity, uni_module_id: mod1.id, theme_id: t1.id, user_id: u1.id)
        a2 = FactoryBot.create(:activity, code: 112, uni_module_id: mod1.id, theme_id: t1.id, user_id: u1.id)
        a3 = FactoryBot.create(:activity, code: 113, uni_module_id: mod2.id, theme_id: t1.id, user_id: u1.id)
        a4 = FactoryBot.create(:activity, code: 114, uni_module_id: mod2.id, theme_id: t1.id, user_id: u1.id)
        a5 = FactoryBot.create(:activity, code: 115, uni_module_id: mod1.id, theme_id: t2.id, user_id: u1.id)
        a6 = FactoryBot.create(:activity, code: 116, uni_module_id: mod1.id, theme_id: t2.id, user_id: u1.id)
        a7 = FactoryBot.create(:activity, code: 117, uni_module_id: mod2.id, theme_id: t2.id, user_id: u1.id)
        a8 = FactoryBot.create(:activity, code: 118, uni_module_id: mod2.id, theme_id: t2.id, user_id: u1.id)

        # Durations for each ActivityTimetable
        dur1 = 60
        dur2 = 180
        dur3 = 120
        dur4 = 30
        dur5 = 120
        dur6 = 60
        dur7 = 45
        dur8 = 60

        atime1 = FactoryBot.create(:activity_timetable, activity_id: a1.id, duration: dur1)
        atime2 = FactoryBot.create(:activity_timetable, activity_id: a2.id, duration: dur2)
        atime3 = FactoryBot.create(:activity_timetable, activity_id: a3.id, duration: dur3)
        atime4 = FactoryBot.create(:activity_timetable, activity_id: a4.id, duration: dur4)
        atime5 = FactoryBot.create(:activity_timetable, activity_id: a5.id, duration: dur5)
        atime6 = FactoryBot.create(:activity_timetable, activity_id: a6.id, duration: dur6)
        atime7 = FactoryBot.create(:activity_timetable, activity_id: a7.id, duration: dur7)
        atime8 = FactoryBot.create(:activity_timetable, activity_id: a8.id, duration: dur8)

        # Sum of hours for each theme per semester
        t1m1 = (dur1 + dur2) / 60
        t1m2 = (dur3 + dur4) / 60
        t2m1 = (dur5 + dur6) / 60
        t2m2 = (dur7 + dur8) / 60

        login_as u1, scope: :user
        visit '/analytics'
        click_link 'Contact Hours per Theme (By semester)'

        within(:css, 'table#hours-per-theme'){
            page.all('td', text: t1.code).each do |td|
                # Get parent row of table cell
                tr = td.find(:xpath, './parent::tr')
                if tr.has_text? "Autumn"
                    expect(page).to have_content(t1m1)
                elsif tr.has_text? "Spring"
                    expect(page).to have_content(t1m2)
                else
                    # If the row has neither autumn, nor spring, fail the test by searching for gibberish
                    expect(page).to have_content "uirebveir"
                end
            end

            page.all('td', text: t2.code).each do |td|
                # Get parent row of table cell
                tr = td.find(:xpath, './parent::tr')
                if tr.has_text? "Autumn"
                    expect(page).to have_content(t2m1)
                elsif tr.has_text? "Spring"
                    expect(page).to have_content(t2m2)
                else
                    # If the row has neither autumn, nor spring, fail the test by searching for gibberish
                    expect(page).to have_content "uirebveir"
                end
            end
        }

    end
end

describe 'Viewing contact hours by degree programme' do
    specify 'The table should contain the sum of durations for each degree programme', js: true do
        email1 = "dperry1@sheffield.ac.uk"
        display_name1 = "Dan Perry"
        u1 = FactoryBot.create(:user, email: email1, display_name: display_name1)
        
        # Creating two programmes
        code1 = 'GEE'
        code2 = 'MEC'
        prog1 = FactoryBot.create(:programme, code: code1)
        prog2 = FactoryBot.create(:programme, code: code2)

        # Creating two activities for each programme, and one which has both degree programmes
        t = FactoryBot.create(:theme, code: 'AMT')
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: 'semester', value: 'Both', display_name: 'Semester')
        u = FactoryBot.create(:uni_module, code: 'AMR124', user_id: u1.id, semester_id: sem_aut.id)

        a1 = FactoryBot.create(:activity, theme_id: t.id, uni_module_id: u.id)
        a2 = FactoryBot.create(:activity, code: '112', theme_id: t.id, uni_module_id: u.id)
        a3 = FactoryBot.create(:activity, code: '113', theme_id: t.id, uni_module_id: u.id)
        a4 = FactoryBot.create(:activity, code: '114', theme_id: t.id, uni_module_id: u.id)
        a5 = FactoryBot.create(:activity, code: '115', theme_id: t.id, uni_module_id: u.id)

        dur1 = 60
        dur2 = 120
        dur3 = 180
        dur4 = 60
        dur5 = 150

        prog1time = (dur1 + dur2 + dur5) / 60
        prog2time = (dur3 + dur4 + dur5) / 60

        FactoryBot.create(:activity_timetable, activity_id: a1.id, duration: dur1)
        FactoryBot.create(:activity_timetable, activity_id: a2.id, duration: dur2)
        FactoryBot.create(:activity_timetable, activity_id: a3.id, duration: dur3)
        FactoryBot.create(:activity_timetable, activity_id: a4.id, duration: dur4)
        FactoryBot.create(:activity_timetable, activity_id: a5.id, duration: dur5)

        FactoryBot.create(:activity_programme, activity_id: a1.id, programme_id: prog1.id)
        FactoryBot.create(:activity_programme, activity_id: a2.id, programme_id: prog1.id)
        FactoryBot.create(:activity_programme, activity_id: a3.id, programme_id: prog2.id)
        FactoryBot.create(:activity_programme, activity_id: a4.id, programme_id: prog2.id)
        FactoryBot.create(:activity_programme, activity_id: a5.id, programme_id: prog1.id)
        FactoryBot.create(:activity_programme, activity_id: a5.id, programme_id: prog2.id)

        login_as u1, scope: :user
        visit '/analytics'
        click_link 'Sum of the Durations of Activities per Degree Programme (By Semester)'

        tbl = 'table#hours-per-programme'
        find_value_from_row(tbl, code1, prog1time)
        find_value_from_row(tbl, code2, prog2time)

    end
end

describe 'Viewing the setup time by theme and setup time by technician tables' do
    specify 'The table should contain the setup time for each theme / technician', js: true do
        # Creating users for technicians
        email1 = "dperry1@sheffield.ac.uk"
        display_name1 = "Dan Perry"
        u1 = FactoryBot.create(:user, email: email1, display_name: display_name1)
        email2 = "djwhiteman1@sheffield.ac.uk"
        display_name2 = "Dan Whiteman"
        u2 = FactoryBot.create(:user, email: email2, display_name: display_name2)
        email3 = "njridsdale1@sheffield.ac.uk"
        display_name3 = "Nicola Ridsdale"
        u3 = FactoryBot.create(:user, email: email3, display_name: display_name3)

        # Creating 2 themes
        t1 = FactoryBot.create(:theme, code: 'AMT')
        t2 = FactoryBot.create(:theme, code: 'ACME')

        # Creating 2 modules, one for each semester
        sem_aut = FactoryBot.create(:dropdown, drop_down: "semester", value: "Autumn", display_name: "Semester")
        sem_spr = FactoryBot.create(:dropdown, drop_down: "semester", value: "Spring", display_name: "Semester")
        sem_both = FactoryBot.create(:dropdown, drop_down: 'semester', value: 'Both', display_name: 'Semester')
        mod1 = FactoryBot.create(:uni_module, code: 'AMR124', user_id: u1.id, semester_id: sem_aut.id)
        mod2 = FactoryBot.create(:uni_module, code: 'AMR125', user_id: u1.id, semester_id: sem_spr.id)

        # Creating 2 activities for each theme and each semester
        a1 = FactoryBot.create(:activity, uni_module_id: mod1.id, theme_id: t1.id, user_id: u1.id)
        a2 = FactoryBot.create(:activity, code: '112', uni_module_id: mod1.id, theme_id: t1.id, user_id: u1.id)
        a3 = FactoryBot.create(:activity, code: '113', uni_module_id: mod2.id, theme_id: t1.id, user_id: u1.id)
        a4 = FactoryBot.create(:activity, code: '114', uni_module_id: mod2.id, theme_id: t1.id, user_id: u1.id)
        a5 = FactoryBot.create(:activity, code: '115', uni_module_id: mod1.id, theme_id: t2.id, user_id: u1.id)
        a6 = FactoryBot.create(:activity, code: '116', uni_module_id: mod1.id, theme_id: t2.id, user_id: u1.id)
        a7 = FactoryBot.create(:activity, code: '117', uni_module_id: mod2.id, theme_id: t2.id, user_id: u1.id)
        a8 = FactoryBot.create(:activity, code: '118', uni_module_id: mod2.id, theme_id: t2.id, user_id: u1.id)

        setup1 = 10
        ser_setup1 = 10
        setup2 = 20
        ser_setup2 = 15
        setup3 = 30
        ser_setup3 = 10
        setup4 = 30
        ser_setup4 = 45
        setup5 = 10
        ser_setup5 = 10
        setup6 = 10
        ser_setup6 = 5
        setup7 = 5
        ser_setup7 = 10
        setup8 = 25
        ser_setup8 = 5

        # Sums for each theme/module combo
        t1m1 = (setup1 + ser_setup1 + setup2 + ser_setup2) / 60
        t1m2 = (setup3 + ser_setup3 + setup4 + ser_setup4) / 60
        t2m1 = (setup5 + ser_setup5 + setup6 + ser_setup6) / 60
        t2m2 = (setup7 + ser_setup7 + setup8 + ser_setup8) / 60

        FactoryBot.create(:activity_timetable, activity_id: a1.id, setup_time: setup1, series_setup_time: ser_setup1)
        FactoryBot.create(:activity_timetable, activity_id: a2.id, setup_time: setup2, series_setup_time: ser_setup2)
        FactoryBot.create(:activity_timetable, activity_id: a3.id, setup_time: setup3, series_setup_time: ser_setup3)
        FactoryBot.create(:activity_timetable, activity_id: a4.id, setup_time: setup4, series_setup_time: ser_setup4)
        FactoryBot.create(:activity_timetable, activity_id: a5.id, setup_time: setup5, series_setup_time: ser_setup5)
        FactoryBot.create(:activity_timetable, activity_id: a6.id, setup_time: setup6, series_setup_time: ser_setup6)
        FactoryBot.create(:activity_timetable, activity_id: a7.id, setup_time: setup7, series_setup_time: ser_setup7)
        FactoryBot.create(:activity_timetable, activity_id: a8.id, setup_time: setup8, series_setup_time: ser_setup8)

        # User1 gets first 4 activities, user2 gets other 4
        FactoryBot.create(:activity_tech, activity_id: a1.id, tech_lead_id: u1.id)
        FactoryBot.create(:activity_tech, activity_id: a2.id, tech_lead_id: u1.id)
        FactoryBot.create(:activity_tech, activity_id: a3.id, tech_lead_id: u1.id)
        FactoryBot.create(:activity_tech, activity_id: a4.id, tech_lead_id: u1.id)
        FactoryBot.create(:activity_tech, activity_id: a5.id, tech_lead_id: u2.id)
        FactoryBot.create(:activity_tech, activity_id: a6.id, tech_lead_id: u2.id)
        FactoryBot.create(:activity_tech, activity_id: a7.id, tech_lead_id: u2.id)
        FactoryBot.create(:activity_tech, activity_id: a8.id, tech_lead_id: u2.id)

        # Sums for each technical lead
        user1time = t1m1 + t1m2
        user2time = t2m1 + t2m2

        login_as u1, scope: :user
        visit '/analytics'

        tbl1 = 'table#setup-per-theme'
        tbl2 = 'table#setup-per-tech'

        click_link 'Total Setup Time per Theme (By Semester).'
        within(:css, tbl1){
            page.all('td', text: t1.code).each do |td|
                # Get parent row of table cell
                tr = td.find(:xpath, './parent::tr')
                if tr.has_text? "Autumn"
                    expect(tr).to have_content(t1m1)
                elsif tr.has_text? "Spring"
                    expect(tr).to have_content(t1m2)
                else
                    # If the row has neither autumn, nor spring, fail the test by searching for gibberish
                    expect(page).to have_content "uirebveir"
                end
            end

            page.all('td', text: t2.code).each do |td|
                # Get parent row of table cell
                tr = td.find(:xpath, './parent::tr')
                if tr.has_text? "Autumn"
                    expect(tr).to have_content(t2m1)
                elsif tr.has_text? "Spring"
                    expect(tr).to have_content(t2m2)
                else
                    # If the row has neither autumn, nor spring, fail the test by searching for gibberish
                    expect(page).to have_content "uirebveir"
                end
            end
        }

        visit '/analytics'
        click_link 'Total Setup Time per Technician (By Semester).'
        find_value_from_row(tbl2, display_name1, user1time)
        find_value_from_row(tbl2, display_name2, user2time)
        within(:css, tbl2){
            expect(page).to_not have_content(display_name3)
        }
    end
end

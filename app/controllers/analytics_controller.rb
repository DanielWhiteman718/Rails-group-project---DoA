class AnalyticsController < ApplicationController
    
    def index
    end

    def view
        @techStats = getTechnicianStatsActivities
        render layout: false
    end

    def view2
        @MEELeadContactHours = getMEELeadContactHours
        render layout: false
    end

    def view3
        @MEELeadActivitiesCount = getMEELeadActivitiesCount
        render layout: false
    end

    def view4
        @MEELeadActivities = getMEELeadActivities
        render layout: false
    end

    def view5
        @HoursPerThemeA, @HoursPerThemeS = getStudentHoursTheme
        render layout: false
    end

    def view6
        @HoursPerCohort = getActivitiesCohortSemester
        render layout: false
    end

    def view7
        @SetupTimeThemeA, @SetupTimeThemeS = getSetupTimeTheme
        render layout: false
    end

    def view8
        @SetupTimeTechnicianA, @SetupTimeTechnicianS = getSetupTimeTechnician
        render layout: false
    end

    #Number Activities per technician
    def getTechnicianStatsActivities
        #Getting all the tech leads and understudies for each activity
        actTechs = ActivityTech.all.pluck(:tech_lead_id)
        actTechsU = ActivityTech.all.pluck(:tech_ustudy_id)
        
        #putting them in the same set
        actTechs = actTechs + actTechsU 

        userIDs = User.all.pluck(:id)
        
        userCount = []
        userIDs.each do |id|

            #Only add it to the final result if the number of activities > 0
            if actTechs.count(id) != 0 then
                username = User.find(id).display_name
                #get the number of activities by counting the number of occurences of the id
                userCount.push([username, actTechs.count(id)])
            end

        end
        
        return userCount
    end


    #Number of contact hours per MEE Lead
    def getMEELeadContactHours
        users = User.all.pluck(:id)

        contactHours = []
        users.each do |id|
            #get all activities where the user is the mee lead
            acts = Activity.where(user_id: id)
                        
            hours = 0
            #get the list of contact hours from the activites
            tt = ActivityTimetable.where(activity_id: (acts.pluck(:id))).pluck(:duration)
            
            #add the hours up
            tt.each do |act|
                unless act.nil?
                    hours = hours + (act / 60.0)  
                end
            end

            #only add the hours to the final result if the hours > 0
            if hours != 0 then
                username = User.find(id).display_name
                contactHours.push([username, hours])
            end
        end
        return contactHours
    end

    #Number of Activities per MEE Lead
    def getMEELeadActivitiesCount
        users = User.all.pluck(:id)

        activities = []
        users.each do |id|
            #get the activities where the user is the mee lead
            acts = Activity.where(user_id: id)

            #only add the result if number of activites > 0
            if acts.length != 0
                username = User.find(id).display_name
                
                #get number by doing.length on the list
                activities.push([username, acts.length])
            end
        end
        return activities
    end
    
    #Set of activities relating to each user
    def getMEELeadActivities
        users = User.all.pluck(:id)
        activities = []
        users.each do |id|
            username = User.find(id).display_name
            #create list of [[user, [their activities...]]...]
            activities.push([username, Activity.where(user_id: id)])                    
        end
        return activities 
    end

    #Number of student hours per theme by semester
    def getStudentHoursTheme
        themes = Theme.all.pluck(:id)
        #get modules for autumn, spring and both
        sem_aut = Dropdown.where(drop_down: 'semester', value: 'Autumn').first
        sem_spr = Dropdown.where(drop_down: 'semester', value: 'Spring').first
        sem_both = Dropdown.where(drop_down: 'semester', value: 'Both').first
        
        autumnModules = UniModule.where(semester_id: sem_aut.id).pluck(:id)
        springModules = UniModule.where(semester_id: sem_spr.id).pluck(:id)
        bothModules = UniModule.where(semester_id: sem_both.id).pluck(:id)
        
        hoursAutumn = []
        hoursSpring = []
        themes.each do |theme|

            #Get durations of activites that belong to modules in both semesters
            activitiesB = Activity.where(theme_id: theme, uni_module_id: bothModules).pluck(:id)
            activities_ttB = ActivityTimetable.where(activity_id: activitiesB).pluck(:duration)
            
            #add the durations to the totals for autumn and spring
            sumA = 0
            sumS = 0
            activities_ttB.each do |time|
                unless time.nil?
                    sumA = sumA + (time/60.0)
                    sumS = sumS + (time/60.0)
                end
            end

            #Get durations of activites that belong to modules in autumn semester
            activitiesA = Activity.where(theme_id: theme, uni_module_id: autumnModules).pluck(:id)
            activities_ttA = ActivityTimetable.where(activity_id: activitiesA).pluck(:duration)
            
            #add the durations to the totals for autumn
            activities_ttA.each do |time|
                sumA = sumA + (time/60.0)
            end

            #pushing the result to the autumn hours array
            themeCode = Theme.find(theme).code
            hoursAutumn.push([themeCode, sumA])
            
            #Get durations of activites that belong to modules in Spring semester
            activitiesS = Activity.where(theme_id: theme, uni_module_id: springModules).pluck(:id)
            activities_ttS = ActivityTimetable.where(activity_id: activitiesS).pluck(:duration)
            
            #add the durations to the totals for spring
            activities_ttS.each do |time|
                sumS = sumS + (time/60.0)
            end

            #pushing result to the spring hours array
            hoursSpring.push([themeCode, sumS])
            

        end
        return hoursAutumn, hoursSpring
    end

    #Number of activities per degree(cohort) by semester semester
    def getActivitiesCohortSemester
        degreeProgs = Programme.all.pluck(:id)
        
        acts = []
        degreeProgs.each do |prgm|
            
            #Get the durations of activities that belong to the current programme
            actProgs = ActivityProgramme.where(programme_id: prgm).pluck(:activity_id)
            actstt = ActivityTimetable.where(activity_id: actProgs).pluck(:duration)
            
            #Add all durations to the sum
            sum = 0
            actstt.each do |time|
                unless time.nil?
                    sum = sum + (time/60.0)
                end
            end
            
            #push the result
            progName = Programme.find(prgm).code
            acts.push([progName, sum])   

        end
        return acts
    end

    #Total setup time per theme (by semester)
    def getSetupTimeTheme
        theme = Theme.all.pluck(:id)
        #get modules for autumn, spring and both
        sem_aut = Dropdown.where(drop_down: 'semester', value: 'Autumn').first
        sem_spr = Dropdown.where(drop_down: 'semester', value: 'Spring').first
        sem_both = Dropdown.where(drop_down: 'semester', value: 'Both').first

        autumnModules = UniModule.where(semester_id: sem_aut.id).pluck(:id)
        springModules = UniModule.where(semester_id: sem_spr.id).pluck(:id)
        bothModules = UniModule.where(semester_id: sem_both.id).pluck(:id)


        setupTimeAutumn = []
        setupTimeSpring = []
        theme.each do |theme|

            #Get durations of activites that belong to modules in both semesters
            activitiesB = Activity.where(theme_id: theme, uni_module_id: bothModules).pluck(:id)
            activities_ttB = ActivityTimetable.where(activity_id: activitiesB).pluck(:series_setup_time)

            #add the durations to the totals for autumn and spring
            sumA = 0
            sumS = 0
            activities_ttB.each do |time|
                unless time.nil?
                    sumA = sumA + (time/60.0)
                    sumS = sumS + (time/60.0)
                end
            end

            #get the setup time
            activities_ttB = ActivityTimetable.where(activity_id: activitiesB).pluck(:setup_time)
            
            #add the durations to the totals for autumn and spring
            activities_ttB.each do |time|
                unless time.nil?
                    sumA = sumA + (time/60.0)
                    sumS = sumS + (time/60.0)
                end 
            end


            #Get durations of activites that belong to modules in autumn semesters
            activitiesA = Activity.where(theme_id: theme, uni_module_id: autumnModules).pluck(:id)
            activities_ttA = ActivityTimetable.where(activity_id: activitiesA).pluck(:series_setup_time)
            
            #add the durations to the totals for autumn
            activities_ttA.each do |time|
                unless time.nil?    
                    sumA = sumA + (time/60.0)
                end
            end

            #get the setup time
            activities_ttA = ActivityTimetable.where(activity_id: activitiesA).pluck(:setup_time)
            
            #add the durations to the totals for autumn
            activities_ttA.each do |time|
                unless time.nil?
                    sumA = sumA + (time/60.0)
                end
            end
            themeCode = Theme.find(theme).code

            setupTimeAutumn.push([themeCode, sumA])
            

            #Get durations of activites that belong to modules in spring semesters
            activitiesS = Activity.where(theme_id: theme, uni_module_id: springModules).pluck(:id)
            activities_ttS = ActivityTimetable.where(activity_id: activitiesS).pluck(:series_setup_time)
            
            #add the durations to the totals for spring
            activities_ttS.each do |time|
                unless time.nil?
                    sumS = sumS + (time/60.0)#
                end
            end

            #get the setup time
            activities_ttS = ActivityTimetable.where(activity_id: activitiesS).pluck(:setup_time)
            
            #add the durations to the totals for spring
            activities_ttS.each do |time|
                unless time.nil?
                    sumS = sumS + (time/60.0)
                end
            end
            
            setupTimeSpring.push([themeCode, sumS])
        end
        return setupTimeAutumn, setupTimeSpring
    end

    #Total setup time per technician (by semester)
    def getSetupTimeTechnician
        technicians = User.all.pluck(:id)
        #get modules for autumn, spring and both
        sem_aut = Dropdown.where(drop_down: 'semester', value: 'Autumn').first
        sem_spr = Dropdown.where(drop_down: 'semester', value: 'Spring').first
        sem_both = Dropdown.where(drop_down: 'semester', value: 'Both').first
        
        autumnModules = UniModule.where(semester_id: sem_aut.id).pluck(:id)
        springModules = UniModule.where(semester_id: sem_spr.id).pluck(:id)
        bothModules = UniModule.where(semester_id: sem_both.id).pluck(:id)

        setupTimeAutumn = []
        setupTimeSpring = []

        technicians.each do |tech|
            actTech = ActivityTech.where(tech_lead_id: tech).pluck(:activity_id)
            actTechU = ActivityTech.where(tech_ustudy_id: tech).pluck(:activity_id)
            actTech = actTech + actTechU

            #Get durations of activites that belong to modules in both semesters
            activitiesB = Activity.where(id: actTech, uni_module_id: bothModules).pluck(:id)
            activities_ttB = ActivityTimetable.where(activity_id: activitiesB).pluck(:series_setup_time)
            
            #add the durations to the totals for autumn and spring
            sumA = 0
            sumS = 0
            activities_ttB.each do |time|
                unless time.nil?
                    sumA = sumA + (time/60.0)
                    sumS = sumS + (time/60.0)
                end
            end

            #get the setup time
            activities_ttB = ActivityTimetable.where(activity_id: activitiesB).pluck(:setup_time)
            
            #add the durations to the totals for autumn and spring
            activities_ttB.each do |time|
                unless time.nil?
                    sumA = sumA + (time/60.0)
                    sumS = sumS + (time/60.0)
                end 
            end




            #Get durations of activites that belong to modules in autumn semesters
            activitiesA = Activity.where(id: actTech, uni_module_id: autumnModules).pluck(:id)
            activities_ttA = ActivityTimetable.where(activity_id: activitiesA).pluck(:series_setup_time)
            
            #add the durations to the totals for autumn
            activities_ttA.each do |time|
                unless time.nil?
                    sumA = sumA + (time/60.0)
                end
            end

            #get the setup time
            activities_ttA = ActivityTimetable.where(activity_id: activitiesA).pluck(:setup_time)
            
            #add the durations to the totals for autumn
            activities_ttA.each do |time|
                unless time.nil?
                    sumA = sumA + (time/60.0)
                end 
            end

            techName = User.find(tech).display_name
            if sumA != 0 then
                setupTimeAutumn.push([techName, sumA])
            end


            #Get durations of activites that belong to modules in spring semesters
            activitiesS = Activity.where(id: actTech, uni_module_id: springModules).pluck(:id)
            activities_ttS = ActivityTimetable.where(activity_id: activitiesS).pluck(:series_setup_time)
            
            #add the durations to the totals for spring
            activities_ttS.each do |time|
                unless time.nil?
                    sumS = sumS + (time/60.0)
                end
            end

            #get the setup time
            activities_ttS = ActivityTimetable.where(activity_id: activitiesS).pluck(:setup_time)
            
            #add the durations to the totals for spring
            activities_ttS.each do |time|
                unless time.nil?
                    sumS = sumS + (time/60.0)
                end
            end
            
            if sumS != 0 then
                setupTimeSpring.push([techName, sumS])
            end



        end
        return setupTimeAutumn, setupTimeSpring
    end

end
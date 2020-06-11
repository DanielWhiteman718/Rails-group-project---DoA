namespace :change_roles do

  desc "Makes the user with the given id an admin"
  task :make_admin, [:user_id] => :environment do |t, args|
    u = User.find(args[:user_id])
    u.role = User.admin_id
    u.save!
    puts "Role change complete"
  end

  desc "Makes the user with the given id a technician"
  task :make_tech, [:user_id] => :environment do |t, args|
    u = User.find(args[:user_id])
    u.role = User.tech_id
    u.save!
    puts "Role change complete"
  end

  desc "Makes the user with the given id an academic"
  task :make_acad, [:user_id] => :environment do |t, args|
    u = User.find(args[:user_id])
    u.role = User.acad_id
    u.save!
    puts "Role change complete"
  end

  desc "Sets the role of the user with the given id to the role with the given id"
  task :set_role, [:user_id, :role_id] => :environment do |t, args|
    u = User.find(args[:user_id])
    u.role = args[:role_id]
    u.save!
    puts "Role change complete"
  end

  desc "Gives/Removes the analyst role to the user with the given id"
  task :set_analyst, [:user_id, :analyst] => :environment do |t, args|
    u = User.find(args[:user_id])
    if args[:analyst] == '0'
      u.analyst = false
    elsif args[:analyst] == '1'
      u.analyst = True
    end
    u.save!
    puts "Role change complete"
  end

  desc "Gives/removes the super user role to the user with the given id"
  task :set_su, [:user_id, :su] => :environment do |t, args|
    u = User.find(args[:user_id])
    if args[:su] == '0'
      u.super_user = false
    elsif args[:su] == '1'
      u.super_user = true
    end
    u.save!
    puts "Role change complete"
  end

end

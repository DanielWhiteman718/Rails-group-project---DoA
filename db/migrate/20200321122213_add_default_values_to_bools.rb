class AddDefaultValuesToBools < ActiveRecord::Migration[6.0]
  def change
    change_column_default :activities, :archived, false
    change_column_default :activities, :in_drive, false
    change_column_default :users, :analyst, false
    change_column_default :users, :super_user, false
    # add_column :user_invites, :super_user, :boolean, :null => false, :default => false
    change_column_default :room_bookings, :preferred, false
    change_column_default :activity_timetables, :same_as_prev_year, false
    change_column_default :activity_timetables, :checked_on_timetable, false
  end
end

class CreateActivityTimetables < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_timetables do |t|
      t.belongs_to :activity, :null => false, :unique => true
      t.boolean :same_as_prev_year, :null => false
      t.boolean :checked_on_timetable, :null => false
      t.integer :min_week_num
      t.integer :max_week_num
      t.integer :duration
      t.integer :setup_time
      t.integer :takedown_time
      t.integer :series_setup_time
      t.integer :kit_prep_time
      t.text :notes

      t.timestamps
    end
  end
end

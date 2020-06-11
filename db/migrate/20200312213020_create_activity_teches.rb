class CreateActivityTeches < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_teches do |t|
      t.belongs_to :activity, :null => false, :unique => true
      # Technical Lead
      t.references :tech_lead
      # Technical Understudy
      t.references :tech_ustudy
      t.date :last_risk_assess
      t.date :next_risk_assess
      t.text :equip_needed
      t.float :cost_per_student
      
      t.timestamps
    end
  end
end

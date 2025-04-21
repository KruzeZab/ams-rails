class CreateActivityLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_logs do |t|
      t.integer :user_id
      t.string :action
      t.string :record_type
      t.integer :record_id
      t.jsonb :change_log

      t.timestamps
    end
  end
end

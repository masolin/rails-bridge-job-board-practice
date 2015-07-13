class CreateJobTags < ActiveRecord::Migration
  def change
    create_table :job_tags do |t|
      t.belongs_to :job, index: true, foreign_key: true
      t.belongs_to :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

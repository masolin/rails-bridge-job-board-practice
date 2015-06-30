class AddPhoneAndEmailToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :phone, :string
    add_column :jobs, :email, :string
  end
end

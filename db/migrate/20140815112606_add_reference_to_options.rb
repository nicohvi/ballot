class AddReferenceToOptions < ActiveRecord::Migration
 def change
    change_table :options do |t|
      t.references :poll, index: true 
    end
  end
  def down
    change_table :options do |t|
      t.remove :poll_id
    end
  end
end

class CreateDiabetics < ActiveRecord::Migration
  def change
    create_table :diabetics do |t|
      t.float :pregnant
      t.float :oral_glucose_tolerance
      t.float :blood_pressure
      t.float :skin_fold_thickness
      t.float :serum_insulin
      t.float :body_mass_index
      t.float :pedigree_function
      t.float :age
      t.integer :positive

      t.timestamps
    end
  end
end

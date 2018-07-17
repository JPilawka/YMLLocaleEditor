class CreateLocales < ActiveRecord::Migration[5.2]
  def change
    create_table :locales do |t|

      t.string :key
      t.string :value
      t.string :parent
      t.string :parent_key
    end
  end
end

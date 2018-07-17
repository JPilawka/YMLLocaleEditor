class CreateLocales < ActiveRecord::Migration[5.2]
  def change
    create_table :locales do |t|
      t.integer :locale_id
      t.string :locale_key
      t.string :locale_value
      t.string :locale_parent
    end
  end
end

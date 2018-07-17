class Locale < ApplicationRecord
  attr_accessor :locale_id, :locale_key, :locale_value, :locale_parent, :locale_parent_key

  def initialize(attributes={})
    super

  end

  def conDB
    db = ActiveRecord::Base.connection.raw_connection
    db.exec("DROP TABLE IF EXISTS locales")
    db.exec("
        CREATE TABLE locales (
          locale_id SERIAL PRIMARY KEY,
          locale_key VARCHAR(128) NOT NULL,
          locale_value VARCHAR (1024),
          locale_parent VARCHAR (128),
          locale_parent_key VARCHAR (128)
          )"
      )
  end

  def all
    db = ActiveRecord::Base.connection.raw_connection
    result = db.exec("SELECT * FROM locales WHERE locale_value != ''")
    result
  end

  def insertLocale(key, value, parent, parent_key)
    db = ActiveRecord::Base.connection.raw_connection
    db.exec("
      INSERT INTO locales (locale_key, locale_value, locale_parent, locale_parent_key) VALUES ('#{key}', '#{value}', '#{parent}', '#{parent_key}')")
  end

  def dropTable
    db = ActiveRecord::Base.connection.raw_connection
    db.exec("DROP TABLE locales")
  end

  def selectLastId #Function for selection of parent's id
    db = ActiveRecord::Base.connection.raw_connection
    result = db.exec("SELECT locale_id FROM locales ORDER BY locale_id DESC LIMIT 1")
    result = result.first.values[0]
  end

  def searchResults(phrase)
    db = ActiveRecord::Base.connection.raw_connection
    result = db.exec("SELECT * FROM locales
      WHERE
      locale_key LIKE '%#{phrase}%' AND locale_value != ''
      OR
      locale_value LIKE '%#{phrase}%' AND locale_value != ''")
    result
  end

  def updateDB(db,locale_id, locale_value)
    result=db.exec("UPDATE locales SET locale_value='#{locale_value}' WHERE locale_id='#{locale_id}' RETURNING locale_id, locale_value")
    result
  end

end

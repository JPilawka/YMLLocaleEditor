class Locale < ApplicationRecord
  #attr_accessor :id, :key, :value, :parent, :parent_key

  self.primary_key = 'id'

  # def initialize(attributes={})
  #   super

  # end

  def conDB
    db = ActiveRecord::Base.connection.raw_connection
    db.exec("TRUNCATE locales RESTART IDENTITY")
  end

  def ShowAll
    result = Locale.where("value != ''")
    result
  end

  def insertLocale(key, value, parent, parent_key)
    Locale.create(key: key, value: value, parent: parent, parent_key: parent_key)
  end

  def dropTable
    db = ActiveRecord::Base.connection.raw_connection
    db.exec("DROP TABLE locales")
  end

  def selectLastId #Function for selection of parent's id

    result = Locale.order("id DESC").first
    result['id']
  end

  def searchResults(phrase)
    Locale.where("key LIKE ? AND value!='' OR value LIKE ? AND value!=''","%#{phrase}%","%#{phrase}%")
  end

  def fileName
    result = Locale.where("id='1'").first
    result['key']
  end
 
  def searchForChildren(id)
    result = Locale.where("parent='#{id}'")
    result
  end

  def updateDB(id, value)
    result = Locale.find_by(id: id)
    result
  end

end

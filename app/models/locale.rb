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

  def ShowAll(page)
    result = Locale.where("value != ''")
    #result.paginate(:page =>page, :per_page => 10)
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

  def searchResults(phrase, page)
    result = Locale.where("key LIKE ? AND value!='' OR value LIKE ? AND value!=''","%#{phrase}%","%#{phrase}%")
    result.paginate(:page =>page, :per_page => 10)
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

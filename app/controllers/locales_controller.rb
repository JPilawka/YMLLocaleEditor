class LocalesController < ApplicationController
  def index
    config = "#{Rails.root}/config/locales/"
    files = Dir["#{config}*.yml"]
    @files = files.map{|n| n.split("/").last}
  end

  def show
    #tutaj wyświetlamy wszystkie info z otrzymanego pliku.
    @file = params[:locale_file]
    @search_phrase=""

    @db = Locale.new
    if(params[:search_phrase]!=nil) #Returning results of search form
      #render plain: params[:search_phrase].inspect
      @search_phrase=params[:search_phrase]
      @file_lines = @db.searchResults(params[:search_phrase])
    else
      @db.conDB
      #keyValueArr = Array.new
      f=Psych.load_file("config/locales/#{@file}") #opening file to read
      g=f.first
      gg = g.first
      g=g[1]
      parent_key = gg
      @db.insertLocale(gg,'','','')
      #arra = Array.new #tabela tymczasowa
      parent = @db.selectLastId
      g.each do |key, value|
        isHash(key, value, parent, parent_key)
      end

      @file_lines = @db.ShowAll
    end

  end

  def isHash(key, value, parent, parent_key)
    if(value.class==Hash)
      @db.insertLocale(key, nil, parent, parent_key)
      parent_key = key
      parent = @db.selectLastId
      value.each do |key1, value1|
        isHash(key1, value1, parent, parent_key)
      end

    else
      if(value.class==String)
        @db.insertLocale(key, value.strip.gsub(/\s+/, " "), parent, parent_key)
      else
        @db.insertLocale(key, value, parent, parent_key)
      end
    end

  end

  def create
    #Creating backup file from original (zmienić nazwę na nazwa-data.backupyml)
    file = Locale.new
    file = file.fileName
    #renaming file to prepare backup.
    File.rename("#{Rails.root}/config/locales/" + file+'.yml', "#{Rails.root}/config/locales/" + file+'-'+Time.now.to_s+'.backupyml')
    #Saving to database
    @h = Hash.new{|hsh,key| hsh[key] = []}
 
    params[:lines].each do |param|

      @h[param[:id]] = {'key' => param[:key]}
      @h[param[:id]].merge!({ 'value'=> param[:value]})

      Locale.update(param[:id], value: param[:value])
    end
    #saving to YML file from database.

    overallHash = findChildTemp(1)
    overallHash = {file=>overallHash}
    #puts @overallHash
    #Writing to file
    File.open("#{Rails.root}/config/locales/" + file+'.yml', 'w') do |file|
      file.write(Psych.dump(overallHash))
    end
    @file = file+'.yml'

  end

  def findChildTemp(id)
    db=Locale.new
    key = Locale.find(id)['key']

    children = findChildren(id)

    allChildrenHash = Hash.new{|hsh,key| hsh[key] = []}
    grandchildrenHash = Hash.new{|hsh,key| hsh[key] = []}
    children.each do |child|
      #<--------
      if(child['value']!=nil)
        grandchildrenHash.merge!(child['key']=>child['value'])
      else
        grandchildren = findChildTemp(child['id'])
        grandchildrenHash.merge!(child['key']=>grandchildren)
      end

      allChildrenHash.merge!(grandchildrenHash)

    end
    allChildrenHash

  end


  def findChildren(id)
    db=Locale.new
    children = db.searchForChildren(id)
    children
  end

end

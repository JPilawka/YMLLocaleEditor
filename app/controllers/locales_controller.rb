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
    if(params[:search_phrase]!=nil)
      #render plain: params[:search_phrase].inspect
      @search_phrase=params[:search_phrase]
      @file_lines = @db.searchResults(params[:search_phrase])
    else
      @db.conDB
      keyValueArr = Array.new
      f=Psych.load_file("config/locales/#{@file}")
      g=f.first
      gg = g.first
      g=g[1]
      parent_key = gg
      @db.insertLocale(gg,'','','')
      arra = Array.new #tabela tymczasowa
      parent = @db.selectLastId
      g.each do |key, value|
        isHash(key, value, parent, parent_key)
      end

      @file_lines = @db.all
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
        @db.insertLocale(key, value.gsub("'","&#39;"), parent, parent_key)
      else
        @db.insertLocale(key, value, parent, parent_key)
      end
    end

  end

  def create

    @h = Hash.new{|hsh,key| hsh[key] = []}
    params[:lines].each do |param|
      #h.push(param[:locale_id], (param[:locale_key], param[:locale_value], param[:locale_parent]))
      #locale=Locale.find_by(locale_id: param[:locale_id])
      #locale.update(locale_value: param[:locale_value])
      #lh = Hash.new{|hsh,key| hsh[key] = []}
      #lh[param[:locale_id]] = {'locale_key' => param[:locale_key]}
      #lh[param[:locale_id]].merge!({ 'locale_value'=> param[:locale_value]})
      @h[param[:locale_id]] = {'locale_key' => param[:locale_key]}
      @h[param[:locale_id]].merge!({ 'locale_value'=> param[:locale_value]})

      @locale = Locale.find(param[:locale_id])
      @locale.valid?
      @locale.persisted?
      @locale.update(locale_id: param[:locale_id])


    end
    #render plain: h.inspect
    #zapis do pliku odosobnionego: test-nazwa pliku
  end

end

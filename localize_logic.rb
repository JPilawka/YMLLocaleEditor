require 'Psycho'

files = Dir["config/locales/*.yml"]
files.each

index_number=0;
def allKeys()
  keyValueArr = Array.new
  f=Psych.load_file("config/locales/en-EN.yml")
  g=f.first
  g=g[1]
  x=0
  arra = Array.new #tabela tymczasowa
  g.each do |key, value|
    keyValueArr.push([key, value]) #tabela wszystkich kluczy
    arra.push([key, value])
    if (value.class == Hash)
      value.each do |key, value|
        keyValueArr.push([key, value])
      end
    end
    #value jest teraz hashem z dodatkowymi parami key => value
    #potrzeba uzyskać dostęp do każdego poziomu i każdej wartości key=>value
    #każdy key należ powiązać z linią lub przyporządkować mu pewień unikatowy index, potem wprowadzić pod tym indexem do tymczasowej bazy
    #i ostatecznie zbudować z tego plik pamiętając o tym, że zawiera on na początku pewne wartości jak ---- oraz idetyfikatyor języka (on również powinien posiadać unikatowy index)
    x=+1
  end
  puts keyValueArr.count

  keyValueArr.each{|y| puts y[0], "-----------------------------------------------------"}
  return nil
end #class end
allKeys


<%if(line[3]=="")
    number_of_px = 0;
  end
  if(line[3]!="")
    if(line[3]==@previous_node)
      number_of_px += 20
    end
  end
@previous_node = line[1]%>
<!-- dla mniejszych wpisów zrobić input - text, jeśli przekraczają jakąś długość to zrobić textarea -->
<div class="value" style="display: inline-block; margin-left: <%=number_of_px%>px;">
  <%=line[1]%>
</div>


<form action="/locales/find" method="get">
  <input type="hidden" value="<%=@file%>" name='locale_file'>
  <input style="width: 400px" type="text" name="search_phrase" placeholder="Put needed key or value phrase or partial in <%=@file%>">
  <input type="submit" value="SEARCH">
</form>

<%= form_for(:locale), :method => :get do |f|%>
<%= f.hidden_field(:locale_field, :value=>"#{@file}")%>
<%= f.search_field(:search_phrase, size: "100px", placeholder: "Put needed key or value phrase or partial in #{@file}")%>
<%= f.submit "SEARCH"%>
<%end%>


<%@file_ouput.each do |line|%>
  <p>
    <%= line['locale_id']%>
    <%= line['locale_key']%>
    <%= line['locale_value']%>
    <%= line['locale_parent']%>
  </p>--->







  def findChildTemp(id)
    db=Locale.new
    key = Locale.find(id)['key']
    puts "id: "+id.to_s+" => key: "+key

    children = findChildren(id)

    allChildrenHash = Hash.new{|hsh,key| hsh[key] = []}
    grandchildrenHash = Hash.new{|hsh,key| hsh[key] = []}
    children.each do |child|
      #<--------
        grandchildren = findChildren(child['id']) #znajdujemy wszystkie wnuki
        #tworzymy Hash zawierający wszystki wnuki danego dziecka
        grandgrandchildrenHash = Hash.new{|hsh,key| hsh[key] = []}
        grandchildren.each do |grand|
          grandgrandchildrenHash.merge!(grand['key']=>grand['value'])
        end
        #------> dotąd na pewno możemy zastąpić samą sobą
        grandchildrenHash.merge!(child['key'].to_s=>grandgrandchildrenHash)
        #dla każdego granchilden zrobić hash klucz => wartość
      allChildrenHash.merge!(key=>grandchildrenHash)
    end

    allChildrenHash
  end

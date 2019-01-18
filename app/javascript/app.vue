<template>
  <div id="app">
    <div class="navbar sticky-top navbarstyle">

    <h2>
      <div class="btn btn-primary" @click="linkTo()"> <= Back To Filelist</div>
      You're editing file: {{file}}
    </h2>
    <form action="/locales/find" method="get">
      <!--<input type="hidden" v-bind="file" name='locale_file'>-->

      <input type="hidden" name='locale_file'>
      <div class="input-group d-inline-block">
      <input style="width: 400px"
             class="form-control"
             type="text"
             name="search_phrase"
             :placeholder="'Put needed key or value phrase or partial in '+file"
             v-model.lazy="search_phrase">
      <input type="submit"
              value="SEARCH / SHOW ALL"
             class="btn btn-primary input-group-append">
      </div>
    </form>
    </div>

      <div v-if="showAll">
        <form action="/locales" method="post">
          <input name="authenticity_token" type="hidden" :value="csrf">
          <div class="navbar sticky-top saveDiv">
            <input type="hidden"
                   :value="file"
                   name='id'>
            <input type="submit"
                   value="SAVE CHANGES"
                   class="btn btn-danger"
                   style="font-weight: bold; font-size: 120%; float: right">
          </div>
          <li style="" v-for="(line, index) in file_lines" v-bind:currentPage="currentPage" v-bind:class="{'invisible':(index<firstElementOnPage || index>lastElementOnPage)}">

              <div class="parent">
                {{line.parent_key}}
              </div>

              <input type="hidden" v-model="line.id" name="lines[]id">
              <input type="hidden" v-model="line.key" name="lines[]key">
              <div class="key" style="font-weight: bold">{{line.id}}: {{line.key}}</div>

              <textarea cols="40" rows="3" style="font-size: 100%;" class="form-control shadow-textarea" v-model="line.value" name="lines[]value"></textarea>


          </li>


        </form>
        <pagination
            v-bind:items="file_lines"
            v-on:page:update="updatePage"
            v-bind:currentPage="currentPage"
            v-bind:pageSize="itemsOnPage">
        </pagination>
    </div>
    <div v-if="!showAll" >
      <p>Data processing... Please wait</p>
        <p class="loadingStar">&#9733;</p>
    </div>
  </div>
</template>

<script>
//import vPagination from 'vue-plain-pagination'
import Pagination from './components/Pagination.vue'

export default {
  props: ['file','file_lines','token'],
  data() {
    return {
      search_phrase: '',
      previous_parent: '',
      cParent: '',
      csrf: document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
      currentPage: 0,
      itemsOnPage: 10,
      showAll: true
    }
  },
  created: function(){

  },
  beforeDestroy: function() {

  },
  computed: {
    firstElementOnPage: function(){
      return this.currentPage*this.itemsOnPage;
    },

    lastElementOnPage: function(){
      return (this.currentPage*this.itemsOnPage) + 9;
    },
  },
  components: {
    Pagination
  },
  methods: {
    linkTo (){
      //teoretycznie powinien przenosić do indexu
      window.location.href = '/locales'
    },
    cleanSearch(e){
      this.search_phrase='';
      console.log('teoretycznie wyczyściłem');
      e.preventDefault();
    },
    searchResult(){
      console.log('search_result: '+this.search_phrase);
    },
    previousParent(parent){
      if(this.previous_parent!=parent){
        this.previous_parent=parent;
        return parent;
      }
    },
    updatePage(pageNumber) {
      this.currentPage = pageNumber;
    }


  }
}
</script>

<style>
.navbarstyle{
  box-shadow: 0 4px 2px -2px silver;
  position: -webkit-sticky !important;
  position: sticky !important;
  top: 0;
  background-color: white;
  padding-bottom: 10px;
}
.saveDiv{
  position: -webkit-sticky !important;
  position: sticky !important;
  top: 65px;
}
.parent{
  font-size: 120%;
  text-align: center;
  display: inline-block;
  width: 90%;
  text-decoration: underline;
  text-weight: 110%;
}
.curPage{
  display: inherit;
}
.invisible{
  display: none;
}
.loadingStar{
  -animation: spin .7s infinite linear;
    -webkit-animation: spin2 .7s infinite linear;
}


</style>

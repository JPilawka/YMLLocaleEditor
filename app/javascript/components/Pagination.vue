<template>

  <div v-if="totalPages() > 0" class="btn-group pagination-group" role="group" aria-label="Pagination btns">
    <button type="button" v-if="showPreviousLink()" class="btn btn-secondary btn-primary" v-on:click="updatePage(currentPage - 1)"> PREV </button>
    <span  v-for="button in shownButtons()" class="btn-group" role="group" aria-label="Pagination btns">
    <button v-if="button === currentPage" class="btn btn-secondary btn-success" v-on:click="updatePage(button)">
      {{button + 1}}
    </button>
    <button v-else class="btn btn-secondary btn-primary" v-on:click="updatePage(button)">
      {{button + 1}}
    </button>
  </span>
    <button type="button" v-if="showNextLink()" class="btn btn-secondary btn-primary" v-on:click="updatePage(currentPage + 1)"> NEXT</button>
  </div>

</template>

<script>
export default {
  name: 'pagination',
  props: ['items', 'currentPage', 'pageSize'],
  methods: {
    updatePage(pageNumber) {
      this.$emit('page:update', pageNumber);
    },
    totalPages() {
      return Math.ceil(this.items.length / this.pageSize);
    },
    showPreviousLink() {
      return this.currentPage == 0 ? false : true;
    },
    showNextLink() {
      return this.currentPage == (this.totalPages() - 1) ? false : true;
    },
    shownButtons(){
      var array = [];
      var p=this.currentPage;
      if(p-2<0){
        array =[p, p+1, p+2, p+3, p+4];
      }
      else if(p-1<0){
        array =[p-1, p, p+1, p+2, p+3];
      }
      else{
        array = [p-2, p-1, p, p+1, p+2];
      }
      return array;
    }
  }
}
</script>

<style>
.pagination-group{
  padding-top: 20px;
  padding-bottom: 50px;
}

</style>

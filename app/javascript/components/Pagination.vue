<template>
  <div class="paginationContainer">
    <div v-if="totalPages() > 0" class="btn-group pagination-group " role="group" aria-label="Pagination btns">
      <button type="button" v-if="showPreviousLink()" class="btn btn-secondary btn-primary" @:click="updatePage(currentPage - 1)"> PREV </button>
      <button v-if="currentPage != 0" type="button" class="btn btn-secondary btn-primary" @click="updatePage(0)"> FIRST</button>
      <!--Display first 5 pages -->
      <span  v-for="button in shownButtons()" class="btn-group" role="group" aria-label="Pagination btns">
        <button :class="['btn', 'btn-secondary',{ 'btn-success':(isCurrentPage(button)), 'btn-primary':(!isCurrentPage(button))}]"  @click="updatePage(button)">
          {{button + 1}}
        </button>
      </span>
      <span v-if="currentPage < totalPages()-6" class="btn-group" role="group" aria-label="Pagination btns">
        <span class="btn btn-secondary dotsButton disabled ">...</span>

        <!--Display last 5 pages-->
        <span v-for="button in 3" class="btn-group" role="group" aria-label="Pagination btns">
          <button class="btn btn-secondary btn-primary"  @click="updatePage(totalPages()-4+button)">
            {{totalPages()-4+button}}
          </button>
        </span>
      </span>
      <button v-if="currentPage != totalPages()-1" type="button" class="btn btn-secondary btn-primary" @click="updatePage(totalPages()-1)"> LAST</button>
      <button type="button" v-if="showNextLink()" class="btn btn-secondary btn-primary" @click="updatePage(currentPage + 1)"> NEXT</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'pagination',
  props: ['items', 'currentPage', 'pageSize'],
  computed: {

  },
  methods: {
    isCurrentPage(page){
      var isTrue = true;
      page == this.currentPage ? isTrue=true : isTrue = false;
      return isTrue;
    },
    updatePage(pageNumber) {
      this.$emit('page:update', pageNumber);
    },
    totalPages() {
      return Math.ceil(this.items.length / this.pageSize);
    },
    showPreviousLink() {
      return this.currentPage < 1 ? false : true;
    },
    showNextLink() {
      return this.currentPage == (this.totalPages() - 1) ? false : true;
    },
    shownButtons(){
      var array = [];
      var p=this.currentPage;
      if(p<=2){
        array =[0,1,2, 3, 4];
      }
      else if(p>this.totalPages()-5 && p<=this.totalPages()-1){
        array=[this.totalPages()-3, this.totalPages()-2, this.totalPages()-1 ];
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
  margin: auto;
  display: block;
}
.paginationContainer{
    display: flex;
    justify-content: center;
    align-items: center;
}
.dotsButton{
  border-top: 1px solid lavender;
  border-bottom: 1px solid lavender;
}

</style>

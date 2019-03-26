<template>
  <vs-row vs-justify="center">
    <vs-col type="flex" vs-w="12">
      <vs-card class="main">
        <div slot="header">
          <vs-row>
            <vs-col vs-w="8"><h1>{{title}}</h1></vs-col>
            <vs-col vs-w="4" vs-align="flex-end"><slot vs-align="flex-end" name="paginator"></slot></vs-col>
          </vs-row>
        </div>
        <div>
          <slot name="content"></slot>
        </div>
      </vs-card>
    </vs-col>
  </vs-row>
</template>

<script>
export default {
  props: ['title', 'page', 'total']
}
</script>

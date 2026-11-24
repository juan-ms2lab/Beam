<template>
  <component
    :is="svgData"
    class="icon"
  />
</template>

<script>
import { defineAsyncComponent } from 'vue';

const iconMap = new Map();
const icons = import.meta.glob('./images/*.svg', { query: '?component' });

/**
 * @component Icon Display css-customisable SVG icons from a list of pre-defined icons.
 * @namespace uikit/icons
 * @story Default {"name":"new"}
 */
export default {
  name: 'UkIcon',
  compatConfig: {
    // or, for full vue 3 compat in this component:
    MODE: 3,
  },
  props: {
    /**
     * Name of the icon as declared within the image folder.
     * @see /images
     */
    name: {
      type: String,
      default: null,
    },
  },
  computed: {
    /**
     * Dynamically requires SVG asset from local "./images" list.
     *
     * @property svgData
     */
    svgData() {
      if (!iconMap.has(this.name)) {
        iconMap.set(this.name, defineAsyncComponent(async () => {
          try {
            // import.meta.glob, not import(`./images/${name}...`): Vite 5's
            // dynamic-import-vars builds a broken lookup key when the project
            // path contains glob chars such as "(" -- every icon fell back to ✕.
            return await icons[`./images/${this.name}.svg`]();
          } catch (err) {
            // eslint-disable-next-line no-return-await, import/no-unresolved
            return await import('./images/close.svg?component');
          }
        }));
      }
      return iconMap.get(this.name);
    },
  },
};
</script>

<style scoped>

.icon {
  width: 16px;
  height: 16px;
}
</style>

// import { makeRecipeIntoBlogPost } from './lib/recipe-handler.js'
import { readNotes } from './lib/obsidian-handlers.js'

const testContent = `---
tags: recipe 
created: 2018-07-18
author: Sonja
url: https://www.acouplecooks.com/superfood-pecan-energy-bars/ 
---
This homemade energy bar recipe is the perfect wholesome snack! It's naturally sweet, featuring oats, chia seeds, and pecans.

![Homemade Energy Bar Recipe|250](https://www.acouplecooks.com/wp-content/uploads/2018/07/Pecan-Superfood-Energy-Bar-013-225x225.jpg)

# Ingredients

- 15 Medjool dates (9 ounces)*
- 1 cup raw pecan halves
- 1/2 cup gluten free oats
- 1 tablespoon chia seeds
- 1 teaspoon vanilla extract
- 1/2 teaspoon cinnamon
- 1/4 teaspoon kosher salt

# Instructions

- Preheat the oven to 200F.
- Remove the pits from the dates with your fingers (they come right out!). Place the dates in the food processor and process or pulse until they are mainly chopped and a rough texture forms. Then add the remaining ingredients and process for a minute or so until a crumbly dough forms.
- Line a baking sheet or jelly roll pan with parchment paper. Dump the dough into the center of the parchment paper and use a rolling pin to roll it into a rectangle that is 6” x 10.5”. Cut the dough into 14 bars that are 1.5” x 3”. (You don&#8217;t have to be as precise as we were, but we found it was easiest for cutting uniform bars!)
- Bake the bars for 30 minutes (this step helps to make the texture more dry and less sticky). Cool the bars to room temperature, then store refrigerated in a sealed container between sheets of wax paper. If you&#8217;d like to package them for on the go snacking, cut out 4” x 6” rectangles of wax paper, wrap them around the bars, and secure them with tape. Stays good for 1 month refrigerated (or more, but they may not last that long!). 

-----

# Notes
- it *technically* works in the blender! Hooray
- If you leave out nuts, say you’ve forgotten to buy them, use less dates or more oats: it gets real sticky and hard to fashion
- Possibly also don’t blend the dates first, for similar reasons
- Roll them out between two parchment sheets
- Use the bench scraper to cut them
`

// console.log( makeRecipeIntoBlogPost( testContent, 'Date Bars' ) )

readNotes( 'recipe/' ).then( notes => {
    
})
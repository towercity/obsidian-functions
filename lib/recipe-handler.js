import { splitFrontMatter } from "./obsidian-handlers.js";

/**
 * Takes in a recipe note and returns a recipe blog post
 * 
 * @param {string} noteContent  
 * 
 * @returns {string}
 */
export function makeRecipeIntBlogPost(noteContent) {
    console.log(splitFrontMatter( noteContent ) )
}
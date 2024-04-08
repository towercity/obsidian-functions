import { splitFrontMatter } from "./obsidian-handlers.js";
import { readNotes } from './obsidian-handlers.js'
import { writeToAstro } from "./astro-handler.js";

import config from "../config.js";


/**
 * Gets all recipe notes and creates recipe blog posts
 */
export function doRecipes() {
    readNotes( config.recipesDir ).then( notes => {
        notes.forEach( note => {
            note.content = makeRecipeNoteIntoBlogPost( note.content, note.title )
            writeToAstro(note, config.recipesDir )
        });
    })
}

/**
 * Takes in a recipe note and returns a recipe blog post
 * 
 * @param {string} noteContent  
 * 
 * @returns {string}
 */
export function makeRecipeNoteIntoBlogPost(noteContent, noteTitle) {
    const basicNoteObj = reduceNoteContentHeadingsBy( splitFrontMatter( noteContent ) );

    return `---
layout: ../../../layouts/MarkdownPostLayout.astro
title: '${noteTitle}'
pubDate: ${basicNoteObj.frontMatter.created || '2024-04-07'}
tags: ["recipe"]
---

${basicNoteObj.noteContent}
`
}

function reduceNoteContentHeadingsBy( noteContentObj ) {
    noteContentObj.noteContent = reduceHeadingsBy( noteContentObj.noteContent );

    return noteContentObj
}

/**
 * temporary easy func to reduce headings lol
 * 
 * @param {string} noteContent
 * @param {int} num 
 * 
 * @returns {string}
 */
function reduceHeadingsBy( noteContent, num = 2 ) {
    return noteContent.split('\n').map( line => {
        return line.replace( /^#/g, '###' );
    }).join('\n');
}
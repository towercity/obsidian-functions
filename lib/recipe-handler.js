import { splitFrontMatter } from "./obsidian-handlers.js";

/**
 * Takes in a recipe note and returns a recipe blog post
 * 
 * @param {string} noteContent  
 * 
 * @returns {string}
 */
export function makeRecipeIntoBlogPost(noteContent, noteTitle) {
    const basicNoteObj = reduceNoteContentHeadingsBy( splitFrontMatter( noteContent ) );

    return `---
layout: ../../layouts/MarkdownPostLayout.astro
title: '${noteTitle}'
pubDate: ${basicNoteObj.frontMatter.created}
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